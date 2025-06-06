import { LightningElement } from 'lwc';

export default class LifeCycleChild extends LightningElement {
    constructor(){
        super()
        console.log("child constructor called")
    }

    connectedCallback(){
        console.log("child connected callback is called")
    }

    renderedCallback(){
        console.log("child rendered call back is called")
    }

    disconnectedCallback(){
        alert('child disconnected callback is called')
    }
}