import { LightningElement } from 'lwc';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import TITLE_FIELD from '@salesforce/schema/Contact.Title';
import ACCOUNT_FIELD from '@salesforce/schema/Contact.AccountId';
export default class Learn_RecordEditFormDemo extends LightningElement {
    objectName = CONTACT_OBJECT;
    fields={
        accountField:ACCOUNT_FIELD,
        nameField:NAME_FIELD,
        emailField:EMAIL_FIELD,
        phoneField:PHONE_FIELD,
        titleField:TITLE_FIELD
    }

    handleReset(){
        const inputFields = this.template.querySelectorAll('lightning-input-field')
        if (inputFields) {
           Array.from(inputFields).forEach(field => {
               field.reset();
           })
        }
    }
}