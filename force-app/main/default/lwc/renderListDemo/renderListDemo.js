import { LightningElement } from 'lwc';

export default class RenderListDemo extends LightningElement {
    superstars = ["Spiderman","Superman","Batman","Ironman","Hulk"];

    contactList = [
        {
            id : 1,
            firstName : "Sai",
            lastName : "Vardhan"
        },
        {
            id : 2,
            firstName : "Rajya",
            lastName : "Lakshmi"
        },
        {
            id : 3,
            firstName : "Shiva",
            lastName : "Prasad"
        },
        {
            id : 4,
            firstName : "Sujith",
            lastName : "Raj"
        }
    ];
}