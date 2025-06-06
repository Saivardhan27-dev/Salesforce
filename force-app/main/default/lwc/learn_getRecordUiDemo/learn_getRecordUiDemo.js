import { getRecordUi } from 'lightning/uiRecordApi';
import { api, LightningElement, wire } from 'lwc';

export default class Learn_getRecordUiDemo extends LightningElement {

    formFields = [
        {"fieldName":'AccountNumber','label':'Account Number'},
        {"fieldName":'AnnualRevenue','label':'Annual Revenue'},
        {"fieldName":'Name','label':'Name'},
        {"fieldName":'Phone','label':'Phone'}
    ]

    @api recordId;
    @wire(getRecordUi, {recordIds:'$recordId',layoutTypes:'Full',modes:'Edit'})
    accountRecordHandler({data, error}) {
        if(data) {
            console.log('Data:', data);
            this.formFields = this.formFields.map(item=>{
                return {...item,value:data.records[this.recordId].fields[item.fieldName].value}
            })
        } else if(error) {
            console.error('Error:', error);
        }
    }
}