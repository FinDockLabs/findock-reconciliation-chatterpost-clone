trigger FinDockLocalChatterFeedItemAfterInsert on ChatterFeedClone__e (after insert) {
List<FeedItem> FeedItemList = new List<FeedItem>();
    For (ChatterFeedClone__e item: trigger.new) {
        proh__environment_settings__c cs = proh__environment_settings__c.getInstance('CHATTER_GROUP_ID'); 
        String FinDockGlobalChatterGroupID = cs.proh__value__c;
        
        FeedItem feed = new FeedItem();
        feed.ParentId = FinDockGlobalChatterGroupID;
        feed.Body = 'This post has been cloned automatically for FinDock Processing from : '+ URL.GetOrgDomainURL().ToExternalForm()+'/'+item.FeedItemID__c;
        feed.RelatedRecordId= item.FeedAttachmentID__c;
        
        feeditemlist.add(feed);
    }
    
    if (feeditemlist.size()>0){
        insert feeditemlist;
    }
}