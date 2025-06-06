import { LightningElement } from 'lwc';

export default class DataBinding1 extends LightningElement {

    firstName = ""
    lastName = ""

    changeHandler(event)
    {
        const field = event.target.name

        if(field == 'firstName')
        {
            this.firstName = event.target.value
        }
        else if(field == 'lastName')
        {
            this.lastName = event.target.value
        }
    }

    get upperCasedFullName()
    {
        return this.firstName.toUpperCase() + ' '+ this.lastName.toUpperCase();
    }
}