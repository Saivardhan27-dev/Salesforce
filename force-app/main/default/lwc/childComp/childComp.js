import { LightningElement, api, track } from 'lwc';

export default class ChildComp extends LightningElement {
    @track message;

    @api
    changeMessage(strString)
    {
        this.message=strString.toUpperCase();
    }
    
}