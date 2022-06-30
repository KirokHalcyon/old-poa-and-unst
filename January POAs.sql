USE [SharedServices]
GO

SELECT
	TempTrilUserCalendarDim.TrilAcctName
	,TempTrilUserCalendarDim.FullName
	,TempTrilUserCalendarDim.POA_Year
	,TempTrilUserCalendarDim.POA_MonthNum
	,TempTrilUserCalendarDim.POA_Month
	,TempTrilUserCalendarDim.POA_Week
	,CountOfPendingClicksPOA_Num
	,CountOfDonePOA_Num
	,SumOfEveryPendingCurrPOA_Amt_Clicked
	,SumOfOrigPOA_Amt
FROM
(SELECT 
	TrilAcctName
	,POA_Associates.FullName
	,DATENAME(year, [PendingDate]) AS POA_Year 
	,MONTH([PendingDate]) AS POA_MonthNum 
	,DATENAME(month, [PendingDate]) AS POA_Month 
	,DATEPART(wk, [PendingDate]) AS POA_Week
FROM [dbo].[POA_PendingLog] INNER JOIN POA_Associates ON POA_PendingLog.OwnerID = POA_Associates.UserID
WHERE DATENAME(year, [PendingDate]) = 2018 AND MONTH([PendingDate]) = 2

UNION

SELECT 
	TrilAcctName
	,POA_Associates.FullName
	,POA_DoneYear AS POA_Year
	,POA_DoneMonthNum AS POA_MonthNum 
	,POA_DoneMonth AS POA_Month 
	,POA_DoneWeek AS POA_Week
FROM POA_BasicReporting INNER JOIN POA_Associates ON POA_BasicReporting.OwnerID = POA_Associates.UserID
WHERE POA_DoneYear = 2018 AND POA_DoneMonthNum = 2) AS TempTrilUserCalendarDim

LEFT JOIN 
(SELECT 
       TrilAcctName
      ,POA_Associates.FullName
	  ,DATENAME(year, [PendingDate]) AS POA_PendingYear 
	  ,MONTH([PendingDate]) AS POA_PendingMonthNum 
	  ,DATENAME(month, [PendingDate]) AS POA_PendingMonth 
	  ,DATEPART(wk, [PendingDate]) AS POA_PendingWeek
      ,COUNT([POANum]) AS CountOfPendingClicksPOA_Num
	  ,SUM(CurrPOA_Amt*-1) AS SumOfEveryPendingCurrPOA_Amt_Clicked
  FROM [dbo].[POA_PendingLog] INNER JOIN POA_Associates ON POA_PendingLog.OwnerID = POA_Associates.UserID
  WHERE DATENAME(year, [PendingDate]) = 2018 AND MONTH([PendingDate]) = 2
  GROUP BY TrilAcctName, POA_Associates.FullName, DATENAME(year, [PendingDate]) ,MONTH([PendingDate]) ,DATENAME(month, [PendingDate]) ,DATEPART(wk, [PendingDate]))
  AS POA_PendingSummary 
  ON POA_PendingSummary.TrilAcctName = TempTrilUserCalendarDim.TrilAcctName AND POA_PendingSummary.FullName = TempTrilUserCalendarDim.FullName AND POA_PendingSummary.POA_PendingMonthNum = TempTrilUserCalendarDim.POA_MonthNum AND POA_PendingSummary.POA_PendingWeek = TempTrilUserCalendarDim.POA_Week AND POA_PendingSummary.POA_PendingYear = TempTrilUserCalendarDim.POA_Year
LEFT JOIN
(SELECT 
	 TrilAcctName
	,POA_Associates.FullName
	,POA_DoneYear
	,POA_DoneMonthNum
	,POA_DoneMonth
	,POA_DoneWeek
	,COUNT(POA_Num) AS CountOfDonePOA_Num
	,SUM(OrigPOA_Amt*-1) AS SumOfOrigPOA_Amt
FROM POA_BasicReporting INNER JOIN POA_Associates ON POA_BasicReporting.OwnerID = POA_Associates.UserID
WHERE POA_DoneYear = 2018 AND POA_DoneMonthNum = 2
GROUP BY TrilAcctName, POA_Associates.FullName, POA_DoneYear, POA_DoneMonthNum, POA_DoneMonth, POA_DoneWeek)
AS POA_DoneSummary
ON POA_DoneSummary.TrilAcctName = TempTrilUserCalendarDim.TrilAcctName AND POA_DoneSummary.FullName = TempTrilUserCalendarDim.FullName AND POA_DoneSummary.POA_DoneMonthNum = TempTrilUserCalendarDim.POA_MonthNum AND POA_DoneSummary.POA_DoneWeek = TempTrilUserCalendarDim.POA_Week AND POA_DoneSummary.POA_DoneYear = TempTrilUserCalendarDim.POA_Year

ORDER BY TrilAcctName, FullName, POA_Week

GO