import { LightningElement,track } from 'lwc';

export default class EmployeeList extends LightningElement {
@track employees = [];


addEmployee(){

    const nameInput = this.template.querySelector('input[type="text"]');
    const ageInput = this.template.querySelector('input[type="number"]');
    const emailInput = this.template.querySelector('input[type="email"]');
    this.employees.push({
            name: nameInput.value,
            age: ageInput.value,
            email: emailInput.value
        });
nameInput.value = '';
ageInput.value = '';
emailInput.value = '';

}

deleteEmployee(event){
    const index = event.target.key;
 
  this.employees.splice(index, 1); 
  this.employees = [...this.employees];
}

}



