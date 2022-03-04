({

   openModel: function(component, event, helper) {
      component.set("v.isModalOpen", true);
   },
  
   closeModel: function(component, event, helper) {
      component.set("v.isModalOpen", false);
   },

   deleteRecordData: function(component, event, helper) {
      component.set("v.isModalOpen", false);
      helper.deleteData(component);
   },
     
   confirmDeleteModal: function(component, event, helper) {
      var params = event.getParam('arguments');
      
      console.log('==params.Id==' + params.Id);
      
      component.set("v.currentStudentId", params.Id);
      // show modal 
      component.set("v.isModalOpen", true);
   }
})
