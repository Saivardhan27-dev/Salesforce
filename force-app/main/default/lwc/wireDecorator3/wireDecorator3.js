import { getRecord } from 'lightning/uiRecordApi';
import { LightningElement, api, track, wire } from 'lwc';

export default class WireDecorator3 extends LightningElement {
    @api recordId;
    @track data
    @track error
    @track accounts;
    @wire (getRecord,{recordId:'$recordId',fields:['Account.Name','Account.Phone']})
    wiredAccounts({data,error})
    {
        if(data)
        {
            this.accounts = data;
            this.error = undefined;
        }
        else if(error)
        {
            this.accounts = undefined;
            this.error = error;
        }
    }

    get getName(){
        return this.accounts.fields.Name.value;
    }

    get getPhone(){
        return this.accounts.fields.Phone.value;
    }
}