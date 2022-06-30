USE SharedServices_DEV
GO

SELECT 
	[WHSE] AS WhseNum
	,[ACCOUNT] AS TrilAcctName 
	,[CUST] AS CustNum
	,[NAME] AS CustName
	,[ORIG_BAL] AS OrigInvBal
	,[BAL] AS CurrInvBal
	,[INVOICE_NUM] AS InvNum
	,[DATE] AS InvDate
	,[PROCESS_DATE] AS InvProcDate
	,[WRITER] AS InvWriter
	,[AR_GL_NUM] AS CustGL_Num
	,IIF([AR GL NUM] IN('1300','1322'), 1, 0) AS HasTradeOrWriteOffGL_Num
	,[ORDCDE] AS OrdCode
	,[SELL_WHSE] AS SellWhse
	,[SHIP_WHSE] AS ShipWhse
	,[JOB] AS Job
	,[SRM] AS SalesMgr
	,[CRED_MGR] AS CredMgr
	,[CRMEMO] AS CM_Num
	,[SHIP_INSTR1] AS ShipInstr1
	,[SHIP_INSTR2] AS ShipInstr2
	,[SHIP_INSTR3] AS ShipInstr3
	,[SHIP_INSTR4] AS ShipInstr4
	,[OML_ASSOC] AS OrdMngmtLogAssocName
	,[CUST_PO] AS CustPO
	,[OML_ASSOC_MAIL] AS OrdMngmtLogAssocEml
	,[OML_SUPER_NAME] AS OrdMngmtLogSuperName
	,[OML_SUPER_MAIL] AS OrdMngmtLogSuperEml
	,[PY_TYPE] AS PymtType
	,[PY_NUMBER] AS PymtNum
	,IIF([PY_NUMBER] LIKE '%PA%' OR [PY_NUMBER] LIKE '%CM%', 1, 0) AS HasPymtNumCMorPA
	,[PY_COMMENT] AS PymtCmnt
	,[PY_AMOUNT] AS PymtAmt
	,[PY_DATE] AS PymtDate
	,[PY_EMPLOYEE_NAME] AS PymtEmpName
	,[CM_STATUS] AS CM_Status
	,[INSERT_DATE] AS InsertDate
	,[CHECKED_OUT] AS CheckedOut
	,[OWNER] AS OwnerID
	,[STATUS] AS CurrStatus
	,[PENDING] AS Pending
	,[START_DATE] AS StartDate
	,[UPDATE_DATE] AS UpdateDate
	,[END_DATE]	AS EndDate
	,(SELECT COUNT(*) AS Expr1 
	  FROM CalendarDim 
	  WHERE (CalendarDim.Date Between PROCESS_DATE AND GetDate()) 
		AND (CalendarDim.IsWeekend = 0) AND (CalendarDim.IsHoliday = 0)) AS BusinessDaysOpen
	,IIF((SELECT COUNT(*) AS Expr1 
		  FROM CalendarDim 
		  WHERE (CalendarDim.Date Between PROCESS_DATE AND GetDate()) 
			AND (CalendarDim.IsWeekend = 0) AND (CalendarDim.IsHoliday = 0)) > 5, 0, 1) AS SSC_Review 
    ,IIF((SELECT COUNT(*) AS Expr1 
		  FROM CalendarDim 
		  WHERE (CalendarDim.Date Between PROCESS_DATE AND GetDate()) 
			AND (CalendarDim.IsWeekend = 0) AND (CalendarDim.IsHoliday = 0)) > 5, 1, 0) AS Branch_Review  
	,DATENAME(year, [END_DATE]) AS UNST_DoneYear 
    ,MONTH([END_DATE]) AS UNST_DoneMonthNum 
    ,DATENAME(month, [END_DATE]) AS UNST_DoneMonth 
    ,DATEPART(wk, [END_DATE]) AS UNST_DoneWeek 
    ,IIF([START_DATE] IS NULL, CAST(GetDate() - [PROCESS_DATE] AS int), 
        IIF([UPDATE_DATE] IS NULL, CAST([START_DATE] - [PROCESS_DATE] AS int), 
            IIF([END_DATE] IS NULL, CAST([UPDATE_DATE] - [START_DATE] AS int), CAST([END_DATE] - [START_DATE] AS int)))) AS DaysSinceLastUpdate 
	,[UNST_BusinessDaysOpenCat] = CASE 
	WHEN (SELECT COUNT(*) AS Expr1 
		  FROM CalendarDim 
		  WHERE (CalendarDim.Date Between PROCESS_DATE AND GetDate()) 
			AND (CalendarDim.IsWeekend = 0) AND (CalendarDim.IsHoliday = 0)) BETWEEN 0 AND 5 THEN '0-5' 
	WHEN (SELECT COUNT(*) AS Expr1 
		  FROM CalendarDim 
		  WHERE (CalendarDim.Date Between PROCESS_DATE AND GetDate()) 
			AND (CalendarDim.IsWeekend = 0) AND (CalendarDim.IsHoliday = 0)) BETWEEN 6 AND 10 THEN '6-10'
	WHEN (SELECT COUNT(*) AS Expr1 
		  FROM CalendarDim 
		  WHERE (CalendarDim.Date Between PROCESS_DATE AND GetDate()) 
			AND (CalendarDim.IsWeekend = 0) AND (CalendarDim.IsHoliday = 0)) BETWEEN 11 AND 15 THEN '11-15'
	WHEN (SELECT COUNT(*) AS Expr1 
		  FROM CalendarDim 
		  WHERE (CalendarDim.Date Between PROCESS_DATE AND GetDate()) 
			AND (CalendarDim.IsWeekend = 0) AND (CalendarDim.IsHoliday = 0)) BETWEEN 16 AND 20 THEN '16-20'
	WHEN (SELECT COUNT(*) AS Expr1 
		  FROM CalendarDim 
		  WHERE (CalendarDim.Date Between PROCESS_DATE AND GetDate()) 
			AND (CalendarDim.IsWeekend = 0) AND (CalendarDim.IsHoliday = 0)) BETWEEN 21 AND 25 THEN '21-25'
	WHEN (SELECT COUNT(*) AS Expr1 
		  FROM CalendarDim 
		  WHERE (CalendarDim.Date Between PROCESS_DATE AND GetDate()) 
			AND (CalendarDim.IsWeekend = 0) AND (CalendarDim.IsHoliday = 0)) BETWEEN 26 AND 30 THEN '26-30'
	WHEN (SELECT COUNT(*) AS Expr1 
		  FROM CalendarDim 
		  WHERE (CalendarDim.Date Between PROCESS_DATE AND GetDate()) 
			AND (CalendarDim.IsWeekend = 0) AND (CalendarDim.IsHoliday = 0)) BETWEEN 31 AND 60 THEN '31-60'
	WHEN (SELECT COUNT(*) AS Expr1 
		  FROM CalendarDim 
		  WHERE (CalendarDim.Date Between PROCESS_DATE AND GetDate()) 
			AND (CalendarDim.IsWeekend = 0) AND (CalendarDim.IsHoliday = 0)) BETWEEN 61 AND 90 THEN '61-90'
	WHEN (SELECT COUNT(*) AS Expr1 
		  FROM CalendarDim 
		  WHERE (CalendarDim.Date Between PROCESS_DATE AND GetDate()) 
			AND (CalendarDim.IsWeekend = 0) AND (CalendarDim.IsHoliday = 0)) BETWEEN 91 AND 180 THEN '91-180'
	WHEN (SELECT COUNT(*) AS Expr1 
		  FROM CalendarDim 
		  WHERE (CalendarDim.Date Between PROCESS_DATE AND GetDate()) 
			AND (CalendarDim.IsWeekend = 0) AND (CalendarDim.IsHoliday = 0)) BETWEEN 181 AND 360 THEN '181-360'
	WHEN (SELECT COUNT(*) AS Expr1 
		  FROM CalendarDim 
		  WHERE (CalendarDim.Date Between PROCESS_DATE AND GetDate()) 
			AND (CalendarDim.IsWeekend = 0) AND (CalendarDim.IsHoliday = 0)) > 360 THEN '>360'
	END
FROM            [dbo].[UNST_ZNST]