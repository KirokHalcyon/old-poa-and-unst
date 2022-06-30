USE [SharedServices]
GO  
-- Create procedure to retrieve error information.  
CREATE PROCEDURE [dbo].[usp_GetErrorInfo]  
WITH EXECUTE AS OWNER 
AS  
SELECT  
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage;  

GO

GRANT EXECUTE ON OBJECT::[dbo].[usp_GetErrorInfo]
	TO [DS\FEI-SSC-AR Users] 
GO