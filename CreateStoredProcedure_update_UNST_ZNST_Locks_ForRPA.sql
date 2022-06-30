USE [SharedServices]
GO

-- =============================================
-- Author:		<Aaron Lawrence>
-- Create date: <6/18/19>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[update_UNST_ZNST_Locks_ForRPA] (@RowCount int)
WITH EXECUTE AS OWNER
AS
BEGIN
	-- Declare variables here
	-- None to declare

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Procedure statements here
	-- Used Transaction to Rollback if something goes wrong
	-- Used Try-Catch Block
	-- Set for the allowance of transaction to abort
	SET XACT_ABORT ON;

	BEGIN TRY
		BEGIN TRANSACTION;
			-- Temporary Common Table Expression for the update step later
			WITH CTE AS
			(	-- There probably should be a parameter here to pass how many records to select for the update
				SELECT TOP (@RowCount) * 
				FROM 
				(
					SELECT * 
					FROM [SharedServices].[dbo].[UNST_ZNST]
					WHERE
					(  
						(	
							-- Exception Path
							AR_GL_NUM IN('1300','1322') -- THE EXCEL MACRO ONLY SHOWS THESE TWO GL NUMBERS TO AN ASSOCIATE
							AND PY_NUMBER IS NOT NULL   -- THIS REALLY NEEDS TO BE HERE AS THE BOT IS RELIANT ON PY NUMBER INFO BEING PRESENT
							AND
								(-- THE SPREADSHEET MACRO ONLY SHOWS PY_NUMBERS THAT HAVE PA OR CM IN THEM
									PY_NUMBER LIKE '%PA%'
									OR
									PY_NUMBER LIKE '%CM%'
								)-- THE SPREADSHEET MACRO ALSO TRIES TO FILTER ON ALL OF THE SHIP INSTR
								 -- BUT THE BOT DOESN'T CARE ABOUT THOSE COLUMNS
							-- UNST REPORT DOES NOT CONTAIN A TERM COLUMN ALL RECORDS ARE ASSUMED TO BE TERMS = COD AS PART OF THE CODE FOR THE UNST TRILOGIE REPORT
						)
						AND
						(
							( -- Happy Path 1
							  -- PY_AMOUNT IS NOT STORED AS NUMERIC AND CAN'T BE STORED THAT WAY
							  -- THIS MAY NOT WORK
							  -- WILL HAVE TO CAST BAL AS VARCHAR
								CAST(BAL AS varchar(255)) = PY_AMOUNT
								AND PY_NUMBER NOT LIKE '%|%'
							)
							OR
							( -- Happy Path 2
								PY_AMOUNT IS NULL
								AND PY_NUMBER NOT LIKE '%|%'
							)
							OR
							( -- Happy Path 3 
								PY_NUMBER LIKE '%|%'
								AND 
									(PY_AMOUNT IS NULL
									OR PY_AMOUNT LIKE '%|%')
							)
							 -- Happy Path 4 is identical to 3 except for how the bot handles the ones where the sum of PY Amounts equals BAL
						)
					)
					AND
					(   -- Excluding UNST records that are currently checked out, done, partial, set for pending and already owned by the bot
						CHECKED_OUT = 0 
						AND [STATUS] NOT IN('Done','Partial') 
						AND PENDING = 0 
						AND [OWNER] <> 'AAQ6349'
					)
				) AS RPA
			)
			/* Update the selected records above to be checked_out, owned by the bot account, status to Started from a None and Started state, update_date to current datetime and start_date to current datetime only if null */ 
			UPDATE CTE SET CHECKED_OUT = 1, [OWNER] = 'AAQ6349', [STATUS] = 'Started', UPDATE_DATE = getdate(), [START_DATE] = ISNULL([START_DATE], getdate()) 
			-- Should also consider a parameter to pass OWNER ID for the possiblity of multiple bots
		COMMIT TRANSACTION;
		GOTO DONE
	END TRY
	BEGIN CATCH
		EXECUTE usp_GetErrorInfo;

		IF (XACT_STATE()) <> 0  
		BEGIN  
			PRINT 'The transaction is in an uncommittable state.' +  
				  ' Rolling back transaction.'  
			ROLLBACK TRANSACTION;  
		END;
		GOTO FAIL
	END CATCH;

	DONE:
		RETURN

	FAIL:
		RETURN -1
END

GO

GRANT EXECUTE ON OBJECT::[dbo].[update_UNST_ZNST_Locks_ForRPA]
	TO [DS\FEI-SSC-AR Users] 
GO



