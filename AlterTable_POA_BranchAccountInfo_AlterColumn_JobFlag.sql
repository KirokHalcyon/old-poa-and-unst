USE SharedServices
GO

ALTER TABLE [dbo].[POA_BranchAccountInfo]
ADD [JobFlag] bit NULL;
GO

ALTER TABLE [dbo].[POA_BranchAccountInfo] 
ADD CONSTRAINT [DF_POA_BranchAccountInfo_JobFlag]  DEFAULT ((0)) FOR [JobFlag];
GO

UPDATE [dbo].[POA_BranchAccountInfo]
SET JobFlag = 0;
GO

UPDATE [dbo].[POA_BranchAccountInfo]
SET JobFlag = 1
WHERE TrilogieAcctName = 'LAKEWOOD';
GO

ALTER TABLE [dbo].[POA_BranchAccountInfo]
ALTER COLUMN [JobFlag] bit NOT NULL;
GO
