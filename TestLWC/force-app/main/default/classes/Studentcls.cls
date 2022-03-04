public class Studentcls {
    public String studentId {get;set;}
    public HocSinh__c student {get;set;}
    public Studentcls(){
        student = new HocSinh__c();
    }

    public Pagereference saveStudent(){
        insert student;
        return new Pagereference('/' + student.Id);
    }

    public Pagereference retrieveStudentDetail(){
        if(studentId != null){
            student = [SELECT Id,
                            HoHS__c,
                            TenHS__c,
                            NgaySinh__c,
                            GioiTinh__c,
                            Diem1__c,
                            Diem2__c,
                            Diem3__c,
                            DiemTB__c,
                            TinhTrang__c 
                            FROM HocSinh__c
                            WHERE Id = :studentId];
        }
        return null;
    }

    @AuraEnabled()
    public static List<HocSinh__c> getStudentRecords(){
            return [SELECT  Id,
                            HoHS__c,
                            TenHS__c,
                            NgaySinh__c,
                            GioiTinh__c,
                            Diem1__c,
                            Diem2__c,
                            Diem3__c,
                            DiemTB__c,
                            TinhTrang__c 
                            FROM HocSinh__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<HocSinh__c> getStudentList(){
            return [SELECT  Id,
                            HoHS__c,
                            TenHS__c,
                            NgaySinh__c,
                            GioiTinh__c,
                            Diem1__c,
                            Diem2__c,
                            Diem3__c,
                            DiemTB__c,
                            TinhTrang__c 
                            FROM HocSinh__c];
    }
}