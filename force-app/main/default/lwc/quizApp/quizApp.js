import { LightningElement } from 'lwc';

export default class QuizApp extends LightningElement {
    selected = {} //for storing answers
    correctAnswers = 0 // to show the number of correct answers
    isSubmitted = false // use to show the result
    myQuestions = [
        {
            id:"Question1",
            question:"Which of the following is not a template loop?",
            answers:{
                a:"for-each",
                b:"iterator",
                c:"map loop"
            },
            correctAnswer:"c"
        },

        {
            id:"Question2",
            question:"Which of the following is invalid in LWC component folder?",
            answers:{
                a:".svg",
                b:".apex",
                c:".js"
            },
            correctAnswer:"b"
        },

        {
            id:"Question3",
            question:"Which of the following is not a directive?",
            answers:{
                a:"for-each",
                b:"if:true",
                c:"@track"
            },
            correctAnswer:"c"
        }
    ]

    get allNotSelected(){
        return !(Object.keys(this.selected).length === this.myQuestions.length)
    }

    get isScoredFull(){
        return `slds-text-heading_large ${this.myQuestions.length === this.correctAnswers?`slds-text-color_success`:`slds-text-color_error`}`
    }

    //changeHandler get's called on every click on options
    changeHandler(event){
        // console.log("name",event.target.name)
        // console.log("value",event.target.value)
        const {name,value} = event.target
        // const name = event.target.name
        // const value = event.target.value
        this.selected = {...this.selected, [name]:value}
        //this.selected = {"Question1":"b"}
    }


    submitHandler(event){
        event.preventDefault()
        let correct=this.myQuestions.filter(item=>this.selected[item.id] === item.correctAnswer)
        this.correctAnswers = correct.length
        this.isSubmitted = true
        // console.log("this.correctAnswers ",this.correctAnswers)
    }
    resetHandler(){
        this.selected = {}
        this.correctAnswers=0
        this.isSubmitted = false
    }
}