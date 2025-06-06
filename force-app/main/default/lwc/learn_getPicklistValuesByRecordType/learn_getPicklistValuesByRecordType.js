import { LightningElement, wire } from 'lwc';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
export default class Learn_getPicklistValuesByRecordType extends LightningElement {

    ratingOptions;
    industryOptions;
    selectedRating;
    selectedIndustry;
    @wire(getObjectInfo,{objectApiName:ACCOUNT_OBJECT})
    objectInfo

    @wire(getPicklistValuesByRecordType,{objectApiName:ACCOUNT_OBJECT,recordTypeId:'$objectInfo.data.defaultRecordTypeId'})
    picklistHandler({data,error}){
        if(data){
            console.log('data',data);
            this.ratingOptions = this.picklistGenerator(data.picklistFieldValues.Rating)
            this.industryOptions = this.picklistGenerator(data.picklistFieldValues.Industry)
        }
        if(error){
            console.log('error',error);
        }
    }

    picklistGenerator(data){
        return data.values.map(item => ({label:item.label, value:item.value}))
    }

    handleChange(event){
        // if(event.target.name === 'rating'){
        //     this.selectedRating = event.detail.value;
        // }
        // if(event.target.name === 'industry'){
        //     this.selectedIndustry = event.detail.value;
        // }
        
        //easy method
        const {name,value} = event.target;
        if(name === 'rating'){
            this.selectedRating = value;
        }
        if(name === 'industry'){
            this.selectedIndustry = value;
        }
    }
}