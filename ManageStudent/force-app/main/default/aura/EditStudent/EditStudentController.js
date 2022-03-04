({
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },

    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    saveStudent: function(component, event, helper) {
        helper.saveData(component);
    },

    getModalStudent: function(component, event, helper) {
        var params = event.getParam('arguments');
        component.set('v.currentStudent',params.student);
        
        // hien thi modal 
        component.set("v.isModalOpen", true);
     }
})
