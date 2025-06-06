import { LightningElement } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact'
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class CreateRecordDemo extends LightningElement {

    formfields={}
    changeHandler(event)
    {
        const{name,value} = event.target
        this.formfields[name] = value //When ever we are giving input through it will add new field name and value if its not exist

    }

    createContact()
    {
        const recordInput = {apiName:CONTACT_OBJECT.objectApiName,fields:this.formfields}
        createRecord(recordInput).then(result=>{
            this.showToast('Success!!',`contact created with id ${result.id}`)
            this.template.querySelector('form.createForm').reset()
            this.formfields= {}
        }).catch(error=>{
            this.showToast('Error Creating record',error.body.message,'error')
        })
    }

    showToast(title,message,variant)
    {
        this.dispatchEvent(new ShowToastEvent({
            title,
            message,
            variant:variant || 'success'
        }))
    }

}