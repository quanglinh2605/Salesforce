({
	doInit : function(component, event, helper) {
		console.log('==component==');
        helper.getAccounts(component);
	},
    search: function(component, event, helper) {
        console.log('==seachItems==');
        helper.getAccounts(component);
    },
    newAccount : function(component, event, helper) {
        var recordId = '';
        console.log('==newAccount==' + recordId);
        component.find('account_model').getModalRecordData(recordId);
    },
    editAccount: function(component, event, helper) {
        var recordId = event.getSource().get('v.name');
        console.log('==recordId==' + recordId);
        component.find('account_model').getModalRecordData(recordId);
    },
    deleteAccount: function(component, event, helper) {
        var recordId = event.getSource().get('v.name');
        component.find('confirm_delete_modal').confirmDeleteModal(recordId);
    },
    handleReloadEvent: function(component, event, helper) {
        console.log('==handleReloadEvent==');
        helper.getAccounts(component);
    }
})