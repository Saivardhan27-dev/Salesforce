import { LightningElement, wire } from 'lwc';
import filterAccountType from '@salesforce/apex/AccountController.filterAccountType'
export default class WireApexWithParams extends LightningElement {
    selectedType=''

    @wire(filterAccountType, {type:'$selectedType'})
    filteredAccounts

    get typeOptions()
    {
        return [
            {label:"Customer - Direct",value:"Customer - Direct"},
            {label:"Prospect",value:"Prospect"}
        ]
    }

    typeChangeHandler(event)
    {
        this.selectedType = event.target.value;
    }
}