Public Function SQL_UpdateZNSTLocks(intRows As Integer, strAssoc As String, strTrilAcctNameIN As String, strDayOption As String, Optional ByVal Days As Integer) As Long
'Okay, parameterized queries and IN() statements don't play well together without a lot of effort. So, this might be a
'string-concatenation instead - SAB 9/29/16

    Dim objCnn As ADODB.Connection
    Set objCnn = New ADODB.Connection 'Dont forget your Set statements for Objects!
    
    objCnn.ConnectionString = ConstConnString 'ODBC-less connection string
    
    Dim cmdUpdateZNSTLocks As ADODB.Command
    Set cmdUpdateZNSTLocks = New ADODB.Command
    
    'Parameter definitions
    Dim prmAssoc As ADODB.Parameter
    
    'Set and Create Parameter
    Set prmAssoc = cmdUpdateZNSTLocks.CreateParameter("strAssoc", adVarChar, adParamInput, 50, strAssoc)
    
    Dim iRecAffect As Long
    iRecAffect = 0
    
    objCnn.Open 'Open Connection
    cmdUpdateZNSTLocks.CommandType = adCmdText
    cmdUpdateZNSTLocks.CommandTimeout = GlobalTimeout
    cmdUpdateZNSTLocks.Prepared = True
    cmdUpdateZNSTLocks.ActiveConnection = objCnn
    
    If strDayOption = "N" Then 'User didn't choose to pull a set number of days back
    
        'SQL that updates the "lock" on a "random" set of UNST records = introws that matches the parameters given
        cmdUpdateZNSTLocks.CommandText = "With CTE As " & _
                                         "(SELECT TOP " & intRows & " * FROM ( SELECT * FROM [" & ConstDbName & "].[dbo].[UNST_ZNST] " & _
                                         "WHERE ACCOUNT IN(" & Left(strTrilAcctNameIN, Len(strTrilAcctNameIN) - 1) & ") AND " & _
                                         "(PY_NUMBER LIKE '%PA%' OR PY_NUMBER LIKE '%CM%') AND " & _
                                         "AR_GL_NUM IN('1300', '1322') AND " & _
                                         "CHECKED_OUT = 0 AND STATUS NOT IN('Done','Partial') AND PENDING = 0) AS Rando_Rowisian " & _
                                         "ORDER BY ABS(CAST(BINARY_CHECKSUM(Rando_Rowisian.ACCOUNT, Rando_Rowisian.INVOICE_NUM, NEWID()) as Int)))" & _
                                         "UPDATE CTE SET CHECKED_OUT = 1, OWNER = ?, " & _
                                         "STATUS = 'Started', UPDATE_DATE = getdate(), START_DATE = ISNULL(START_DATE, getdate());"
                
        cmdUpdateZNSTLocks.Parameters.Append prmAssoc
    
    ElseIf strDayOption = "Y" Then 'User elected to choose how many days back to retrieve
            
            'SQL that updates the "lock" on a "random" set of UNST records = introws that matches the parameters given
            cmdUpdateZNSTLocks.CommandText = "With CTE As " & _
                                             "(SELECT TOP " & intRows & " * FROM ( SELECT * FROM [" & ConstDbName & "].[dbo].[UNST_ZNST] " & _
                                             "WHERE ACCOUNT IN(" & Left(strTrilAcctNameIN, Len(strTrilAcctNameIN) - 1) & ") AND " & _
                                             "(PY_NUMBER LIKE '%PA%' OR PY_NUMBER LIKE '%CM%') AND " & _
                                             "AR_GL_NUM IN('1300', '1322') AND " & _
                                             "CHECKED_OUT = 0 AND STATUS NOT IN('Done','Partial') AND PENDING = 0 AND " & _
                                             "(SELECT COUNT(*) AS Expr1 FROM dbo.CalendarDim WHERE (dbo.CalendarDim.Date Between dbo.UNST_ZNST.PROCESS_DATE AND GetDate()) AND " & _
                                             "(dbo.CalendarDim.IsWeekend = 0) AND (dbo.CalendarDim.IsHoliday = 0)) <= " & Days & ") AS Rando_Rowisian " & _
                                             "ORDER BY ABS(CAST(BINARY_CHECKSUM(Rando_Rowisian.ACCOUNT, Rando_Rowisian.INVOICE_NUM, NEWID()) as Int)))" & _
                                             "UPDATE CTE SET CHECKED_OUT = 1, OWNER = ?, " & _
                                             "STATUS = 'Started', UPDATE_DATE = getdate(), START_DATE = ISNULL(START_DATE, getdate());"
                                             
            cmdUpdateZNSTLocks.Parameters.Append prmAssoc
            
    End If
    
    objCnn.BeginTrans 'Starts SQL transaction
    
    cmdUpdateZNSTLocks.Execute iRecAffect 'Executes SQL
    
    If iRecAffect = 0 Then
        objCnn.RollbackTrans 'Rollback the transaction if number of records was none
        SQL_UpdateZNSTLocks = iRecAffect 'set return value for function 0 = bad
    Else
        objCnn.CommitTrans 'Do the thing
        objCnn.Close 'Close connection
        SQL_UpdateZNSTLocks = iRecAffect 'set return value for function non-zero = Good
    End If
        

End Function
Public Function SQL_UpdateZNST()

    'Okay, parameterized queries and IN() statements don't play well together without a lot of effort. So, this might be a
    'string-concatenation instead - SAB 9/29/16
    'Updated by AML 5/4/17
    'Updated again by AML 6/25/19
    
    Dim db As DAO.Database
    Set db = CurrentDb
    
    Dim rst As DAO.Recordset
    Set rst = db.OpenRecordset("ZNST_Temp", dbOpenDynaset)
    
    rst.MoveFirst
    
    If rst.EOF Then 'Um what happened to your Temp table
        MsgBox "You have no records in your workflow. Something catastrophic has happened to your workflow. Contact SPI immediately.", vbCritical, "Critical Fail!"
        Exit Function
    End If
    
    Dim objCnn As ADODB.Connection
    Set objCnn = New ADODB.Connection 'Dont forget your Set statements for Objects!
    
    objCnn.ConnectionString = ConstConnString 'ODBC-less connection string
    'Didn't forget the set statements
    Dim cmdUpdateZNST As ADODB.Command
    Set cmdUpdateZNST = New ADODB.Command
    
    cmdUpdateZNST.CommandType = adCmdText
    cmdUpdateZNST.Prepared = True
    cmdUpdateZNST.CommandTimeout = GlobalTimeout
    
    Dim strInvNum As String
    Dim strAcct As String
    
    strInvNum = "INVALID"
    strAcct = "#UNKNOWN#"
    
    Dim prmInvNum As ADODB.Parameter
    Dim prmAcct As ADODB.Parameter
    
    Set prmInvNum = cmdUpdateZNST.CreateParameter("InvNum", adVarChar, adParamInput, 50, strInvNum)
    Set prmAcct = cmdUpdateZNST.CreateParameter("Acct", adVarChar, adParamInput, 50, strAcct)
    
    cmdUpdateZNST.Parameters.Append prmInvNum
    cmdUpdateZNST.Parameters.Append prmAcct
    
    Dim TotalRecFound As Long
    Dim SumOfRecAffected As Long
    Dim iRecAffect As Long
    iRecAffect = 0
    SumOfRecAffected = 0
    TotalRecFound = 0
    
    objCnn.Open
    objCnn.BeginTrans
    cmdUpdateZNST.ActiveConnection = objCnn
    
    With rst
        Do Until .EOF
            If rst("Done").Value = True And rst("PENDING").Value = False Then 'ZNST Temp = Done so update the Live table to be Done
                TotalRecFound = TotalRecFound + 1
                strInvNum = rst("INVOICE_NUM").Value
                strAcct = rst("ACCOUNT").Value
                cmdUpdateZNST.Parameters("InvNum").Value = strInvNum
                cmdUpdateZNST.Parameters("Acct").Value = strAcct
                cmdUpdateZNST.CommandText = "UPDATE [" & ConstDbName & "].[dbo].[UNST_ZNST] SET CHECKED_OUT = 0, STATUS = 'Done', UPDATE_DATE = GetDate(), END_DATE = GetDate() WHERE INVOICE_NUM = ? AND ACCOUNT = ? ;"
                cmdUpdateZNST.Execute iRecAffect
                SumOfRecAffected = SumOfRecAffected + iRecAffect
            ElseIf rst("Done").Value = False And rst("PENDING").Value = True Then 'ZNST Temp = PENDING so update the Live table to be PENDING
                    TotalRecFound = TotalRecFound + 1
                    strInvNum = rst("INVOICE_NUM").Value
                    strAcct = rst("ACCOUNT").Value
                    cmdUpdateZNST.Parameters("InvNum").Value = strInvNum
                    cmdUpdateZNST.Parameters("Acct").Value = strAcct
                    cmdUpdateZNST.CommandText = "UPDATE [" & ConstDbName & "].[dbo].[UNST_ZNST] SET CHECKED_OUT = 0, STATUS = 'Started', PENDING = 1, UPDATE_DATE = GetDate() WHERE INVOICE_NUM = ? AND ACCOUNT = ? ;"
                    cmdUpdateZNST.Execute iRecAffect
                    SumOfRecAffected = SumOfRecAffected + iRecAffect
                ElseIf rst("Done").Value = False And rst("PENDING").Value = False Then 'ZNST Temp had no changes but update the Live table because you touched it
                        TotalRecFound = TotalRecFound + 1
                        strInvNum = rst("INVOICE_NUM").Value
                        strAcct = rst("ACCOUNT").Value
                        cmdUpdateZNST.Parameters("InvNum").Value = strInvNum
                        cmdUpdateZNST.Parameters("Acct").Value = strAcct
                        cmdUpdateZNST.CommandText = "UPDATE [" & ConstDbName & "].[dbo].[UNST_ZNST] SET CHECKED_OUT = 0, UPDATE_DATE = GetDate() WHERE INVOICE_NUM = ? AND ACCOUNT = ? ;"
                        cmdUpdateZNST.Execute iRecAffect
                        SumOfRecAffected = SumOfRecAffected + iRecAffect
            End If
            .MoveNext
        Loop
    End With
    
    If SumOfRecAffected <> TotalRecFound Then 'OMG WTF some nutso stuff is going on
        objCnn.RollbackTrans
        MsgBox "Records affected mismatch detected! No Records Updated! Contact SPI Immediately!", vbCritical, "Critical Fail!"
        DoCmd.Hourglass (False)
    Else
        objCnn.CommitTrans
        objCnn.Close
    End If

End Function