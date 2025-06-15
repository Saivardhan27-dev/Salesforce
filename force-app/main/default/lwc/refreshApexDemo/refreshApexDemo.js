import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/getAccountDetails.getAccounts';
import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

const cols = [
    {label : 'Account Name', fieldName : 'Name'},
    {label : 'Phone', fieldName : 'Phone'},
    {label : 'Type', fieldName : 'Type'},
    {label : 'Total Opportunity Amount', fieldName : 'Total_Opportunities_Amount__c'}
]
export default class RefreshApexDemo extends LightningElement {

    columns = cols;
    accounts;
    error;
    selectedRecord;
    wiredAccountList;

    @wire(getAccounts)
    wiredAccounts(result){
        this.wiredAccountList = result; // Store the result for later use with refreshApex
        if(result.data) {
            this.accounts = result.data;
        }
        else if(result.error){
            this.error = result.error;
        }
    }

    handleSelection(event){
        if(event.detail.selectedRows.length > 0){
            this.selectedRecord = event.detail.selectedRows[0].Id;
        }
    }
    deleteAccount(){
        deleteRecord(this.selectedRecord)
        .then(() => {
            refreshApex(this.wiredAccountList)
        })
        .catch(error => {

        })
    }
}