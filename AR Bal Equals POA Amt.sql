SELECT 
ACCOUNT AS TrilAcctName, 
COUNT(INVOICE) AS POA_Count, 
SUM(IIF([AR BAL NC] = [ORIG POA AMT], 1, 0)) AS SumOfAR_Bal_et_OrigPOA_Amt,
SUM(IIF([AR BAL NC] = [POA BAL], 1, 0)) AS SumOfAR_Bal_et_CurrPOA_Amt,
CAST(SUM(IIF([AR BAL NC] = [ORIG POA AMT], 1, 0)) AS decimal)/CAST(COUNT(INVOICE) AS decimal) AS PercOfAR_Bal_et_OrigPOA_Amt,
CAST(SUM(IIF([AR BAL NC] = [POA BAL], 1, 0)) AS decimal)/CAST(COUNT(INVOICE) AS decimal) AS PercOfAR_Bal_et_CurrPOA_Amt,
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
FROM POA_ZOAP
INNER JOIN CalendarDim ON CalendarDim.Date = POA_ZOAP.[DATE]
WHERE [Year] = 2018 AND [Month] IN('1','2','3','4','5')
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