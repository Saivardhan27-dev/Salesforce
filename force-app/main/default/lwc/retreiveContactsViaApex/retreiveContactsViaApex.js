import { LightningElement, wire } from 'lwc';
import  getContact  from '@salesforce/apex/ContactManager.getContact'
export default class RetreiveContactsViaApex extends LightningElement {

    @wire(getContact) contacts;

    get responseRecieved()
    {
        if(this.contacts)
            return true;
        else   
            return false;
    }

}