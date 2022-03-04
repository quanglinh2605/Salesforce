import { LightningElement, track } from 'lwc';
import getStudents from '@salesforce/apex/Studentcls.getStudentList';
import {createMessageContext, releaseMessageContext, publish} from 'lightning/messageService';
import SAMPLEMC from "@salesforce/messageChannel/SampleMessageChannel__c";
export default class Publish_lwc extends LightningElement {
    context = createMessageContext();
    @track studentList;
    
    connectedCallback(){
        getStudents()
        .then(result => {
            this.studentList = result;
        })
        .catch(error => {
            this.studentList = error;
        });
    }

    handleClick(event){
        event.preventDefault();
        const message = {
            recordId: event.target.dataset.value,
            recordData: {value: "message from Lightning Web Component"}
        };
        publish(this.context, SAMPLEMC, message);
    }
}