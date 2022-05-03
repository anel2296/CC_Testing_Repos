//  Trigger Name  on Which Update  (Type of Event or Events)
//  In this example, A Trigger is executed before the records of Leads are updated
trigger HelloWorld on Lead (before update) {

// This can be called a trigger loop
// Trigger.new is List of all lists in this trigger 
// Loop through all Leads of Trigger new

//TRIGGER.NEW IS TYPE LIST AND WILL RETURNS A LIST OF THE NEW VERSIONS OF THE SOBJECT RECORDS. NOTE THAT THIS SIBHECT LIST IS
//ONLY AVAILABLE IN INSERT AND UPDATE TRIGGERS, AND THE RECORDS CAN ONLY BE MODIFIED IN BEFORE TRIGGERS.


//TRIGGER.OLD RETURNS A LIST OF THE OLD VERSIONS OF THE SOBJECT RECORDS. NOTE THAT THIS SOBJECT LIST IS ONLY
//AVAILABLE IN THE UPDATE AND DELETE TRIGGERS.

    for(Lead l : trigger.new){
        l.FirstName = 'Hello';
        l.LastName = 'World';
    }
}