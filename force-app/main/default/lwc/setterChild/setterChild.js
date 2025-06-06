import { LightningElement, api } from 'lwc';

export default class SetterChild extends LightningElement {
    name = ''

    @api
    get nameMethod()
    {
        return this.name
    }

    set nameMethod(value)
    {
        this.name = value.toUpperCase();
    }
}