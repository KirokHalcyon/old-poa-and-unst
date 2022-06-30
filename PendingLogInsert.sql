--INSERT INTO [dbo].[POA_PendingLog] ( POANum, TrilAcctName, OwnerID, PendingDate, OrigPOA_Amt, CurrPOA_Amt ) 
SELECT [INVOICE], [ACCOUNT], [OWNER], UPDATE_DATE, [ORIG POA AMT], [POA BAL] 
FROM [dbo].[POA_ZOAP] 
LEFT JOIN [dbo].[POA_PendingLog] 
    ON POA_ZOAP.INVOICE = POA_PendingLog.POANum 
        AND POA_ZOAP.UPDATE_DATE = POA_PendingLog.PendingDate 
WHERE [dbo].[POA_ZOAP].PENDING = 1 
    AND [dbo].[POA_ZOAP].[OWNER] <> 'None' 
    AND AR_GL_NUM <> '1310' 
    AND [dbo].[POA_PendingLog].POANum IS NULL