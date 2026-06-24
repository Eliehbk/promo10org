import { LightningElement } from 'lwc';

export default class Parent2 extends LightningElement {
c1 = 'Deselected';
c2 = 'Deselected';
handleStatusChange(event){
    const{label,selected}=event.detail;
    if(label==='Component 1'){
        this.c1 =selected ? 'Selected':'Deselected';
    }
    if(label==='Component 2'){
        this.c2 =selected ? 'Selected':'Deselected';
    }
}
}