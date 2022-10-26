import { LightningElement, wire, track, api} from 'lwc';
import getData from '@salesforce/apex/getStatementData.statementData';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord } from 'lightning/uiRecordApi';
import {exportCSVFile} from 'c/utils';
import JSPDF from '@salesforce/resourceUrl/jspdf';
// import JSPDF from '@salesforce/resourceUrl/jspdf';
import {loadScript} from "lightning/platformResourceLoader";

export default class Statement extends LightningElement {

  @api recordId;
  @track startDate;
  @track endDate;
  @track format;
  @track dataList;
  value = '';
  
  columnHeader = {ID: 'ID', Name: 'Name', Amount__c: 'Amount', Type__c: 'Type',Contact__c: 'Contact', Status__c: 'Status', Transaction_Date__c: 'Transaction Date'}

    get options() {
        return [
            { label: 'CSV', value: 'option1' },
        ];
    }

    get options1() {
      return [
          { label: 'PDF', value: 'option2' },
      ];
  }

  handleOnChange(event) {
    const name = event.target.name;
    if (name === 'StartDate') {
      this.startDate = event.target.value;
    } else if (name === 'EndDate') {
      this.endDate = event.target.value;
    }
  }

  handleClick() {
    console.log(this.startDate);
    console.log(this.endDate);
    getData({ startDate : this.startDate, endDate : this.endDate, recordId : this.recordId })
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
    
    //CSV file
    //M-1
    downloadData(){
      console.log("download CSV.")
      exportCSVFile(this.columnHeader, this.dataList, "Statement")
  }

  // PDF file

  headers = this.createHeaders([
		'ID','Name',' Amount__c', 'Type__c', 'Contact__c', 'Status__c','Transaction_Date__c'
  ]);


  renderedCallback() {
    Promise.all([
        loadScript(this, JSPDF)
    ]);
}

  generatePdf(){
      const { jsPDF } = window.jspdf;
      const pdf = new jsPDF({
          encryption: {
              userPermissions: ["print", "modify", "copy", "annot-forms"]
          }
      });

      console.log(this.dataList);

      pdf.text("Transaction Statement", 90, 20);
      pdf.table(30, 30, this.dataList, this.headers, {autosize: true});
      pdf.saveAs("Statement.pdf");
  }

  downloadDataPdf() {

    console.log("download PDF.");
    this.generatePdf();
  }


  createHeaders(keys) {
		let result = [];
		for (let i = 0; i < keys.length; i += 1) {
			result.push({
				id: keys[i],
				name: keys[i],
				prompt: keys[i],
				width: 65,
				align: "center",
				padding: 0
			});
		}
		return result;
	}


  // M-2
    exportContactData(){
      // Prepare a html table
      let doc = '<table>';
      // Add styles for the table
      doc += '<style>';
      doc += 'table, th, td {';
      doc += '    border: 1px solid black;';
      doc += '    border-collapse: collapse;';
      doc += '}';          
      doc += '</style>';
      // Add all the Table Headers
      doc += '<tr>';
      this.columnHeader.forEach(element => {            
          doc += '<th>'+ element +'</th>'           
      });
      doc += '</tr>';
      // Add the data rows
      this.dataList.forEach(record => {
          doc += '<tr>';
          doc += '<th>'+record.Id+'</th>'; 
          doc += '<th>'+record.Name+'</th>'; 
          doc += '<th>'+record.Amount__c+'</th>';
          doc += '<th>'+record.Contact__c+'</th>'; 
          doc += '<th>'+record.Status__c+'</th>'; 
          doc += '<th>'+record.Transaction_Date__c+'</th>';
          doc += '</tr>';
      });
      doc += '</table>';
      var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
      let downloadElement = document.createElement('a');
      downloadElement.href = element;
      downloadElement.target = '_self';
      // downloadElement.download = 'Statement.csv';
      downloadElement.download = 'Statement.xls';
      document.body.appendChild(downloadElement);
      downloadElement.click();
  }

}