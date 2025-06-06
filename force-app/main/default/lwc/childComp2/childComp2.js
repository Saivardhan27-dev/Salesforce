import { LightningElement } from 'lwc';

export default class ChildComp2 extends LightningElement {
    handleChange(event){
        const name = event.target.value;
        const selectEvent = new CustomEvent('mycustomevent',{detail:name});
        this.dispatchEvent(selectEvent);
    }
}