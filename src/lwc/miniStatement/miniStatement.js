import { LightningElement, wire, track, api} from 'lwc';
import getData from '@salesforce/apex/getTransactionData.transData';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord } from 'lightning/uiRecordApi'

export default class MiniStatement extends LightningElement {

    // @track value = '5';
    @api recordId;
    @api transLimit_Ref ='5';
    @track dataList;


    handle_Option_Value(event) {

      // this.value = event.target.value;
      this.transLimit_Ref = event.target.value;
  }

    get options() {
        return [
            { label: '5', value: '5' },
            { label: '10', value: '10' },
            { label: '15', value: '15' },
            { label: '20', value: '20' },
            { label: '25', value: '25' },
        ];
    }

    // Fetched data
    @track columns = [
      { label: 'Name', fieldName: 'Name' },
      { label: 'Id', fieldName: 'Id'},  
      { label: 'Amount', fieldName: 'Amount__c'},
      { label: 'Contact', fieldName: 'Contact__c'},
      { label: 'Status', fieldName: 'Status__c'},
      { label: 'Date', fieldName: 'Transaction_Date__c'},
      { label: 'Available Balance', fieldName: 'Contact__r.Available_Balance__c'}
    ];

      handleClick() {
        console.log(this.transLimit_Ref);
        getData({ transLimit : this.transLimit_Ref, recordId : this.recordId })
        .then(result => {
          
          this.dataList = result;
          console.log(result);
        })
        .catch(error => {

          console.log(error);
        })
      }
      
      

    // To close the Quick Action button
    closeAction(){
      this.dispatchEvent(new CloseActionScreenEvent());
    }
}