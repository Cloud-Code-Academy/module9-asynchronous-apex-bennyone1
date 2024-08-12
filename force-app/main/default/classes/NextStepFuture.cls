/*
 * NextStepFuture Class Description:
 * 
 * Question 1: Create a future method that updates all account and opportunities next step to 'Meeting in the future'
 * Question 2: Create a method that inserts a big deal opportunity and updates the user role name to 'CRO'
 * 
 * Benefits of using future methods:
 * 
 * 1. Asynchronous Processing: Allows long-running operations to be handled in the background, freeing up resources.
 * 2. Governor Limit Management: Asynchronous methods have a separate set of limits, providing more flexibility.
 * 3. User Experience Enhancement: Improves responsiveness in user interfaces by offloading processes to the background.
 * 4. Mixed DML Operations Handling: Helps overcome Mixed DML errors by allowing updates on setup and non-setup objects.
 * 5. Enhanced Integration Capabilities: Useful for making callouts to external systems without blocking the user interaction.
 * 
 * For more detailed information, refer to the official Salesforce documentation: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_invoking_future_methods.htm
 * 
 * Note: The class below contains placeholders for implementing a future method to update accounts and opportunities.
 *       The accompanying test class 'AsynchronousTest' should also be updated to test this method.
 */
public with sharing class NextStepFuture {
    

    /* 
     * Question 1
     * Update/Uncomment the template code to create a method
     * Create a future method that updates all account and opportunities next step to 'Meeting in the future'
     * Account Next Step field is a custom field
     * Opportunity Next Step field is a standard field
     * Update the corresponding test class AsynchronousTest and test method nextStepFuture_testUpdateAllNextStep to cover test this method
     */
    @future
    public static void updateAllNextStep (List<Id> accIdsToUpdate , List<Id> oppIdsToUpdate) {
        List<Account> accList = new List<Account>([SELECT ID FROM Account WHERE Id IN : accIdsToUpdate]);
        List<Opportunity> oppList = new List<Opportunity>([SELECT ID FROM Opportunity WHERE Id IN : oppIdsToUpdate]);
        for (Account acc : accList) {
            acc.Next_Step__c = 'Meeting in the future';
        }

        for (Opportunity opp: oppList) {
            opp.NextStep = 'Meeting in the future';
        }
        update accList;
        update oppList;
   }

    /*
    * Question 2
    * Update/Uncomment the template code to create a method
    * Create a method that inserts a big deal opportunity and updates the user role name to 'CRO'
    * Update the corresponding test class AsynchronousTest and test method nextStepFuture_testCreateDealAndUpdateRole to cover test this method
    */
    //Mix DML Error happens when you try to perform DML operations on setup and non-setup objects in a single transaction.
    
    public static void createDealAndUpdateRole() {
        insertBigDeal();
    
        UserRole[] roles = [SELECT Id, Name FROM UserRole WHERE Name = 'CRO' LIMIT 1];
        updateUserRoleName(roles);
    }

    @future
    public static void insertBigDeal() {
        Opportunity bigDeal = new Opportunity(
            Amount = 1000000,
            Name = 'Big Deal',
            StageName = 'Closed Won',
            CloseDate = Date.today()
        );
        insert bigDeal;
    }

    // Helper method to update role name
    public static void updateUserRoleName(UserRole[] roles){
        UserRole role;
        if (roles.isEmpty()) {
            role = new UserRole();
            role.portalType = 'None'; 
            role.CaseAccessForAccountOwner = 'Edit'; 
        } else {
            role = roles[0];
        }

        role.Name = 'CRO';

        upsert role;
    }
}
