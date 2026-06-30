import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
// Added missing Toast import
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';
import LEASE_TYPE_FIELD from '@salesforce/schema/Opportunity.Lease_Type__c';

import QUOTE_NAME from '@salesforce/schema/Quote.Name';
import START_DATE from '@salesforce/schema/Quote.Proposed_Start_Date__c';
import END_DATE from '@salesforce/schema/Quote.Proposed_End_Date__c';
import PAYMENT_TERMS from '@salesforce/schema/Quote.Payment_Terms__c';
import GRACE_PERIOD from '@salesforce/schema/Quote.Grace_Period_Months__c';
import RETAIL_CAT from '@salesforce/schema/Quote.Retail_Sales_Category__c';
import DURATION from '@salesforce/schema/Quote.Proposed_Duration_Years__c';
import RENT_REVIEW from '@salesforce/schema/Quote.Rent_Review_Frequency__c';

export default class CreateQuote extends LightningElement {
    @api recordId;
    
    // Declared class variables
    selectedDuration = '';
    acceptedFormats = ['.pdf', '.png', '.jpg', '.jpeg'];

    quoteNameField = QUOTE_NAME;
    startDateField = START_DATE;
    endDateField = END_DATE;
    paymentTermsField = PAYMENT_TERMS;
    gracePeriodField = GRACE_PERIOD;
    retailCatField = RETAIL_CAT;
    durationField = DURATION;
    rentReviewField = RENT_REVIEW;

    @wire(getRecord, { recordId: '$recordId', fields: [STAGE_FIELD, LEASE_TYPE_FIELD] })
    opportunity;

    get stageName() { return getFieldValue(this.opportunity.data, STAGE_FIELD); }
    get leaseType() { return getFieldValue(this.opportunity.data, LEASE_TYPE_FIELD); }

    get isStageNew() { return this.stageName === 'New'; }
    get isOffice() { return this.leaseType === 'Office'; }
    get isRetail() { return this.leaseType === 'Retail'; }
    get isLand() { return this.leaseType === 'Land'; }
    get isOfficeOrRetail() { return this.isOffice || this.isRetail; }

    get requiresAttachment() {
        if (!this.isLand) return false;
        const durationInt = parseInt(this.selectedDuration, 10);
        return durationInt > 30;
    }

    handleDurationChange(event) {
        this.selectedDuration = event.target.value;
    }

    handleFormSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        
        fields.OpportunityId = this.recordId; 

        if (this.isLand) {
            fields[this.paymentTermsField.fieldApiName] = 4;
        }

        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    // Renamed this method to match your HTML template!
    handleSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Quote created successfully with ID: ' + event.detail.id,
                variant: 'success'
            })
        );
    }
}