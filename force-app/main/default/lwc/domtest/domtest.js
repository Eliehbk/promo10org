import { LightningElement } from 'lwc';

export default class Domtest extends LightningElement {
counter=0;
showMessage=true;
constructor(){
super();
    console.log('constructor called')
}
connectedCallback(){
console.log('connectedCallback called')
}
renderedCallback(){
    console.log('rendercallback called')
}
handleIncrement(){
    this.counter++;
}
toggleMessage(){
    this.showMessage=!this.showMessage;
}
}