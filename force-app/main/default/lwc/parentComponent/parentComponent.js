import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
    firstName='';
    lastName='';

    eventHandler(event)
    {
        this.firstName=event.detail.FirstName;
        this.lastName=event.detail.LastName
    }
}