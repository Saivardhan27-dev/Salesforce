import { LightningElement, track } from 'lwc';
import invokeAgentKoaMethod from '@salesforce/apex/KoaAgentInvoker.invokeAgentKoaMethod';
export default class KoaAgentComponent extends LightningElement {
   @track userMessage = '';
   @track chatHistory = [];
   sessionId = '';
   handleChange(event) {
       this.userMessage = event.detail.value;
   }
   handleSend() {
       this.chatHistory.push(`User: ${this.userMessage}`);
       invokeAgentKoaMethod({ message: this.userMessage, sessionId: this.sessionId })
           .then(response => {
               this.chatHistory.push(`Agent: ${response.reply}`);
               this.sessionId = response.sessionId;
               this.userMessage = '';
           })
           .catch(error => {
               console.error(error);
               this.chatHistory.push('Agent: [Error communicating with agent]');
           });
   }
}