({
    getData : function(cmp, helper) {
        var action = cmp.get('c.getStudents');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                records.forEach(function(record){ 
                    if(record.TinhTrang__c=='Rot'){
                        record.showClass = (record.TinhTrang__c=='Rot' ? 'orangeColor' : '');
                    }
                });
                cmp.set("v.totalPages", Math.ceil(response.getReturnValue().length/cmp.get("v.pageSize")));
                cmp.set("v.allData", records);
                cmp.set("v.currentPageNumber",1);
                helper.buildData(cmp, helper);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },

    getLops : function(cmp) {
        var action = cmp.get('c.getLops');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal = response.getReturnValue();
                var opts = retVal.map(opt => ({ value: opt.Id, label: opt.TenLop__c }));
                cmp.set("v.lops", opts);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getStudents : function(component, helper) {
        var action = component.get('c.searchStudent');
        action.setParams({ ten : component.get("v.ten"), 
                        lopId : component.get("v.lopId"), 
                        sortByName : component.get('v.sortByName'),
                        beginDate : component.get('v.beginDate'),
                        endDate : component.get('v.endDate') });	
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS")
            {
                var records = actionResult.getReturnValue();
                records.forEach(function(record){ 
                    if(record.TinhTrang__c=='Rot'){
                        record.showClass = (record.TinhTrang__c=='Rot' ? 'orangeColor' : '');
                    }
                });
                component.set("v.totalPages", Math.ceil(actionResult.getReturnValue().length/component.get("v.pageSize")));
                component.set("v.allData", records);
                component.set("v.currentPageNumber",1);
                helper.buildData(component, helper);
            }
        });
        $A.enqueueAction(action);
    },

    buildData : function(component, helper) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber-1)*pageSize;
        //creating data-table data
        for(; x < (pageNumber)*pageSize; x++){
            if(allData[x]){
            	data.push(allData[x]);
            }
        }
        component.set("v.mydata", data);
        
        helper.generatePageList(component, pageNumber);
    },

    generatePageList : function(component, pageNumber){
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    }
})