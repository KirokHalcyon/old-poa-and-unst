USE [SharedServices_DEV]
GO

UPDATE [dbo].[POA_PendingLog]
   SET POA_PendingLog.[AmtAllocated] = POA_ZOAP.[POA BAL] - POA_PendingLog.CurrPOA_Amt
   FROM POA_PendingLog INNER JOIN POA_ZOAP ON POA_PendingLog.POANum = POA_ZOAP.INVOICE AND POA_PendingLog.PendingDate = POA_ZOAP.UPDATE_DATE 
 WHERE 
	POA_ZOAP.PENDING = 1
GO


