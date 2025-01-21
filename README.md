<a href="https://githubsfdeploy.herokuapp.com?owner=FinDockLabs&repo=findock-reconciliation-chatterpost-clone&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

```text
NOTE: to be able to deploy this project to your Salesforce production environment your overall test code coverage needs to meet Salesforce thresholds.
Although this project has 100% coverage, existing custom code in your environment might push the overall coverage below the threshold. 
```

# FinDock Chatter Feed Clone

Use Case : There are multiple Customer entities, for example, different geographical entities, using the same Salesforce Org with FinDock and there is a requirement to segregate user access to reconciliation files being uploaded to the FinDock Chatter group. In other words, requirement is for users from one geography to not have access to files of the other geographies.

Solution : 
- Create a private Chatter group for the individual entity (Local Chatter Group)
- use this Project to clone the Chatter posts from the Local Chatter group into the FinDock Chatter Group linked to ProcessingHub (Global Chatter Group) in the context of the FinDock Integration User. 
- Individual users who upload files should be members of the Local Chatter Group
- FinDock Integration User should be a member of the Global Chatter Group


A quick description for what this repo contains:
- A flow to create a Platform event when a Chatter post is created in the Local Chatter Group
- A platform event to hold the FeedItemID and FeedAttachment to be cloned
- An apex trigger that clones the Chatter Feed Item from the Local Chatter group to the Global Chatter Group
- A PlatformEventSubscriberConfig that ensures the apex trigger runs in the context of the FinDock Integration User



## Full list of components

```text

**flows**
flows/FinDock_Chatter_Feed_Clone_Platform_Event.flow

**objects**
objects/ChatterFeedClone__e.object

**triggers**
triggers/FinDockLocalChatterFeedItemAfterInsert.trigger

**apexclass**
classes/FinDockLocalChatterFeedItemTest.cls
```

## Installation
- use `sfdx` to deploy a selection of or all components.
- press the "Deploy to Salesforce" button at the top of this README and then press "Login to Salesforce" in the top right of your screen. Please note, the GitHub Salesforce Deploy Tool is provided open source by [andyinthecloud](http://andyinthecloud.com/category/githubsfdeploy/). No FinDock support is provided.
- any other deployment method you prefer.

## Configuration
1. Create a platform event subscriber configuration to run the Apex trigger in the context of the FinDock Integration User. Please edit the body of the command as described below
    - replace "recordID of apex trigger" with the record ID of the Apex trigger created by this project
    - replace  "userID of FinDock integration user" with the userID of the FinDock Integration User
    
    Run the following POST Command from Workbench
    - End point : /services/data/v58.0/tooling/sobjects/PlatformEventSubscriberConfig
    - Body
    {
    "BatchSize": "50",
    "DeveloperName":"Findock_Local_Chatter_Feed_Item_Config",
    "MasterLabel":"Findock_Local_Chatter_Feed_Item_Config",
    "PlatformEventConsumerId": "recordID of apex trigger",
    "UserId": "userID of FinDock integration user"
    }

2. Edit the entry conditions in the start step of the flow "FinDock_Chatter_Feed_Clone_Platform_Event" to assign the Local Chatter Group ID to the value of ParentID field.

## Contributing

When contributing to this repository, please first discuss the change you wish to make via an issue or any other method with FinDock before making a change.

## Support

FinDock Labs is a non-supported group in FinDock that releases applications. Despite the name, assistance for any of these applications is not provided by FinDock Support because they are not officially supported features. For a list of these apps, visit the FinDock Labs account on Github.

## License

This project is licensed under the MIT License - see the [LICENSE](/LICENSE) file for details
