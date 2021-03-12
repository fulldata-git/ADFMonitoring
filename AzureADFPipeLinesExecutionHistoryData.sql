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
-- Description:     This table holds the Historical Data for Execution of ADF pipelines			
-- ==================================================================================================================================================================================================================================================================================================================================================================*/

CREATE TABLE [Internal].[AzureADFPipeLinesExecutionHistoryData](
	[AzureADFPipeLinesExecutionHistoryDataID] [bigint] IDENTITY(1,1) NOT NULL,
	[RunId] [uniqueidentifier] NULL,
	[RunGroupId] [uniqueidentifier] NULL,
	[PipelineName] [varchar](200) NULL,
	[RunStart] [datetime2](7) NULL,
	[RunEnd] [datetime2](7) NULL,
	[DurationInMs] [bigint] NULL,
	[Status] [varchar](200) NULL,
	[Message] [varchar](max) NULL,
	[NoOfEmailsSent] [int] NULL,
	[LastUpdated] [datetime2](7) NULL,
	[InvokedByType] [varchar](max) NULL,
	[InvokedByName] [varchar](max) NULL,
	[ModifiedDateTime] [datetime] NULL,
	[FactoryName] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[AzureADFPipeLinesExecutionHistoryDataID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO