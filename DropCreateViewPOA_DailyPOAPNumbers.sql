USE [SharedServices]
GO

/****** Object:  View [dbo].[POA_DailyPOAPNumbers]    Script Date: 7/18/2019 8:36:25 AM ******/
DROP VIEW [dbo].[POA_DailyPOAPNumbers]
GO

CREATE VIEW [dbo].[POA_DailyPOAPNumbers]
AS
SELECT        POA_Num, TrilAcctName, POA_SOP_Category, OrigPOA_Amt, AR_Bal, CurrPOA_Amt, HasComments, BusinessDayToday, WeekDayNameToday
FROM            dbo.POA_BasicReporting
WHERE        (Pending = 0) AND (CheckedOut = 0) AND (AR_GL_Num <> '1310') AND (CurrStatus NOT IN ('Done', 'Partial')) AND (POA_SOP_Count = 1) AND (HasComments = 1)

GO
