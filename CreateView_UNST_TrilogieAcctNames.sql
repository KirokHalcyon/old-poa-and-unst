USE [SharedServices]
GO

DROP VIEW [dbo].[UNST_TrilogieAcctNames]
GO

CREATE VIEW [dbo].[UNST_TrilogieAcctNames]
AS
SELECT         LTRIM(RTRIM(TrilogieAcctName)) AS TrilogieAcctName
FROM            dbo.POA_BranchAccountInfo
WHERE        (RunUNST = 1)
ORDER BY TrilogieAcctName

GO