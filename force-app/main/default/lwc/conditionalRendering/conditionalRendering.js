import { LightningElement } from 'lwc';

export default class ConditionalRendering extends LightningElement {
    showMe = false;

    handleChange(event) {
        this.showMe = event.target.checked;
    }
}