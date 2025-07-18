import { LightningElement, api, wire } from 'lwc';
import { getFieldDisplayValue, getFieldValue, getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import OWNER_NAME_FIELD from '@salesforce/schema/Account.Owner.Name';
import ANNUAL_REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';

export default class Learn_getFieldValueDemo extends LightningElement {
    name
    owner
    annualRevenue
    @api recordId;
    @wire(getRecord,{recordId:'$recordId',fields:[NAME_FIELD, OWNER_NAME_FIELD, ANNUAL_REVENUE_FIELD]})
    accountHandler({data, error}) {
        if(data){
            console.log(data);
            this.name = getFieldValue(data,NAME_FIELD)
            this.annualRevenue = getFieldDisplayValue(data, ANNUAL_REVENUE_FIELD) //for this field 
            this.owner = getFieldValue(data, OWNER_NAME_FIELD)
        };
    }

}