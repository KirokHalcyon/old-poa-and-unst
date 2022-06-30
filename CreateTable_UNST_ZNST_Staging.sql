USE [SharedServices]
GO

CREATE TABLE [dbo].[UNST_ZNST_Staging](
	[WHSE] [varchar](50) NULL,
	[CUST] [numeric](18, 0) NOT NULL,
	[NAME] [varchar](50) NOT NULL,
	[BAL] [decimal](28, 2) NOT NULL,
	[INVOICE_NUM] [varchar](50) NULL,
	[DATE] [date] NOT NULL,
	[PROCESS_DATE] [date] NULL,
	[WRITER] [varchar](10) NULL,
	[AR_GL_NUM] [varchar](50) NOT NULL,
	[ORDCDE] [varchar](10) NULL,
	[SELL_WHSE] [varchar](50) NULL,
	[SHIP_WHSE] [varchar](50) NULL,
	[JOB] [varchar](1) NULL,
	[SRM] [varchar](1) NULL,
	[CRED_MGR] [varchar](50) NULL,
	[CRMEMO] [varchar](255) NULL,
	[SHIP_INSTR1] [varchar](50) NULL,
	[SHIP_INSTR2] [varchar](50) NULL,
	[SHIP_INSTR3] [varchar](50) NULL,
	[SHIP_INSTR4] [varchar](50) NULL,
	[OML_ASSOC] [varchar](50) NULL,
	[CUST_PO] [varchar](50) NULL,
	[OML_ASSOC_MAIL] [varchar](50) NULL,
	[OML_SUPER_NAME] [varchar](50) NULL,
	[OML_SUPER_MAIL] [varchar](50) NULL,
	[PY_TYPE] [varchar](255) NULL,
	[PY_NUMBER] [varchar](255) NULL,
	[PY_COMMENT] [varchar](255) NULL,
	[PY_AMOUNT] [varchar](255) NULL,
	[PY_DATE] [varchar](255) NULL,
	[PY_EMPLOYEE_NAME] [varchar](255) NULL,
	[CM_STATUS] [varchar](255) NULL
) ON [PRIMARY]

GO
