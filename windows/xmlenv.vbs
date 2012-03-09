'////////////////////////////////////////////////////////////////////
'/
'/  Name:            xmlenv.vbs
'/  Author:          Miroslav Safr <miroslav.safr@gmail.com>
'/  Web:             https://github.com/safrm/xmlenv
'/  
'/  Description:     multiplatformal/distribution system dumping and comparation 
'/
'////////////////////////////////////////////////////////////////////

Const msiInstallStateNotUsed      = -7
Const msiInstallStateBadConfig    = -6
Const msiInstallStateIncomplete   = -5
Const msiInstallStateSourceAbsent = -4
Const msiInstallStateInvalidArg   = -2
Const msiInstallStateUnknown      = -1
Const msiInstallStateBroken       =  0
Const msiInstallStateAdvertised   =  1
Const msiInstallStateRemoved      =  1
Const msiInstallStateAbsent       =  2
Const msiInstallStateLocal        =  3
Const msiInstallStateSource       =  4
Const msiInstallStateDefault      =  5

Dim installer : Set installer = Nothing
Set installer = Wscript.CreateObject("WindowsInstaller.Installer")

Dim product, products, info, productList, version
Set products = installer.Products

Dim oShell: Set oShell = CreateObject("Wscript.Shell")
Dim oFSO : set oFSO = CreateObject("Scripting.FileSystemObject")
Dim Mappings : Set mappings = CreateObject("Scripting.Dictionary")
Dim g_oSwitches : Set g_oSwitches = CreateObject("Scripting.Dictionary")
g_oSwitches.CompareMode = vbTextcompare ' set case insensitivity for arguments
Dim oNet : Set oNet = CreateObject("Wscript.Network")
logonname = LCase(oNet.userdomain) & "\" & LCase(oNet.UserName)

Dim reroot, clearlist
Dim g_sScriptEngine


' Script Version
g_sVersion = "1.0.3"
g_sComment = ""
g_bCmd_show = false
g_bCmd_dump = false

MakeDesiredHost "cscript.exe"

' Show signon banner
ix = Instr(Wscript.ScriptName, ".")
If ix <> 0 Then s = Left(Wscript.ScriptName, ix - 1) Else s = Wscript.ScriptName
Wscript.Echo s & " version " & g_sVersion & vbCrlf

'Parse Command Line Arguments
ParseArgs

'Validate arguments, check for help request
AssignAndValidateArgs


'////////////////////////////////////////////////////////////////////////////
' Main Code
'
'
If g_bCmd_dump Or g_bCmd_show Then 
	dumppackages
	Wscript.Quit(0)	
End If

'////////////////////////////////////////////////////////////////////////////
' ParseArgs
' Parse the arguments using Split function
'
'
Sub ParseArgs
	Dim pair, list, sArg, Item
	For Each sArg In Wscript.Arguments
		pair = Split(sArg, "=", 2)
	
		'if value is specified multiple times, last one wins
		If g_oSwitches.Exists(Trim(pair(0))) Then
			g_oSwitches.Remove(Trim(pair(0)))
		End If

		If UBound(pair) >= 1 Then
			g_oSwitches.add Trim(pair(0)), Trim(pair(1))
		Else
			g_oSwitches.add Trim(pair(0)),""
		End If
	Next
    	If g_nTraceLevel > 0 Then
    		For each Item in g_oSwitches
    			list = list & Item & "=" & g_oSwitches(Item) &vbNewline
    		Next
    	wscript.echo list
	End If
End Sub

'////////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////////
' AssignAndValidateArgs
' Error check arguments and setup switches
'
'
Sub AssignAndValidateArgs
	' Check for -help, -? etc help request on command line
	If (g_oSwitches.count < 1) Or (g_oSwitches.Exists("help")) Or (g_oSwitches.Exists("/help")) Or (g_oSwitches.Exists("?")) Or (g_oSwitches.Exists("/?")) Then
		ShowHelpMessage
		Wscript.Quit(1)
	End If

  If g_oSwitches.Exists("dump") Then
    g_bCmd_dump = True
  End If

  If g_oSwitches.Exists("show") Then
    g_bCmd_show = True
 	'	wscript.echo "    g_bCmd_show true "
  End If

  If (Not g_bCmd_show and Not g_bCmd_dump) Then
    	  wscript.echo "for now is supported only dump or show feature"
      	Wscript.Quit(1)
  End If

  
  If g_oSwitches.Exists("comment") Then
    g_sComment = g_oSwitches("comment")
  End If

	If ucase(g_oSwitches("reroot")) = "YES" And g_oSwitches("roots") = "" Then
		wscript.echo "If ""reroot=yes"" you must also specify ""roots=<pathname>;<pathname>..."" "
		wscript.quit 1
	End If

	If g_oSwitches("roots") <> "" And ucase(g_oSwitches("reroot")) <> "YES" Then
		wscript.echo """reroot"" does not equal ""YES"", ignoring argument ""roots=" & g_oSwitches("roots") & """"
		wscript.quit 1
	End If

	If UCase(g_oSwitches("clearlist")) = UCase("YES") Then clearlist = true
	If UCase(g_oSwitches("reroot")) = UCase("YES") Then reroot = True

End Sub
'////////////////////////////////////////////////////////////////////////////


'////////////////////////////////////////////////////////////////////////////
' Dump MSI packages
'
'
Sub DumpPackages
	Dim product, products, info, productList, version, InstSource, objNetwork, envvar
	Dim installer4 : Set installer4 = Wscript.CreateObject("WindowsInstaller.Installer")
	Dim fs2 : Set fs2 = CreateObject("Scripting.FileSystemObject")
  'Dim xmlfile : Set xmlfile = fs2.CreateTextFile("pkgversions.xml", true, -1)
  'var ForReading = 1, ForWriting = 2, ForAppending = 8;
  'var TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0;
  'solution without unicode
  
If g_bCmd_dump  Then 
	Dim xmlfile : Set xmlfile = fs2.CreateTextFile("pkgversions.xml", true)
	xmlfile.WriteLine "<?xml version=""1.0"" encoding=""ISO-8859-15""?>" 
End If  

  Set objWMIService = GetObject( "winmgmts://./root/CIMV2" )
  Set objNetwork = CreateObject("WScript.Network")
  userName = objNetwork.UserName
  hostName = objNetwork.ComputerName
  
  Set objProcessor = objWMIService.Get("win32_Processor='CPU0'")
  If objProcessor.Architecture = 0 Then
      archType = "x86"
  ElseIf objProcessor.Architecture = 1 Then
      archType = "MIPS"
  ElseIf objProcessor.Architecture = 2 Then
      archType = "Alpha"
  ElseIf objProcessor.Architecture = 3 Then
      archType = "PowerPC"
  ElseIf objProcessor.Architecture = 6 Then
      archType = "ia64"
  Else
      archType = "not recognized"
  End If
  
  Set colSettings = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")
  For Each objOperatingSystem in colSettings 
      systemName = split(objOperatingSystem.Name , "|")(0)
      systemInfo = objOperatingSystem.Version & " SP:" & objOperatingSystem.ServicePackMajorVersion & "." & objOperatingSystem.ServicePackMinorVersion & " OS:" & objOperatingSystem.SizeStoredInPagingFiles
  Next

	If g_bCmd_show  Then 
    WScript.Echo "type=" & "windows"
    WScript.Echo "systemname=" & systemName
    WScript.Echo "arch=" & archType
    WScript.Echo "info=" & systemInfo
    WScript.Echo "hostname=" & hostName
    WScript.Echo "username=" & userName
    WScript.Echo "managers=" & "msi"
    WScript.Echo "comment=" & g_sComment
  End If
	If g_bCmd_dump  Then 
    xmlfile.WriteLine "<system type=""" & "windows" & """ systemname =""" & systemName & """ arch=""" & archType & """ info=""" & systemInfo   & """ hostname=""" & hostName & """ username=""" & userName & """ pkgmanager= """ & "msi" & """ xmlenv=""" & g_sVersion & """ comment="""& g_sComment & """ >"
    xmlfile.WriteLine "<envvars>"
  End If  
  
	Set wshShell = CreateObject( "WScript.Shell" )
  Set wshUserEnv = wshShell.Environment( "PROCESS" )
  For Each strItem In wshUserEnv
  		envvar = Split(strItem, "=", 2)
    If  Len(envvar(0)) > 0 Then
      If (StrComp(envvar(0), "XMLENV_COMMANDS") = 0) Or (StrComp(envvar(0), "XMLENV_COMMENT") = 0) Then
      
      else
        If g_bCmd_show  Then 
           WScript.Echo strItem
        End If
        If g_bCmd_dump  Then 
          xmlfile.WriteLine  "  <envvar name=""" & envvar(0) & """ value=""" & envvar(1) & """ />"
        End If
      End If
    End If
  Next
  Set wshUserEnv = Nothing
  Set wshShell   = Nothing
 

 'Set objWMIService = GetObject( "winmgmts://./root/CIMV2" )
 'strQuery = "SELECT * FROM Win32_Environment " 
 'Set colItems = objWMIService.ExecQuery( strQuery, "WQL", 48 )

 ' For Each objItem In colItems
    'WScript.Echo "Caption        : " & objItem.Caption
    'WScript.Echo "Description    : " & objItem.Description
    'WScript.Echo "Name           : " & objItem.Name
    'WScript.Echo "Status         : " & objItem.Status
    'WScript.Echo "SystemVariable : " & objItem.SystemVariable
    'WScript.Echo "UserName       : " & objItem.UserName
    'WScript.Echo "VariableValue  : " & objItem.VariableValue
    'WScript.Echo
 '   xmlfile.WriteLine  "  <envvar name=""" & objItem.Name & """ value =""" & objItem.VariableValue & """ />"
 ' Next

Set colItems      = Nothing
Set objWMIService = Nothing

  If g_bCmd_dump  Then 
    xmlfile.WriteLine "</envvars>"
    xmlfile.WriteLine "<packages>"
	End If

	 
	Set products = installer4.Products 
	For Each product In products
		version = DecodeVersion(installer4.ProductInfo(product, "Version")) 
		On Error Resume Next
		InstSource = installer4.ProductInfo(product, "InstallSource")
		If Err <> 0 Then Err.Clear
		info = product & " = " & installer4.ProductInfo(product, "ProductName") & " " & version & " " & InstSource
		If productList <> Empty Then productList = productList & vbNewLine & info Else productList = info
    If g_bCmd_dump  Then 
      xmlfile.WriteLine  "  <package name=""" & installer4.ProductInfo(product, "ProductName") & """ version=""" & version & """ package=""" & installer4.ProductInfo(product, "PackageName") & """ />" 
    End If  
		InstSource=""
	Next
	If productList = Empty Then productList = "No products installed or advertised"
  If g_bCmd_show  Then 
    Wscript.Echo productList
  End If
	Set products = Nothing
  If g_bCmd_dump  Then 
    xmlfile.WriteLine "</packages>"
    xmlfile.WriteLine "</system>"
    xmlfile.Close
  End If
	Wscript.Quit 0
End Sub

'////////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////////
' MakeDesiredHost
' Make the script run in the desired host
'
'
Sub MakeDesiredHost(desiredhost)
	g_sScriptEngine = lcase(mid(WScript.FullName, InstrRev(WScript.FullName,"\")+1))
	Dim oShell : Set oShell = createobject("wscript.shell") 
	comspec = oShell.Environment("Process").Item("COMSPEC")
	If Not g_sScriptEngine=desiredhost Then
		' re-launch script using the desired host
		Set oShell = CreateObject("WScript.Shell")
		Set objArgs = WScript.Arguments
		For I = 0 To objArgs.Count - 1	  
			args = args & " " & objArgs(I)	
		Next
		' uncomment next line for debugging
		'wscript.echo comspec & " /k " & desiredhost & " """ & wscript.scriptfullname & """" & args
		RunCmd = oShell.Run(comspec & " /k " & desiredhost & " """ & wscript.scriptfullname & """" & args, 1, True)
		WScript.Quit
	end if
End Sub
'////////////////////////////////////////////////////////////////////////////


'////////////////////////////////////////////////////////////////////////////
' DecodeVersion
' Decode MSI version string
'
'
Function DecodeVersion(version)
	version = CLng(version)
	DecodeVersion = version\65536\256 & "." & (version\65535 MOD 256) & "." & (version Mod 65536)
End Function

'////////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////////
' ShowHelpMessage
' Display help message
'
Sub ShowHelpMessage
  Wscript.Echo " xmlenv dumps and compare installed programms in MSI source paths" &_
	vbNewLine & " https://github.com/safrm/xmlenv" &_
	vbNewLine & "  MUST BE RUN IN CSCRIPT!" &_
	vbNewLine & " " &_
	vbNewLine & " commands: " &_
	vbNewLine & "   dump - dumps environment to pkgversion.xml file" &_
	vbNewLine & "   show - shows environment on console " &_
	vbNewLine & " parameters:" &_
	vbNewLine & "   comment=<comment>  {not required, empty }" &_
	vbNewLine & "     stores comment to dump system/comment" &_
	vbNewLine & " " &_
	vbNewLine & " " 
End Sub

'////////////////////////////////////////////////////////////////////////////



