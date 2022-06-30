USE [SharedServices]
GO

SELECT
[POANum]
,[TrilAcctName]
,[OwnerID]
,[PendingDate]
,[OrigPOA_Amt]
,[CurrPOA_Amt]
,[AmtAllocated]
FROM [dbo].[POA_PendingLog]
WHERE POANum IN(SELECT [POANum] FROM [dbo].[POA_PendingLog] WHERE (PendingDate Between '2018-12-01 00:00:00.000' AND '2018-12-31 11:59:59.999'))
    AND (NOT PendingDate Between '2018-12-01 00:00:00.000' AND '2018-12-31 11:59:59.999') AND OrigPOA_Amt <> CurrPOA_Amt
ORDER BY PendingDate, POANum
GO

