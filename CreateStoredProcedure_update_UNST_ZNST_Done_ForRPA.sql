USE [SharedServices]
GO

-- =============================================
-- Author:		<Aaron Lawrence>
-- Create date: <6/18/19>
-- Description:	<This Stored Procedure will update a single UNST record completed by a(n) RPA to their Done status>
-- =============================================
CREATE PROCEDURE [dbo].[update_UNST_ZNST_Done_ForRPA] (@Whse_Num varchar(50), @Inv_Num varchar(50))
WITH EXECUTE AS OWNER
AS
BEGIN
	-- Variables for the stored procedure
	DECLARE @strInv_Num varchar(50),
			@rtrnInv_Num varchar(50),
			@chkdoutBit bit,
			@userID varchar(50),
			@strWhse_Num varchar(50) 

			-- Test if passed parameter is null
	IF @Inv_Num IS NULL
		BEGIN
			SELECT 'NO UPDATE TO UNST_ZNST' AS 'Inv Number parameter was Null';
			GOTO FAIL
		END 
	IF @Whse_Num IS NULL
		BEGIN
			SELECT 'NO UPDATE TO UNST_ZNST' AS 'Whse Number parameter was Null';
			GOTO FAIL
		END 

	SET @strInv_Num = @Inv_Num;
	SET @strWhse_Num = @Whse_Num;

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Test that the Inv_Num and Whse_Num combination that was passed can be found
	SELECT @rtrnInv_Num = INVOICE_NUM, @chkdoutBit = CHECKED_OUT, @userID = [OWNER]
	FROM [dbo].[UNST_ZNST]
	WHERE INVOICE_NUM = @strInv_Num AND WHSE = @strWhse_Num;

	IF @rtrnInv_Num IS NULL
		BEGIN
			SELECT 'NO UPDATE TO UNST_ZNST' AS 'Inv_Num and Whse_Num combination that was passed to this procedure could not be found in UNST_ZNST table';
			GOTO FAIL
		END

	-- Test that the UNST hasn't been unlocked by other means

	IF @chkdoutBit = 0
		BEGIN
			SELECT 'NO UPDATE TO UNST_ZNST' AS 'Inv_Num and Whse_Num combination that was passed to this procedure was already checked back in by a separate process';
			GOTO FAIL
		END

	-- Test that the UNST isn't owned by someone else

	IF @userID <> 'AAQ6349'
		BEGIN
			SELECT 'NO UPDATE TO UNST_ZNST' AS 'Inv_Num and Whse_Num combination that was passed to this procedure is checked out by someone else';
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
					FROM [SharedServices].[dbo].[UNST_ZNST]
					WHERE
					(
						INVOICE_NUM = @strInv_Num AND WHSE = @strWhse_Num
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

GRANT EXECUTE ON OBJECT::[dbo].[update_UNST_ZNST_Done_ForRPA]
	TO [DS\FEI-SSC-AR Users] 
GO

