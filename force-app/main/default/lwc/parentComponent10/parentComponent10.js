import { LightningElement } from 'lwc';

export default class ParentComponent10 extends LightningElement {

message;
    handleInput(event){
        this.message=event.target.value;
    }
}