/****** Object:  StoredProcedure [Internal].[usp_AzureADFPipeLinesExecutionData]    Script Date: 2/26/2021 12:45:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Internal].[usp_AzureADFPipeLinesExecutionData]
(
	@AdfPipeLineMonitoringData	VARCHAR(MAX)
)
AS
BEGIN
BEGIN TRY
      BEGIN TRANSACTION
	DECLARE @TodaysDateTime DATETIME = GETUTCDATE()
			,@RefDate       DATETIME = CONVERT(DATETIME, '01.01.1900',104);

	INSERT INTO Internal.AzureAdfPipeLineJsonData
	(
		 AdfPipeLineMonitoringData
		,[LastUpdatedDateTime]
	)
	SELECT   @AdfPipeLineMonitoringData	AS AdfPipeLineMonitoringData
			,@TodaysDateTime			AS [LastUpdatedDateTime]

	DROP TABLE IF EXISTS #TempTable

	SELECT    [RunId]
		     ,[RunGroupId]	
		     ,[PipelineName]	
		     ,[RunStart]		
		     ,[RunEnd]	
			 ,[DurationInMs]
		     ,[Status]		
		     ,[Message]		
		     ,[LastUpdated]	
			 ,[FactoryName]
			 ,[InvokedByName]			 
			 ,[InvokedByType]
	INTO #TempTable
	FROM OPENJSON(@AdfPipeLineMonitoringData)
	WITH 
	(	
	    [RunId]					UNIQUEIDENTIFIER  	'$.RunId'			
	   ,[RunGroupId]			UNIQUEIDENTIFIER  	'$.RunGroupId'	
       ,[PipelineName]			VARCHAR(200)  		'$.PipelineName'
       ,[RunStart]				DATETIME2  			'$.RunStart'			
       ,[RunEnd]				DATETIME2  			'$.RunEnd'	
       ,[DurationInMs]			BIGINT  			'$.DurationInMs'	   
       ,[Status]				VARCHAR(200)  		'$.Status'	
       ,[Message]				VARCHAR(MAX)  		'$.Message'	
       ,[LastUpdated]			DATETIME2  			'$.LastUpdated'
       ,[FactoryName]			VARCHAR(1000)  		'$.FactoryName'
	   ,[InvokedByType]			VARCHAR(MAX)  		'$.InvokedBy.invokedByType'
	   ,[InvokedByName]			VARCHAR(MAX)  		'$.InvokedBy.name'
	);

	DELETE FROM [Internal].[AzureADFPipeLinesExecutionData]
	WHERE CAST([LastUpdated] AS DATE) < CAST(@TodaysDateTime-7 AS DATE)

	MERGE [Internal].[AzureADFPipeLinesExecutionData] AS Trgt
	USING (SELECT * FROM #TempTable) AS Src
	ON   Trgt.[RunId]  = Src.[RunId]	     
	WHEN MATCHED 
	THEN UPDATE 
		SET  Trgt.[RunGroupId]			= Src.[RunGroupId]
			,Trgt.[RunEnd]				= Src.[RunEnd]	
			,Trgt.[DurationInMs]		= Src.[DurationInMs]
			,Trgt.[Status]				= Src.[Status]
			,Trgt.[Message]				= Src.[Message]	
			,Trgt.[LastUpdated]			= Src.[LastUpdated]	
			,Trgt.[FactoryName]			= Src.[FactoryName]
			,Trgt.[InvokedByType]		= Src.[InvokedByType]	
			,Trgt.[InvokedByName]		= Src.[InvokedByName]	
			,Trgt.[ModifiedDateTime]	= @TodaysDateTime
	WHEN NOT MATCHED THEN
	INSERT
	(
				[RunId]
			   ,[RunGroupId]
			   ,[PipelineName]
			   ,[RunStart]
			   ,[RunEnd]
			   ,[DurationInMs]
			   ,[Status]
			   ,[Message]
			   ,[NoOfEmailsSent]
			   ,[LastUpdated]
			   ,[FactoryName]
			   ,[InvokedByType]
			   ,[InvokedByName]
			   ,[ModifiedDateTime]
	)
	VALUES(	  Src.[RunId]
		     ,Src.[RunGroupId]	
		     ,Src.[PipelineName]	
		     ,Src.[RunStart]		
		     ,Src.[RunEnd]	
			 ,Src.[DurationInMs]
		     ,Src.[Status]		
		     ,Src.[Message]	
			 ,0 
		     ,Src.[LastUpdated]	
			 ,Src.[FactoryName]
			 ,Src.[InvokedByName]			 
			 ,Src.[InvokedByType]
			 ,@TodaysDateTime 
			 );

	MERGE [Internal].[AzureADFPipeLinesExecutionHistoryData] AS Trgt
	USING (SELECT * FROM #TempTable) AS Src
	ON   Trgt.[RunId]  = Src.[RunId]	     
	WHEN MATCHED 
	THEN UPDATE 
		SET  Trgt.[RunGroupId]			= Src.[RunGroupId]
			,Trgt.[RunEnd]				= Src.[RunEnd]	
			,Trgt.[DurationInMs]		= Src.[DurationInMs]
			,Trgt.[Status]				= Src.[Status]
			,Trgt.[Message]				= Src.[Message]	
			,Trgt.[LastUpdated]			= Src.[LastUpdated]	
			,Trgt.[FactoryName]			= Src.[FactoryName]
			,Trgt.[InvokedByType]		= Src.[InvokedByType]	
			,Trgt.[InvokedByName]		= Src.[InvokedByName]	
			,Trgt.[ModifiedDateTime]	= @TodaysDateTime
	WHEN NOT MATCHED THEN
	INSERT
	(
				[RunId]
			   ,[RunGroupId]
			   ,[PipelineName]
			   ,[RunStart]
			   ,[RunEnd]
			   ,[DurationInMs]
			   ,[Status]
			   ,[Message]
			   ,[NoOfEmailsSent]
			   ,[LastUpdated]
			   ,[FactoryName]
			   ,[InvokedByType]
			   ,[InvokedByName]
			   ,[ModifiedDateTime]
	)
	VALUES(	  Src.[RunId]
		     ,Src.[RunGroupId]	
		     ,Src.[PipelineName]	
		     ,Src.[RunStart]		
		     ,Src.[RunEnd]	
			 ,Src.[DurationInMs]
		     ,Src.[Status]		
		     ,Src.[Message]	
			 ,0 
		     ,Src.[LastUpdated]	
			 ,Src.[FactoryName]
			 ,Src.[InvokedByName]			 
			 ,Src.[InvokedByType]
			 ,@TodaysDateTime 
			 );

			UPDATE ppl
			SET	 [MinPipelineDurationInSeconds]	= CASE WHEN temp.MinDurationInSeconds < ISNULL(ppl.[MinPipelineDurationInSeconds],0)
													   OR ISNULL(ppl.[MinPipelineDurationInSeconds],0) = 0
													   THEN temp.MinDurationInSeconds
													   ELSE ISNULL(ppl.[MinPipelineDurationInSeconds],0)
													   END
				,[MaxPipelineDurationInSeconds]	= CASE WHEN temp.MaxDurationInSeconds > ISNULL(ppl.[MaxPipelineDurationInSeconds],0)
													   THEN temp.MaxDurationInSeconds
													   ELSE ISNULL(ppl.[MaxPipelineDurationInSeconds],0)
													   END
			FROM [Report].[AzureADFPipelinesExecutionPerformance] PPl
			INNER JOIN (SELECT [PipelineName]
							  ,MIN([DurationInMs])/1000 AS MinDurationInSeconds
							  ,MAX([DurationInMs])/1000 AS MaxDurationInSeconds
						FROM #TempTable 
						WHERE [Status] = 'Succeeded'
						GROUP BY [PipelineName]
						)temp
			ON ppl.[PipelineName] = temp.[PipelineName]

			--Previous Count  10 --> 40
			--you multiply the old average by n−1, add the new number, and divide the total by n.
			UPDATE ppl
			SET	  [AvgPipelineDurationInSeconds]	= (CAST(([AvgPipelineDurationInSeconds]*((ppl.NoOfRecordsForAvg+Subq.Cnt)-1))+([SumDurationInSeconds])
															AS DECIMAL(38,2)
															) 
														 /(ppl.NoOfRecordsForAvg+Subq.Cnt))
				 ,[NoOfRecordsForAvg]				= ppl.NoOfRecordsForAvg+Subq.Cnt
				 ,[LastUpdatedDateTime]				= @TodaysDateTime--This Updation Should not happen above update stmt
			FROM [Report].[AzureADFPipelinesExecutionPerformance] PPl
			INNER JOIN (SELECT [PipelineName]
							  ,COUNT(1) AS Cnt
							  ,SUM([DurationInMs])/1000 AS [SumDurationInSeconds]
						FROM #TempTable
						WHERE [Status] = 'Succeeded'
						GROUP BY [PipelineName]
						)Subq
			ON Subq.PipelineName = PPl.PipelineName

			INSERT INTO [Report].[AzureADFPipelinesExecutionPerformance]
			(
				 [PipelineName]
				,[MinPipelineDurationInSeconds]
				,[MaxPipelineDurationInSeconds]
				,[AvgPipelineDurationInSeconds]
				,[NoOfRecordsForAvg]
				,[LastUpdatedDateTime]
			)
			SELECT  [PipelineName]			 AS [PipelineName] 
				   ,MIN([DurationInMs])/1000 AS [MinPipelineDurationInSeconds]
				   ,MAX([DurationInMs])/1000 AS [MaxPipelineDurationInSeconds]
				   ,AVG([DurationInMs])/1000 AS [AvgPipelineDurationInSeconds]
				   ,COUNT(1)				 AS [NoOfRecordsForAvg]
				   ,@TodaysDateTime			 AS [LastUpdatedDateTime]
			FROM #TempTable Ppl
			WHERE [Status] = 'Succeeded'
			AND [PipelineName] NOT IN (SELECT [PipelineName] FROM [Report].[AzureADFPipelinesExecutionPerformance])
			GROUP BY [PipelineName]


       COMMIT TRANSACTION
END TRY
BEGIN CATCH
	DECLARE @ErrorMsg NVARCHAR(MAX)
	SELECT @ErrorMsg= ERROR_MESSAGE()
	RAISERROR(@ErrorMsg,16,1)
		ROLLBACK TRANSACTION;
END CATCH	
	
END
