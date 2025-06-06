import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import { LightningElement, wire } from 'lwc';
import NAME_FIELD from '@salesforce/schema/User.Name';
import EMAIL_FIELD from '@salesforce/schema/User.Email';
const fields = [NAME_FIELD, EMAIL_FIELD];
export default class Learn_WireDemoUserDetails extends LightningElement {
    userId = Id
    userDetail
    // @wire (adaptor,{adaptorConfig})
    // propertyOrFunction

    @wire(getRecord,{recordId:'$userId', fields}) // fields : fields (In JS if key and value are same, we can use only one)
    userDetailHandler({data,error}){
        if(data){
            this.userDetail = data.fields;
            console.log(this.userDetail);
        }
        if(error){
            console.error(error);
        }
    }

    @wire(getRecord,{recordId:'$userId', fields})
    userDetailProperty
}