import { LightningElement } from 'lwc';

export default class QuerySelector extends LightningElement {
    name = 'Vardhan'
    clickHandler(event)
    {
        this.name = this.template.querySelector('lightning-input').value;
    }
}