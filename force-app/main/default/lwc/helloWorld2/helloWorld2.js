import { LightningElement , track} from 'lwc';

export default class HelloWorld2 extends LightningElement {
    fullName = "Zero To Hero";
    title = "aura";

    // two way binding
    changeHandler(event)
    {
        this.title = event.target.value;
    }

    // track properties
    // When we are updating objects or Arrays use @track property
    @track address = {
        city:"Warangal",
        postcode:506002,
        country:"India"
    }

    trackHandler(event)
    {
        this.address.city = event.target.value;
    }

    // getter demo
    users = ["Sai","Vardhan","Sai Vardhan"];
    num1 = 10;
    num2 = 20;

    //firstUser = this.users[0] we have to update everytime explicitly but in getters it renders automatically.
    get firstUser()
    {
        return this.users[0];
    }

    get multiply()
    {
        return this.num1 * this.num2;
    }
}