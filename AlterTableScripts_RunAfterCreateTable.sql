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

-- =================================================================================================================================================================================================================================================================================================================================================================
-- Author:          Full Data
-- Created Date: 	Mar-12-2021
-- Updated Date:	Mar-12-2021
-- Description:     This sql script consists of alter table commands to be run after creation of tables		
-- ==================================================================================================================================================================================================================================================================================================================================================================*/


ALTER TABLE [Internal].[AzureADFPipeLinesExecutionData] ADD  CONSTRAINT [DF_AzureADFPipeLinesExecutionData_NoOfEmailSent]  DEFAULT ((0)) FOR [NoOfEmailsSent]
GO

ALTER TABLE [Internal].[AzureADFPipeLinesExecutionHistoryData] ADD  CONSTRAINT [DF_AzureADFPipeLinesExecutionHistoryData_NoOfEmailSent]  DEFAULT ((0)) FOR [NoOfEmailsSent]
GO

ALTER TABLE [Report].[AzureADFPipelinesExecutionPerformance] ADD  DEFAULT ((-1)) FOR [ThresholdInSeconds]
GO

ALTER TABLE [Report].[AzureADFPipelinesExecutionPerformance] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedDateTime]
GO