import { LightningElement, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
export default class ObjectInfoAdapterDemo extends LightningElement {

    objectData

    @wire( getObjectInfo, {objectApiName:ACCOUNT_OBJECT})

    accountInfo({data,error})
    {
        if(data)
        {
            console.log(data)
            this.objectData = data;
        }
        else if(error)
        {
            console.error(error);
        }
    }
}