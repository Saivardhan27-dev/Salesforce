import { LightningElement, track } from 'lwc';

export default class WelcomeLWC extends LightningElement {
    greeting = 'Hello';
    @track welcome = 'Welcome to LWC';
}