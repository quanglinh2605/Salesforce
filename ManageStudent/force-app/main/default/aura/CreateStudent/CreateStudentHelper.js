({

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
            }
        }));
        $A.enqueueAction(action);
    },

    getStudentFromId : function(component,event) {
        
        var params = event.getParam('arguments');
        
        var recordId = '';
        
        // If recordId have value -> edit
        if (params.Id) {
            recordId = params.Id;
        }
        
        var action = component.get('c.getStudentFromId');
        action.setParams({stId : recordId});
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS")
            {
                component.set('v.currentStudent', actionResult.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
    
    saveData : function(component) {
        
        var action = component.get('c.saveData');
        action.setParams({ std : component.get("v.currentStudent") });
        
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            console.log('==state==' + state);
            if (state === "SUCCESS")
            {
                component.set("v.isModalOpen", false);
                // Reload list Student
                var reloadEvt = component.getEvent("reload_evt");
        		reloadEvt.fire();
                
                // Show message toast
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Save",
                    "type": "success",
                    "message": "The student was saved."
                });
                resultsToast.fire();
            }
            else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            } else if (state === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
            
        });
        
        $A.enqueueAction(action);
    }
})
