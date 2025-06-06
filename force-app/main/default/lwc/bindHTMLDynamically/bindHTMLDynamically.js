import { LightningElement } from 'lwc';

export default class BindHTMLDynamically extends LightningElement {

    myValue = 'World';
    handleChange(event) {
        this.myValue = event.target.value;
    }
}