USE SharedServices
GO

ALTER TABLE [dbo].[POA_BranchAccountInfo]
ADD [Priority] int NULL;
GO

ALTER TABLE [dbo].[POA_BranchAccountInfo]
ADD CONSTRAINT [DF_POA_BranchAccountInfo_Priority]  DEFAULT ((0)) FOR [Priority];
GO

UPDATE [dbo].[POA_BranchAccountInfo]
SET [Priority] = 0;
GO

ALTER TABLE [dbo].[POA_BranchAccountInfo]
ALTER COLUMN [Priority] int NOT NULL;
GO
