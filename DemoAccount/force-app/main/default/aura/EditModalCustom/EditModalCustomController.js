({
    openModel: function(component, event, helper) {
       component.set("v.isModalOpen", true);
    },
   
    closeModel: function(component, event, helper) {
       component.set("v.isModalOpen", false);
    },
   
    saveRecordData: function(component, event, helper) {
       component.set("v.isModalOpen", false);
       helper.saveData(component);
    },
    
    getModalRecordData: function(component, event, helper) {
       
       // lay du lieu
       helper.getAccountFromId(component,event);
       
       // hien thi modal 
       component.set("v.isModalOpen", true);
    }
     
 })