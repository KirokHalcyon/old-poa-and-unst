				SELECT TOP 100 * 
				FROM 
				(
					SELECT * 
					FROM [SharedServices].[dbo].[POA_ZOAP]
					WHERE
					(  
						(	
							-- Exception Path
							-- Some of these are redundant, consider reducing
							[POA COMMENTS FUT PAST] NOT LIKE '%REMIT%' 
							AND [POA COMMENTS FUT PAST] NOT LIKE '%WILL POST%' 
							AND [POA COMMENTS FUT PAST] NOT LIKE '%WILL APPLY%'
							AND [POA COMMENTS FUT PAST] NOT LIKE '%CHECK FOLDER%'
							AND [POA COMMENTS FUT PAST] NOT LIKE '%BACK-UP%'
							AND [POA COMMENTS FUT PAST] NOT LIKE '%MOVE%'
							AND [POA COMMENTS FUT PAST] NOT LIKE '%TRANSFER%'
							AND [POA COMMENTS FUT PAST] NOT LIKE '%BALANCE LESS%'
							AND [POA COMMENTS FUT PAST] NOT LIKE '%LESS%'
							AND [POA COMMENTS FUT PAST] NOT LIKE '%MAIN JOBS%'
							AND [POA COMMENTS FUT PAST] NOT LIKE '%BID%'
							AND [POA COMMENTS FUT PAST] NOT LIKE '%NET%'
							AND [POA COMMENTS FUT PAST] <> 'BRANCH'
							AND [POA COMMENTS FUT PAST] IS NOT NULL
							AND [POA COMMENTS FUT PAST] NOT LIKE '%[B][0-9]%'
							AND [POA COMMENTS FUT PAST] NOT LIKE '%[CA][0-9]%'
							AND [POA COMMENTS FUT PAST] NOT LIKE '%[CS][0-9]%'
							AND [POA COMMENTS FUT PAST] NOT LIKE '%[CT][0-9]%'
							AND [POA COMMENTS FUT PAST] NOT LIKE '%[CN][0-9]%'
							AND [POA COMMENTS FUT PAST] NOT LIKE '%[CW][0-9]%'
							AND TERMS <> 'COD'
							AND ([POA BAL] <> [AR BAL NC] AND  [AR BAL NC] <> [ORIG POA AMT])
							AND LEN([POA COMMENTS FUT PAST]) > 4
						)
						AND
						(
							( -- Happy Path 1
								[AR BAL NC] = 0
							)
							OR
							( -- Happy Path 2
								[POA COMMENTS FUT PAST] LIKE '%PAID ON ACCOUNT%'
								OR [POA COMMENTS FUT PAST] LIKE '%PAYMENT ON ACCOUNT%'
								OR [POA COMMENTS FUT PAST] LIKE '%PAY BALANCE FORWARD%'
								OR [POA COMMENTS FUT PAST] LIKE '%PAYING OLD INVOICES%' 
								OR [POA COMMENTS FUT PAST] LIKE '%OLDEST INVOICES ON ACCOUNT%'
								OR [POA COMMENTS FUT PAST] LIKE '%PAYING CURRENT%'
							)
							OR
							( -- Happy Path 3 which is just the exception path again
								[POA COMMENTS FUT PAST] NOT LIKE '%REMIT%' 
								AND [POA COMMENTS FUT PAST] NOT LIKE '%WILL POST%' 
								AND [POA COMMENTS FUT PAST] NOT LIKE '%WILL APPLY%'
								AND [POA COMMENTS FUT PAST] NOT LIKE '%CHECK FOLDER%'
								AND [POA COMMENTS FUT PAST] NOT LIKE '%BACK-UP%'
								AND [POA COMMENTS FUT PAST] NOT LIKE '%MOVE%'
								AND [POA COMMENTS FUT PAST] NOT LIKE '%TRANSFER%'
								AND [POA COMMENTS FUT PAST] NOT LIKE '%BALANCE LESS%'
								AND [POA COMMENTS FUT PAST] NOT LIKE '%LESS%'
								AND [POA COMMENTS FUT PAST] NOT LIKE '%MAIN JOBS%'
								AND [POA COMMENTS FUT PAST] NOT LIKE '%BID%'
								AND [POA COMMENTS FUT PAST] NOT LIKE '%NET%'
								AND [POA COMMENTS FUT PAST] <> 'BRANCH'
								AND [POA COMMENTS FUT PAST] IS NOT NULL
								AND [POA COMMENTS FUT PAST] NOT LIKE '%[B][0-9]%'
								AND [POA COMMENTS FUT PAST] NOT LIKE '%[CA][0-9]%'
								AND [POA COMMENTS FUT PAST] NOT LIKE '%[CS][0-9]%'
								AND [POA COMMENTS FUT PAST] NOT LIKE '%[CT][0-9]%'
								AND [POA COMMENTS FUT PAST] NOT LIKE '%[CN][0-9]%'
								AND [POA COMMENTS FUT PAST] NOT LIKE '%[CW][0-9]%'
								AND TERMS <> 'COD'
								AND ([POA BAL] <> [AR BAL NC] AND  [AR BAL NC] <> [ORIG POA AMT])
								AND LEN([POA COMMENTS FUT PAST]) > 4
							)
						)
					)
					--AND
					--(   -- Excluding POA records that are currently checked out, done, partial and set for pending
					--	CHECKED_OUT = 0 
					--	AND [STATUS] NOT IN('Done','Partial') 
					--	AND PENDING = 0 
					--	AND OWNER <> @UserID
					--)
				) AS RPA
			ORDER BY [DATE] DESC
			