import { LightningElement, wire } from 'lwc';
import { getObjectInfos } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account'
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity'

export default class GetObjectInfosDemo extends LightningElement {

    objectInfos
    objectApiNames = [ACCOUNT_OBJECT,OPPORTUNITY_OBJECT];
    @wire(getObjectInfos,{objectApiNames:'$objectApiNames'})
    objectInfosHandler({data,error}){
        if(data)
        {
            console.log(JSON.stringify(data));
            this.objectInfos = data;
        }

        if(error)
        {
            console.error(error);
        }
    }
}