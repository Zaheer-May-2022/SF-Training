/**
 * Purpose : Create a Automation of new instance of Automobile according to details provided on the Opportunity’s Automobile Tag Details 1, Automobile Tag Details 2, Automobile Tag Details 3 and Return To HQ fields.
 * Created By : ZAHEER KHAN
 * Created Date : 30-07-2022
 * Revision Logs : V_1.0 - Created By : ZAHEER KHAN - 30-07-2022
 */

public with sharing class OpportunityTriggerHandler {
    
    public static Set<String> automobileNames = new Set<String>();
    public static Map<Id,Set<Opportunity>> mapIdListOppr = new Map<Id,Set<Opportunity>>();

    // ##### newAutomationInstance Method for create instance ###########################
    public static void newAutomationInstance(List<Opportunity> oppList) {

        List<Automobile_Sensor__c> autoSensor = new List<Automobile_Sensor__c>();
        List<Automobile_Presence_Sensor__c> autoPreSensor = new List<Automobile_Presence_Sensor__c>();
        List<Automobile_Tag__c> autoTag = new List<Automobile_Tag__c>();
        List<Automobile_TDU__c> autoTDU = new List<Automobile_TDU__c>();
        Map<Id,Opportunity> mapIdOpportunity = new Map<Id,Opportunity>();

        for(Opportunity opp : oppList) {
            if(opp.StageName == 'Shipped to Customer' || opp.StageName == 'Return to HQ' || opp.StageName == 'Return to Customer') {
                if(opp.StageName == 'Shipped to Customer' || opp.StageName == 'Return to Customer') {
                    mapIdOpportunity.put(opp.AccountId,opp);
                } 
                else if(opp.StageName == 'Return to HQ') {
                    mapIdOpportunity.put(opp.Shipment_Account__c,opp);
                }
            }   
        }

        // #create records based on names
        Integer maxSize = 18;
        Set<String> names = new Set<String>(); 
        Set<String> noSenSet = new Set<String>(); 
        for(id oppid : mapIdOpportunity.keySet()) {
            //#seprate this object o
            Opportunity o = mapIdOpportunity.get(oppid); // Value = Stage == Account || Shipment
            if(String.isNotBlank(o.Automobile_Tag_Details_1__c) && o.Automobile_Tag_Details_1__c.contains('\n')) {
                List<string> naminwords = o.Automobile_Tag_Details_1__c.split('\n');
                System.debug('String Found' + naminwords);
                names.addAll(naminwords);
                for(string s : names) {
                    if(s.startsWith('00:11:CE:00:')) {
                        Automobile_Sensor__c autoSen = new Automobile_Sensor__c();
                        autoSen.Name = (s.length()>maxsize) ? s.substring(0, maxSize) : s;
                        autoSen.Account__c = oppid;
                        autoSen.Opportunity__c = o.id;
                        autoSensor.add(autoSen);
                    }
                    else if(s.startsWith('00:11:CE:D:')) {
                        Automobile_Presence_Sensor__c autoPreSen = new Automobile_Presence_Sensor__c();
                        autoPreSen.Name = (s.length()>maxSize) ? s.substring(0, maxSize) : s;
                        autoPreSen.Account__c = oppid;
                        autoPreSen.Opportunity__c = o.id;
                        autoPreSensor.add(autoPreSen);
                    }
                    else if(s.startsWith('00:11:CE:E:')) {
                        Automobile_Tag__c autoTg = new Automobile_Tag__c();
                        autoTg.Name = (s.length()>maxsize) ? s.substring(0, maxSize) : s;
                        autoTg.Account__c = oppid;
                        autoTg.Opportunity__c = o.id;
                        autoTag.add(autoTg);
                    }
                    else if(s.substring(0,3).isNumeric()) {
                        Automobile_TDU__c auTDU = new Automobile_TDU__c();
                        auTDU.Name = (s.length()>maxsize) ? s.substring(0, maxSize) : s;
                        auTDU.Opportunity__c = o.id;
                        auTDU.Account__c = oppid;
                        autoTDU.add(auTDU);
                    }
                    else {
                        noSenSet.add(s);
                    }
                }
            }
        }
            
        for(id oppid : mapIdOpportunity.keySet()) {
            Opportunity o = mapIdOpportunity.get(oppid); // Value = Stage == Account || Shipment
            if(String.isNotBlank(o.Automobile_Tag_Details_2__c) && o.Automobile_Tag_Details_2__c.contains('\n')) {
                List<string> naminwords = o.Automobile_Tag_Details_2__c.split('\n');
                System.debug('String Found' + naminwords);
                // Set<String> names = new Set<String>();
                names.addAll(naminwords);
                for(string s : names) {
                    if(s.startsWith('00:11:CE:00:')) {
                        Automobile_Sensor__c autoSen = new Automobile_Sensor__c();
                        autoSen.Name = (s.length()>maxsize) ? s.substring(0, maxSize) : s;
                        autoSen.Opportunity__c = o.id;
                        autoSen.Account__c = oppid;
                        autoSensor.add(autoSen);
                    }
                    else if(s.startsWith('00:11:CE:D:')) {
                        Automobile_Presence_Sensor__c autoPreSen = new Automobile_Presence_Sensor__c();
                        autoPreSen.Name = (s.length()>maxSize) ? s.substring(0, maxSize) : s;
                        autoPreSen.Opportunity__c = o.id;
                        autoPreSen.Account__c = oppid;
                        autoPreSensor.add(autoPreSen);
                    }
                    else if(s.startsWith('00:11:CE:E:')) {
                        Automobile_Tag__c autoTg = new Automobile_Tag__c();
                        autoTg.Name = (s.length()>maxsize) ? s.substring(0, maxSize) : s;
                        autoTg.Opportunity__c = o.id;
                        autoTg.Account__c = oppid;
                        autoTag.add(autoTg);
                    }
                    else if(s.substring(0,3).isNumeric()) {
                        Automobile_TDU__c auTDU = new Automobile_TDU__c();
                        auTDU.Name = (s.length()>maxsize) ? s.substring(0, maxSize) : s;
                        auTDU.Opportunity__c = o.id;
                        auTDU.Account__c = oppid;
                        autoTDU.add(auTDU);
                    }
                    else {
                        noSenSet.add(s);
                    }
                }
            }
        }

        for(id oppid : mapIdOpportunity.keySet()) {
            Opportunity o = mapIdOpportunity.get(oppid); // Value = Stage == Account || Shipment
            if(String.isNotBlank(o.Automobile_Tag_Details_3__c) && o.Automobile_Tag_Details_3__c.contains('\n')) {
                List<string> naminwords = o.Automobile_Tag_Details_3__c.split('\n');
                System.debug('String Found' + naminwords);
                // Set<String> names = new Set<String>();
                names.addAll(naminwords);
                for(string nwname : names) {
                    if(nwname.startsWith('00:11:CE:00:')) {
                        Automobile_Sensor__c autoSen = new Automobile_Sensor__c();
                        autoSen.Name = (nwname.length()>maxsize) ? nwname.substring(0, maxSize) : nwname;
                        autoSen.Opportunity__c = o.id;
                        autoSen.Account__c = oppid;
                        autoSensor.add(autoSen);
                    }
                    else if(nwname.startsWith('00:11:CE:D:')) {
                        Automobile_Presence_Sensor__c autoPreSen = new Automobile_Presence_Sensor__c();
                        autoPreSen.Name = (nwname.length()>maxSize) ? nwname.substring(0, maxSize) : nwname;
                        autoPreSen.Opportunity__c = o.id;
                        autoPreSen.Account__c = oppid;
                        autoPreSensor.add(autoPreSen);
                    }
                    else if(nwname.startsWith('00:11:CE:E:')) {
                        Automobile_Tag__c autoTg = new Automobile_Tag__c();
                        autoTg.Name = (nwname.length()>maxsize) ? nwname.substring(0, maxSize) : nwname;
                        autoTg.Opportunity__c = o.id;
                        autoTg.Account__c = oppid;
                        autoTag.add(autoTg);
                    }
                    else if(nwname.substring(0,3).isNumeric()) {
                        Automobile_TDU__c auTDU = new Automobile_TDU__c();
                        auTDU.Name = (nwname.length()>maxsize) ? nwname.substring(0, maxSize) : nwname;
                        auTDU.Opportunity__c = o.id;
                        auTDU.Account__c = oppid;
                        autoTDU.add(auTDU);
                    }
                    else {
                        noSenSet.add(nwname);
                    }
                }
            }
        }

        for(id oppid : mapIdOpportunity.keySet()) {
            Opportunity o = mapIdOpportunity.get(oppid); // Value = Stage == Account || Shipment
            if(String.isNotBlank(o.Return_To_HQ__c) && o.Return_To_HQ__c.contains('\n')) {
                List<string> naminwords = o.Return_To_HQ__c.split('\n'); // List of Names
                System.debug('String Found' + naminwords);
                // Set<String> names = new Set<String>();
                names.addAll(naminwords);
                for(string nwname : names) {
                    if(nwname.startsWith('00:11:CE:00:')) {
                        Automobile_Sensor__c autoSen = new Automobile_Sensor__c();
                        autoSen.Name = (nwname.length()>maxsize) ? nwname.substring(0, maxSize) : nwname;
                        autoSen.Opportunity__c = o.id;
                        autoSen.Account__c = oppid;
                        autoSensor.add(autoSen);
                    }
                    else if(nwname.startsWith('00:11:CE:D:')) {
                        Automobile_Presence_Sensor__c autoPreSen = new Automobile_Presence_Sensor__c();
                        autoPreSen.Name = (nwname.length()>maxSize) ? nwname.substring(0, maxSize) : nwname;
                        autoPreSen.Opportunity__c = o.id;
                        autoPreSen.Account__c = oppid;
                        autoPreSensor.add(autoPreSen);
                    }
                    else if(nwname.startsWith('00:11:CE:E:')) {
                        Automobile_Tag__c autoTg = new Automobile_Tag__c();
                        autoTg.Name = (nwname.length()>maxsize) ? nwname.substring(0, maxSize) : nwname;
                        autoTg.Opportunity__c = o.id;
                        autoTg.Account__c = oppid;
                        autoTag.add(autoTg);
                    }
                    else if(nwname.substring(0,3).isNumeric()) {
                        Automobile_TDU__c auTDU = new Automobile_TDU__c();
                        auTDU.Name = (nwname.length()>maxsize) ? nwname.substring(0, maxSize) : nwname;
                        auTDU.Opportunity__c = o.id;
                        auTDU.Account__c = oppid;
                        autoTDU.add(auTDU);
                    }
                    else {
                        noSenSet.add(nwname);
                    }
                }
            }
        }

        // #creating new records
        if (!autoPreSensor.isEmpty()) {
            insert autoPreSensor;
        }
        if (!autoSensor.isEmpty()) {
            insert autoSensor;
        }
        if (!autoTag.isEmpty()) {
            insert autoTag;
        }
        if (!autoTDU.isEmpty()) {
            insert autoTDU;
        }

        //#Email send on successful
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        for(Opportunity opp : oppList) {
            String oppOwner = opp.OwnerId;
            String oppName = opp.Name;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{opp.Email__c});
            mail.setSubject(oppName + ' ' + 'Date: '+ Date.today());
            String htmlBody = '';
            htmlBody = '<table border="1" cellpadding="0"style="border-collapse: collapse"><caption>Successful: Summary Data</caption><tr><th>Automobile Type</th><th>Name</th><th>Message</th></tr>';
            // htmlBody+='<tr><td>';
            for(String str : names) {
                if(str.startsWith('00:11:CE:00:')) {
                    htmlBody+= '<tr><td>' + 'Sensor ' +'</td><td> '+str+' </td><td>'+'Sensor inserted under installation account id: '+ opp.AccountId +'</td></tr>';
                }
                else if(str.startsWith('00:11:CE:D:')) {
                    htmlBody+= '<tr><td>' + 'Presence Sensor ' +'</td><td> '+str+' </td><td>'+'Sensor inserted under installation account id: '+ opp.AccountId +'</td></tr>';
                }
                else if(str.startsWith('00:11:CE:E:')) {
                    htmlBody+= '<tr><td>' + 'TDU Sensor ' +'</td><td> '+str+' </td><td>'+'Sensor inserted under installation account id: '+ opp.AccountId +'</td></tr>';
                }
                else if(str.substring(0,3).isNumeric()) {
                    htmlBody+= '<tr><td>' + 'Tag Sensor ' +'</td><td> '+str+' </td><td>'+'Sensor inserted under installation account id: '+ opp.AccountId +'</td></tr>';
                }
            }
            htmlBody += '</table>';
            system.debug('Email Body: ' + htmlBody);

            String htmlBody2 = '';
            htmlBody2 = '<table border="1" cellpadding="1" cellspacing="1" style="border-collapse: collapse"><caption>Unsuccessful: Summary Data</caption><tr><th>Automobile Type</th><th>Name</th><th>Message</th></tr>';
            // htmlBody+='<tr><td>';
            for(String str : noSenSet) {
                htmlBody2+= '<tr><td>' + 'Sensor ' +'</td><td> '+str+' </td><td> Invalid sensor </td></tr>';
            }
            htmlBody2 += '</table>';
            mail.setHTMLbody(htmlBody + htmlBody2);    
            String emailAddress = opp.Email__c;
            System.debug('Email Send Successfully at: ' + emailAddress);
            messages.add(mail);
        }
        // Messaging.sendEmail(messages);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(  messages );
        System.debug('Result' + results);
    } // newAutomationInstance

    // ##### updateAutomationInstance Method for update instance  ###############
    public static void updateAutomationInstance(Map<Id,Opportunity>oldMapInstance, List<Opportunity>newListInstance) {

        List<String> stagesList = new List<String>{'Shipped to Customer', 'Return to HQ', 'Return to Customer'};

        Set<Id> newInstanceSet1 = new Set<Id>();
        Set<Id> newInstanceSet2 = new Set<Id>();
        List<Automobile_Sensor__c> upAutoSensor = new List<Automobile_Sensor__c>();
        List<Automobile_Presence_Sensor__c> upAutoPreSensor = new List<Automobile_Presence_Sensor__c>();
        List<Automobile_Tag__c> upAutoTag = new List<Automobile_Tag__c>();
        List<Automobile_TDU__c> upAutoTDU = new List<Automobile_TDU__c>();

        //# check if stageName is changed
        for(Opportunity upOpp : newListInstance) {
            Opportunity upOldOpp = oldMapInstance.get(upOpp.id);
            if(upOpp.StageName != upOldOpp.StageName) {
                if(stagesList.contains(upOpp.StageName)) {
                    if(upOpp.StageName == 'Shipped to Customer' || upOpp.StageName == 'Return to Customer') {
                        newInstanceSet1.add(upOpp.Id);
                    }
                    else if(upOpp.StageName == 'Return to HQ') {
                        newInstanceSet2.add(upOpp.Id);
                    }
                }
            }
        } // for

        //#get all data by query
        List<Automobile_Sensor__c> autoSensorQryData1 = [Select Id, Name, Account__c, Opportunity__c From Automobile_Sensor__c Where Opportunity__c In :newInstanceSet1];
        List<Automobile_Presence_Sensor__c> autoPreSensorRecQryData1 = [Select Id, Name, Account__c, Opportunity__c From Automobile_Presence_Sensor__c Where Opportunity__c In :newInstanceSet1];
        List<Automobile_Tag__c> autoTagQryData1 = [Select Id, Name, Account__c, Opportunity__c From Automobile_Tag__c Where Opportunity__c In :newInstanceSet1];
        List<Automobile_TDU__c> autoTDUQryData1 = [Select Id, Name, Account__c, Opportunity__c From Automobile_TDU__c Where Opportunity__c In :newInstanceSet1];

        List<Automobile_Sensor__c> autoSensorQryData2 = [Select Id, Name, Account__c, Opportunity__c From Automobile_Sensor__c Where Opportunity__c In :newInstanceSet2];
        List<Automobile_Presence_Sensor__c> autoPreSensorRecQryData2 = [Select Id, Name, Account__c, Opportunity__c From Automobile_Presence_Sensor__c Where Opportunity__c In :newInstanceSet2];
        List<Automobile_Tag__c> autoTagQryData2 = [Select Id, Name, Account__c, Opportunity__c From Automobile_Tag__c Where Opportunity__c In :newInstanceSet2];
        List<Automobile_TDU__c> autoTDUQryData2 = [Select Id, Name, Account__c, Opportunity__c From Automobile_TDU__c Where Opportunity__c In :newInstanceSet2];

        //#update there account with new by condition
        for(Automobile_Sensor__c auS : autoSensorQryData1) {
            id auid = auS.Opportunity__c;
            for(Opportunity upOpp : newListInstance) {
                if(upOpp.Id == auid) {
                    Automobile_Sensor__c autoSen = new Automobile_Sensor__c();
                    autoSen.Account__c = upOpp.AccountId;
                    autoSen.Id = auS.Id;
                    upAutoSensor.add(autoSen);
                }
            }
        }
        for(Automobile_Presence_Sensor__c auS : autoPreSensorRecQryData1) {
            id auid = auS.Opportunity__c;
            for(Opportunity upOpp : newListInstance) {
                if(upOpp.Id == auid) {
                    Automobile_Presence_Sensor__c autoSen = new Automobile_Presence_Sensor__c();
                    autoSen.Account__c = upOpp.AccountId;
                    autoSen.Id = auS.Id;
                    upAutoPreSensor.add(autoSen);
                }
            }
        }
        for(Automobile_Tag__c auS : autoTagQryData1) {
            id auid = auS.Opportunity__c;
            for(Opportunity upOpp : newListInstance) {
                if(upOpp.Id == auid) {
                    Automobile_Tag__c autoSen = new Automobile_Tag__c();
                    autoSen.Id = auS.Id;
                    autoSen.Account__c = upOpp.AccountId;
                    upAutoTag.add(autoSen);
                }
            }
        }
        for(Automobile_TDU__c auS : autoTDUQryData1) {
            id auid = auS.Opportunity__c;
            for(Opportunity upOpp : newListInstance) {
                if(upOpp.Id == auid) {
                    Automobile_TDU__c autoSen = new Automobile_TDU__c();
                    autoSen.Id = auS.Id;
                    autoSen.Account__c = upOpp.AccountId;
                    upAutoTDU.add(autoSen);
                }
            }
        }

        for(Automobile_Sensor__c auS : autoSensorQryData2) {
            id auid = auS.Opportunity__c;
            for(Opportunity upOpp : newListInstance) {
                if(upOpp.Id == auid) {
                    Automobile_Sensor__c autoSen = new Automobile_Sensor__c();
                    autoSen.Id = auS.Id;
                    autoSen.Account__c = upOpp.Shipment_Account__c;
                    upAutoSensor.add(autoSen);
                }
            }
        }
        for(Automobile_Presence_Sensor__c auS : autoPreSensorRecQryData2) {
            id auid = auS.Opportunity__c;
            for(Opportunity upOpp : newListInstance) {
                if(upOpp.Id == auid) {
                    Automobile_Presence_Sensor__c autoSen = new Automobile_Presence_Sensor__c();
                    autoSen.Id = auS.Id;
                    autoSen.Account__c = upOpp.Shipment_Account__c;
                    upAutoPreSensor.add(autoSen);
                }
            }
        }
        for(Automobile_Tag__c auS : autoTagQryData2) {
            id auid = auS.Opportunity__c;
            for(Opportunity upOpp : newListInstance) {
                if(upOpp.Id == auid) {
                    Automobile_Tag__c autoSen = new Automobile_Tag__c();
                    autoSen.Id = auS.Id;
                    autoSen.Account__c = upOpp.Shipment_Account__c;
                    upAutoTag.add(autoSen);
                }
            }
        }
        for(Automobile_TDU__c auS : autoTDUQryData2) {
            id auid = auS.Opportunity__c;
            for(Opportunity upOpp : newListInstance) {
                if(upOpp.Id == auid) {
                    Automobile_TDU__c autoSen = new Automobile_TDU__c();
                    autoSen.Id = auS.Id;
                    autoSen.Account__c = upOpp.Shipment_Account__c;
                    upAutoTDU.add(autoSen);
                }
            }
        }
        
        // Update changed stage data
        if (!upAutoPreSensor.isEmpty()) {
            update upAutoPreSensor;    
        }
        if (!upAutoSensor.isEmpty()) {
            update upAutoSensor;
        }
        if (!upAutoTag.isEmpty()) {
            update upAutoTag;
        }
        if (!upAutoTDU.isEmpty()) {
            update upAutoTDU;    
        }
    } // updateAutomationInstance

}// main






























                                //####################
// ######################################  Error #########################
                                //####################
/**                             
 * The method 'newAutomationInstance(List<Opportunity>)' has a cognitive complexity of 149, current threshold is 15 (rule: Design-CognitiveComplexity)apex pmdCognitiveComplexity
The method newAutomationInstance() has an NCSS line count of 147 (rule: Design-NcssMethodCount)
 */