import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import { api, LightningElement, wire } from 'lwc';

export default class WireExample3 extends LightningElement {
    @api recordId;

    @wire(getRecord, {recordId:'$recordId', fields:['Account.Name','Account.Phone']}) accounts;)

    get getName(){
        if(this.accounts.data){
            return this.accounts.data.fields.Name.value;
        }
        return getFieldValue(this.accounts.data, 'Account.Name');
    }
}