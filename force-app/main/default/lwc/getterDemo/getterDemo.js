import { LightningElement } from 'lwc';

export default class GetterDemo extends LightningElement {
    title = 'This is getter power'

    lowerTitle 

    get getTitle()
    {
        return this.title;
    }

    clickHandler()
    {
        this.lowerTitle = this.lowerTitle.toLowerCase();
        this.title = this.title.toUpperCase();
    }

}