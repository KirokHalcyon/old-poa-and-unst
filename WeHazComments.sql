SELECT 
ACCOUNT AS TrilAcctName, 
COUNT(INVOICE) AS POA_Count, 
SUM(IIF([POA COMMENTS FUT PAST] IS NOT NULL, 1, 0)) AS SumOfHasComments,
SUM(IIF([POA COMMENTS FUT PAST] IS NULL, 1, 0)) AS SumOfNoComments,
CAST(SUM(IIF([POA COMMENTS FUT PAST] IS NOT NULL, 1, 0)) AS decimal)/CAST(COUNT(INVOICE) AS decimal) AS PercOfHasComments,
CAST(SUM(IIF([POA COMMENTS FUT PAST] IS NULL, 1, 0)) AS decimal)/CAST(COUNT(INVOICE) AS decimal) AS PercOfNoComments,
[Month],
[FiscalMonth],
[MonthName],
[Quarter],
[FiscalQuarter],
[QuarterName],
[FiscalQuarterName],
[Year],
[FiscalYear],
[MMYYYY],
[FiscalMMYYYY],
[MonthYear], 
SUM([ORIG POA AMT]) AS SumOfOrigPOA_Amt,  
SUM([POA BAL]) AS SumOfCurrPOA_Amt  
FROM POA_ZOAP
INNER JOIN CalendarDim ON CalendarDim.Date = POA_ZOAP.[DATE]
WHERE [Year] = 2018 AND [Month] IN('1','2','3','4')
GROUP BY 
ACCOUNT, 
[Month],
[FiscalMonth],
[MonthName],
[Quarter],
[FiscalQuarter],
[QuarterName],
[FiscalQuarterName],
[Year],
[FiscalYear],
[MMYYYY],
[FiscalMMYYYY],
[MonthYear]
ORDER BY TrilAcctName, MMYYYY