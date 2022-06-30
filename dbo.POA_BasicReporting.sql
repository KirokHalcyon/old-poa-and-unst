CREATE VIEW dbo.POA_BasicReporting
AS
SELECT	[INVOICE] AS POA_Num, 
		[ACCOUNT] AS TrilAcctName, 
		IIF([POA COMMENTS FUT PAST] IS NOT NULL, 1, 0) AS HasComments, 
		[DATE] AS POA_Date, 
		DATENAME(year, [DATE]) AS POA_DateYear, 
		MONTH([DATE]) AS POA_DateMonthNum, 
		DATENAME(month, [DATE]) AS POA_DateMonth, 
		DATEPART(wk, [DATE]) AS POA_DateWeek, 
		IIF([END_DATE] IS NULL, 
		CAST(GetDate() - [DATE] AS int), 
		CAST([END_DATE] - [DATE] AS int)) AS TotalAgeInDays, 
		[ORIG POA AMT] AS OrigPOA_Amt, 
		[AR BAL NC] AS AR_Bal, 
		[POA BAL] AS CurrPOA_Amt, 
		IIF([ORIG POA AMT] = [POA BAL], 'Full', 'Partial') AS FullOrPartial, 
		[INSERT_DATE] AS InsertDate, 
        [AR_GL_NUM] AS AR_GL_Num, 
		[CHECKED_OUT] AS CheckedOut, 
		[OWNER] AS OwnerID, 
		[STATUS] AS CurrStatus, 
		[PENDING] AS Pending, 
		[START_DATE] AS StartDate, 
		[UPDATE_DATE] AS UpdateDate, 
		[END_DATE] AS EndDate, 
		(SELECT BusinessDayOfMonth FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) AS BusinessDayToday,
		(SELECT WeekDayName FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) AS WeekDayNameToday,
        DATENAME(year, [END_DATE]) AS POA_DoneYear, 
		MONTH([END_DATE]) AS POA_DoneMonthNum, 
		DATENAME(month, [END_DATE]) AS POA_DoneMonth, 
		DATEPART(wk, [END_DATE]) AS POA_DoneWeek, 
        IIF([START_DATE] IS NULL, 
			CAST(GetDate() - [DATE] AS int), 
			IIF([UPDATE_DATE] IS NULL, 
				CAST([START_DATE] - [DATE] AS int), 
				IIF([END_DATE] IS NULL, 
					CAST([UPDATE_DATE] - [START_DATE] AS int), 
					CAST([END_DATE] - [START_DATE] AS int)))) AS DaysSinceLastUpdate, 
		IIF(DATEDIFF(d, [DATE], CAST(GetDate() AS DATE)) <= 3, 1, 0) AS ThreeDaysOldOrLess, 
		IIF(DATEDIFF(d, [DATE], CAST(GetDate() AS DATE)) <= 5, 1, 0) AS FiveDaysOldOrLess, 
		IIF([DATE] BETWEEN DATEFROMPARTS(Year(GetDate()), Month(GetDate()), 1) AND GetDate(), 1, 0) AS ThisMonth, 
		IIF([DATE] BETWEEN DATEFROMPARTS(Year(DateAdd(m, - 1, GetDate())), Month(DateAdd(m, - 1, GetDate())), 1) AND DateAdd(d, - 1, DATEFROMPARTS(Year(GetDate()), Month(GetDate()), 1)), 1, 0) AS LastMonth, 
		IIF([DATE] < DATEFROMPARTS(Year(DateAdd(m, - 1, GetDate())), Month(DateAdd(m, - 1, GetDate())), 1), 1, 0) AS Older, 
		[POA_SOP_Count] = CASE 
			WHEN (SELECT BusinessDayOfMonth FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) = 1 OR (SELECT BusinessDayOfMonth FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) = 2 
			THEN IIF([DATE] BETWEEN DATEFROMPARTS(Year(DateAdd(m, - 1, GetDate())), Month(DateAdd(m, - 1, GetDate())), 1) AND GetDate(), 1, 0) 
			WHEN (SELECT BusinessDayOfMonth FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) BETWEEN 3 AND 10 
			THEN IIF([DATE] BETWEEN DATEFROMPARTS(Year(GetDate()), Month(GetDate()), 1) AND GetDate(), 1, 0) 
			WHEN (SELECT BusinessDayOfMonth FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) > 10 AND ((SELECT WeekDayName FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) = 'Monday' OR (SELECT WeekDayName FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) = 'Tuesday' OR (SELECT WeekDayName FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) = 'Wednesday') 
			THEN IIF([DATE] BETWEEN DATEFROMPARTS(Year(DateAdd(d, - 5, GetDate())), Month(DateAdd(d, - 5, GetDate())), Day(DateAdd(d, - 5, GetDate()))) AND GetDate(), 1, 0) 
			WHEN (SELECT BusinessDayOfMonth FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) > 10 
			THEN IIF([DATE] BETWEEN DATEFROMPARTS(Year(DateAdd(d, - 3, GetDate())), Month(DateAdd(d, - 3, GetDate())), Day(DateAdd(d, - 3, GetDate()))) AND GetDate(), 1, 0) 
			END, 
        [POA_SOP_Category] = CASE 
			WHEN (SELECT BusinessDayOfMonth FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) = 1 OR (SELECT BusinessDayOfMonth FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) = 2 
			THEN IIF([DATE] BETWEEN DATEFROMPARTS(Year(DateAdd(m, - 1, GetDate())), Month(DateAdd(m, - 1, GetDate())), 1) AND GetDate(), '1st or 2nd', NULL) 
			WHEN (SELECT BusinessDayOfMonth FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) BETWEEN 3 AND 10 
			THEN IIF([DATE] BETWEEN DATEFROMPARTS(Year(GetDate()), Month(GetDate()), 1) AND GetDate(), '3rd to 10th', NULL) 
			WHEN (SELECT BusinessDayOfMonth FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) > 10 AND ((SELECT WeekDayName FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) = 'Monday' OR (SELECT WeekDayName FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) = 'Tuesday' OR (SELECT WeekDayName FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) = 'Wednesday') 
			THEN IIF([DATE] BETWEEN DATEFROMPARTS(Year(DateAdd(d, - 5, GetDate())), Month(DateAdd(d, - 5, GetDate())), Day(DateAdd(d, - 5, GetDate()))) AND GetDate(), '>10th And 1st Half of Week', NULL) 
			WHEN (SELECT BusinessDayOfMonth FROM CalendarDim WHERE [Date] = CAST(GetDate() AS date)) > 10 
			THEN IIF([DATE] BETWEEN DATEFROMPARTS(Year(DateAdd(d, - 3, GetDate())), Month(DateAdd(d, - 3, GetDate())), Day(DateAdd(d, - 3, GetDate()))) AND GetDate(), '>10th', NULL) 
			END
FROM            [dbo].[POA_ZOAP]
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[5] 4[5] 2[58] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 29
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'POA_BasicReporting';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'POA_BasicReporting';

