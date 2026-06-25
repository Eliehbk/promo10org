import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/accountController.getAccounts';

export default class AccountList extends LightningElement {
    @track accountLimit = 5;

    @wire(getAccounts, { limitNumber: '$accountLimit' })
    wiredAccountsResult;

    handleInputChange(event) {
        this.accountLimit = event.target.value ? parseInt(event.target.value, 10) : 0;
    }
}
