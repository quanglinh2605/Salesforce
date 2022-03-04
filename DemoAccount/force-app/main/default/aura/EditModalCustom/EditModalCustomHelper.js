({
	getAccountFromId : function(component,event) {
        
        var params = event.getParam('arguments');
        
        console.log('==params.Id==' + params.Id);
        
        var recordId = '';
        
        // Truong hop có record Id -> edit
        if (params.Id) {
            recordId = params.Id;
        }
        
        var action = component.get('c.getAccountFromId');
        action.setParams({accId : recordId});
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS")
            {
                component.set('v.currentAccount', actionResult.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
	},
    
    saveData : function(component) {
        
        var action = component.get('c.saveData');
        action.setParams({ acc : component.get("v.currentAccount") });
        
        console.log('==currentAccount==');
        console.log(component.get("v.currentAccount"));
        
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === "SUCCESS")
            {
                // Reload lại list Account
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
            
        });
        
        $A.enqueueAction(action);
    }
    
})