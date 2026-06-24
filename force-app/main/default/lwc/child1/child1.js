
import { LightningElement } from 'lwc';

export default class child1 extends LightningElement {
    handleClick() {
        const myEvent = new CustomEvent('myevent', {
            detail: { message: 'Hello from the child!' },
        });

        this.dispatchEvent(myEvent);
    }
}
