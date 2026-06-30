import { LightningElement ,track,wire} from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import getAccounts from '@salesforce/apex/accountActionController.getAccounts';
import updateDescription from '@salesforce/apex/accountActionController.updateDescription';
import { refreshApex } from '@salesforce/apex';
export default class GetUpdateAccounts extends NavigationMixin(LightningElement) {
    filterType = 'Recent';
 @track accounts =[];
 @track selectedAccount=null;
 wiredAccountsResult;
newDesc ='';
async handleLoad(event){
const filter = event.target.dataset.filter;
try{
  this.accounts= await getAccounts({ filterType: filter });
  this.selectedAccount=null;  
}
catch(error){
console.error(error);
}
}
 /*@wire(getAccounts, { filterType: '$filterType' })
    wiredAccounts(result) {
        this.wiredAccountsResult = result;
        const { data, error } = result;
        if (data) {
            this.accounts = data;
            // Sync selectedAccount details if it was previously open
            if (this.selectedAccount) {
                const updated = data.find(acc => acc.Id === this.selectedAccount.Id);
                if (updated) {
                    this.selectedAccount = updated;
                    this.newDesc = updated.Description || '';}}} else if (error) {
            console.error('Error loading wired data:', error);
            this.accounts = [];}}**/
handleNavigateToRecord(event) {
        const accId = event.target.dataset.id;
        console.log(accId);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: accId,
                objectApiName: 'Account',
                actionName: 'view'}});}
handleSelect(event){
const accId=event.target.dataset.id;
this.selectedAccount=this.accounts.find(acc=> acc.Id===accId)
this.newDesc=this.selectedAccount.Description ||null;
this.selectedAccount.Description = this.newDesc;}
handleInputChange(event) {
        this.newDesc = event.target.value;}
async handleUpdate(){
try{
await updateDescription({
accountId: this.selectedAccount.Id, 
descText: this.newDesc});
//await refreshApex(this.wiredAccountsResult);
}
catch(error){
    console.error(error);
}}}