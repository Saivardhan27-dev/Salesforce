import { getRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id'
import { LightningElement, wire } from 'lwc';
import NAME_FIELD from '@salesforce/schema/User.Name'
import EMAIL_FIELD from '@salesforce/schema/User.Email'
const fields = [NAME_FIELD,EMAIL_FIELD]

export default class WireUserDetailDemo extends LightningElement {
    //0055j000003HAzLAAW
    userId = Id
    userDetail

    @wire (getRecord, {recordId:userId,fields:fields})
    userDetailHandler({data,error})
    {
        if(data)
        {
            this.userDetail = data.fields
            console.log(this.userDetail)
        }
        if(error)
        {
            console.error(error)
        }
    }

    @wire (getRecord, {recordId:userId,fields:fields})
    userDetailProperty
    
}