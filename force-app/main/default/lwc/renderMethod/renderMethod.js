import { LightningElement } from 'lwc';
import signinTemplate from './signinTemplate.html'
import signupTemplate from './signupTemplate.html'
import renderMethod from './renderMethod.html'
export default class RenderMethod extends LightningElement {

    selectedBtn=''
    render(){
        return this.selectedBtn === 'signup' ? signupTemplate:
                this.selectedBtn==='signin' ? signinTemplate:
                renderMethod
    }

    handleClick(event){
        this.selectedBtn = event.target.label
    }

    submitHandler(){
        console.log(`${event.target.label} Successfully!!!`)
    }
}