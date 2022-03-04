import { api, LightningElement, track, wire } from 'lwc';
import HOHS_FIELD from '@salesforce/schema/HocSinh__c.HoHS__c';
import TENHS_FIELD from '@salesforce/schema/HocSinh__c.TenHS__c';
import NGAYSINH_FIELD from '@salesforce/schema/HocSinh__c.NgaySinh__c';
import GIOITINH_FIELD from '@salesforce/schema/HocSinh__c.GioiTinh__c';
import DIEM1_FIELD from '@salesforce/schema/HocSinh__c.Diem1__c';
import DIEM2_FIELD from '@salesforce/schema/HocSinh__c.Diem2__c';
import DIEM3_FIELD from '@salesforce/schema/HocSinh__c.Diem3__c';
import ID_FIELD from '@salesforce/schema/HocSinh__c.Id';
import { ShowToastEvent } from  'lightning/platformShowToastEvent';
// import getStudentById from '@salesforce/apex/StudentLWCController.getStudentById';
import { updateRecord } from 'lightning/uiRecordApi';
export default class EditStudentPage extends LightningElement {
    @api isOpenModal = false;
    @api student;

    // @wire(getStudentById, {stdId:'$id'}) getStudent(result){
    //     if(result.data){
    //         this.student = result.data;
    //     }else if(result.error){
    //         this.student = [];
    //     }
    // }

    handlechange(event){
        if(event.target.label="Ngay sinh"){
            var birthField = this.template.querySelector("[data-field='Birth']");
        var ageDifMs = Date.now() - (new Date(birthField.value)).getTime();
            var ageDate = new Date(ageDifMs);
            var age = Math.abs(ageDate.getUTCFullYear() - 1970);
            if(age < 6 || age > 18){
                birthField.setCustomValidity("Ngay sinh khong hop le");                    
            }else{
                birthField.setCustomValidity("");               
            }
        }
    }

    closeModal() {
        // to close modal set isModalOpen track value as false
        this.isOpenModal = false;
        const setOpen = new CustomEvent('setfalse', {detail: false});
        this.dispatchEvent(setOpen);
    }

    updateStudent() {
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.student.Id;
        fields[HOHS_FIELD.fieldApiName] = this.template.querySelector("[data-field='HoHS']").value;
        fields[TENHS_FIELD.fieldApiName] = this.template.querySelector("[data-field='TenHS']").value;
        fields[NGAYSINH_FIELD.fieldApiName] = this.template.querySelector("[data-field='Birth']").value;
        fields[GIOITINH_FIELD.fieldApiName] = this.template.querySelector("[data-field='Gender']").checked;
        fields[DIEM1_FIELD.fieldApiName] = this.template.querySelector("[data-field='Diem1']").value;
        fields[DIEM2_FIELD.fieldApiName] = this.template.querySelector("[data-field='Diem2']").value;
        fields[DIEM3_FIELD.fieldApiName] = this.template.querySelector("[data-field='Diem3']").value;
        const recordInput = { fields };
        updateRecord(recordInput)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Contact updated',
                            variant: 'success'
                        })
                    );
                    const setReload = new CustomEvent('setreload');
                    this.dispatchEvent(setReload);
                })
                .catch(error => {
                    console.log(error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });

        this.closeModal(); 
    }
}