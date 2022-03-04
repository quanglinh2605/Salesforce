({
	
    deleteData : function(component) {
        
        var action = component.get('c.deleteAccount');
        action.setParams({ accId : component.get("v.currentAccountId") });
        
        console.log('==currentAccountId==');
        console.log(component.get("v.currentAccountId"));
        
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS")
            {
                // Reload lแบกi list Account
                var reloadEvt = component.getEvent("reload_evt");
        		reloadEvt.fire();
				
                // Show message toast
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Delete",
                    "type": "success",
                    "message": "The record was deleted."
                });
                resultsToast.fire();
            }
            
        });
        
        $A.enqueueAction(action);
    }
})