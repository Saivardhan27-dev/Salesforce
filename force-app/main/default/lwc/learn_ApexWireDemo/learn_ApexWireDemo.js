import { LightningElement, wire } from 'lwc';
import getAccountList from '@salesforce/apex/AccountController.getAccountList'
export default class Learn_ApexWireDemo extends LightningElement {

    accountsList

    @wire(getAccountList)
    accounts;

    @wire(getAccountList)
    accountsHandler({data, error}) {
        // if(data){
        //     this.accountsList = data.map(item=>{
        //         let newType = item.Type === 'Prospect' ? 'Pros' : item.Type === 'Customer - Direct' ? 'Direct' : '-------';
        //         return {...item, newType}
        //     })
        // }
        // if(error){
        //     console.error(error);
        // }
        if(data){
            this.accountsList = data;
        }
    }
}