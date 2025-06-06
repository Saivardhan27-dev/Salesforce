import { LightningElement } from 'lwc';

export default class HelloQuerySelector extends LightningElement {
    userNames = ["Jhon","Sai","Vardhan","Sai Vardhan"]
    fetchDetailHandler()
    {
        const elem = this.template.querySelector('h1')
        elem.style.border="1px solid red"
        console.log(elem.innerText)
        const userElemenets = this.template.querySelectorAll('.name')
        console.log(elem.innerText)
        Array.from(userElemenets).forEach(item=>{
            console.log(item.innerText)
            item.setAttribute("title",item.innerText)
        })

        //lwc:manual demo
        const childElem = this.template.querySelector('.child')
        childElem.innerHTML = '<p>Hey I am a child element</p>'
    }
}