import { LightningElement, wire, track } from 'lwc';
import getTextMethod1 from '@salesforce/apex/LWC.getTextMethod1';
import getTextMethod2 from '@salesforce/apex/LWC.getTextMethod2';
import getTextMethod3 from '@salesforce/apex/LWC.getTextMethod3';


export default class CallingApex extends LightningElement {
  
  @wire(getTextMethod1) str1;
  @wire(getTextMethod2) str2;
  @wire(getTextMethod3) str3;

  callHandlerMethod1() {
      getTextMethod1()
        .then(result => {
              this.str1 = result;
              this.error = undefined;
            })
            .catch(error => {
              this.str1 = undefined;
              this.error = error;
            });
  }
  callHandlerMethod2() {
    getTextMethod1()
    .then(result => {
      this.str1 = result;
      this.error = undefined;
    })
    getTextMethod2()
    .then(result => {
      this.str2 = result;
      this.error = undefined;
    })
    .catch(error => {
      this.str2 = undefined;
      this.error = error;
    });
  }
  callHandlerMethod3() {
    getTextMethod1()
    .then(result => {
      this.str1 = result;
      this.error = undefined;
    })
    getTextMethod2()
    .then(result => {
      this.str2 = result;
      this.error = undefined;
    })
    .catch(error => {
      this.str2 = undefined;
      this.error = error;
    });
    getTextMethod3()
        .then(result => {
          this.str3 = result;
          this.error = undefined;
        })
          .catch(error => {
            this.str3 = undefined;
            this.error = error;
          });
  }
}



// import { LightningElement, track } from 'lwc';
// import getContactList from '@salesforce/apex/ContactController.getContactList';

// export default class ApexImperativeMethod extends LightningElement {
//     @track contacts;
//     @track error;

//     handleLoad() {
//         getContactList()
//             .then(result => {
//                 this.contacts = result;
//             })
//             .catch(error => {
//                 this.error = error;
//             });
//     }
// }