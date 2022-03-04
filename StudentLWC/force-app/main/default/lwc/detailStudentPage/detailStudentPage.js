import { api, LightningElement } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';

export default class DetailStudentPage extends LightningElement {
    @api isOpenModal = false;
    @api student;

    closeModal() {
        // to close modal set isModalOpen track value as false
        this.isOpenModal = false;
        const setOpen = new CustomEvent('setfalse', {detail: false});
        this.dispatchEvent(setOpen);
    }

    updateStudent(){
        this.isOpenModal = false;
        this.dispatchEvent(new CustomEvent('openedit'));
    }

    deleteStudent(){
        deleteRecord(this.student.Id)
      .then(() => {
          this.dispatchEvent(new CustomEvent('delete'));
          this.isOpenModal = false;
      })
      .catch(error => {
      })
    }
}