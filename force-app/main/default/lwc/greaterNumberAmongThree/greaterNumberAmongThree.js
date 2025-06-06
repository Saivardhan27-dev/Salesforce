import { LightningElement } from 'lwc';

export default class GreaterNumberAmongThree extends LightningElement {
    fNumber;
    sNumber;
    tNumber;
    result;

    handleFirstNumber(event) {
        this.fNumber = event.target.value;
    }

    handleSecondNumber(event) {
        this.sNumber = event.target.value;

    }

    handleThirdNumber(event) {
        this.tNumber = event.target.value;
    }


    handleCalculate(event) {
        if (this.fNumber > this.sNumber && this.fNumber > this.tNumber) {
            this.result = this.fNumber;
        }
        else if (this.sNumber > this.fNumber && this.sNumber > this.tNumber) {
            this.result = this.sNumber;
        }
        else {
            this.result = this.tNumber;
        }
        
    }

    handleReset(event) {
        this.fNumber = '';
        this.sNumber = '';
        this.tNumber = '';
        this.result = '';
    }

    handleChange(event) {
        const field = event.target.name;
        if (field === 'first') {
            this.fNumber = event.target.value;
        }
        else if (field === 'second') {
            this.sNumber = event.target.value;
        }
        else if (field === 'third') {
            this.tNumber = event.target.value;
        }
    }
}