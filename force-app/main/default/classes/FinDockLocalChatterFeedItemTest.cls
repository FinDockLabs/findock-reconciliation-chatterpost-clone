@isTest
public class FinDockLocalChatterFeedItemTest {
    @TestSetup
    static void createTestData(){
    
        CollaborationGroup localChatterGroup = new CollaborationGroup(
            Name = 'Test Local Chatter Group',
            CollaborationType = 'Public'
        );
        insert localChatterGroup;

        CollaborationGroup globalChatterGroup = new CollaborationGroup(
            Name = 'Test Global Chatter Group',
            CollaborationType = 'Public'
        );
        insert globalChatterGroup;

        // Use the global Chatter Group ID for the mock environment setting
        proh__environment_settings__c envSetting = new proh__environment_settings__c(
            Name = 'CHATTER_GROUP_ID',
            proh__value__c = globalChatterGroup.Id
        );
        insert envSetting;

        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'TestDocument.pdf',
            VersionData = Blob.valueOf('Test content')
        );
        insert contentVersion;

        FeedItem testFeedItem = new FeedItem(
            ParentId = localChatterGroup.Id,
            Body = 'Test Feed Item'
        );
        insert testFeedItem;
    }

    @isTest
    static void testValidPlatformEvent() {   
        
        List<proh__environment_settings__c> globalChatterGroup = [SELECT proh__value__c FROM  proh__environment_settings__c WHERE Name = 'CHATTER_GROUP_ID'];
        FeedItem testFeedItem = [SELECT ParentId,Body FROM FeedItem];

        ContentVersion insertedFile = [SELECT Id, ContentDocumentId FROM ContentVersion];
        
        ChatterFeedClone__e testEvent = new ChatterFeedClone__e(
            FeedItemId__c = testFeedItem.Id,
            FeedAttachmentID__c = insertedFile.Id
        );
        
        Test.startTest();
        
        // Publish a test platform event
        Database.saveResult sr = EventBus.publish(testEvent);
        
        Test.stopTest();
        
        List<FeedItem> createdFeedItems = [
            SELECT ParentId, RelatedRecordId 
            FROM FeedItem 
            WHERE ParentId = :globalChatterGroup[0].proh__value__c
            ];
        
        System.assertEquals(true, sr.isSuccess());
        System.assertEquals(1, createdFeedItems.size()); 
        System.assertEquals(globalChatterGroup[0].proh__value__c, createdFeedItems[0].ParentId);
        System.assertEquals(insertedFile.Id, createdFeedItems[0].RelatedRecordId);
    }
    
    @isTest
    static void testInvalidPlatformEvent() {   
        
        List<proh__environment_settings__c> globalChatterGroup = [SELECT proh__value__c FROM  proh__environment_settings__c WHERE Name = 'CHATTER_GROUP_ID'];
        FeedItem testFeedItem = [SELECT ParentId,Body FROM FeedItem];

        ContentVersion insertedFile = [SELECT Id, ContentDocumentId FROM ContentVersion];
        
        ChatterFeedClone__e testEvent = new ChatterFeedClone__e(
            FeedItemId__c = testFeedItem.Id,
            FeedAttachmentID__c = insertedFile.Id
        );
        
        Test.startTest();
        
        EventBus.publish(testEvent);
        //invoke failure and do not deliver event to subscribers
        Test.getEventBus().fail(); 
        
        Test.stopTest();

        List<FeedItem> createdFeedItems = [
            SELECT ParentId, RelatedRecordId 
            FROM FeedItem 
            WHERE ParentId = :globalChatterGroup[0].proh__value__c
            ];

        System.assertEquals(0, createdFeedItems.size()); 
    }
    
}