import { LightningElement, wire } from 'lwc';
import filterAccountType from '@salesforce/apex/AccountController.filterAccountType'

export default class Learn_WireApexWithParams extends LightningElement {

    selectedType = ''
    @wire(filterAccountType,{type:'$selectedType'})
    filteredAccounts

    get typeOptions(){
        return [
            {label:"Prospect", value:"Prospect"},
            {label:"Customer - Direct", value:"Customer - Direct"},
            {label:"Customer - Channel", value:"Customer - Channel"}
        ]
    }

    typeHandler(event){
        this.selectedType = event.detail.value
    }
}