import { LightningElement } from 'lwc';
import getContacts from '@salesforce/apex/ContactHandlerLWC.getContacts';

export default class SearchContacts extends LightningElement {
    contacts;
    error;
    async handleLoad(){
        try{
            this.contacts = await getContacts();
            this.error = undefined;
        }
        catch(error){
            this.error = error;
            this.contacts = undefined;
        }
    }
}