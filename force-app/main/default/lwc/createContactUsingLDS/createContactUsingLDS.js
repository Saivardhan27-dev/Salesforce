import { LightningElement, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';

export default class CreateContactUsingLDS extends LightningElement {
    @track contactName
    @track contactEmail
    @track contactPhone

    contactNameChangeHandler(event)
    {
        this.contactName = event.target.value;
    }

    contactEmailChangeHandler(event)
    {
        this.contactEmail = event.target.value;
    }

    contactPhoneChangeHandler(event)
    {
        this.contactPhone = event.target.value;
    }

    createContactHandler()
    {
        const fields = {'LastName':this.contactName,'Phone':this.contactPhone,'Email':this.contactEmail}
        const recordInput = {apiName:'Contact',fields}
        createRecord(recordInput).then(response=>{
            console.log('Contact has been created successfully',response.Id)
        }).catch(error=>{
            console.log('Error in creating contact',error.body.message)
        });
    }
}