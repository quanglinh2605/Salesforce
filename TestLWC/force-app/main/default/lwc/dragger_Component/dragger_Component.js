import { LightningElement, wire } from 'lwc';
import getStudents from '@salesforce/apex/Studentcls.getStudentList';
export default class Dragger_Component extends LightningElement {
    @wire(getStudents) students;
    handlerDragStart(event){
        event.dataTransfer.setData("student_id", event.target.dataset.item);
    }
}