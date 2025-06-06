import { LightningElement, wire } from 'lwc';
import {getNavItem} from 'lightning/uiAppsApi'
export default class GetNavItemsDemo extends LightningElement {

        @wire(getNavItem,{
            pagesize:30
        })  
        navItemHandler({data})
        {
            if(data)
            {
                console.log(data)
            }
        }
}