import { LightningElement, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
export default class Learn_getObjectInfoDemo extends LightningElement {
    defaultRecordTypeId
    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    objectInfo
}