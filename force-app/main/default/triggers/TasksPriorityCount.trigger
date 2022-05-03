trigger TasksPriorityCount on SOBJECT (before update) {
    
    Integer highCount = 0;
    Integer mediumCount = 0;
    Integer lowCount = 0;
    
// TRIGGER.NEWMAP IS A MAP OF IDS TO THE NEW VERSIONS OF THE SOBJECT RECORDS. NOTE THAT THIS MAP
//US ONLY AVAILABLE IN BEFORE UPDATE, AFTER INTSERT, AND UPDATE TRIGGERS

// TRIGGER.OLDMAP IS A MAP OF IDS TO THE OLD VERSIONS OF THE OBJECT RECORDS. NOTE THAT THIS MAP IS ONLY AVAILABLE IN UPDATE AND DELETE TRIGGERS.
    
    List<project_cloud__Project_Task__c> projectTasks = [SELECT Id, Name, Task_Priority__c FROM project_cloud__Project_Task__c];
    for(project_cloud__Project_Task__c pT : projectTasks){
        if(pT.Task_Priority__c != trigger.oldMap.get(pH.Id).Task_Priority__c){
            Id projectId = pT.project_cloud__Project_Phase__r.project_cloud__Project__c;
            List<project_cloud__Project_Task__c> tasksToGetFields = [SELECT Id, Name, Task_Priority__c FROM project_cloud__Project_Task__c WHERE Id=:projectId];
            for(project_cloud__Project_Task__c pTask : tasksToGetFields){
                if(pTask.Task_Priority__c = 'High'){
                    highCount = highCount + 1;
                } if(pTask.Task_Priority__c = 'Medium'){
                    mediumCount = mediumCount + 1;
                } if(pTask.Task_Priority__c = 'Low'){
                    lowCount = lowCount + 1;
                }
            }
            project_cloud__Project__c projectToUpdate = [SELECT Id, Name, Tasks_of_High_Prio__c,Tasks_of_Medium_Prio__c,Tasks_of_Low_Prio__c FROM project_cloud__Project__c WHERE Id =:projectId ];
            projectToUpdate.Tasks_of_High_Prio__c = highCount;
            projectToUpdate.Tasks_of_Medium_Prio__c = mediumCount;
            projectToUpdate.Tasks_of_High_Prio__c = lowCount; 
            update projectToUpdate;
        }
    }
}


