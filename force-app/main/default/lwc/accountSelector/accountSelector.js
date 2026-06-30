import { LightningElement, wire, track } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import ACCOUNT_CHANNEL from '@salesforce/messageChannel/channelTest__c';
import getAccountList from '@salesforce/apex/AccountOppController.getAccountList';

export default class AccountSelector extends LightningElement {
    @track accounts = [];
    error;

    @wire(MessageContext)
    messageContext;

    @wire(getAccountList)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accounts = [];
        }
    }

    get accountOptions() {
        return this.accounts.map(acc => ({
            label: acc.Name,
            value: acc.Id
        }));
    }

    handleAccountChange(event) {
        const selectedId = event.detail.value;

        const payload = { 
            accountId: selectedId 
        };

        // Broadcast selected Account ID to any listening sibling components
        publish(this.messageContext, ACCOUNT_CHANNEL, payload);
    }
}