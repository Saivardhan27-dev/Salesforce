import { LightningElement, wire } from 'lwc';
import Id from '@salesforce/user/Id'
import { getRecord } from 'lightning/uiRecordApi';

export default class WireDemoUSerDetail extends LightningElement {
    userId = Id
    //0055j000003HAzLAAW

    //@wire (adapter, {adapterConfig})
    //property or function

    userDetail 
    @wire (getRecord, {recordId:'0055j000003HAzLAAW',fields:['User.Name','User.Email']})
    userDetailHandler(data,error)
    {
        if(data)
        {   
            this.userDetail = data.fields
        }

        if(error)
        {
            console.error(error);
        }

    } 
}