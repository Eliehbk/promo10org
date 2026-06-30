import { LightningElement, wire, track } from 'lwc';
import { subscribe, MessageContext, APPLICATION_SCOPE } from 'lightning/messageService';
import ACCOUNT_CHANNEL from '@salesforce/messageChannel/channelTest__c';
import getOppsByAccount from '@salesforce/apex/AccountOppController.getOppsByAccount';

export default class OpportunityList extends LightningElement {
    @track opportunities = [];
    selectedAccountId = '';
    isLoading = false;
    subscription = null;

    @wire(MessageContext)
    messageContext;

    @wire(getOppsByAccount, { accountId: '$selectedAccountId' })
    wiredOpportunities({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.opportunities = data;
        } else if (error) {
            this.opportunities = [];
            console.error('Error fetching opportunities:', error);
        }
    }

    connectedCallback() {
        this.subscribeToChannel();
    }

    subscribeToChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                ACCOUNT_CHANNEL,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    handleMessage(message) {
        if (message?.accountId) {
            this.isLoading = true;
            this.selectedAccountId = message.accountId; // Forces the @wire adapter above to fire
        }
    }
}