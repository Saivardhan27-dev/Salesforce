import { LightningElement, wire } from 'lwc';
import getContactsdata from '@salesforce/apex/ExposeApexMethodController.getContacts';
import getFilteredContacts from '@salesforce/apex/ExposeApexMethodController.getContactsByName'
export default class WireApexMethodExample extends LightningElement {

    allContacts
    allFilteredContacts
    name=''
    //wire property
    @wire(getContactsdata)
    contacts;

    //Wire function
    @wire(getContactsdata)
    contactsResponse({data,error})
    {
        if(data)
        {
            this.allContacts = data;
        }
        if(error)
        {
            console.error(error);
        }
    }

    //Wire function with params
    /*@wire(getFilteredContacts,{Name:'$name'})
    contactFilterResponse({data,error})
    {
        if(data)
        {
            this.allFilteredContacts = data;
        }
        if(error)
        {
            console.error(error);
        }
    }*/

    //Using imperative
    callApexUsingImperative()
    {
        getFilteredContacts({Name:this.name})
        .then(result=>{
            this.allFilteredContacts = result;
        }).catch(error=>{
            console.error(error);
        })
    }

    onNameChangeHandler(event)
    {
        this.name = event.target.value;
    }

}