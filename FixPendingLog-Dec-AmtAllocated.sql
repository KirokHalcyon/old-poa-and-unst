--SELECT [POANum]
--      ,[PendingDate]
--      ,[OrigPOA_Amt]
--      ,[CurrPOA_Amt]
--      ,[AmtAllocated]
UPDATE [dbo].[POA_PendingLog]
SET POA_PendingLog.[AmtAllocated] = POA_PendingLog.OrigPOA_Amt - POA_PendingLog.CurrPOA_Amt
FROM POA_PendingLog
WHERE (PendingDate Between '2018-12-01 00:00:00.000' AND '2018-12-31 11:59:59.99') 
    AND OrigPOA_Amt <> CurrPOA_Amt