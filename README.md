# FullData ADF Monitoring utility

This Azure Data Factory monitoring utility is a solution that records and stores pipeline execution runtimes in an Azure SQL Database and sends out an Email alert when a threshold limit is exceeded. Its developed by FullData and provided ‘AS-IS’ to the Microsoft Data Platform community.


When your Azure Data Factory environment is consuming a lot of resources due some unforeseen failing or /long running job s you would want to be informed right away rather then after receiving a serious bill. An ADF environment easily spans 100+ pipelines that execute b. But not all actions may be properly logged as status ‘Completed’ or and get stuck as ‘InProgress’. The current standard Azure generic monitoring signal logic does not cover the full range of scenarios.


To avoid surprises and to provide more granular insights and alerting, the FullData team developed a simple and efficient service that will email you when the duration of pipeline activities exceeds 2x the average duration or any other configurable alarm threshold that you as user can set by querying by querying the Azure management API directly. This is more reliable than leveraging the Azure Log Analytics data as source.


todo:  
1) Insert pictures of overall architecture ( adf-> FD monitor -> SQLDB -> sendgrid)  

The API call to use: 
POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/queryPipelineRuns?api-version=2018-06-01

For more information see also: https://docs.microsoft.com/en-us/rest/api/datafactory/pipelineruns/querybyfactory

![image](https://user-images.githubusercontent.com/79724599/109359528-a224e600-78ab-11eb-8666-37e4041e8037.png)

Figure 1:  Raw API output.


The ADF Monitoring utility will update table [internal].[AzureADFPipeLinesExecutionData] every hour with the latest information: 

![image](https://user-images.githubusercontent.com/79724599/109359548-ae10a800-78ab-11eb-97e8-42499db56245.png)

Figure 2: Sample of the persisted ADF pipeline details


The typical scenario to keep an eye on cost is by levering Azure cost alerts. However, many Azure customers may not have direct insights to their azure cost metrics due to their Azure subscription type where a few days delay in cost insights is typical. Therefor Azure cost alerts might not be an adequate alternative to monitor ADF consumption. 

Our monitoring approach to check Pipeline runtime duration in near-realtime on a granular level are a great alternative! 


## Installation

Step 1 : Clone the repository


Step 2 : Open ADFMonitor.sln


Step 3 : Add connection Strings to ADFMonitor.cs


Step 4 : Add your ADF specific info and run the program



```bash
            #region Get Config
            var clientId = "Client Id for the Service Principal registered";
            var clientSecret = "Client Secret for the Service Principal registered";
            var tenantId = "Tenant Id for the azure tenant";
            var subscriptionId = "Subscription Id for the azure subscription";
            var resourceGroupName = "resourceGroupName for the factory to be queried";
            var factoryName = "Name of the factory to be queried";
            #endregion
```
## Usage

By tracking your ADF pipeline runtime durations, you also have a perfect start to perform trend analysis to predict when your ADF environment runs in overtime.

Easily and visualy identify which pipelines take most time to complete, spotting the outliers which would benefit from optimization and predict when you will run out of your data processing window. 

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Full Data ADF Monitoring - The complete solution

In addition to the gathering the base ADF monitoring data we can help you visualize trends and resolve ADF pipeline challenges and optimize their runtimes minimizing cost and maximizing efficiency.

## License
[MIT](https://choosealicense.com/licenses/mit/)
