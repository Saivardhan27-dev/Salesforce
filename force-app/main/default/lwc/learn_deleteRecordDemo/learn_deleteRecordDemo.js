import { LightningElement } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Learn_deleteRecordDemo extends LightningElement {

    recordId;
    changeHandler(event)
    {
        this.recordId = event.target.value;
    }

    deleteHandler()
    {
        deleteRecord(this.recordId).then(() =>{
            this.showToast('Success', 'Record Deleted Successfully', 'success');
        }).catch(error =>{
            console.error(error);
            this.showToast('Error', 'Error Deleting Record', 'error');  
        })
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            })
        );
    }
}