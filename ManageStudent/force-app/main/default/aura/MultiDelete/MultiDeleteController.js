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
       
   listDelete: function(component, event, helper) {
      var params = event.getParam('arguments');
      
      console.log('==params.listId==' + params.listId);
      
      component.set("v.listId", params.listId);
      // hien thi modal 
      component.set("v.isModalOpen", true);
   }
})
