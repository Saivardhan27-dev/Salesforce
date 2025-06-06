import { LightningElement, wire } from 'lwc';
import { getObjectInfos } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
export default class Learn_getObjectInfosDemo extends LightningElement {
    
    objectInfos
    objectApiNames = [ACCOUNT_OBJECT, OPPORTUNITY_OBJECT];
    @wire(getObjectInfos, { objectApiNames: '$objectApiNames' })
    objectInfoHandler({ data}) {
        if(data)
        {
            console.log('data', data);
            this.objectInfos = data;
        }
    }
}