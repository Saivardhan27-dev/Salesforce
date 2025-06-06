import { LightningElement } from 'lwc';

export default class ChildComponent extends LightningElement {
    firstName='';
    lastName='';

    changeHandlerFirstName(event)
    {
        this.firstName=event.target.value;
    }

    changeHandlerLastName(event)
    {
        this.lastName=event.target.value;
    }
    clickHandler(event)
    {
        const searchEvent = new CustomEvent('getsearchevent',
        {detail:
            {
                FirstName:this.firstName,
                LastName:this.lastName
            }    
        })
        this.dispatchEvent(searchEvent)

        //or
        //this.dispatchEvent(new CustomEvent('getsearchevent',{detail:this.name}))
    }
}