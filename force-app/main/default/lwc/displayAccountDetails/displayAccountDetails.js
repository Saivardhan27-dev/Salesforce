import { LightningElement } from 'lwc';
import getAccounts from '@salesforce/apex/AccountHandlerLWC.getAccounts';

export default class DisplayAccountDetails extends LightningElement {

    accounts = [];
    columns = [
        {label:'Account Name', fieldName:'Name', type:'text'},
        {label:'Account Type', fieldName:'Type', type:'text'},
        {label:'Account Industry', fieldName:'Industry',type:'text'},
        {label:'Account Annual Revenue', fieldName:'AnnualRevenue', type:'currency'}
    ];

    connectedCallback() {
        this.fetchAccounts();
    }

    fetchAccounts() {
        getAccounts()
            .then(result => {
                this.accounts = result;
            })
            .catch(error => {
                console.error('Error fetching accounts:', error);
            });
    }
}