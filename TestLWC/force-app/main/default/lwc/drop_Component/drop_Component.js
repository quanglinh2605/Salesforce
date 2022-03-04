import { LightningElement, track } from 'lwc';
import HoHS_FIELD from '@salesforce/schema/HocSinh__c.HoHS__c';
import TenHS_FIELD from '@salesforce/schema/HocSinh__c.TenHS__c';
import NgaySinh_FIELD from '@salesforce/schema/HocSinh__c.NgaySinh__c';
export default class Drop_Component extends LightningElement {
    fields = [HoHS_FIELD, TenHS_FIELD, NgaySinh_FIELD];
    @track studentId;
    @track message = "Drop an Student here";
    dropElement(event){
        console.log(event.dataTransfer.getData("student_id"));
        this.studentId = event.dataTransfer.getData("student_id");
        this.message = '';
    }

    allowDrop(event){
        event.preventDefault();
    }
}