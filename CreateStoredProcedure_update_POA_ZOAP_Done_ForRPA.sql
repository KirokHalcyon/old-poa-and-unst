USE [SharedServices]
GO

-- =============================================
-- Author:		<Aaron Lawrence>
-- Create date: <5/2/19>
-- Updated: <5/3/19>
-- Description:	<This Stored Procedure will update a single POA record completed by a(n) RPA to their Done status>
-- =============================================
CREATE PROCEDURE [dbo].[update_POA_ZOAP_Done_ForRPA] (@POA_Num varchar(50))
WITH EXECUTE AS OWNER
AS
BEGIN
	-- Variables for the stored procedure
	DECLARE @strPOA_Num varchar(50),
			@rtrnPOA_Num varchar(50),
			@chkdoutBit bit,
			@userID varchar(50)

	-- Test if passed parameter is null
	IF @POA_Num IS NULL
		BEGIN
			SELECT 'NO UPDATE TO POA_ZOAP' AS 'POA Number parameter was Null';
			GOTO FAIL
		END 

	SET @strPOA_Num = @POA_Num;

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Test that the POA Number passed can be found
	SELECT @rtrnPOA_Num = INVOICE, @chkdoutBit = CHECKED_OUT, @userID = [OWNER]
	FROM [dbo].[POA_ZOAP]
	WHERE INVOICE = @strPOA_Num;

	IF @rtrnPOA_Num IS NULL
		BEGIN
			SELECT 'NO UPDATE TO POA_ZOAP' AS 'POA Number that was passed to this procedure could not be found in POA_ZOAP table';
			GOTO FAIL
		END

	-- Test that the POA Number hasn't been unlocked by other means

	IF @chkdoutBit = 0
		BEGIN
			SELECT 'NO UPDATE TO POA_ZOAP' AS 'POA Number that was passed to this procedure was already checked back in by a separate process';
			GOTO FAIL
		END

	-- Test that the POA Number isn't owned by someone else

	IF @userID <> 'AAQ6349'
		BEGIN
			SELECT 'NO UPDATE TO POA_ZOAP' AS 'POA Number that was passed to this procedure is checked out by someone else';
			GOTO FAIL
		END

    -- Procedure statements here
	-- Used Transaction to Rollback if something goes wrong
	-- Used Try-Catch Block
	-- Set for the allowance of transaction to abort
	SET XACT_ABORT ON;

	BEGIN TRY
		BEGIN TRANSACTION;
			WITH CTE AS
			(
					SELECT *
					FROM [SharedServices].[dbo].[POA_ZOAP]
					WHERE
					(
						INVOICE = @strPOA_Num
					)
			)
			UPDATE CTE SET CHECKED_OUT = 0, [STATUS] = 'Done', UPDATE_DATE = GetDate(), END_DATE = GetDate();
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

GRANT EXECUTE ON OBJECT::[dbo].[update_POA_ZOAP_Done_ForRPA]
	TO [DS\FEI-SSC-AR Users] 
GO
