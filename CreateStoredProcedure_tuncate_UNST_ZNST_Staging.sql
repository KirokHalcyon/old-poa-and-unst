USE [SharedServices]
GO

-- =============================================
-- Author:		<Aaron Lawrence>
-- Create date: <6/10/2019>
-- Description:	<Truncates the UNST_ZNST_Staging table>
-- =============================================
CREATE PROCEDURE [dbo].[truncate_UNST_ZNST_Staging] 
WITH EXECUTE AS OWNER
AS
BEGIN

	TRUNCATE TABLE [dbo].[UNST_ZNST_Staging];
END;

GO

GRANT EXECUTE ON OBJECT::[dbo].[truncate_UNST_ZNST_Staging]
	TO [DS\FEI-SSC-AR Users] 
GO


