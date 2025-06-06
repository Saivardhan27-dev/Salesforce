import { LightningElement, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { getListUi } from 'lightning/uiListApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';

const COLS =[
    {label:'Id', fieldName:'Id'},
    {label:'Name', fieldName:'Name'},
    {label:'Title', fieldName:'Title'},
    {label:'Phone', fieldName:'Phone',editable:true},
    {label:'Email', fieldName:'Email',type:'email',editable:true}
]

export default class Learn_updateRecordDemo extends LightningElement {

    contacts=[];
    columns=COLS;
    draftValues=[];
    @wire(getListUi, {objectApiName:CONTACT_OBJECT,listViewApiName:'AllContacts',pageSize:10})
    listViewHandler({data, error}) {
        if(data){
            console.log('List View Data:', data);
            this.contacts = data.records.records.map(item=>{
                return {
                    "Id":this.getValue(item,'Id'),
                    "Name":this.getValue(item,'Name'),
                    "Email":this.getValue(item,'Email'),
                    "Phone":this.getValue(item,'Phone'),
                    "Title":this.getValue(item,'Title'),
                }
            })
        }
        if(error){
            console.error('Error:', error);
        }
    }

    getValue(data,field){
        return data.fields[field].value;
    }

    handleSave(event)
    {
        console.log(JSON.stringify(event.detail.draftValues))
        const recordInputs = event.detail.draftValues.map(draft =>{
            const fields = {...draft}
            return {fields:fields}
        })
        const promises = recordInputs.map(recordInput => updateRecord(recordInput))
        Promise.all(promises).then(() => {
            console.log('Contact updated successfully')
            this.draftValues=[]
        }).catch(error => {
            console.log('Error updating the record', error)
        })
    }
}