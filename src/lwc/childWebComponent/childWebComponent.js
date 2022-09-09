import { LightningElement, track,api } from "lwc";

export default class ChildWebComponent extends LightningElement {
  @track color='Red';
  // @track hexcode = '#ff0a0a'; 
  
  @api handleChangeColor() {
    this.color='Blue';
    // this.hexcode = '#0901fa';
  }
}