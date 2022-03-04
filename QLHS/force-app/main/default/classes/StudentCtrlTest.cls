/**
 * クラス名：StudentCtrlTest
 * クラス概要：Test methods in StudentController   
 * @created：Linh Vo Duc Quang
 * @modified:
*/
@isTest
public class StudentCtrlTest {
    
    /**
    * setup   
    * Create data
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @TestSetup
    static void setup(){
        Lop__c lop = new Lop__c(TenLop__c= 'CNTT');
        insert lop;
      
        List<HocSinh__c> listStd = new List<HocSinh__c>();
        for(Integer i = 0; i < 3; i++){
            HocSinh__c std = new HocSinh__c(
                                    TenHS__c = 'A' + i, 
                                    HoHS__c = 'A', 
                                    GioiTinh__c = false, 
                                    NgaySinh__c = Date.newInstance(2005,12,12),
                                    Diem1__c = 2,
                                    Diem2__c = 5,
                                    Diem3__c = 4,
                                    Lop__c = lop.Id);
            listStd.add(std);
        }

        insert listStd;
    }

    /**
    * testMethodInitStudentById   
    * Test create an Object HocSinh__c
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testMethodInitStudentById(){
        HocSinh__c std = [SELECT Id FROM HocSinh__c WHERE TenHS__c = 'A0'];
        
        Pagereference pageRef = Page.EditStudentPage;
        StudentController controller = new StudentController();
        Test.startTest();
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', std.Id);
            controller.initStudentById();
            String nextPage = controller.save().getURL();

            Pagereference pageRef1 = Page.CreateStudentPage;
            Test.setCurrentPage(pageRef1);
            ApexPages.currentPage().getParameters().put('id', '');
            controller.initStudentById();
        Test.stopTest();
        System.assertEquals('/apex/studentpage', nextPage);
    }
    
    /**
    * testMethodSaveSuccess   
    * Save Object HocSinh
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testMethodSaveSuccess(){
        String nextpage;
        
        HocSinh__c std = [SELECT Id FROM HocSinh__c WHERE TenHS__c = 'A0'];

        StudentController controller = new StudentController();
            Test.startTest();
            controller.currentStudent = std;
            nextpage = controller.save().getURL();
            Test.stopTest();
        
        System.assertEquals('/apex/studentpage', nextpage);
    }

    /**
    * testMethodSaveUnSuccess   
    * Save Object HocSinh
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testMethodSaveUnSuccess(){
        Pagereference nextpage;
        StudentController controller = new StudentController();
            Test.startTest();
            controller.currentStudent = new HocSinh__c();
            nextpage = controller.save();
            Test.stopTest();
        
        System.assertEquals(null, nextpage);
    }
    
    /**
    * testMethodSearchWithLopSortAsc   
    * Filter record on field Lop__c, TenHS__c and sord increase by TenHS__c
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testMethodSearchWithLopSortAsc(){
        Lop__c lop = new Lop__c();
        insert lop;
        
        StudentController controller = new StudentController();
        controller.ten = '';
        controller.lopId = lop.Id;
        controller.isSortByName = true;

        Test.startTest();
        controller.searchStudent();
        Test.stopTest();

        System.assertEquals(3, [SELECT count() FROM HocSinh__c WHERE HoHS__c = 'A']);  
    }

    /**
    * testMethodSearchWithLopSortDesc   
    * Filter record on field Lop__c, TenHS__c and sord descrease by TenHS__c
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testMethodSearchWithLopSortDesc(){
        Lop__c lop = new Lop__c();
        insert lop;
        
        StudentController controller = new StudentController();
        controller.ten = '';
        controller.lopId = lop.Id;
        controller.isSortByName = false;

        Test.startTest();
        controller.searchStudent();
        Test.stopTest();
        System.assertEquals(3, [SELECT count() FROM HocSinh__c WHERE HoHS__c = 'A']);  
    }

    /**
    * testMethodNewStudent   
    * Test return createstudentpage or not
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testMethodNewStudent(){
        StudentController controller = new StudentController();
        Test.startTest();
        String pageName = controller.newStudent().getURL();
        Test.stopTest();
        System.assertEquals('/apex/createstudentpage', pageName);
    }

    /**   
    * Reload Page
    * Test return studentpage or not
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testMethodReload(){
        StudentController controller = new StudentController();
        Test.startTest();
        String pageName = controller.ReloadPage().getURL();
        Test.stopTest();
        System.assertEquals('/apex/studentpage', pageName);
    }

    /**   
    * Test method Edit
    * Test return editstudentpage or not
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testMethodEditPage(){

        HocSinh__c std = [SELECT Id FROM HocSinh__c WHERE TenHS__c = 'A0'];

        Pagereference pageRef = Page.EditStudentPage;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getParameters().put('recordId', std.Id);
        StudentController controller = new StudentController();
        Test.startTest();
          controller.editStudent().getURL();
        Test.stopTest();
        System.assertEquals(3, [SELECT count() FROM HocSinh__c WHERE HoHS__c = 'A']);  
    }

    /**
    * testMethodDeleteRecord   
    * Test can delete an object or not
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testMethodDeleteRecord(){
        
        HocSinh__c std = [SELECT Id FROM HocSinh__c WHERE TenHS__c = 'A0'];

        Pagereference pageRef = Page.StudentPage;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getParameters().put('recordIndex',std.Id);
        StudentController controller = new StudentController();
        Test.startTest();
        controller.deleteRecord();
        Test.stopTest();
        System.assertEquals(2, [SELECT count() FROM HocSinh__c WHERE HoHS__c = 'A']);  
    }

    /**
    * testMethodMultilDelete   
    * Test can delete records through ids
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testMethodMultilDelete(){
        Lop__c lop = new Lop__c();
        insert lop;
        List<HocSinh__c> students = new List<HocSinh__c>();
        for(Integer i = 0; i<10;i++){
            HocSinh__c std = new HocSinh__c(TenHS__c = 'A' + i, 
                                        HoHS__c = 'A', 
                                        GioiTinh__c = false, 
                                        NgaySinh__c = Date.newInstance( 2005,12,17 ),
                                        Diem1__c = 2,
                                        Diem2__c = 5,
                                        Diem3__c = 4,
                                        Lop__c = lop.Id);
            students.add(std);
        }        
        insert students;

        String ids = '';
        for(HocSinh__c std : students){
            ids += std.Id + ',';
        }

        Pagereference pageRef = Page.StudentPage;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getParameters().put('ids',ids);
        StudentController controller = new StudentController();
        Test.startTest();
        controller.multilDelete();
        Test.stopTest();
        System.assertEquals(3, [SELECT count() FROM HocSinh__c WHERE HoHS__c = 'A']);  
    }

    /**
    * TestMethodGetItems   
    * Test can create a selectoption or not
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void TestMethodGetItems(){
        List<Lop__c> lops = new List<Lop__c>();
        for (Integer i=0;i<9;i++) {
            lops.add(new Lop__c(TenLop__c = 'tenLop' + i ));
        }
        insert lops;
        
        StudentController controller = new StudentController();
        Test.startTest();
        controller.getItems();
        Test.stopTest();
        System.assertEquals(10, [SELECT count() FROM Lop__c]);  
    }
}