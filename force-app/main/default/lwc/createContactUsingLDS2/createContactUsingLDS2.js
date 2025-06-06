import { LightningElement, wire } from 'lwc';
import { createRecord, getRecord } from 'lightning/uiRecordApi';

const fieldArray = ['Contact.LastName', 'Contact.Phone', 'Contact.Email'];

export default class CreateContactUsingLDS2 extends LightningElement {
    contactName = '';
    contactEmail = '';
    contactPhone = '';
    recordId;

    @wire(getRecord, { recordId: '$recordId', fields: fieldArray }) contactRecord;

    contactNameChangeHandler(event) {
        this.contactName = event.target.value;
    }

    contactEmailChangeHandler(event) {
        this.contactEmail = event.target.value;
    }

    contactPhoneChangeHandler(event) {
        this.contactPhone = event.target.value;
    }

    createContactHandler() {
        const fields = {
            'LastName': this.contactName,
            'Email': this.contactEmail,
            'Phone': this.contactPhone
        };
        const inputRecord = { apiName: 'Contact', fields };
        createRecord(inputRecord)
            .then(response => {
                console.log('Contact created successfully', response.id);
                this.recordId = response.id;
            })
            .catch(error => {
                console.error('Error in creating contact', error.body.message);
            });
    }

    get retContactName() {
        return this.contactRecord.data ? this.contactRecord.data.fields.LastName.value : '';
    }

    get retContactEmail() {
        return this.contactRecord.data ? this.contactRecord.data.fields.Email.value : '';
    }

    get retContactPhone() {
        return this.contactRecord.data ? this.contactRecord.data.fields.Phone.value : '';
    }
}