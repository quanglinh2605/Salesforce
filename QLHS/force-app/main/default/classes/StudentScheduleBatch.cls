/**
 * クラス名：  StudentScheduleBatch
 * クラス概要：Set run Batch 
 * @created:  Linh Vo Duc Quang
 * @modified:
*/
public class StudentScheduleBatch implements Schedulable  {
    public void execute(SchedulableContext sc) {
        try {
            StudentBatch b = new StudentBatch(); 
            database.executebatch(b,50);   
        } catch (Exception e) {
        }
    }
}