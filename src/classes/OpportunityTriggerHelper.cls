/**
 * Purpose : Create a Automation of new instance of Automobile according to details provided on the Opportunity’s Automobile Tag Details 1, Automobile Tag Details 2, Automobile Tag Details 3 and Return To HQ fields.
 * Created By : ZAHEER KHAN
 * Created Date : 30-07-2022
 * Revision Logs : V_1.0 - Created By : ZAHEER KHAN - 30-07-2022, V_2.0 - Created By : ZAHEER KHAN - 05-08-2022
 */

public with sharing class OpportunityTriggerHelper {

    public static List<Automobile_Sensor__c> autoSensor = new List<Automobile_Sensor__c>();
    public static List<Automobile_Presence_Sensor__c> autoPreSensor = new List<Automobile_Presence_Sensor__c>();
    public static List<Automobile_Tag__c> autoTag = new List<Automobile_Tag__c>();
    public static List<Automobile_TDU__c> autoTDU = new List<Automobile_TDU__c>();

    public static Set<String> names = new Set<String>(); 
    public static Set<String> noSenSet = new Set<String>();
    public static List<String> allNames = new List<String>();


    //#String Shortner
    public static void stringShortner(Map<Id,Opportunity> mapIdOpportunity) {
        
        Integer maxSize = 18;
        for(id oppid : mapIdOpportunity.keySet()) {
            Opportunity o = mapIdOpportunity.get(oppid); // Value = Stage == Account || Shipment
            allNames.add(o.Automobile_Tag_Details_1__c);
            allNames.add(o.Automobile_Tag_Details_2__c);
            allNames.add(o.Automobile_Tag_Details_3__c);
            allNames.add(o.Return_To_HQ__c);
            for(String str : allNames) {
                if(String.isNotBlank(str) && str.contains('\n')) {
                    List<string> naminwords = str.split('\n');
                    names.addAll(naminwords);
                    System.debug('String Found' + naminwords);
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
        }
    }//stringShortner Ended
    
    //#automobileInstance
    public static void automobileInstance(Map<Id,Opportunity>oldMapInstance, List<Opportunity> newOppList) {
        
        List<String> stagesList = new List<String>{'Shipped to Customer', 'Return to HQ', 'Return to Customer'};
        Set<Id> instanceSet = new Set<Id>();
        Map<Id,Opportunity> mapIdOpportunity = new Map<Id,Opportunity>();

        for(Opportunity upOpp : newOppList) {
            if(oldMapInstance!= null) {
                Opportunity upOldOpp = oldMapInstance.get(upOpp.id);
                if(upOpp.StageName != upOldOpp.StageName) {
                    if(stagesList.contains(upOpp.StageName)) {
                        if(upOpp.StageName == 'Shipped to Customer' || upOpp.StageName == 'Return to Customer') {
                            instanceSet.add(upOpp.Id);
                        }
                        else if(upOpp.StageName == 'Return to HQ') {
                            instanceSet.add(upOpp.Id);
                        }
                    }
                }
            }
            
            else if(oldMapInstance == null) {
                if(stagesList.contains(upOpp.StageName)) {
                    if(upOpp.StageName == 'Shipped to Customer' || upOpp.StageName == 'Return to Customer') {
                        mapIdOpportunity.put(upOpp.AccountId,upOpp);
                    } 
                    else if(upOpp.StageName == 'Return to HQ') {
                        mapIdOpportunity.put(upOpp.Shipment_Account__c,upOpp);
                    }
                }
            }
        }// newOppList loop

        // ############# create records based on names by StringShortner Class
        // List<SObject> automobileNewInstance = new List<SObject>;
        // automobileNewInstance = stringShortner.shortner(mapIdOpportunity, String Automobile_Tag_Details_1__c);
        // stringShortner.shortner(mapIdOpportunity, String Automobile_Tag_Details_2__c);
        // stringShortner.shortner(mapIdOpportunity, String Automobile_Tag_Details_3__c);
        // stringShortner.shortner(mapIdOpportunity, String Return_To_HQ__c);
        
        //############# stringShortner Method
        stringShortner(mapIdOpportunity);

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

        //#get all data by query
        List<Automobile_Sensor__c> autoSensorQryData1 = [Select Id, Name, Account__c, Opportunity__c From Automobile_Sensor__c Where Opportunity__c In :instanceSet];
        List<Automobile_Presence_Sensor__c> autoPreSensorRecQryData1 = [Select Id, Name, Account__c, Opportunity__c From Automobile_Presence_Sensor__c Where Opportunity__c In :instanceSet];
        List<Automobile_Tag__c> autoTagQryData1 = [Select Id, Name, Account__c, Opportunity__c From Automobile_Tag__c Where Opportunity__c In :instanceSet];
        List<Automobile_TDU__c> autoTDUQryData1 = [Select Id, Name, Account__c, Opportunity__c From Automobile_TDU__c Where Opportunity__c In :instanceSet];

        List<Automobile_Sensor__c> upAutoSensor = new List<Automobile_Sensor__c>();
        List<Automobile_Presence_Sensor__c> upAutoPreSensor = new List<Automobile_Presence_Sensor__c>();
        List<Automobile_Tag__c> upAutoTag = new List<Automobile_Tag__c>();
        List<Automobile_TDU__c> upAutoTDU = new List<Automobile_TDU__c>();

        //############### update there account with new by condition
        for(Automobile_Sensor__c auS : autoSensorQryData1) {
            id auid = auS.Opportunity__c;
            // Opportunity o = new Opportunity();
            // o.id = auid;
            for(Opportunity o : newOppList) {
                if(o.id == auid) {
                    if(stagesList.contains(o.StageName)) {
                        if(o.StageName == 'Shipped to Customer' || o.StageName == 'Return to Customer') {
                            auS.Account__c = o.AccountId;
                            upAutoSensor.add(auS);
                        }
                        else if(o.StageName == 'Return to HQ') {
                            auS.Account__c = o.Shipment_Account__c;
                            upAutoSensor.add(auS);
                        }
                    }
                }
            }
        }
        for(Automobile_Presence_Sensor__c auS : autoPreSensorRecQryData1) {
            id auid = auS.Opportunity__c;
            // Opportunity o = new Opportunity();
            // o.id = auid;
            for(Opportunity o : newOppList) {
                if(o.id == auid) {
                    if(stagesList.contains(o.StageName)) {
                        if(o.StageName == 'Shipped to Customer' || o.StageName == 'Return to Customer') {
                            auS.Account__c = o.AccountId;
                            upAutoPreSensor.add(auS);
                        }
                        else if(o.StageName == 'Return to HQ') {
                            auS.Account__c = o.Shipment_Account__c;
                            upAutoPreSensor.add(auS);
                        }
                    }
                }
            }
            
        }
        for(Automobile_Tag__c auS : autoTagQryData1) {
            id auid = auS.Opportunity__c;
            // Opportunity o = new Opportunity();
            // o.id = auid;
            for(Opportunity o : newOppList) {
                if(o.id == auid) {
                    if(stagesList.contains(o.StageName)) {
                        if(o.StageName == 'Shipped to Customer' || o.StageName == 'Return to Customer') {
                            auS.Account__c = o.AccountId;
                            upAutoTag.add(auS);
                        }
                        else if(o.StageName == 'Return to HQ') {
                            auS.Account__c = o.Shipment_Account__c;
                            upAutoTag.add(auS);
                        }
                    }
                }
            }
            
        }
        for(Automobile_TDU__c auS : autoTDUQryData1) {
            id auid = auS.Opportunity__c;
            // Opportunity o = new Opportunity();
            // o.id = auid;
            for(Opportunity o : newOppList) {
                if(o.id == auid) {
                    if(stagesList.contains(o.StageName)) {
                        if(o.StageName == 'Shipped to Customer' || o.StageName == 'Return to Customer') {
                            auS.Account__c = o.AccountId;
                            upAutoTDU.add(auS);
                        }
                        else if(o.StageName == 'Return to HQ') {
                            auS.Account__c = o.Shipment_Account__c;
                            upAutoTDU.add(auS);
                        }
                    }
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

        //#Email send on successful and unsuccessful
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        for(Opportunity opp : newOppList) {
            String oppOwner = opp.OwnerId;
            String oppName = opp.Name;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{opp.Email__c});
            mail.setSubject(oppName + ' ' + 'Date: '+ Date.today());
            String htmlBody = '';
            htmlBody = '<table border="1" cellpadding="0" style="border-collapse: collapse"><caption>Successful: Summary Data</caption><tr><th>Automobile Type</th><th>Name</th><th>Message</th></tr>';
            // htmlBody+='<tr><td>';
            for(String str : names) {
                if(str.startsWith('00:11:CE:00:')) {
                    htmlBody+= '<tr><td border:"1px solid black">' + 'Sensor ' +'</td><td> '+str+' </td><td>'+'Sensor inserted under installation account id: '+ opp.AccountId +'</td></tr>';
                }
                else if(str.startsWith('00:11:CE:D:')) {
                    htmlBody+= '<tr><td border:"1px solid black>' + 'Presence Sensor ' +'</td><td> '+str+' </td><td>'+'Sensor inserted under installation account id: '+ opp.AccountId +'</td></tr>';
                }
                else if(str.startsWith('00:11:CE:E:')) {
                    htmlBody+= '<tr><td border:"1px solid black>' + 'TDU Sensor ' +'</td><td> '+str+' </td><td>'+'Sensor inserted under installation account id: '+ opp.AccountId +'</td></tr>';
                }
                else if(str.substring(0,3).isNumeric()) {
                    htmlBody+= '<tr><td border:"1px solid black>' + 'Tag Sensor ' +'</td><td> '+str+' </td><td>'+'Sensor inserted under installation account id: '+ opp.AccountId +'</td></tr>';
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

    } // automobileInstance method ended

    //#if detail get data check that data and create new if not
    //#send email on updation

}//main
