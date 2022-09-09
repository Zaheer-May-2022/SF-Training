import { LightningElement, track } from 'lwc';
import getTextMethod1 from '@salesforce/apex/LWC.getTextMethod1';
import getTextMethod2 from '@salesforce/apex/LWC.getTextMethod2';
import getTextMethod3 from '@salesforce/apex/LWC.getTextMethod3';

export default class CallingApex2 extends LightningElement {

  @track str1;
  @track str2;
  @track str3;
  @track str4;
  
  callHandlerMethod() {
    this.invokeApexMethods();
  }

  async invokeApexMethods() {
      try {
        this.str1 = await getTextMethod1();
        console.log(`This one is first async call`);
        this.str2 = await getTextMethod2();
        console.log(`This one is second async call`);
        this.str3 = await getTextMethod3();
        console.log(`This one is third async call`);
      } catch(error) {
          console.error(error);
      } finally {
        console.log(`Code executed Block ${this.str1} ${this.str2} ${this.str3}`);
        this.str4 = this.str1 + ' ' + this.str2 + ' ' + this.str3;
      }
  }
}