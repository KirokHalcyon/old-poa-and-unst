--SELECT TOP 100 * FROM 
--(
    SELECT *, 
    (
        SELECT COUNT(*) AS Expr1 
        FROM dbo.CalendarDim 
        WHERE (dbo.CalendarDim.Date Between dbo.UNST_ZNST.PROCESS_DATE AND GetDate()) AND (dbo.CalendarDim.IsWeekend = 0) AND (dbo.CalendarDim.IsHoliday = 0)
    ) AS DAYS_OPEN
    FROM [dbo].[UNST_ZNST]  
    WHERE 
        --ACCOUNT IN(  Left(strTrilAcctNameIN, Len(strTrilAcctNameIN) - 1)  ) AND  
        (PY_NUMBER LIKE '%PA%' OR PY_NUMBER LIKE '%CM%') AND  
        AR_GL_NUM IN('1300', '1322') AND  
        CHECKED_OUT = 0 AND STATUS NOT IN('Done','Partial') AND PENDING = 0 AND  
        (SELECT COUNT(*) AS Expr1 FROM dbo.CalendarDim WHERE (dbo.CalendarDim.Date Between dbo.UNST_ZNST.PROCESS_DATE AND GetDate()) AND (dbo.CalendarDim.IsWeekend = 0) AND (dbo.CalendarDim.IsHoliday = 0) ) <= 5
--) AS Rando_Rowisian  
--ORDER BY ABS(CAST(BINARY_CHECKSUM(Rando_Rowisian.WHSE, Rando_Rowisian.INVOICE_NUM, NEWID()) as Int)) 
