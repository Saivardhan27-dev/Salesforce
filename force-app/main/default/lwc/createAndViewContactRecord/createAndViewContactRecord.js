import { LightningElement, track } from 'lwc';

export default class CreateAndViewContactRecord extends LightningElement {
    @track recordId

    createContactHandler(event)
    {
        this.recordId = event.detail.id;
    }
}