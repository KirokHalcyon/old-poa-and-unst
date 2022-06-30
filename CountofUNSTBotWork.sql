SELECT COUNT(*) 
				FROM 
				(
					SELECT * 
					FROM [SharedServices].[dbo].[UNST_ZNST]
					WHERE
					(  
						(	
							-- Exception Path
							AR_GL_NUM IN('1300','1322') -- THE EXCEL MACRO ONLY SHOWS THESE TWO GL NUMBERS TO AN ASSOCIATE
							AND PY_NUMBER IS NOT NULL   -- THIS REALLY NEEDS TO BE HERE AS THE BOT IS RELIANT ON PY NUMBER INFO BEING PRESENT
							AND
								(-- THE SPREADSHEET MACRO ONLY SHOWS PY_NUMBERS THAT HAVE PA OR CM IN THEM
									PY_NUMBER LIKE '%PA%'
									OR
									PY_NUMBER LIKE '%CM%'
								)-- THE SPREADSHEET MACRO ALSO TRIES TO FILTER ON ALL OF THE SHIP INSTR
								 -- BUT THE BOT DOESN'T CARE ABOUT THOSE COLUMNS
							-- UNST REPORT DOES NOT CONTAIN A TERM COLUMN ALL RECORDS ARE ASSUMED TO BE TERMS = COD AS PART OF THE CODE FOR THE UNST TRILOGIE REPORT
						)
						AND
						(
							( -- Happy Path 1
							  -- PY_AMOUNT IS NOT STORED AS NUMERIC AND CAN'T BE STORED THAT WAY
							  -- THIS MAY NOT WORK
							  -- WILL HAVE TO CAST BAL AS VARCHAR
								CAST(BAL AS varchar(255)) = PY_AMOUNT
								AND PY_NUMBER NOT LIKE '%|%'
							)
							OR
							( -- Happy Path 2
								PY_AMOUNT IS NULL
								AND PY_NUMBER NOT LIKE '%|%'
							)
							OR
							( -- Happy Path 3 
								PY_NUMBER LIKE '%|%'
								AND 
									(PY_AMOUNT IS NULL
									OR PY_AMOUNT LIKE '%|%')
							)
							 -- Happy Path 4 is identical to 3 except for how the bot handles the ones where the sum of PY Amounts equals BAL
						)
					)
					AND
					(   -- Excluding UNST records that are currently checked out, done, partial, set for pending and already owned by the bot
						CHECKED_OUT = 0 
						AND [STATUS] NOT IN('Done','Partial') 
						AND PENDING = 0 
						AND [OWNER] <> RIGHT(CURRENT_USER, 7)
					)
				) AS RPA;