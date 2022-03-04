({
    doInit : function(component, event, helper) {
		component.set('v.mycolumns', [
            {label: 'Ho', fieldName: 'HoHS__c', type: 'text'},
            {label: 'Ten', type: "button", typeAttributes: 
                {  
                    label: {fieldName:'TenHS__c'},  
                    name: 'Detail',  
                    title: 'Detail',  
                    disabled: false,  
                    value: 'detail',  
                    iconPosition: 'left'  
                }
            },
            {
                label: 'Ngay Sinh',
                fieldName: 'NgaySinh__c',
                type: 'date',
                typeAttributes: {
                    weekday: 'short',
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric'
                }
            },
            {label: 'Gioi Tinh', fieldName: 'GioiTinh__c', type: 'boolean'},
            {label: 'Diem1', fieldName: 'Diem1__c', type: 'number'},
            {label: 'Diem2', fieldName: 'Diem2__c', type: 'number'},
            {label: 'Diem3', fieldName: 'Diem3__c', type: 'number'},
            {label: 'DiemTB', fieldName: 'DiemTB__c', type:'number'},
            {label: 'Tinh Trang', fieldName: 'TinhTrang__c', type: 'text', 
            'cellAttributes': {
                "class": {
                    "fieldName": "showClass"
                }
            }},
            {type: "button", typeAttributes: {  
                label: 'Edit',  
                name: 'Edit',  
                title: 'Edit',  
                disabled: false,  
                value: 'edit',  
                iconPosition: 'left'  
            }},
            {type: "button", typeAttributes: {  
                label: 'Delete',  
                name: 'Delete',  
                title: 'Delete',  
                disabled: false,  
                value: 'delete',  
                iconPosition: 'left'  
            }}  
        ]);
        helper.getLops(component);
        helper.getData(component, helper);
    },
    
    sort : function(cmp, event, helper){
        var a = event.getSource().get('v.value');
        cmp.set('v.sortByName', !a);
        helper.getStudents(cmp);
    },
    
    search: function(component, event, helper) {
        helper.getStudents(component, helper);
    },
    
    newStudent : function(component, event, helper) {
        var recordId = '';
        component.find('create_student').getModalStudent(recordId);
    },
    
    getSelectedRows: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var Ids = [];
        // Display that fieldName of the selected rows
        for (var i = 0; i < selectedRows.length; i++){
            Ids.push(selectedRows[i].Id);
        }
        cmp.set('v.listId',Ids.toString());
    },
    
    comboboxChange: function(cmp, event, helper){
        var selectedOptionValue = event.getParam("value");
        cmp.set("v.lopId", selectedOptionValue);
    },
    
    handleReloadEvent: function(component, event, helper) {
        helper.getStudents(component, helper);
    },
    
    handleRowAction: function (cmp, event, helper) {
        var student = event.getParam('row');
        var action = event.getParam('action');
        switch (action.name) {
            case 'Edit':
                cmp.find('edit_student').editStudent(student);
                break;
            case 'Delete':
                cmp.find('delete_student').confirmDeleteModal(student.Id);
                break;
            case 'Detail':
                cmp.find('detail_student').detailStudent(student);
                break;    
        }
    },

    multiDelete: function(component, event, helper) {
        var action = component.get('c.multiDel');
        action.setParams({ listId : component.get("v.listId") });
        
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS")
            {
                // Reload lai list Student
                helper.getStudents(component, helper);
                
                //RefreshView
                $A.get('e.force:refreshView').fire();

                // Show message toast
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Delete",
                    "type": "success",
                    "message": "Records was deleted."
                });
                resultsToast.fire();
            }
            
        });
        
        $A.enqueueAction(action);
    },

    listDelete: function(cmp,event,helper){
        var listId = cmp.get("v.listId");
        console.log('listId ' + listId);
        cmp.find('multi_delete').xoaNhieu(listId);
    },

    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
})