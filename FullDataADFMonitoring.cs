/*
███████████████████████████ FULLDATA.NL ██████████████████████████████

███████╗██╗   ██╗██╗     ██╗         ██████╗  █████╗ ████████╗ █████╗ 
██╔════╝██║   ██║██║     ██║         ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗
█████╗  ██║   ██║██║     ██║         ██║  ██║███████║   ██║   ███████║
██╔══╝  ██║   ██║██║     ██║         ██║  ██║██╔══██║   ██║   ██╔══██║
██║     ╚██████╔╝███████╗███████╗    ██████╔╝██║  ██║   ██║   ██║  ██║
╚═╝      ╚═════╝ ╚══════╝╚══════╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
███████████████████████████ FULLDATA.NL ██████████████████████████████
*/

using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.Management.DataFactory;
using Microsoft.Azure.Management.DataFactory.Models;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Rest;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Dapper;
using System.Data;

namespace MonitoringGit
{
    public static class FullDataADFMonitoring
    {
        [FunctionName("FullDataADFMonitoringFuntion")]
        public static async Task Run([TimerTrigger("0 */5 * * * *")]TimerInfo myTimer, ILogger log)
        {
            log.LogInformation($"C# Timer trigger function executed at: {DateTime.Now}");

            // This section needs to be updated before running the Project
            #region Get Config
            var clientId = "Client Id for the Service Principal registered";
            var clientSecret = "Client Secret for the Service Principal registered";
            var tenantId = "Tenant Id for the azure tenant";
            var subscriptionId = "Subscription Id for the azure subscription";
            var resourceGroupName = "resourceGroupName for the factory to be queried";
            var factoryName = "Name of the factory to be queried";
            #endregion

            //Generate authentication token with the client Id and secret of the registered service Principal
            var context = new AuthenticationContext("https://login.windows.net/" + tenantId);
            ClientCredential cc = new ClientCredential(clientId, clientSecret);
            AuthenticationResult authResult = context.AcquireTokenAsync(
                "https://management.azure.com/", cc).Result;
            ServiceClientCredentials cred = new TokenCredentials(authResult.AccessToken);

            // Create Data Factory Client and use the auth token
            var client = new Microsoft.Azure.Management.DataFactory.DataFactoryManagementClient(cred)
            {
                SubscriptionId = subscriptionId
            };
            
            List<RunQueryFilter> listQuery = new List<RunQueryFilter>();

            #region FilterClause and Run Parameters
            RunQueryFilter queryFilter = new RunQueryFilter()
            {
                Operand = "RunStart",
                OperatorProperty = "Equals",
                Values = new List<string> { "InProgress" }
            };
            listQuery.Add(queryFilter);
            
            RunFilterParameters runFilterParameters = new RunFilterParameters()
            {
                LastUpdatedAfter = DateTime.UtcNow.AddHours(-10),
                LastUpdatedBefore = DateTime.UtcNow,
                Filters = listQuery
            };
            #endregion

            //Query Data factory
            var queryResult = await client.PipelineRuns.QueryByFactoryAsync(resourceGroupName, factoryName, runFilterParameters);


            //Serialize the incoming data in a model and store in DB if required
            List<FullDataADFMonitoringModel> modelList = new List<FullDataADFMonitoringModel>();
            var serializedResult = JsonConvert.SerializeObject(queryResult?.Value);

            modelList = JsonConvert.DeserializeObject<List<FullDataADFMonitoringModel>>(serializedResult);
            foreach (var item in modelList)
            {
                item.FactoryName = factoryName;
            }
            using (System.Data.SqlClient.SqlConnection connectionAzureDB = new SqlConnection("conn string"))
            {
                var serilaizedModel = JsonConvert.SerializeObject(modelList);
                var values = new { AdfPipeLineMonitoringData = "data model to be inserted" };
                var sqlResults = await connectionAzureDB.QueryAsync("[Internal].[usp_AzureADFPipeLinesExecutionData]", values, commandTimeout: 0, commandType: CommandType.StoredProcedure);
                connectionAzureDB.Close();
            }

            // Send Mail using sendgrid to concerned team if a pipeline exceeds configured threshold
            foreach (var item in modelList)
            {
                if (item.Status.ToLower() == "inprogress")
                {
                    var timeDiff = DateTime.Now - Convert.ToDateTime(item.RunStart);

                    // Can be configured based on each pipeline in the factory
                    var threshold = 10;

                    if(threshold<timeDiff.Hours)
                    {
                            var sendMailUtility = new FullDataSendMailUtility();
                            await sendMailUtility.SendMailAsync(item, timeDiff, "sendGridApiKey", threshold);
                    }
                }
            }
        }
    }
}
