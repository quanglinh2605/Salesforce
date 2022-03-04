/**
 * クラス名：TriggerHandler
 * クラス概要：Handler for event in Trigger of Object HocSinh__c
 * @created：Linh Vo Duc Quang
 * @modified:
*/
public class TriggerHandler {
    
    /**
    * validate   
    * Validate for fileds of Object HocSinh__c 
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    public static void validate(List<HocSinh__c> students){
        for(HocSinh__c std: students){

            if(std.NgaySinh__c == null){
                std.NgaySinh__c.addError('Hay nhap ngay sinh');
            }else{
                // Kiểm tra tuoi hợp lệ trong khoảng 6-18
                Integer days = std.NgaySinh__c.daysBetween(Date.today());
                Integer age = Integer.valueOf(days/365);
                if(age < 6 || age > 18){
                std.NgaySinh__c.addError('Tuoi khong hop le');
                }
            } 
            
            if(String.isBlank(std.HoHS__c)){
                std.HoHS__c.addError('chua nhap ho hoc sinh');
            }

            if(String.isBlank(std.TenHS__c)){
                std.TenHS__c.addError('chua nhap ten');
            }
            
            if(std.Diem1__c == null){
                std.Diem1__c.addError('Hay vao diem cho mon Hoa');
            }
            
            if(std.Diem2__c == null){
                std.Diem2__c.addError('Hay vao diem cho mon Ly');
            }
            
            if(std.Diem3__c == null){
                std.Diem3__c.addError('Hay vao diem cho mon Toan');
            }
            
            if(String.isBlank(std.Lop__c)){
                std.Lop__c.addError('Hay chon lop');
            }
        }
    }

    /**
    * affter   
    * Update Siso__c, HocSinhDau__c and HocSinhRot__c of Lop__c 
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    public static void affter(List<HocSinh__c> Students){
        HocSinh__c std = Students[0];
        Lop__c lop = [SELECT 
                            Id, 
                            MaLop__c, 
                            Siso__c, 
                            HocSinhDau__c, 
                            HocSinhRot__c 
                            FROM Lop__c WHERE 
                            Id = :std.Lop__c];
        
        List<HocSinh__c> listStd = [SELECT Id FROM HocSinh__c WHERE Lop__c = :std.Lop__c];
        if(!listStd.isEmpty()){
            lop.Siso__c = listStd.size();
        }
        
        List<HocSinh__c> listStdPass = [SELECT Id FROM HocSinh__c WHERE Lop__c = :std.Lop__c AND TinhTrang__c = 'Dau'];
        List<HocSinh__c> listStdFail = [SELECT Id FROM HocSinh__c WHERE Lop__c = :std.Lop__c AND TinhTrang__c = 'Rot'];
        
        if(!listStdPass.isEmpty()){
            lop.HocSinhDau__c = listStdPass.size();
        }
        if(!listStdFail.isEmpty()){
            lop.HocSinhRot__c = listStdFail.size();
        }
        
        try {
            update lop;   
        } catch (Exception e) {
        }
    }
}
