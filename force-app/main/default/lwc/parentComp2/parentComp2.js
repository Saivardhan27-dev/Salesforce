import { LightningElement, track } from 'lwc';

export default class ParentComp2 extends LightningElement {
    @track msg;

    handleCustomEvent(event){
        this.msg = event.detail
    }
}