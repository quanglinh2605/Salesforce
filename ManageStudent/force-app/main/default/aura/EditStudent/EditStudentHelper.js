({
    saveData : function(component) {
        
        var action = component.get('c.saveData');
        action.setParams({ std : component.get("v.currentStudent") });
        
        console.log('==currentStudent==');
        console.log(component.get("v.currentStudent"));
        
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS")
            {
                component.set("v.isModalOpen", false);
                // Reload lại list Student
                var reloadEvt = component.getEvent("reload_evt");
        		reloadEvt.fire();
				
                // Show message toast
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Save",
                    "type": "success",
                    "message": "The record was saved."
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
            }else if (status === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
            
        });
        
        $A.enqueueAction(action);
    }
})
