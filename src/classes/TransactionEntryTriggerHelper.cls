
public with sharing class TransactionEntryTriggerHelper {
    
    public static void DebitDataLimit(List<Transaction_Entry__c> newList) {

        List <id> tranContId = new List<id>();
        for(Transaction_Entry__c tranEntry : newList) {

            tranContId.add(tranEntry.Contact__c);
        }

        //fetching all newly created list for adding limits
        List <Transaction_Entry__c> newTranEntries = [SELECT Id, Amount__c FROM Transaction_Entry__c WHERE Type__c = 'Debit' AND CreatedDate = TODAY AND Contact__c in : tranContId];
        List <Transaction_Entry__c> newTranEntriesLast30 = [SELECT Id, Amount__c FROM Transaction_Entry__c WHERE Type__c = 'Debit' AND CreatedDate = LAST_N_DAYS:30 AND Contact__c in : tranContId];

        System.debug('Today transaction::::::::::::' + newTranEntries);
        System.debug('Monthly transaction::::::::::::' + newTranEntriesLast30);

        Decimal debitPerDay = 0;
        Decimal debitPerMonth = 0;
        // Decimal tranPerDay = 0;
        // Decimal tranPerMonth = 0;
        Map<Id,Decimal> tranDayLimitMap = new Map<Id,Decimal>();
        Map<Id,Decimal> tranMonthLimitMap = new Map<Id,Decimal>();

        if(!newList.isEmpty()) {

            for(Transaction_Entry__c tranAmt : newTranEntries) {
    
                debitPerDay += tranAmt.Amount__c;
                tranDayLimitMap.put(tranAmt.Id, debitPerDay);
                System.debug('Total Day amount => ' + debitPerDay + ', ID =>' + tranAmt.Id);
            }
            for(Transaction_Entry__c tranAmt : newTranEntriesLast30) {
    
                debitPerMonth += tranAmt.Amount__c;
                tranMonthLimitMap.put(tranAmt.Id, debitPerMonth);
                System.debug('Total Month amount => ' + debitPerMonth + ', ID=>' + tranAmt.Id);
            }
        }

        // fetching transaction limits for all contacts.
        List<Contact> tranLimit = [SELECT ID, Transaction_Limit__r.Maximum_Debit_Allowed_per_Day__c, Transaction_Limit__r.Maximum_Debit_Allowed_per_Month__c, Transaction_Limit__r.Maximum_Debit_Allowed_per_Transaction__c, Transaction_Limit__r.Maximum_Transactions_Allowed_per_Day__c, Transaction_Limit__r.Maximum_Transactions_Allowed_per_Month__c FROM Contact Where ID IN :tranContId ];

        System.debug('All Transaction Limit =>' + tranLimit );

        for(Contact c : tranLimit) {

            for(Transaction_Entry__c setLimit : newList) {
                
                if( (setLimit.Amount__c + tranDayLimitMap.get(setLimit.Id)) > c.Transaction_Limit__r.Maximum_Debit_Allowed_per_Day__c ) {

                    Decimal dayAmount = setLimit.Amount__c + tranDayLimitMap.get(setLimit.Id);
                    System.debug('Current Amount of transaction limit (Day) => ' + dayAmount);
                    setLimit.addError('Opps you have exceeded the day limit');
                }

                if( (setLimit.Amount__c + tranMonthLimitMap.get(setLimit.Id)) > c.Transaction_Limit__r.Maximum_Debit_Allowed_per_Month__c ) {

                    Decimal monthAmount = setLimit.Amount__c + tranMonthLimitMap.get(setLimit.Id);
                    System.debug('Current Amount of transaction limit (Month) => ' + monthAmount);
                    setLimit.addError('Opps you have exceeded the Month limit');
                }
            }
        }
    } // DebitDataLimit Ended
}
