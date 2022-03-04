({
    deleteData: function(component, event, helper) {
        var action = component.get('c.multiDel');
        action.setParams({ listId : component.get("v.listId") });
        
        console.log('==listId==');
        console.log('>>>' + component.get("v.listId"));
        
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS")
            {
                // Reload lแบกi list student
                var reloadEvt = component.getEvent("reload_evt");
                reloadEvt.fire();
                
                $A.get("e.force:refreshView").fire();

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
    }
})
