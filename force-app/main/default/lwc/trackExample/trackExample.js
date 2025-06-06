import { LightningElement, track } from 'lwc';

export default class TrackExample extends LightningElement {

    @track counter = 0;

    incrementCounter()
    {
        this.counter = this.counter + 1;
    }

    decrementCounter()
    {
        this.counter = this.counter - 1;
    }
}