public class StudentLWCController {
   
    @AuraEnabled(cacheable=true)
    public static List<HocSinh__c> getStudents( String ten ,String lopId, Date beginDate, Date endDate, Boolean isSortByName ){
        List<HocSinh__c> students = new List<HocSinh__c>();
        String query = 'SELECT Id,'
                        + 'HoHS__c,'
                        + 'TenHS__c,'
                        + 'NgaySinh__c,'
                        + 'GioiTinh__c,'
                        + 'Diem1__c,'
                        + 'Diem2__c,'
                        + 'Diem3__c,'
                        + 'DiemTB__c,'
                        + 'TinhTrang__c,' 
                        + 'Lop__c ' 
                        + 'FROM HocSinh__c WHERE ' 
                        + 'TenHS__c LIKE :likeTen '
                        + 'AND NgaySinh__c >= :beginDate ' 
                        + 'AND NgaySinh__c < :endDate ';
        
        try {
            if(String.isNotBlank(lopId)){
                if(String.isBlank(ten)) ten = '';
                String likeTen = '%' + String.escapeSingleQuotes(ten) + '%';
                if(lopId.equals('0')){
                    if(isSortByName){
                        // filter by TenHS__c and sort increase by name
                        students = Database.query(query + 'ORDER BY TenHS__c ASC');
                    }else{
                        // filter by TenHS__c and sort descrease by name
                        students = Database.query(query + 'ORDER BY TenHS__c DESC');
                    }
                }else{
                    if(isSortByName){
                        // filter by TenHS__c, Lop__c and sort increase by name
                        students = Database.query(query + 'AND Lop__r.Id = :lopId ORDER BY TenHS__c ASC');
                    }else{
                        // filter by TenHS__c, Lop__c and sort descrease by name
                        students = Database.query(query + 'AND Lop__r.Id = :lopId ORDER BY TenHS__c DESC');
                    }
                }     
            }
            return students;   
        }catch (Exception e) {
            return null;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Lop__c> getLops(){
        return [SELECT Id, 
                    TenLop__c
                    FROM Lop__c LIMIT 10];
    }

    @AuraEnabled()
    public static void deleteStudents(List<Id> deleteStudentIds){
        List<HocSinh__c> listStudentsToDelete = new List<HocSinh__c>();
        for(Id StudentId : deleteStudentIds){
            listStudentsToDelete.add(new HocSinh__c(Id = StudentId));
        }
        delete listStudentsToDelete;
    }
    // @AuraEnabled(cacheable=true)
    // public static HocSinh__c getStudentById(String stdId){
    //     String id = stdId.replace('-83', '');
    //     return [SELECT Id, HoHS__c, TenHS__c, NgaySinh__c, GioiTinh__c, Diem1__c, Diem2__c, Diem3__c, Lop__c FROM HocSinh__c WHERE Id = :id];
    // }
}
