global class AccountContactsSOAPApi {
	webservice static String insertAccContact(String customerName,Boolean isAccount)
    {
        if(isAccount == true)
        {
            Account acc = new Account(Name = customerName);
            insert acc;
            return acc.Id;
        }
        else
        {
            Contact con = new Contact(LastName = customerName);
            insert con;
            return con.Id;
        }
    }
}

/*
@isTest
public class SNHU_TestFlowAfterCaseDisposition {

    @isTest
    static void testCaseUpdateFlow() {
        
        // Create a Case record that meets the initial conditions
		Case SMSSupport = SNHU_TestDataFactory.TestCase(SNHU_GlobalConstants.SMSSUPPORTRECORDTYPE,NULL,NULL, NULL, false);
		SMSSupport.Session_Disposition__c = 'Resolution Found';
        SMSSupport.Disposition_Reason__c = 'Inquiry Resolved';
        SMSSupport.Short_Survey_URL__c = 'http://example.com/survey';
		insert SMSSupport;

        // Create a Messaging Session related to the Case
		MessagingSession msgsRecord =  SNHU_TestDataFactory.testMessagingSession(false);
        msgsRecord.CaseId = SMSSupport.Id;
        msgsRecord.Status = 'ENDED';
        msgsRecord.MessagingEndUserId = createUserWithConsent().Id;
        insert msgsRecord;

        //Simulate the update that triggers the flow
        SMSSupport.Disposition_Timestamp__c = DateTime.now();
        update SMSSupport;

        // Verify the update on the Messaging User object
        MessagingEndUser msgUser = [SELECT Last_Survey_Date__c FROM MessagingEndUser WHERE Id = :msgsRecord.MessagingEndUserId];
        System.assertEquals(Date.today(), msgUser.Last_Survey_Date__c, 'The Last_Survey_Date__c should be updated to today\'s date');
    }

    // Helper method to create a Messaging User with consent
    private static MessagingEndUser createUserWithConsent() {
        MessagingEndUser user = new MessagingEndUser(
            Consent_Status__c = 'Opted In',
            MessagingPlatformKey = 'SomePlatformKey'
        );
        insert user;
        return user;
    }
}

Create a apex text class for a flow which triggers 
step1: when a case is updated with the below conditions if
	1. Session_Disposition__c != null
	2. Disposition_Reason__c != null
	3. Disposition_Reason__c != 'No Reply (Student)'
	4. Disposition_Timestamp__c is changed 
	5. Short_Survey_URL__c != null
step2: Get Records on Record type object if
	1. sObjectType = Case
	2. DeveloperName = Student_SMS_Support
	only the first record 
step3: Get records on Messaging Session object if
	1. CaseId = triggered Case ID
step4: Get records on SNHU SMS VOC Survey Frequency metadata if
	1. Days__c != null
step5: Checking condition for recordtype and disposition data if
	1. Triggering case recordtype ID = the ID of record type which we are getting from step 2.
	2. Messaging Session Record from step3 != null
	3. Messaging Session Status from step3 == "ENDED"
	4. Messaging Session from step3 > Messaging userID > Consent Status == "Opted In"
If step5 is true 
Step6: Get Records on Messaging User if
	1. MessagingPlatformKey = Messaging Session from step3 > Messaging userID > Messaging Platform Key
	2. Last_Survey_Date__c != NULL
Step7: Checking if 
	1. step6 Record == NULL 
	OR
	2. a formula field < current date (formula: {!Date}+{!Dayvalues})
If step7 true we are sending an Messaging Notification Action
	1. Messaging channel Unique Name = Messaging Session from step3 > Messaging userID > Developer Name
	2. Messaging Template Unique Name = 'SMS_Survey_Link_Template'
	3. Context Record ID = Triggered Case ID
	4. Recipient Phone Number = Messaging Session from step3 > Messaging userID > Messaging User Name
	5. Recipient Record ID = Messaging Session from step3 > Messaging userID
Finally we are updating on Messaging User Object  if
	1. Id = Messaging Session from step3 > Messaging userID > Messaging userID
	then update 
	Last_Survey_Date__c = CurrentDate
		
System.DmlException: Insert failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Required fields are missing: [Name, MessagingChannelId, MessageType]: [Name, MessagingChannelId, MessageType]
System.DmlException: Insert failed. First exception on row 0; first error: MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a non-setup object (or vice versa): MessagingChannel, original object: Case: []

@isTest
public class FlowTriggerTestClass {
    @isTest
    static void testCaseUpdateFlowTrigger() {
        // Step 1: Setup - Create User for System.runAs to avoid Mixed DML
        User testUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
        System.runAs(testUser) {
            // Create a RecordType for Case with DeveloperName = 'Student_SMS_Support'
            RecordType caseRecordType = new RecordType(
                SObjectType = Case.SObjectType,
                DeveloperName = 'Student_SMS_Support',
                Name = 'Student SMS Support',
                IsActive = true
            );
            insert caseRecordType;

            // Step 2: Insert non-setup records after RecordType creation
            // Create a Case that meets the initial update conditions
            Case testCase = new Case(
                RecordTypeId = caseRecordType.Id,
                Session_Disposition__c = 'Test Disposition',
                Disposition_Reason__c = 'Test Reason',
                Short_Survey_URL__c = 'https://testurl.com',
                Disposition_Timestamp__c = DateTime.now(),
                Status = 'New'
            );
            insert testCase;

            // Step 3: Create a Messaging Session record linked to the Case
            Messaging_Session__c messagingSession = new Messaging_Session__c(
                CaseId__c = testCase.Id,
                Status__c = 'ENDED',
                Messaging_User__c = 'OptedInUserId' // Placeholder
            );
            insert messagingSession;

            // Step 4: Create a Messaging User record
            Messaging_User__c messagingUser = new Messaging_User__c(
                Id = messagingSession.Messaging_User__c,
                Consent_Status__c = 'Opted In',
                MessagingPlatformKey__c = 'TestPlatformKey',
                DeveloperName__c = 'TestUniqueName',
                Last_Survey_Date__c = Date.today().addDays(-5) // 5 days ago
            );
            insert messagingUser;

            // Step 5: Query existing SNHU SMS VOC Survey Frequency metadata record
            SNHU_SMS_VOC_Survey_Frequency__mdt surveyFrequency = [
                SELECT Days__c
                FROM SNHU_SMS_VOC_Survey_Frequency__mdt
                WHERE Days__c != null
                LIMIT 1
            ];

            // Step 6: Update the Case to trigger the Flow (simulate update)
            testCase.Disposition_Timestamp__c = DateTime.now().addMinutes(1); // Simulate timestamp change
            update testCase;

            // Step 7: Validate results
            // Query Messaging User to check Last_Survey_Date__c has been updated
            Messaging_User__c updatedMessagingUser = [
                SELECT Last_Survey_Date__c
                FROM Messaging_User__c
                WHERE Id = :messagingUser.Id
                LIMIT 1
            ];

            // Assertions
            System.assertEquals(Date.today(), updatedMessagingUser.Last_Survey_Date__c, 'Last Survey Date should be updated to current date.');
        }
    }
}


@isTest
    static void testCaseUpdateFlow() {
        
        User testUser = SNHU_TestDataFactory.testUser(SNHU_GlobalConstants.SYSTEMADMINPROFILE, null, null, true);

        MessagingChannel msgChannel;
        MessagingEndUser msgEndUser;
        
        System.runAs(testUser) {
            
            msgChannel = new MessagingChannel();
            msgChannel.MessagingPlatformKey = 'testKey';
            msgChannel.MessageType = 'text';
            msgChannel.DeveloperName = 'Sample';
            msgChannel.MasterLabel = 'Sample';
            insert msgChannel;

            msgEndUser = new MessagingEndUser();
            msgEndUser.Consent_status__c = 'Opted In';
            msgEndUser.MessagingPlatformKey = 'Test Key';
			msgEndUser.Name = '+18765456787';
			msgEndUser.MessagingChannelId =  msgChannel.Id;
            msgEndUser.MessageType = 'Text';
            insert msgEndUser;
        }
        
        Test.startTest();
        // Create a Case record that meets the initial conditions
		Case SMSSupport = SNHU_TestDataFactory.TestCase(SNHU_GlobalConstants.SMSSUPPORTRECORDTYPE,NULL,NULL, NULL, false);
		SMSSupport.Session_Disposition__c = 'Resolution Found';
        SMSSupport.Disposition_Reason__c = 'Inquiry Resolved';
        SMSSupport.Short_Survey_URL__c = 'http://example.com/survey';
		insert SMSSupport;

        // Create a Messaging Session related to the Case
		MessagingSession msgsRecord =  SNHU_TestDataFactory.testMessagingSession(true);
        msgsRecord.CaseId = SMSSupport.Id;
        msgsRecord.Status = 'ENDED';
        msgsRecord.MessagingEndUserId = msgEndUser.Id;
        insert msgsRecord;

        //Simulate the update that triggers the flow
        SMSSupport.Disposition_Timestamp__c = DateTime.now();
        update SMSSupport;
        Test.stopTest();

        // Verify the update on the Messaging User object
        MessagingEndUser msgUser = [SELECT Last_Survey_Date__c FROM MessagingEndUser WHERE Id = :msgsRecord.MessagingEndUserId];
        System.assertEquals(Date.today(), msgUser.Last_Survey_Date__c, 'The Last_Survey_Date__c should be updated to today\'s date');
========================================
@isTest
public class TestCaseUpdateFlow {

    // Future method to isolate non-setup DML operations
    @future
    public static void triggerCaseUpdate(Id caseId, DateTime timestamp) {
        // Update the case to trigger the flow
        Case caseToUpdate = [SELECT Id FROM Case WHERE Id = :caseId];
        caseToUpdate.Disposition_Timestamp__c = timestamp;
        update caseToUpdate;
    }

    @isTest
    static void testCaseUpdateFlow() {
        // Step 1: Create a test user (setup object)
        User testUser = SNHU_TestDataFactory.testUser(SNHU_GlobalConstants.SYSTEMADMINPROFILE, null, null, true);

        MessagingChannel msgChannel;
        MessagingEndUser msgEndUser;

        // Step 2: Perform setup DML operations within System.runAs
        System.runAs(testUser) {
            msgChannel = new MessagingChannel();
            msgChannel.MessagingPlatformKey = 'testKey';
            msgChannel.MessageType = 'text';
            msgChannel.DeveloperName = 'Sample';
            msgChannel.MasterLabel = 'Sample';
            insert msgChannel;

            msgEndUser = new MessagingEndUser();
            msgEndUser.Consent_status__c = 'Opted In';
            msgEndUser.MessagingPlatformKey = 'Test Key';
            msgEndUser.Name = '+18765456787';
            msgEndUser.MessagingChannelId = msgChannel.Id;
            msgEndUser.MessageType = 'Text';
            insert msgEndUser;
        }

        // Step 3: Perform non-setup DML operations in a separate transaction
        Test.startTest();

        // Create a Case record (non-setup object)
        Case testCase = SNHU_TestDataFactory.TestCase(SNHU_GlobalConstants.SMSSUPPORTRECORDTYPE, null, null, null, false);
        testCase.Session_Disposition__c = 'Resolution Found';
        testCase.Disposition_Reason__c = 'Inquiry Resolved';
        testCase.Short_Survey_URL__c = 'http://example.com/survey';
        insert testCase;

        // Create a Messaging Session related to the Case
        MessagingSession msgsRecord = SNHU_TestDataFactory.testMessagingSession(true);
        msgsRecord.CaseId = testCase.Id;
        msgsRecord.Status = 'ENDED';
        msgsRecord.MessagingEndUserId = msgEndUser.Id;
        insert msgsRecord;

        // Call the future method to perform the update asynchronously
        triggerCaseUpdate(testCase.Id, DateTime.now());

        Test.stopTest();

        // Step 4: Verify the outcome of the flow
        MessagingEndUser msgUser = [
            SELECT Last_Survey_Date__c 
            FROM MessagingEndUser 
            WHERE Id = :msgsRecord.MessagingEndUserId
        ];
        System.assertEquals(Date.today(), msgUser.Last_Survey_Date__c, 'The Last_Survey_Date__c should be updated to today\'s date');
    }
}



    }*/