import { LightningElement, track } from 'lwc';
import { createMessageContext, releaseMessageContext,APPLICATION_SCOPE,subscribe, unsubscribe } from 'lightning/messageService';
import SAMPLEMC from "@salesforce/messageChannel/SampleMessageChannel__c";
import HoHS_FIELD from '@salesforce/schema/HocSinh__c.HoHS__c';
import TenHS_FIELD from '@salesforce/schema/HocSinh__c.TenHS__c';
import NgaySinh_FIELD from '@salesforce/schema/HocSinh__c.NgaySinh__c';
export default class Subscriber_lwc extends LightningElement {
    context = createMessageContext();
    subscription = null;
    @track receivedMessage = '';
    @track studentId;
    @track objectApiName='HocSinh__c';
    fields = [HoHS_FIELD, TenHS_FIELD, NgaySinh_FIELD];
    connectedCallback(){
        this.subscribeMC();
    }
    subscribeMC() {
        if (this.subscription) {
            return;
        }
        this.subscription = subscribe(this.context, SAMPLEMC, (message) => {
            this.handleMessage(message);
        },{scope: APPLICATION_SCOPE});
     }
    handleMessage(message) {       
        console.log('message:::'+JSON.stringify(message));
        this.studentId = message.recordId;
        this.receivedMessage = message ? message.recordData.value : 'no message payload';
    }
}