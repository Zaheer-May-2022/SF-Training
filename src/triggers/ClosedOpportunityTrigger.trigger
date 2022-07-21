/*
Purpose : Bulk Adding Task (if Opportunity state is Closed win)
Created By : Zaheer Khan
Created Date : 21-07-22 
Revision Log : 01
 */

trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    //List<Opportunity> oppList = new List<Opportunity>();
    List<Task> taskList = new List<Task>();
    
    for (Opportunity opp : [SELECT Id, Name, StageName FROM Opportunity WHERE Id IN :Trigger.New]) {
        if(opp.StageName == 'Closed Won') {
            //oppList.add(opp);
            taskList.add(new Task(Subject = 'Follow Up Test Task',
                                  WhatId = opp.Id)
                        );      
        }
    }
    //insert oppList;
    //if(taskList.size() > 0)
    insert taskList;
    System.debug('Task Added Successfully' + taskList);
}

/*
Opportunity a = new Opportunity();
a.StageName = 'Closed Won';
Date myDate = date.newInstance(2022,07,21);
a.CloseDate = myDate;
a.Name = 'Bill';
insert a;


Outpuy 
USER_DEBUG [23]|DEBUG|Task Added Successfully(Task:{Subject=Follow Up Test Task, WhatId=0065i000005RQ19AAG, Id=00T5i00000YhTkWEAV})
 */