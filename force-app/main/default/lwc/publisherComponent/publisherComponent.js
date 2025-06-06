import { MessageContext, publish } from 'lightning/messageService';
import { LightningElement, wire } from 'lwc';
import lmsDemoChannel from '@salesforce/messageChannel/lmsDemoChannel__c'

export default class PublisherComponent extends LightningElement {

    name=''
    @wire (MessageContext) messageContext;
    handleChange(event)
    {
        this.name = event.target.value;
    }

    handleClick(event)
    {
        //Code to pass message to subscriber
        //publish(this.messageContext,MessageChannel,payload)
        let payload={name:this.name} //this.name value is assigning to name field which is present in the message channel xml file
        publish(this.messageContext,lmsDemoChannel,payload)
    }
}