import { LightningElement } from 'lwc';

export default class LifeCycleParent extends LightningElement {
    isChildVisible = false
    constructor(){
        super()
        console.log("parent constructor called")
    }

    connectedCallback(){
        console.log("parent connected callback is called")
    }

    renderedCallback(){
        console.log("parent rendered call back is called")
    }

    // name
    // changeHandler(event){
    //     this.name = event.target.value
    // }

    handleClick(){
        this.isChildVisible = !this.isChildVisible
    }
}