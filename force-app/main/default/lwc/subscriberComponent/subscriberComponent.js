import { MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import { LightningElement, wire } from 'lwc';
import lmsDemoChannel from '@salesforce/messageChannel/lmsDemoChannel__c'

export default class SubscriberComponent extends LightningElement {

    name='';
    subscription=null;

    @wire(MessageContext) messageContext
    connectedCallback()
    {
        this.handleSubscribe();
    }

    disconnectedCallback()
    {
        this.handleUnsubcribe();
    }

    handleSubscribe()
    {
        if(!this.subscription)
        {
            this.subscription=subscribe(this.messageContext,lmsDemoChannel,
                    (parameter)=>{
                        this.name=parameter.name //parameter.name -> field name defined in message channel where we'll get data from publish component
                    })
        }
    }

    handleUnsubcribe()
    {
        unsubscribe(this.subscription)
        this.subscription = null
    }
}