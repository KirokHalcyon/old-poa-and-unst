ALTER VIEW [dbo].[POA_DailyPOAPNumbers]
AS
SELECT        POA_Num, TrilAcctName, POA_SOP_Category, OrigPOA_Amt, AR_Bal, CurrPOA_Amt, HasComments, BusinessDayToday, WeekDayNameToday, CalendarDay
FROM            dbo.POA_BasicReporting
WHERE        (Pending = 0) AND (CheckedOut = 0) AND (AR_GL_Num <> '1310') AND (CurrStatus <> 'Done') AND (POA_SOP_Count = 1)