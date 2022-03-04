/**
 * クラス名：   StudentLightningCtrl
 * クラス概要： Modify on Object HocSinh__c
 * @created：  2020/11/06 Linh Vo Duc Quang
 * @modified： 
*/
public with sharing class StudentLightningCtrl {

    /**
    * saveData
    * Save record to Salesforce
    * @param：   std
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @AuraEnabled
    public static void saveData(HocSinh__c std){
        String msg = '';
        try {
            upsert std; // if HocSinh__c has no Id -> insert / if HocSinh__c has Id -> update    
        } catch (DmlException e){
            //Any type of Validation Rule error message, Required field missing error message, Trigger error message etc..
            //we can get from DmlException
             
            //Get All DML Messages
            for (Integer i = 0; i < e.getNumDml(); i++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            //throw DML exception message
            throw new AuraHandledException(msg);
             
        }catch(Exception e){
            //throw all other exception message
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /**
    * deleteStudent
    * Delete record to Salesforce
    * @param：   stdId
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @AuraEnabled
    public static void deleteStudent(String stdId){
        // Dùng Database.delete để delete record theo Id
        Savepoint sp = Database.setSavepoint();
        try {
            Database.delete(stdId);
        } catch (Exception e) {
            Database.rollback(sp);
        }
    }

    /**
    * getStudentFromId
    * Get or new record through Id
    * @param：   stdId
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @AuraEnabled
    public static HocSinh__c getStudentFromId(String stId){
		List<HocSinh__c> lstStudent = [SELECT Id,TenHS__c FROM HocSinh__c WHERE Id = :stId];
        if(!lstStudent.isEmpty()){
            return lstStudent[0]; // Get first Object
        } else {
            return new HocSinh__c();
        }
    }

    /**
    * getStudents 
    * Get List of HocSinh
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @AuraEnabled
    public static List<HocSinh__c> getStudents() {
        shortenAsync();
        List<HocSinh__c> students = [SELECT 
                                        Id,
                                        HoHS__c,
                                        TenHS__c,
                                        NgaySinh__c,
                                        GioiTinh__c,
                                        Diem1__c,
                                        Diem2__c,
                                        Diem3__c,
                                        DiemTB__c,
                                        TinhTrang__c,
                                        Short_URL__c,
                                        Lop__c 
                                        FROM HocSinh__c 
                                        ORDER BY TenHS__c DESC];
        return students;
    }

    /**
    * getLops
    * Get List of Lop
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @AuraEnabled
    public static List<Lop__c> getLops() {
        List<Lop__c> lops =[SELECT MaLop__c, TenLop__c FROM Lop__c];
        return lops;
    }

    /**
    * searchStudent
    * Filter List of Student
    * @param：   ten, lopId, sortByName, beginDate, endDate
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @AuraEnabled
    public static List<HocSinh__c> searchStudent(String ten, String lopId, Boolean sortByName, Date beginDate, Date endDate){
        List<HocSinh__c> students = new List<HocSinh__c>();
        if(String.isNotBlank(lopId)){
            if(String.isBlank(ten)) ten = '';
            String likeTen = '%' + ten + '%';
            if(lopId.equals('0')){
                if(sortByName){
                    // Get list of student through TenHS__c and NgaySinh__c sort by name ASC
                    students = [SELECT 
                                    Id,
                                    HoHS__c,
                                    TenHS__c,
                                    NgaySinh__c,
                                    GioiTinh__c,
                                    Diem1__c,
                                    Diem2__c,
                                    Diem3__c,
                                    DiemTB__c,
                                    TinhTrang__c, 
                                    Lop__c 
                                    FROM HocSinh__c WHERE 
                                    TenHS__c LIKE :likeTen
                                    AND NgaySinh__c >= :beginDate 
                                    AND NgaySinh__c < :endDate 
                                    ORDER BY TenHS__c ASC];
                }else{
                    // Get list of student through TenHS__c and NgaySinh__c sort by name DESC
                    students = [SELECT 
                                    Id,
                                    HoHS__c,
                                    TenHS__c,
                                    NgaySinh__c,
                                    GioiTinh__c,
                                    Diem1__c,
                                    Diem2__c,
                                    Diem3__c,
                                    DiemTB__c,
                                    TinhTrang__c, 
                                    Lop__c 
                                    FROM HocSinh__c WHERE 
                                    TenHS__c LIKE :likeTen
                                    AND NgaySinh__c >= :beginDate 
                                    AND NgaySinh__c < :endDate 
                                    ORDER BY TenHS__c DESC];
                }
            }else{
                if(sortByName){
                    // Get list of student through Lop__c, TenHS__c and NgaySinh__c sort by name ASC
                    students = [SELECT 
                                    Id,
                                    HoHS__c,
                                    TenHS__c,
                                    NgaySinh__c,
                                    GioiTinh__c,
                                    Diem1__c,
                                    Diem2__c,
                                    Diem3__c,
                                    DiemTB__c,
                                    TinhTrang__c, 
                                    Lop__c 
                                    FROM HocSinh__c WHERE 
                                    TenHS__c LIKE :likeTen 
                                    AND Lop__r.Id = :lopId
                                    AND NgaySinh__c >= :beginDate 
                                    AND NgaySinh__c < :endDate 
                                    ORDER BY TenHS__c ASC];
                }else{
                    // Get list of student through Lop__c, TenHS__c and NgaySinh__c sort by name DESC
                    students = [SELECT 
                                    Id,
                                    HoHS__c,
                                    TenHS__c,
                                    NgaySinh__c,
                                    GioiTinh__c,
                                    Diem1__c,
                                    Diem2__c,
                                    Diem3__c,
                                    DiemTB__c,
                                    TinhTrang__c, 
                                    Lop__c 
                                    FROM HocSinh__c WHERE 
                                    TenHS__c LIKE :likeTen 
                                    AND Lop__r.Id = :lopId
                                    AND NgaySinh__c >= :beginDate 
                                    AND NgaySinh__c < :endDate 
                                    ORDER BY TenHS__c DESC];
                }
            }     
        }
        return students;
    }

    /**
    * multiDel
    * Delete a List of Student
    * @param：   listId, a list of Id  
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    @AuraEnabled
    public static void multiDel(String listId){
        String[] arr = listId.split(',');
        try {
            delete [SELECT Id FROM HocSinh__c WHERE HocSinh__c.Id IN :arr];   
        } catch (Exception e) {
           System.debug(e.getMessage()); 
        }        
    }

    @Future(callout = true)
    private static void shortenAsync() {

        // Fetch your data and a field where you want to store the generated short url
        List<HocSinh__c> students = new List<HocSinh__c>([ SELECT Id, Short_URL__c FROM HocSinh__c ]);
        System.debug('students: ' + students);
        // Service to actually call out to bitly and get a shortened url
        BitlyService service = new BitlyService();
        for ( HocSinh__c student : students ) {
            // in this trivial example, we're just creating short urls to the record itself
            student.Short_URL__c = service.shorten( 'https://login.salesforce.com/' + student.Id );
        }
        // update the records with their short urls
        // use workflow or trigger to fire off the short url field being populated
        // to then send email alerts, etc. including the short url
        if ( students.size() > 0 ) {
            update students;
        }

    }
}
