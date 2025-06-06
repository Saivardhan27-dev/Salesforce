import { LightningElement, wire } from 'lwc';
import { getPicklistValues , getObjectInfo} from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account'
import ACCOUNT_SOURCE_FIELD from '@salesforce/schema/Account.AccountSource'
export default class GetPickListValuesExample extends LightningElement {

    sourceOptions;
    selectedSource;

    @wire(getObjectInfo,{objectApiName:ACCOUNT_OBJECT})
    accountInfo

    @wire(getPicklistValues,{recordTypeId:'$accountInfo.data.defaultRecordTypeId',fieldApiName:ACCOUNT_SOURCE_FIELD})
    sourcePicklist({data,error})
    {
        if(data)
        {
            console.log(data)
            this.sourceOptions = [...this.makePicklistValues(data)]
        }
        if(error)
        {
            console.error(error)
        }
    }

    makePicklistValues(data)
    {
        return data.values.map(item => ({label:item.label,value:item.value}))
    }

    onSourceChangeHandler(event)
    {
        this.selectedSource = event.target.value
    }
}