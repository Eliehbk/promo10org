import { LightningElement ,track} from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import getAccounts from '@salesforce/apex/accountActionController.getAccounts';
import updateDescription from '@salesforce/apex/accountActionController.updateDescription';
export default class GetUpdateAccounts extends NavigationMixin(LightningElement) {
 @track accounts =[];
 @track selectedAccount=null;
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
handleNavigateToRecord(event) {
    console.log('hellllllllllllllll');
        const accId = event.target.dataset.id;
        console.log(accId);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: accId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

handleSelect(event){
const accId=event.target.dataset.id;
this.selectedAccount=this.accounts.find(acc=> acc.Id===accId)
this.newDesc=this.selectedAccount.Description ||null;
this.selectedAccount.Description = this.newDesc;
}
handleInputChange(event) {
        this.newDesc = event.target.value;
    }
async handleUpdate(){
try{
await updateDescription({
accountId: this.selectedAccount.Id, 
descText: this.newDesc
    });

}
catch(error){
    console.error(error);
}

}

}