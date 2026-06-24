import { LightningElement, api } from 'lwc';

export default class Child2 extends LightningElement {
@api label;
selected=false;
getStatus(){
return this.selected;
}
handleClick(){
this.selected=! this.selected;
this.dispatchEvent( new CustomEvent('statuschange',{
            detail: { label:this.label,
                selected:this.selected
             },bubbles:true
             ,composed:true}
            ));

}

}