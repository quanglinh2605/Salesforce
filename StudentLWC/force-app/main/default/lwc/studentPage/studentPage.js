import { LightningElement, track, wire } from 'lwc';
import getStudents from '@salesforce/apex/StudentLWCController.getStudents';
import getLops from '@salesforce/apex/StudentLWCController.getLops';
import { refreshApex } from '@salesforce/apex';
import { deleteRecord } from 'lightning/uiRecordApi';
import deleteStudents from '@salesforce/apex/StudentLWCController.deleteStudents';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {loadStyle} from 'lightning/platformResourceLoader';
import COLORS from '@salesforce/resourceUrl/colors';
export default class StudentPage extends LightningElement {
    ten='';
    lopId='0';
    lops = [];
    beginDate = null;
    endDate = null;
    isSortByName = false;
    listId = [];
    
    isOpenCreate = false;
    isOpenEdit = false;
    isOpenDetail = false;
    
    @track std;
    @track students = [];
    @track columns = [
        {label: 'Ho', fieldName: 'HoHS__c', type: 'text'},
        {label: 'Ten', type: "button", typeAttributes: {  
            label: {fieldName:'TenHS__c'},  
            name: 'Detail',  
            title: 'Detail',  
            disabled: false,  
            value: 'detail',  
            iconPosition: 'left'  
        }},
        {
            label: 'Ngay Sinh',
            fieldName: 'NgaySinh__c',
            type: 'date',
            typeAttributes: {
                weekday: 'short',
                year: 'numeric',
                month: 'short',
                day: 'numeric'
            }
        },
        {label: 'Gioi Tinh', fieldName: 'GioiTinh__c', type: 'boolean'},
        {label: 'Diem1', fieldName: 'Diem1__c', type: 'number'},
        {label: 'Diem2', fieldName: 'Diem2__c', type: 'number'},
        {label: 'Diem3', fieldName: 'Diem3__c', type: 'number'},
        {label: 'DiemTB', fieldName: 'DiemTB__c', type:'number'},
        {label: 'Tinh Trang', fieldName: 'TinhTrang__c', type: 'text', 
        'cellAttributes': {
            "class": {
                "fieldName": "showClass"
            }
        }},
        {type: "button", typeAttributes: {  
            label: 'Edit',  
            name: 'Edit',  
            title: 'Edit',  
            disabled: false,  
            value: 'edit',  
            iconPosition: 'left'  
        }},
        {type: "button", typeAttributes: {  
            label: 'Delete',  
            name: 'Delete',  
            title: 'Delete',  
            disabled: false,  
            value: 'delete',  
            iconPosition: 'left'  
        }}  
    ];

    wiredStudentList = [];
    
    //pagination
    recordsToDisplay = [];
    totalRecords;
    pageNo;
    totalPages;
    startRecord;
    endRecord;
    end = false;
    first = true;
    pagelinks = [];
    isLoading = false;
    recordsperpage = 3;  

    @wire(getStudents, {ten:'$ten', lopId:'$lopId', beginDate:'$beginDate', endDate:'$endDate', isSortByName:'$isSortByName'}) stdList(result) {
        this.wiredStudentList = result;
        if (result.data) {
            this.students = result.data.map(item =>{ 
                let color = item.TinhTrang__c=='Rot' ? 'datatable-orange' : ''
                return {...item, "showClass": color}
            });
            this.setRecordsToDisplay();
          } else if (result.error) {
            this.students = [];
          }
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
   
    // handleChange(event){
    //     if(event.target.name==='nameStd'){
    //         this.ten = event.target.value
    //     }
    //     if(event.target.name==='lopId'){
    //         this.lopId = event.target.value
    //     }
    //     if(event.target.name==='beginDate'){
    //         this.beginDate = event.target.value
    //     }
    //     if(event.target.name==='endDate'){
    //         this.endDate = event.target.value
    //     }
    //     if(event.target.name==='isSortByName'){
    //         this.isSortByName = !this.isSortByName;
    //     }
    // }
    
    handleSearch(){
        this.ten = this.template.querySelector("[data-field='nameStd']").value;
        this.lopId = this.template.querySelector("[data-field='lopId']").value;
        this.isSortByName = this.template.querySelector("[data-field='isSortByName']").checked;
        this.beginDate = this.template.querySelector("[data-field='beginDate']").value;
        if(this.beginDate == ''){
            this.beginDate = null;
        }
        this.endDate = this.template.querySelector("[data-field='endDate']").value;
        if(this.endDate == ''){
            this.endDate = null;
        } 
    }

    OpenCreateModal(){
        this.isOpenCreate = !this.isOpenCreate;
    }

    openEdit(){
        this.isOpenEdit = true;
    }

    detailStudent(row){
        this.isOpenDetail = true;
        this.std = row;
    }
    
    closeModal(event){
        this.isOpenCreate = event.detail;
        this.isOpenEdit = event.detail;
        this.isOpenDetail = event.detail;
    }

    reloadPage(){
       return refreshApex(this.wiredStudentList);
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'Edit':
                this.editStudent(row);
                break;
            case 'Delete':
                this.deleteStudent(row);
                break;
            case 'Detail':
                this.detailStudent(row);
                break;   
            default:
        }
    }

    handelRowSelection(event){
        const selectedRows = event.detail.selectedRows;
        for(let i = 0; i< selectedRows.length; i++){
            this.listId.push(selectedRows[i].Id);
        }
    }

    editStudent(row){
        this.isOpenEdit = !this.isOpenEdit;
        this.std = row;
    }
    
    deleteStudent(row){
        deleteRecord(row.Id)
      .then(() => {
        refreshApex(this.wiredStudentList);
      })
      .catch(error => {
      })
    }

    multiDelete(){
        deleteStudents({deleteStudentIds: this.listId})
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Delete Hoc sinh success',
                        variant: 'success',
                    })
                );
            this.template.querySelector('lightning-datatable').selectedRows = [];    
            return refreshApex(this.wiredStudentList);
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    message: error.message,
                    variant: 'error'
                }));
            });
        this.listId = [];    
    }

    renderedCallback(){
        loadStyle(this, COLORS).then(() => {
            console.log('Loaded Successfully');
        }).catch(error => {
            console.log('Error in loading the colors');
        })
    }

    //Pagination
    connectedCallback() {
        getStudents({ten:this.ten, lopId:this.lopId, beginDate:this.beginDate, endDate:this.endDate, isSortByName:this.isSortByName})
            .then(result => {
                this.students = result.map(item =>{ 
                    let color = item.TinhTrang__c=='Rot' ? 'datatable-orange' : ''
                    return {...item, "showClass": color}
                });
                this.setRecordsToDisplay();
            })
            .catch(error => {
                this.errors = error;
            }); 
        this.isLoading = true;
    }
    setRecordsToDisplay() {
        this.totalRecords = this.students.length;
        this.pageNo = 1;
        this.totalPages = Math.ceil(this.totalRecords / this.recordsperpage);
        this.preparePaginationList();
        this.pagelinks = [];
        for (let i = 1; i <= this.totalPages; i++) {
            this.pagelinks.push(i);
        }
        this.isLoading = false;
    }
    handleClick(event) {
        let label = event.target.label;
        if (label === "First") {
            this.handleFirst();
        } else if (label === "Previous") {
            this.handlePrevious();
        } else if (label === "Next") {
            this.handleNext();
        } else if (label === "Last") {
            this.handleLast();
        }
    }

    handleNext() {
        this.pageNo += 1;
        this.preparePaginationList();
    }

    handlePrevious() {
        this.pageNo -= 1;
        this.preparePaginationList();
    }

    handleFirst() {
        this.pageNo = 1;
        this.preparePaginationList();
    }

    handleLast() {
        this.pageNo = this.totalPages;
        this.preparePaginationList();
    }
    preparePaginationList() {
        this.isLoading = true;
        let begin = (this.pageNo - 1) * parseInt(this.recordsperpage);
        let end = parseInt(begin) + parseInt(this.recordsperpage);
        this.recordsToDisplay = this.students.slice(begin, end);

        this.startRecord = begin + parseInt(1);
        this.endRecord = end > this.totalRecords ? this.totalRecords : end;
        this.end = end >= this.totalRecords ? true : false;
        this.first = this.pageNo == 1 ? true : false;

        this.isLoading = false;
    }

    disableEnableActions() {
        let buttons = this.template.querySelectorAll("lightning-button");

        buttons.forEach(bun => {
            if (bun.label === this.pageNo) {
                bun.disabled = true;
            } else {
                bun.disabled = false;
            }
            // if (bun.label === "First") {
            //     bun.disabled = this.pageNo === 1 ? true : false;
            // } else if (bun.label === "Previous") {
            //     bun.disabled = this.pageNo === 1 ? true : false;
            // } else if (bun.label === "Next") {
            //     bun.disabled = this.pageNo === this.totalPages ? true : false;
            // } else if (bun.label === "Last") {
            //     bun.disabled = this.pageNo === this.totalPages ? true : false;
            // }
        });
    }

    handlePage(button) {
        this.pageNo = button.target.label;
        this.preparePaginationList();
    }
}