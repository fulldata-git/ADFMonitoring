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
-- Description:     This table holds the Execution Performance Data for ADF pipelines			
-- ==================================================================================================================================================================================================================================================================================================================================================================*/

CREATE TABLE [Report].[AzureADFPipelinesExecutionPerformance]
(
	[AzureADFPipelinesExecutionPerformanceID] [int] IDENTITY(1,1) NOT NULL,
	[PipelineName] [varchar](200) NULL,
	[MinPipelineDurationInSeconds] [bigint] NULL,
	[MaxPipelineDurationInSeconds] [bigint] NULL,
	[AvgPipelineDurationInSeconds] [bigint] NULL,
	[NoOfRecordsForAvg] [int] NULL,
	[ThresholdInSeconds] [int] NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	
PRIMARY KEY CLUSTERED 
(
	[AzureADFPipelinesExecutionPerformanceID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
