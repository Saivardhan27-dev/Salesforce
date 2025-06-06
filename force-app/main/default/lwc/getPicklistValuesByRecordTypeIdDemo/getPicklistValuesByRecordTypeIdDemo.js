import { LightningElement, wire } from 'lwc';
import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account'
export default class GetPicklistValuesByRecordTypeIdDemo extends LightningElement {

    ratingOptions
    industryOptions
    selectedRating
    selectedIndustry

    @wire (getObjectInfo,{objectApiName:ACCOUNT_OBJECT}) 
    objectInfo

    @wire (getPicklistValuesByRecordType,{objectApiName:ACCOUNT_OBJECT,recordTypeId:'$objectInfo.data.defaultRecordTypeId'})
    picklistHandler({data,error})
    {
        if(data)
        {
            console.log(data)
            this.ratingOptions = this.picklistGenerator(data.picklistFieldValues.Rating)
            this.industryOptions = this.picklistGenerator(data.picklistFieldValues.Industry)
        }
        if(error)
        {
            console.error(error)
        }
    }

    picklistGenerator(data)
    {
        return data.values.map(item=>({"label":item.label,"value":item.value}))
    }

    handleChange(event)
    {
        console.log(event.target.name + '==>' +event.target.value)
        if(event.target.name === 'industry')
        {
            this.selectedIndustry = event.target.value
        }
        if(event.target.name === 'rating')
        {
            this.selectedRating = event.target.value
        } 

        //or use below method
        const {name,value} = event.target
        console.log(name + '=>' +value)
        if(name === 'industry')
        {
            this.selectedIndustry = value
        }
        if(name === 'rating')
        {
            this.selectedRating = value
        }
    }
}