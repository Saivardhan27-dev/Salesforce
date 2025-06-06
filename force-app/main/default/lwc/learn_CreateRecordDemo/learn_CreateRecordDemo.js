import { LightningElement, wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Learn_CreateRecordDemo extends LightningElement {

    formFields = {}
    changeHandler(event) {
        const {name,value} = event.target;
        this.formFields[name] = value; // Similar to -> formFields = {firstName : 'testName'}. It will add all the values to the object
    }

    createContact()
    {
        const recordInput = {apiName:CONTACT_OBJECT.objectApiName,fields:this.formFields}
        createRecord(recordInput).then(result =>{
            this.showToast('Success!!',`Contact Created with id ${result.id}`,'success')
            this.template.querySelector('form.createForm').reset();
            this.formFields={} // Resetting the form
        }).catch(error => {
            this.showToast('Error Creating Record', error.body.message,'error')
        })
    }

    showToast(title, message, variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        )
    }
}