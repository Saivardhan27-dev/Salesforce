import { LightningElement, wire } from 'lwc';
import { getObjectInfo, getObjectInfos } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import CONTACT_OBJECT from '@salesforce/schema/Contact';

export default class ObjectInfosAdapterDemo extends LightningElement {

    multipleObjects
    multipleObjectApiNames = [ACCOUNT_OBJECT,CONTACT_OBJECT]
    @wire(getObjectInfos,{objectApiNames:'$multipleObjectApiNames'})
    multiObjectInfoHandler({data})
    {
        if(data)
        {
            console.log(data)
            this.multipleObjects = data
        }
    }
}