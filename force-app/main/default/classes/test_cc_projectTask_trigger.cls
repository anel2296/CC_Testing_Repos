@isTest
public class test_cc_projectTask_trigger {

    @TestSetup
    static void makeData(){

        project_cloud__Project__c proyecto = new project_cloud__Project__c();
        proyecto.Name = 'Test Project';
        proyecto.redCount__c = 0;
        proyecto.yellowCount__c = 0;
        proyecto.greenCount__c = 0;
        insert proyecto;
        System.debug(proyecto);
        //test commits

        project_cloud__Project_Phase__c fase = new project_cloud__Project_Phase__c();
        fase.Name = 'Test Phase 1';
        fase.project_cloud__Project__c = proyecto.Id;
        insert fase;
        System.debug(fase);

        List<project_cloud__Project_Task__c> taskList = new List<project_cloud__Project_Task__c>();
        System.debug('Task List Empty: ' + taskList);
        project_cloud__Project_Task__c tarea1 = new project_cloud__Project_Task__c(
        Name = 'Test Task 1',
        project_cloud__Health__c = 'Green',
        project_cloud__Health_Reason__c  = 'Test Reason',
        project_cloud__Autonomous_Start__c = System.Today(),
        project_cloud__Duration__c = 2,
        project_cloud__Project_Phase__c = fase.Id);
        taskList.add(tarea1);
        System.debug('Task List (1)): ' + taskList);

        project_cloud__Project_Task__c tarea2 = new project_cloud__Project_Task__c(
        Name = 'Test Task 2',
        project_cloud__Health__c = 'Green',
        project_cloud__Health_Reason__c  = 'Test Reason',
        project_cloud__Autonomous_Start__c = System.Today(),
        project_cloud__Duration__c = 2,
        project_cloud__Project_Phase__c = fase.Id);
        taskList.add(tarea2);
        System.debug('Task List (2)): ' + taskList);

        
        project_cloud__Project_Task__c tarea3 = new project_cloud__Project_Task__c(
        Name = 'Test Task 3',
        project_cloud__Health__c = 'Yellow',
        project_cloud__Health_Reason__c  = 'Test Reason',
        project_cloud__Autonomous_Start__c = System.Today(),
        project_cloud__Duration__c = 2,
        project_cloud__Project_Phase__c = fase.Id);
        taskList.add(tarea3);
        System.debug('Task List (3)): ' + taskList);

        project_cloud__Project_Task__c tarea4 = new project_cloud__Project_Task__c(
        Name = 'Test Task 4',
        project_cloud__Health__c = 'Red',
        project_cloud__Health_Reason__c  = 'Test Reason',
        project_cloud__Autonomous_Start__c = System.Today(),
        project_cloud__Duration__c = 2,
        project_cloud__Project_Phase__c = fase.Id);
        taskList.add(tarea4); 
        System.debug('Task List (4)): ' + taskList);
        insert taskList;
        System.debug(taskList);
        //vas a crear primero el proyecto > DONE
        //luego, crear fases > DONE
        //luego crear tasks y hacer la relacion  __r  > DONE
        //poner x cantidad para colores 1 v ,2 r , 2y  > DONE
        // ponerle health reason  > DONE
        //en el test, cambiar uno rojo a verde
        //hacer asserts

    }

    @isTest 
    public static void TestHealthNumbers() {

        
        //INITIALIZATION
        // project_cloud__Project__c p = new project_cloud__Project__c p();
        Test.startTest();
        project_cloud__Project__c project1 = [SELECT Id, Name, redCount__c, yellowCount__c, greenCount__c FROM project_cloud__Project__c WHERE Name ='Test Project'];


        List<project_cloud__Project_Task__c> tasksToUpdate = [SELECT Id, project_cloud__Health__c, project_cloud__Project_Phase__r.project_cloud__Project__c
                                                        FROM project_cloud__Project_Task__c
                                                        WHERE project_cloud__Project_Phase__r.project_cloud__Project__c =:project1.Id LIMIT 4];
        
        for (project_cloud__Project_Task__c healths : tasksToUpdate) {
            System.debug('Entered Loop' + healths.project_cloud__Health__c);
            if(healths.project_cloud__Health__c == 'Red'){
                System.debug(healths.project_cloud__Health__c);
                healths.project_cloud__Health__c = 'Green';
                System.debug(healths.project_cloud__Health__c);
                healths.project_cloud__Health_Reason__c = 'Changing Health Reason for Testing Purposes';
                //update project1;
            } else {
                System.debug(healths);
            }
        }
        update tasksToUpdate;

        System.debug('Exits Loop');
        System.debug(project1);

        project_cloud__Project__c project2 = [SELECT Id, Name, redCount__c, yellowCount__c, greenCount__c FROM project_cloud__Project__c WHERE Id =:project1.Id];

        //    update project1;
        //    System.debug(project1.redCount__c + project1.yellowCount__c + project1.greenCount__c);
            System.assertEquals(0, project2.redCount__c, 'There Should be No Red Tasks');
        //    System.debug(project1.redCount__c + project1.yellowCount__c + project1.greenCount__c);
            System.assertEquals(3,project2.greenCount__c, 'There Should be 3 Green Tasks');
        //    System.debug(project1.redCount__c);
        System.debug(project2);
        Test.stopTest();
    }
}