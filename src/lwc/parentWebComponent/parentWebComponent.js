import { LightningElement } from "lwc";

export default class ParentWebComponent extends LightningElement {
  handleClick() {
    //Firing an child comp in Parent comp
    this.template.querySelector("c-child-web-component").handleChangeColor();
  }
}