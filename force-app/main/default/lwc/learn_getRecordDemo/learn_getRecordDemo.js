import { api, LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import OWNER_NAME_FIELD from '@salesforce/schema/Account.Owner.Name';
import ANNUAL_REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';

export default class Learn_getRecordDemo extends LightningElement {
    name
    owner
    annualRevenue
    @api recordId;
    /*@wire(getRecord,{recordId:'$recordId',fields:[NAME_FIELD, OWNER_NAME_FIELD, ANNUAL_REVENUE_FIELD]})
    accountHandler({data, error}) {
        if(data){
            console.log(data);
            this.name = data.fields.Name.displayValue ? data.fields.Name.displayValue : 
            data.fields.Name.value
            this.annualRevenue = data.fields.AnnualRevenue.displayValue ? data.fields.AnnualRevenue.displayValue : 
            data.fields.AnnualRevenue.value
            this.owner = data.fields.Owner.displayValue ? data.fields.Owner.displayValue : 
            data.fields.Owner.value
        };
    }*/

    @wire(getRecord,{recordId:'$recordId',layoutTypes:['FULL'],mode:['VIEW']})
    accountHandler({data, error}) {
        if(data){
            console.log(data);
            this.name = data.fields.Name.displayValue ? data.fields.Name.displayValue : 
            data.fields.Name.value
            this.annualRevenue = data.fields.AnnualRevenue.displayValue ? data.fields.AnnualRevenue.displayValue : 
            data.fields.AnnualRevenue.value
            this.owner = data.fields.Owner.displayValue ? data.fields.Owner.displayValue : 
            data.fields.Owner.value
        };
    }
}