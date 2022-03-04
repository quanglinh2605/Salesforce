({
	getAccounts : function(component) {
		var action = component.get('c.searchAccount');
        action.setParams({ searchCondition : component.get("v.searchCondition") });
        action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            console.log('===state get accounts===' + state);
            if (state === "SUCCESS")
            {
                component.set('v.accounts', actionResult.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	}
})