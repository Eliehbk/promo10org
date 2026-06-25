import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/accountController2.getAccounts';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import RATING_FIELD from '@salesforce/schema/Account.Rating';

export default class AccountsFilter extends LightningElement {
    selectedRating = 'All';
    accounts = [];
    filteredAccounts = [];
    
    ratingOptions = [
        { label: 'All Accounts', value: 'All' }
    ];

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    accountInfo;

    @wire(getPicklistValues, {
        recordTypeId: '$accountInfo.data.defaultRecordTypeId',
        fieldApiName: RATING_FIELD
    })
    wiredRatingValues({ error, data }) {
        if (data) {

            const dynamicOptions = data.values.map(option => ({
                label: `${option.label} Accounts`,
                value: option.value
            }));

            this.ratingOptions = [
                { label: 'All Accounts', value: 'All' },
                ...dynamicOptions
            ];
        } else if (error) {
            console.error('Error fetching picklist values:', error);
        }
    }

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data.map(acc => ({
                ...acc,
                Name: acc.Name || 'Not Specified',
                Industry: acc.Industry || 'Not Specified',
                Phone: acc.Phone || 'Not Specified',
                Rating: acc.Rating || 'Not Specified'
            }));
            this.applyFilter();
        } else if (error) {
            console.error('Error fetching accounts:', error);
        }
    }

    handleChange(event) {
        this.selectedRating = event.detail.value;
        this.applyFilter();
    }

    applyFilter() {
        if (this.selectedRating === 'All') {
            this.filteredAccounts = this.accounts;
        } else {
            this.filteredAccounts = this.accounts.filter(
                acc => acc.Rating === this.selectedRating
            );
        }
    }
}