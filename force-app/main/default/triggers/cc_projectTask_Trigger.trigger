trigger cc_projectTask_Trigger on project_cloud__Project_Task__c (after update) {

    //Create variables for different colors

    Integer redCounter = 0;
    Integer yellowCounter = 0;
    Integer greenCounter = 0;

    //Go through all project tasks of all projects
    //Test Changes
    for(project_cloud__Project_Task__c pH :[SELECT Id, project_cloud__Health__c, project_cloud__Project_Phase__r.project_cloud__Project__c FROM project_cloud__Project_Task__c WHERE Id IN :Trigger.new]){

        //If the project task's health changes....

        if( pH.project_cloud__Health__c != trigger.oldMap.get(pH.Id).project_cloud__Health__c){

            //field changed
            //.... verify which parent object is being changed
            //Create a list of the project tasks health (includes all in the parent)

            Id projectId = pH.project_cloud__Project_Phase__r.project_cloud__Project__c;
            System.debug(projectId);
            List<project_cloud__Project_Task__c> healthList = [SELECT Id, project_cloud__Project_Phase__r.project_cloud__Project__c, project_cloud__Health__c 
                                                                FROM project_cloud__Project_Task__c 
                                                                WHERE project_cloud__Project_Phase__r.project_cloud__Project__c =:projectId];

            //iterate over list and add the count for each health level's color 
            System.debug(healthList);
            for(project_cloud__Project_Task__c h: healthList){
                if(h.project_cloud__Health__c == 'RED'){
                    redCounter = redCounter + 1;
                } else if(h.project_cloud__Health__c == 'YELLOW') {
                    yellowCounter = yellowCounter + 1;
                } else if(h.project_cloud__Health__c == 'GREEN') {
                    greenCounter = greenCounter + 1;
                }
            }
            //Type to Work On          Name of Given      //QUERY
            project_cloud__Project__c projectToUpdate = [SELECT Id, redCount__c, yellowCount__c, greenCount__c 
                                                            FROM project_cloud__Project__c
                                                            WHERE Id =:projectId LIMIT 1];
            projectToUpdate.redCount__c = redCounter;
            projectToUpdate.yellowCount__c= yellowCounter;
            projectToUpdate.greenCount__c = greenCounter;

            update projectToUpdate;

        }
    }


}