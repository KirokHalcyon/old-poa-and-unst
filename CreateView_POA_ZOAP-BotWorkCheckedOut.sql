USE [SharedServices]
GO

CREATE VIEW [dbo].[POA_ZOAP-BotWorkCheckedOut]
AS
SELECT        ACCOUNT, CUST#, INVOICE, [POA COMMENTS FUT PAST], DATE, [ORIG POA AMT], [AR BAL NC], [POA BAL], TERMS, INSERT_DATE, CHECKED_OUT, [POA WHSE]
FROM            dbo.POA_ZOAP
WHERE        (CHECKED_OUT = 1) AND (OWNER = 'AAQ6349') AND (PENDING = 0) AND (STATUS NOT IN ('Done', 'Partial'))

GO

