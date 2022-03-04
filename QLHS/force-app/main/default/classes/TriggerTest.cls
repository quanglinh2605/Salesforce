/**
 * クラス名：TriggerTest
 * クラス概要：Test method in TriggerHandler class
 * @created：Linh Vo Duc Quang
 * @modified:
*/
@IsTest
public class TriggerTest {
    
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
    * Test testInsertValidate
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testInsertValidate(){
        Test.startTest();
        // Insert Test
        HocSinh__c std;
        try {
            insert std = new HocSinh__c();   
        } catch (Exception e) {
          
        }
        Test.stopTest();
        System.assertEquals(3, [SELECT count() FROM HocSinh__c WHERE HoHS__c = 'A']);       
    }

    /**
    * Test testInsertInvalidDate
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testInsertInvalidDate(){
        Test.startTest();
        Lop__c lop = [SELECT Id FROM Lop__c WHERE TenLop__c = 'CNTT'];
        HocSinh__c std;
        try {
            insert std = new HocSinh__c(
                            TenHS__c = 'A', 
                            HoHS__c = 'A', 
                            GioiTinh__c = false, 
                            NgaySinh__c = Date.newInstance(1983,02,13),
                            Diem1__c = 2,
                            Diem2__c = 5,
                            Diem3__c = 4,
                            Lop__c = lop.Id);        
        } catch (Exception e) {
            
        }
        Test.stopTest();
        System.assertEquals(3, [SELECT count() FROM HocSinh__c WHERE HoHS__c = 'A']); 
    }
    
    /**
    * Test testInsertSuccess
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testInsertSuccess(){
        Test.startTest();
            setup();
        Test.stopTest();
        System.assertEquals(6, [SELECT count() FROM HocSinh__c WHERE HoHS__c = 'A']); 
    }

    /**
    * Test testUpdate
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testUpdate(){
        Test.startTest();
        // Update Test
        HocSinh__c oldStd = [SELECT Id From HocSinh__c WHERE TenHS__c = 'A0'];
        try {
            oldStd.TenHS__c = '';
            update oldStd;    
        } catch (Exception e) {
            oldStd.TenHS__c = 'B';
            update oldStd;
        }
        Test.stopTest();
        System.assertEquals(3, [SELECT count() FROM HocSinh__c WHERE HoHS__c = 'A']);
    }

    /**
    * Test testDelete
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest
    static void testDelete(){
        Test.startTest();
         // Delete Test
         delete [SELECT Id FROM HocSinh__c Where TenHS__c = 'A0'];
        Test.stopTest(); 
        System.assertEquals(2, [SELECT count() FROM HocSinh__c WHERE HoHS__c = 'A']);
    }
}
