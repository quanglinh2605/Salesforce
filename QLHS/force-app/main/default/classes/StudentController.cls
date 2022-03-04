/**
 * クラス名：  StudentController
 * クラス概要：Intensive handling on HocSinh__c   
 * @created： 2020/11/4 Linh Vo Duc Quang
 * @modified:
*/
public class StudentController {
    public List<HocSinh__c> students {get;set;}
    public HocSinh__c currentStudent {get;set;}
    public List<Lop__c> lops {get;set;}
    public String lopId {get;set;}
    public String tenString {get;set;}
    public Date beginDate {get;set;}
    public Date endDate {get;set;}
    public Boolean isSortByName {get;set;}

    public StudentController() {
        initData();
    }

    /**   
    * searchStudent
    * Return list of HocSinh__c
    * @return：  List<HocSinh__c>
    * @param: 
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    public void searchStudent(){
        try {
            students = new List<HocSinh__c>();
            String query = 'SELECT Id'
                            + ', HoHS__c'
                            + ', TenHS__c'
                            + ', NgaySinh__c'
                            + ', GioiTinh__c'
                            + ', Diem1__c'
                            + ', Diem2__c'
                            + ', Diem3__c'
                            + ', DiemTB__c'
                            + ', TinhTrang__c' 
                            + ', Lop__c ' 
                            + 'FROM HocSinh__c';
            if(String.isNotBlank(lopId)){
                query += ' AND Lop__r.Id = :lopId ';
            }
            if(String.isNotBlank(tenString)){
                String likeTen = '%' + String.escapeSingleQuotes(tenString) + '%';
                query += ' AND TenHS__c LIKE :likeTen ';
            }
            if(beginDate != null){
                query += ' AND NgaySinh__c >= :beginDate ';
            }
            if(endDate != null){
                query += ' AND NgaySinh__c <= :endDate ';
            }    
            String conditionSort = ' ORDER BY TenHS__c {0}';
                
            if(isSortByName){
                query += String.format(conditionSort, new List<String> {'ASC'});
            }else{
                query += String.format(conditionSort, new List<String> {'DESC'});
            }
            students = Database.query(query.replaceFirst('AND', 'WHERE'));
            if (students.isEmpty()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'There is no result!!!'));
            }
        }catch (Exception e){
        }
    }

    /**   
    * initStudentById
    * return an Object HocSinh__c
    * @param:    id, id is handled
    * @return：  HocSinh__c has value or HocSinh__c without value
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    public void initStudentById(){
    	try{
            String recordId = Apexpages.currentPage().getParameters().get('id');
            if(String.isBlank(recordId)){
                currentStudent = new HocSinh__c();
            } else {
                currentStudent = [SELECT 
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
                                Id = :recordId];
            } 
        }catch (Exception e) {

        }
    }

    /**   
    * save 
    * return StudentPage page
    * @return：  PageReference
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    public PageReference save(){
        try {
            upsert currentStudent;
            Pagereference pageRef = Page.StudentPage;
            pageRef.setRedirect(true);
            return pageRef;
        } catch (Exception e) {
            return null;
        }
    }

    /**   
    * newStudent
    * return CreateStudentPage page
    * @return：  PageReference
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    public PageReference goToNewStudentPage(){
        try {
            PageReference pageRef = Page.CreateStudentPage;
            pageRef.setRedirect(true);
            return pageRef;   
        } catch (Exception e) {
            return null;
        }
    }
    
    /**   
    * reloadPage 
    * return StudentPage page
    * @return：  PageReference
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    public PageReference reloadPage() {
        try {
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
                        FROM HocSinh__c 
                        ORDER BY TenHS__c DESC];
            PageReference pageRef  = Page.StudentPage;
            pageRef.setRedirect(true);
            return pageRef;   
        } catch (Exception e) {
            return null;
        }
    }

    /**   
    * editStudent
    * return EditStudentPage page
    * param:     recordId, record is handled
    * @return：  PageReference
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    public PageReference goToEditStudentPage(){
        try {
            String studentId = Apexpages.currentPage().getParameters().get('studentId');
            PageReference pageRef = Page.EditStudentPage;
            pageRef.getParameters().put('id', studentId);
            pageRef.setRedirect(true);
            return pageRef;   
        } catch (Exception e) {
            return null;
        }   
    }

    /**   
    * deleteRecord
    * param:     recordIndex, recordIndex is handled
    * @created： Linh Vo Duc Quang
    * @modified：
    */
    public void deleteRecord(){
        try {
            String studentId = Apexpages.currentPage().getParameters().get('studentId');
            delete [SELECT Id FROM HocSinh__c WHERE Id = :studentId];
            reloadPage();
        } catch (Exception e) {
        }          
    }

    /**   
    * multilDelete
    * param:     ids, ids is handled
    * @created： Linh Võ Đức Quang
    * @modified：
    */
    public void multilDelete(){
        try {
            String listIdHocSinh =  Apexpages.currentPage().getParameters().get('idList');
            List<Id> arr = listIdHocSinh.split(',');
            List<HocSinh__c> listHocSinhDelete = [SELECT Id FROM HocSinh__c WHERE Id IN :arr];
            delete listHocSinhDelete;
            reloadPage();
        } catch (Exception e) {
        }        
    }
    
    /**   
    * getItems
    * return a List<SelectOption> of Object Lop__c
    * @return：  List<SelectOtion>
    * @created： Linh Võ Đức Quang
    * @modified：
    */
    public List<SelectOption> getItems() {
        
        List<SelectOption> options = new List<SelectOption>();
        try {
            options.add(new SelectOption('','Choose class'));
            for (Lop__c lop : lops) {
                options.add(new SelectOption(lop.Id,lop.TenLop__c));            
            }
            return options;   
        } catch (Exception e) {
            return null;
        }     
    }

    private void initData(){
        students = new List<HocSinh__c>();
        lops = new List<Lop__c>();
        lops = [SELECT MaLop__c, TenLop__c FROM Lop__c];
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
                        FROM HocSinh__c 
                        ORDER BY TenHS__c DESC];
    }
}