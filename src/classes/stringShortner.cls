public with sharing class stringShortner {
    //# String Shortner
    public static List<SObject> shortner(Map<Id,Opportunity> mapIdOpportunity, String detailField) {

        List<Automobile_Sensor__c> autoSensor = new List<Automobile_Sensor__c>();
        List<Automobile_Presence_Sensor__c> autoPreSensor = new List<Automobile_Presence_Sensor__c>();
        List<Automobile_Tag__c> autoTag = new List<Automobile_Tag__c>();
        List<Automobile_TDU__c> autoTDU = new List<Automobile_TDU__c>();

        Integer maxSize = 18;
        Set<String> names = new Set<String>(); 
        Set<String> noSenSet = new Set<String>();
        for(id oppid : mapIdOpportunity.keySet()) {
            Opportunity o = mapIdOpportunity.get(oppid); // Value = Stage == Account || Shipment
            // String detailField = Automobile_Tag_Details_2__c;
            if(String.isNotBlank(o.detailField) && o.detailField.contains('\n')) {
                List<string> naminwords = o.detailField.split('\n');
                System.debug('String Found' + naminwords);
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
        List<sObject> insertAutomobile = new List<sObject>();

        insertAutomobile.addAll(autoSensor);
        insertAutomobile.addAll(autoPreSensor);
        insertAutomobile.addAll(autoTag);
        insertAutomobile.addAll(autoTDU);

        return insertAutomobile;
    } // String Shortner End
}
