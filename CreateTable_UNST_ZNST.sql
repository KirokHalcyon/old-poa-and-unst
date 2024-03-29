USE [SharedServices]
GO

CREATE TABLE [dbo].[UNST_ZNST](
	[WHSE] [varchar](50) NOT NULL,
	[ACCOUNT] [varchar](50) NOT NULL,
	[CUST] [numeric](18, 0) NOT NULL,
	[NAME] [varchar](50) NOT NULL,
	[ORIG_BAL] [decimal](28, 2) NOT NULL,
	[BAL] [decimal](28, 2) NOT NULL,
	[INVOICE_NUM] [varchar](50) NOT NULL,
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
	[CM_STATUS] [varchar](255) NULL,
	[INSERT_DATE] [datetime] NOT NULL,
	[CHECKED_OUT] [bit] NOT NULL,
	[OWNER] [varchar](50) NOT NULL,
	[STATUS] [varchar](50) NOT NULL,
	[PENDING] [bit] NOT NULL,
	[START_DATE] [datetime] NULL,
	[UPDATE_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
 CONSTRAINT [PK_UNST_ZNST] PRIMARY KEY CLUSTERED 
(
	[WHSE] ASC,
	[INVOICE_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UNST_ZNST] ADD  CONSTRAINT [DF_UNST_ZNST_WHSE]  DEFAULT ((0)) FOR [WHSE]
GO

ALTER TABLE [dbo].[UNST_ZNST] ADD  CONSTRAINT [DF_UNST_ZNST_ACCOUNT]  DEFAULT ('#UNKNOWN#') FOR [ACCOUNT]
GO

ALTER TABLE [dbo].[UNST_ZNST] ADD  CONSTRAINT [DF_UNST_ZNST_INSERT_DATE]  DEFAULT (getdate()) FOR [INSERT_DATE]
GO

ALTER TABLE [dbo].[UNST_ZNST] ADD  CONSTRAINT [DF_UNST_ZNST_CHECKED_OUT]  DEFAULT ((0)) FOR [CHECKED_OUT]
GO

ALTER TABLE [dbo].[UNST_ZNST] ADD  CONSTRAINT [DF_UNST_ZNST_OWNER]  DEFAULT ('None') FOR [OWNER]
GO

ALTER TABLE [dbo].[UNST_ZNST] ADD  CONSTRAINT [DF_UNST_ZNST_STATUS]  DEFAULT ('None') FOR [STATUS]
GO

ALTER TABLE [dbo].[UNST_ZNST] ADD  CONSTRAINT [DF_UNST_ZNST_PENDING]  DEFAULT ((0)) FOR [PENDING]
GO


