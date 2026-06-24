import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
    handleEventFromChild(event) {
        const messageFromChild = event.detail.message;
        console.log(messageFromChild);
    }
}
