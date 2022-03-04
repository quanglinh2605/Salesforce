({
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },

    doInit : function(component, event, helper) {
        // Get List of Lop
        helper.getLops(component);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    saveStudent: function(component, event, helper) {
        helper.saveData(component);
    },

    getModalStudent: function(component, event, helper) {
       
        // Get Data
        helper.getStudentFromId(component,event);
        
        // Display modal 
        component.set("v.isModalOpen", true);
    }
})
