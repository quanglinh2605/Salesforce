import { LightningElement, api, wire } from 'lwc';
import HOCSINH_OBJECT from '@salesforce/schema/HocSinh__c';
import HOHS_FIELD from '@salesforce/schema/HocSinh__c.HoHS__c';
import TENHS_FIELD from '@salesforce/schema/HocSinh__c.TenHS__c';
import NGAYSINH_FIELD from '@salesforce/schema/HocSinh__c.NgaySinh__c';
import GIOITINH_FIELD from '@salesforce/schema/HocSinh__c.GioiTinh__c';
import DIEM1_FIELD from '@salesforce/schema/HocSinh__c.Diem1__c';
import DIEM2_FIELD from '@salesforce/schema/HocSinh__c.Diem2__c';
import DIEM3_FIELD from '@salesforce/schema/HocSinh__c.Diem3__c';
import LOP_FIELD from '@salesforce/schema/HocSinh__c.Lop__c';
import { ShowToastEvent } from  'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import getLops from '@salesforce/apex/StudentLWCController.getLops';
export default class CreateStudentPage extends NavigationMixin (LightningElement) {
    @api isOpenModal = false;

    ho = '';
    ten = '';
    ngaysinh = null;
    gioitinh = false;
    diem1 = 0;
    diem2 = 0;
    diem3 = 0;
    lopId = '';
    
    closeModal() {
        // to close modal set isModalOpen track value as false
        this.isOpenModal = false;
        const setOpen = new CustomEvent('setfalse', {detail: false});
        this.dispatchEvent(setOpen);
    }

    @wire(getLops) lopRecords ({error, data}){
        if(data){
            this.lops = data;
        }else if(error){
            this.lops = undefined;
        }
    }

    get options(){
        let picklistOptions = [];
        this.lops.forEach(element => {
            picklistOptions.push({
                label:element.TenLop__c,
                value:element.Id
            });
        });
        return picklistOptions;
    }

    handleChange(event){
        if(event.target.label=='Ho hoc sinh'){
            this.ho = event.target.value
        }
        if(event.target.label=='Ten hoc sinh'){
            this.ten = event.target.value
        }
        if(event.target.label=='Gioi tinh'){
            this.gioitinh = !this.gioitinh;
        }
        if(event.target.label=='Ngay sinh'){
            var dob = new Date(event.target.value);
            var ageDifMs = Date.now() - dob.getTime();
            var ageDate = new Date(ageDifMs);
            var age = Math.abs(ageDate.getUTCFullYear() - 1970);
            if(age < 6 || age > 18){
                event.target.setCustomValidity("Ngay sinh khong hop le");                    
            }else{
                event.target.setCustomValidity("");
                this.ngaysinh = dob;
            }
        }
        if(event.target.label=='Diem 1'){
            this.diem1 = event.target.value
        }
        if(event.target.label=='Diem 2'){
            this.diem2 = event.target.value
        }
        if(event.target.label=='Diem 3'){
            this.diem3 = event.target.value
        }
        if(event.target.label=='Lop'){
            this.lopId = event.target.value
        }
    }

    saveStudent(){
        const fields = {};
        fields[HOHS_FIELD.fieldApiName] = this.ho;
        fields[TENHS_FIELD.fieldApiName] = this.ten;
        fields[NGAYSINH_FIELD.fieldApiName] = this.ngaysinh;
        fields[GIOITINH_FIELD.fieldApiName] = this.gioitinh;
        fields[DIEM1_FIELD.fieldApiName] = this.diem1;
        fields[DIEM2_FIELD.fieldApiName] = this.diem2;
        fields[DIEM3_FIELD.fieldApiName] = this.diem3;
        fields[LOP_FIELD.fieldApiName] = this.lopId;
        const recordInput = { apiName: HOCSINH_OBJECT.objectApiName, fields};
        createRecord(recordInput)
            .then(std => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Add Hoc sinh success',
                        variant: 'success',
                    })
                );
                this.dispatchEvent(new CustomEvent('setreload'));
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
       
        this.closeModal();
    }
}