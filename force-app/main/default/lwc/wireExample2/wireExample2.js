import { LightningElement, wire ,api} from 'lwc';
import getAccountList from '@salesforce/apex/AccountHelper.getAccountList';

export default class WireExample2 extends LightningElement {
    @wire (getAccountList) accounts; //=> it will give all the accounts

    // @api recordId;
    // @wire (getAccountList,{accId:'$recordId'}) accounts; //It returns only one record by putting where clause in html
}