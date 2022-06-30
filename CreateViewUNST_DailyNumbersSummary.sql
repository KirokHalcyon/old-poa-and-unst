USE [SharedServices]
GO

--CREATE VIEW [dbo].[UNST_DailyNumbersSummary]
--AS
SELECT        
  AllAccounts.TrilogieAcctName AS TrilAcctName, 
  ISNULL(SSC_Review.CountOfSSC_ReviewInv, 0) AS CountOfSSC_ReviewInv, 
  ISNULL(SSC_Review.SumOfSSC_ReviewCurrInvBal, 0) AS SumOfSSC_ReviewCurrInvBal, 
  ISNULL(SSC_Review.AvgSSC_ReviewBizDaysOpen, 0) AS AvgSSC_ReviewBizDaysOpen, 
  ISNULL(CM_Review.CountOfCM_ReviewInv, 0) AS CountOfCM_ReviewInv, 
  ISNULL(CM_Review.SumOfCM_ReviewCurrInvBal, 0) 
                         AS SumOfCM_ReviewCurrInvBal, ISNULL(CM_Review.AvgCM_ReviewBizDaysOpen, 0) AS AvgCM_ReviewBizDaysOpen
FROM            
  (SELECT DISTINCT TrilogieAcctName
  FROM
    dbo.UNST_TrilogieAcctNames) AS AllAccounts 
LEFT OUTER JOIN
  (SELECT TrilAcctName, 
          COUNT(InvNum) AS CountOfSSC_ReviewInv, 
          SUM(CurrInvBal) AS SumOfSSC_ReviewCurrInvBal, 
          AVG(BusinessDaysOpen) AS AvgSSC_ReviewBizDaysOpen
  FROM
    dbo.UNST_BasicReporting AS UNST_BasicReporting_2
  WHERE
    (HasTradeOrWriteOffGL_Num = 1) 
      AND (HasPymtNumCMorPA = 1) 
      AND (SSC_Review = 1) 
      AND (CurrStatus NOT IN ('Done', 'Partial')) 
      AND (CheckedOut = 0) 
      AND (Pending = 0)
  GROUP BY TrilAcctName) AS SSC_Review 
ON AllAccounts.TrilogieAcctName = SSC_Review.TrilAcctName 
LEFT OUTER JOIN
  (SELECT TrilAcctName, 
          COUNT(InvNum) AS CountOfCM_ReviewInv, 
          SUM(CurrInvBal) AS SumOfCM_ReviewCurrInvBal, 
          AVG(BusinessDaysOpen) AS AvgCM_ReviewBizDaysOpen
  FROM 
    dbo.UNST_BasicReporting AS UNST_BasicReporting_1
  WHERE 
    (NOT (HasTradeOrWriteOffGL_Num = 1)) 
      AND (CurrStatus NOT IN ('Done', 'Partial')) 
      AND (CheckedOut = 0) 
      AND (Pending = 0) 
    OR
    (CurrStatus NOT IN ('Done', 'Partial')) 
      AND (CheckedOut = 0) 
      AND (Pending = 0) 
      AND (NOT (HasPymtNumCMorPA = 1)) 
    OR
    (CurrStatus NOT IN ('Done', 'Partial')) 
      AND (CheckedOut = 0) 
      AND (Pending = 0) 
      AND (NOT (SSC_Review = 1))
  GROUP BY TrilAcctName) AS CM_Review 
ON AllAccounts.TrilogieAcctName = CM_Review.TrilAcctName

GO
