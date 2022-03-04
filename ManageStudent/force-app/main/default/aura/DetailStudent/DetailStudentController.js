({
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },

    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    getModalStudent: function(component, event, helper) {
        var params = event.getParam('arguments');
        component.set('v.currentStudent',params.student);
        
        // hien thi modal 
        component.set("v.isModalOpen", true);
    },

    editStudent: function(component, event, helper) {
        var student = component.get('v.currentStudent');
        component.set("v.isModalOpen", false);
        component.find('edit_student').editStudent(student);
    },

    deleteStudent: function(component, event, helper) {
        var student = component.get('v.currentStudent');
        component.set("v.isModalOpen", false);
        component.find('delete_student').confirmDeleteModal(student.Id);
    }
})
