/**
 * クラス名：  StudentBatch
 * クラス概要：Insert Records into Salesforce   
 * @created:  Linh Vo Duc Quang
 * @modified:
*/
public class StudentBatch implements Database.Batchable<sObject>, Database.Stateful {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
           'SELECT Id, Diem1__c, Diem2__c, Diem3__c FROM HocSinh__c'
        );
    }

    private void schedule(){
        Datetime sysTime = System.now();

        // this would increase the time to 1 hour after current time
        sysTime = sysTime.addHours(1);

        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        try {
            System.schedule('Schedule run batch' + sysTime.getTime(),chron_exp, new InvokeStudentBatch());    
        } catch (Exception e) {         
        }
        
    }
    /**   
    * execute
    * Return a list of HocSinh__c
    * @return：  List<HocSinh__c>
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    public void execute(Database.BatchableContext bc, List<HocSinh__c> scope){
        
        // Lấy ra danh sach Điểm môn toán
        List<Diem__c> listDiemToan = [SELECT Id, HocSinh__c, Diem__c, Mon__c FROM Diem__c WHERE Mon__c = 'Toan'];
        Map<String, String> diemToan = new Map<String, String>();
        // Lấy ra danh sach Điểm môn lý
        List<Diem__c> listDiemLy = [SELECT Id, HocSinh__c, Diem__c, Mon__c FROM Diem__c WHERE Mon__c = 'Ly'];
        Map<String, String> diemLy = new Map<String, String>();
        // Lấy ra danh sach Điểm môn hoá
        List<Diem__c> listDiemHoa = [SELECT Id, HocSinh__c, Diem__c, Mon__c FROM Diem__c WHERE Mon__c = 'Hoa'];
        Map<String, String> diemHoa = new Map<String, String>();
        
        // Put nhưng học sinh có điểm toán vào map dựa theo Id của HocSinh và Diem
        for(Diem__c diem : listDiemToan){
            diemToan.put(diem.HocSinh__c, diem.Id);
        }

        // Put nhưng học sinh có điểm lý vào map dựa theo Id của HocSinh và Diem
        for(Diem__c diem : listDiemLy){
            diemLy.put(diem.HocSinh__c, diem.Id);
        }

        // Put nhưng học sinh có điểm hóa vào map dựa theo Id của HocSinh và Diem
        for(Diem__c diem : listDiemHoa){
            diemHoa.put(diem.HocSinh__c, diem.Id);
        }
        
        List<Diem__c> diems = new List<Diem__c>();

        // Create danh sách điểm dựa theo HocSinh
        for (HocSinh__c std : scope) {
            if(diemToan.get(std.Id) == null){
                diems.add(new Diem__c(HocSinh__c = std.Id, Diem__c = std.Diem1__c, Mon__c = 'Toan'));
            }else{
                diems.add(new Diem__c(HocSinh__c = std.Id, Diem__c = std.Diem1__c, Mon__c = 'Toan', Id = diemToan.get(std.Id)));
            }

            if(diemLy.get(std.Id) == null){
                diems.add(new Diem__c(HocSinh__c = std.Id, Diem__c = std.Diem2__c, Mon__c = 'Ly'));
            }else{
                diems.add(new Diem__c(HocSinh__c = std.Id, Diem__c = std.Diem2__c, Mon__c = 'Ly', Id = diemLy.get(std.Id)));
            }

            if(diemHoa.get(std.Id) == null){
                diems.add(new Diem__c(HocSinh__c = std.Id, Diem__c = std.Diem3__c, Mon__c = 'Hoa'));
            }else{
                diems.add(new Diem__c(HocSinh__c = std.Id, Diem__c = std.Diem3__c, Mon__c = 'Hoa', Id = diemHoa.get(std.Id)));
            }
        }
        
        Savepoint sp = Database.setSavepoint();
        try {
            upsert diems;   
        } catch (Exception e) {           
            Database.rollback(sp);
        }
    }

    public void finish(Database.BatchableContext bc){
        schedule();
    }
}
