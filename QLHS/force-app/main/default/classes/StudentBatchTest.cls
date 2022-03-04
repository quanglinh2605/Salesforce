@isTest
/**
 * クラス名：StudentBatchTest
 * クラス概要：Test StudentBatch   
 * @created Linh Vo Duc Quang
 * @modified:
*/
public class StudentBatchTest {
    
    /**
    * setup   
    * Create data
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @TestSetup
    static void setup(){
        
        Lop__c lop = new Lop__c();
        lop.HocSinhRot__c = 5;
        lop.HocSinhDau__c = 6;
        insert lop;
        
        List<HocSinh__c> students = new List<HocSinh__c>();
        for(Integer i=0;i<10;i++){
            Date birth = Date.newInstance(2013, 12, 27);
            students.add(new HocSinh__c(TenHS__c = 'Hanh' + i, 
                                        HoHS__c = 'Nguyen Hong', 
                                        GioiTinh__c = false, 
                                        NgaySinh__c = birth, 
                                        Diem1__c = Integer.valueof((Math.random() * 9) + 1),
                                        Diem2__c = Integer.valueof((Math.random() * 9) + 1),
                                        Diem3__c = Integer.valueof((Math.random() * 9) + 1),
                                        Lop__c = lop.id
                        ));
        }
        
        HocSinh__c std = new HocSinh__c(TenHS__c = 'Hanh' + 0, 
                                        HoHS__c = 'Nguyen Hong', 
                                        GioiTinh__c = false, 
                                        NgaySinh__c = Date.newInstance(2003,10,25), 
                                        Diem1__c = Integer.valueof((Math.random() * 9) + 1),
                                        Diem2__c = Integer.valueof((Math.random() * 9) + 1),
                                        Diem3__c = Integer.valueof((Math.random() * 9) + 1),
                                        Lop__c = lop.id);
        students.add(std);
        
        insert students;

        List<Diem__c> listDiem = new List<Diem__c>();
        Diem__c diem = new Diem__c(HocSinh__c = std.Id, Diem__c = std.Diem1__c, Mon__c='Toan');
        Diem__c diem1 = new Diem__c(HocSinh__c = std.Id, Diem__c = std.Diem1__c, Mon__c='Ly');
        Diem__c diem2 = new Diem__c(HocSinh__c = std.Id, Diem__c = std.Diem3__c, Mon__c='Hoa');
        listDiem.add(diem);
        listDiem.add(diem1);
        listDiem.add(diem2);

        insert listDiem;
    }

    /** 
    * test  
    * Run Test StudentBatch
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @isTest static void test () {
    
        Test.startTest();
        StudentBatch stb = new StudentBatch();
        Database.executebatch(stb);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(11, [select count() from HocSinh__c where GioiTinh__c = false]);    
    }
}
