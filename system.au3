#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Icon=bin\s-main.ico
#AutoIt3Wrapper_Outfile=system.x86.exe
#AutoIt3Wrapper_Outfile_x64=system.x64.exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=System control panel and tools for system engineers, created by AutoIt3
#AutoIt3Wrapper_Res_Description=SYSTEM   v2.4.07.30   Ultimate Edition
#AutoIt3Wrapper_Res_Fileversion=2.4.8.11
#AutoIt3Wrapper_Res_ProductName=SYSTEM
#AutoIt3Wrapper_Res_ProductVersion=2.4.08.11
#AutoIt3Wrapper_Res_CompanyName=László Kártik - Senior IT System Engineer
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2024, László Kártik
#AutoIt3Wrapper_Res_LegalTradeMarks=SYSTEM ™ SINCE 2019
#AutoIt3Wrapper_Res_Language=1038
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_Field=Website|"https://github.com/lacikartik88"
#AutoIt3Wrapper_Res_Field=Comment|"System control panel and tools for system engineers, created by AutoIt3"
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; Info: http://www.autoitscript.com/autoit3/scite/docs/AutoIt3Wrapper.htm
; Icons added to the resources can be used with TraySetIcon(@ScriptFullPath, -5) etc. and are stored with numbers -5, -6...

#include <Array.au3>
#include <AutoItConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <DateTimeConstants.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <FontConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiComboBox.au3>
#include <GUIComboBoxEx.au3>
#include <GUIButton.au3>
#include <GUIImageList.au3>
#include <GUIListView.au3>
#include <GUIMenu.au3>
#include <IE.au3>
#include <ListViewConstants.au3>
#include <Process.au3>
#include <StaticConstants.au3>
#include <WinAPI.au3>
#include <WinAPISys.au3>
#include <WinAPIsysinfoConstants.au3>
#include <WindowsConstants.au3>

Init()

Func Init()
	; define laod screen gui
	Global $initGUI
	$initGUI = GUICreate("", 320, 60, -1, -1, $WS_POPUP, -1)
	GUISetFont(8, $FW_MEDIUM, "", "Comic Sans Ms", $initGUI, $CLEARTYPE_QUALITY)
	;WinSetTrans($initGUI, "", 250)
	GUISetBkColor(0x2D2D2D)
	GUICtrlSetDefColor(0xFFFFFF, $initGUI)
	GUICtrlSetDefBkColor(0x2D2D2D, $initGUI)

	; show gui, define progress
	GUISetState(@SW_SHOW, $initGUI)
	$iProgress = GUICtrlCreateProgress(10, 10, 300, 25, -1, -1)

	; *** step 1: define variables
	GUICtrlCreateLabel("Define variables...                               ", 10, 35, -1, -1)
	GUICtrlSetData($iProgress, "10")
	Sleep(10)

	; define main gui vars
	Global $mainGUI, $icon, $back, $iExit, $iCAT, $iCP, $iS, $iPS, $iCMD, $iAdd, $iRem, $bExit, $bCAT, $bCP, $bS, $bPS, $bCMD, $bAdd, $bRem ; theme variables
	Global $rCategory[16], $rName[256], $rExecutable[256], $rRun[256], $ext = "*.exe; *.cmd; *.html"  ; create menu system
	Global $i = 0, $j = 0, $k = 0, $l = 0, $m = 0, $n = 0, $p = 0, $q = 0; sequence variables
	Global $aCategory[16] = ["BOOT", "DEV", "EDUCATION", "FILE_MANAGE", "MEDIA_AUDIO", "MEDIA_PICTURE", "MEDIA_VIDEO", "NETWORK", "OFFICE", "SECURITY", "UTILITY"] ; for category folder creation
	Global $aInfo, $aInfoDAT[32], $aInfoDB[32] = ["Host Name", "OS Name", "OS Version", "OS Manufacturer", "OS Configuration", "OS Build Type", "System Boot Time", _
	"System Manufacturer", "System Model", "System Type", "BIOS Version", "Processor(s)", "Boot Device", "Page File Location(s)", "System Locale", _
	"Time Zone", "Domain", "Logon Server", "Hotfix(s)", "Total Physical Memory", "Available Physical Memory", "Drive Space Total", "Drive Space Used", "Drive Space Free", _
	"Drive Space Used In Percent", "Drive Space Free In Percent", "IP Address 1", "IP Address 2", "IP Address 3", "IP Address 4"] ; system informations for reading, writing and gui
	Global $dLabel, $dProgress, $dPercent, $dTotal, $dFree ; disk space variables
	Global $7z ; package management - majd később
	Global $AddGUI, $RemGUI, $bOK, $bCA, $bBR, $cPathOr, $cPathMo, $cCat, $cNameOr, $cNameMo, $cFod ; add or remove application

	; set directories
	Global $appD = @ScriptDir & "\apps" ; applications directory
	Global $binD = @ScriptDir & "\bin" ; binaries directory
	Global $trashD = @ScriptDir & "\trash" ; trash directory
	; define configurations files
	Global $cfg = $binD & "\config.ini" ; setup application main config file
	Global $info = $binD & "\sysinfo.ini" ; system information config file
	Global $7z = $binD & "\7z.exe" ; package

	; delete old menu system from $cfg
	IniDelete($cfg, "SYSTEM")
	IniDelete($cfg, "Info")
	IniDelete($cfg, "Categories")
	IniDelete($cfg, "Applications")
	IniDelete($cfg, "rCategory")
	IniDelete($cfg, "rName")
	IniDelete($cfg, "rExecutable")
	IniDelete($cfg, "rShellExecute")

	; define head
	Global $sysName, $n, $v, $e
	$n = "SYSTEM"
	$v = "v2.4.08.11"
	$e = "Ultimate Edition   (developer: Kártik László - Senior IT System Engineer)"
	$sysName = $n & "    " & $v & "    " & $e
	BinaryToString(IniWrite($cfg, $n, "Name", $n), $SB_ANSI)
	BinaryToString(IniWrite($cfg, $n, "Version", $v), $SB_ANSI)
	BinaryToString(IniWrite($cfg, $n, "Edition", $e), $SB_ANSI)

	; *** step 2: discover envinroments
	GUICtrlCreateLabel("Discover envinroments...                          ", 10, 35, -1, -1)
	GUICtrlSetData($iProgress, "20")
	Sleep(1)

	; run systeminfo in cmd
	SysInfo()

	; *** step 3: write data to info file
	GUICtrlCreateLabel("Writing data to files...                          ", 10, 35, -1, -1)
	GUICtrlSetData($iProgress, "30")
	Sleep(1)

	InfoWrite()

	; *** step 4: setting up themes
	GUICtrlCreateLabel("Setting up theme files...                         ", 10, 35, -1, -1)
	GUICtrlSetData($iProgress, "40")
	Sleep(10)

	; define theme variables
	Global $icon = $binD & "\s-main.ico"
	Global $back = $binD & "\s-back.jpg" ; 1200 x 600
	Global $back2 = $binD & "\s-matrix.mp4" ; -1, -1, 1200, 600 if 1080p resolution video file
	Global $iExit = $binD & "\s-exit.ico"
	Global $iCAT = $binD & "\s-cat.ico"
	Global $iCP = $binD & "\s-control.ico"
	Global $iS = $binD & "\s-settings.ico"
	Global $iPS = $binD & "\s-powershell.ico"
	Global $iCMD = $binD & "\s-cmd.ico"
	Global $iAdd = $binD & "\s-add.ico"
	Global $iRem = $binD & "\s-remove.ico"

	; *** step 5: creating menu structure
	GUICtrlCreateLabel("Creating menu structure...                        ", 10, 35, -1, -1)
	GUICtrlSetData($iProgress, "60")
	Sleep(20)

	; generating data
	ScanFolders()
	GenData()

	; *** step 6: done
	GUICtrlCreateLabel("Done...                                           ", 10, 35, -1, -1)
	GUICtrlSetData($iProgress, "100")
	; wait 0.10s
	Sleep(10)

	; delete gui and run main gui
	GUIDelete($initGUI)
	Main()
EndFunc		;==>Init

Func GenData()
	; generate data
	_ArrayDelete($rCategory, 16) ; reset array
	Global $i = "", $j = 0, $k = "", $l = 0, $m = "", $n = 0 ; sequence variables
	Global $o = 0, $p = 0, $q = 0 ; sequence variables
	; $i = value of $rCategory | $k = value of $rName | $m = value of $rExecutable
	; $j, $l, $n, $o, $p, $q = counters
	$rCategory = _FileListToArray($appD, "*", $FLTA_FOLDERS, False)
	For $i In $rCategory
		If IsString($i) Then
			; IniWrite($cfg, "rCategory", $j, $i)
			$rName = _FileListToArray($appD & "\" & $i, "*", $FLTA_FOLDERS, False)
			$j += 1
			If IsArray($rName) Then
				For $k In $rName
					If IsString($k) Then
						; IniWrite($cfg, $i, $l, $k)
						$rExecutable = _FileListToArrayRec($appD & "\" & $i & "\" & $k, $ext, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
						$l += 1
						If IsArray($rExecutable) Then
							For $m In $rExecutable
								If IsString($m) Then
									; IniWrite($cfg, $k, $n, $m)
									BinaryToString(IniWrite($cfg, "Categories", $o, $i), $SB_ANSI)
									BinaryToString(IniWrite($cfg, "Applications", $p, $i & "\" & $k), $SB_ANSI)
									BinaryToString(IniWrite($cfg, "rCategory", "$rCategory[" & $o & "]", "GUICtrlCreateMenu(" & '"' & $i & '"' & ")"), $SB_ANSI)
									BinaryToString(IniWrite($cfg, "rName", "$rName[" & $p & "]", "GUICtrlCreateMenu(" & '"' & $k & '"' & ", $rCategory[" & $o & "])"), $SB_ANSI)
									BinaryToString(IniWrite($cfg, "rExecutable", "$rExecutable[" & $q & "]", "GUICtrlCreateMenuItem(" & '"' & $m & '"' & ", $rName[" & $p & "])"), $SB_ANSI)
									BinaryToString(IniWrite($cfg, "rShellExecute", $q, $appD & "\" & $i & "\" & $k & "\" & $m), $SB_ANSI)
									$n += 1
									$q += 1
								Else
								EndIf
							Next
							$n = 0
							$p += 1
						Else
						EndIf
					Else
					EndIf
				Next
				$l = 0
				$o += 1
			Else
			EndIf
		Else
		EndIf
	Next
	Global $i = 0 ; sequence variables
	For $i = 0 To 255 Step 1
		$rRun[$i] = BinaryToString(IniRead($cfg, "rShellExecute", $i, ""), $SB_ANSI)
	Next
EndFunc		;==>GenData

Func ScanFolders()
	; generate data
	Global $i = 0 ; sequence variables

	; reading to variables
	For $i = 0 To 15 Step 1
		If BinaryToString(IniRead($cfg, "Categories", $i, ""), $SB_ANSI) <> "" Then $aCategory[$i] = BinaryToString(IniRead($cfg, "Categories", $i, ""), $SB_ANSI)
	Next
	Global $i = 0 ; reset sequence variables

	; check folders and create
	For $i = 0 To 15 Step 1
		If FileExists($appD & "\" & $aCategory[$i]) = False Then DirCreate($appD & "\" & $aCategory[$i])
	Next
	Global $i = 0 ; reset sequence variables
EndFunc		;==>ScanFolders

Func SysInfo()
	; querry informations of machine and write to file
	FileDelete($info)
	_RunDos("systeminfo /s \\" & @ComputerName & " /fo list > " & $info)
EndFunc		;==>SysInfo

Func InfoWrite()
	; generate data
	Global $i = 0 ; sequence variables

	; reading and converting information from $info
	$aInfo = BinaryToString(FileRead($info), $SB_ANSI)
	$aInfo = StringStripWS($aInfo, $STR_STRIPSPACES)
	$aInfo = StringReplace($aInfo, ": ", "=")
	$aInfo = StringReplace($aInfo, "˙", "")
	$aInfo = StringReplace($aInfo, ".,", ",")
	$aInfo = StringReplace($aInfo, "Physical Memory ", "Physical Memory=")
	$aInfo = StringReplace($aInfo, "Virtual Memory=", "Virtual Memory ")
	$aInfo = StringReplace($aInfo, "Installed." & @CR & "[01]=", "Installed: ")
	$aInfo = StringReplace($aInfo, @CR & "[02]=", ", ")
	$aInfo = StringReplace($aInfo, @CR & "[03]=", ", ")
	$aInfo = StringReplace($aInfo, @CR & "[04]=", ", ")
	$aInfo = StringReplace($aInfo, @CR & "[05]=", ", ")
	$aInfo = StringLeft($aInfo, StringInStr($aInfo, "Network Card(s)") - 1)
	If StringInStr($aInfo, "[06]") = True Then $aInfo = StringLeft($aInfo, StringInStr($aInfo, "[06]") - 1)
	$aInfo = StringReplace($aInfo, "displayed." & @CR, "displayed.")
	$dTotal = DriveSpaceTotal(@ScriptDir)
	$dFree = DriveSpaceFree(@ScriptDir)
	$dPercent = $dFree / $dTotal * 100
	$dPercent = 100 - $dPercent

	; writing information to $info
	FileOpen($info, $FO_OVERWRITE)
	BinaryToString(FileWrite($info, "[systeminfo]" & @CR & $aInfo), $SB_ANSI)
	BinaryToString(FileWrite($info, "Drive Space Total=" & StringFormat("%.1f", ($dTotal / 1024)) & " GB" & @CR), $SB_ANSI)
	BinaryToString(FileWrite($info, "Drive Space Used=" & StringFormat("%.1f", (($dTotal - $dFree) / 1024)) & " GB" & @CR), $SB_ANSI)
	BinaryToString(FileWrite($info, "Drive Space Free=" & StringFormat("%.1f", ($dFree / 1024)) & " GB" & @CR), $SB_ANSI)
	BinaryToString(FileWrite($info, "Drive Space Used In Percent=" & StringFormat("%.1f", $dPercent) & " %" & @CR), $SB_ANSI)
	BinaryToString(FileWrite($info, "Drive Space Free In Percent=" & StringFormat("%.1f", ("100" - $dPercent)) & " %" & @CR), $SB_ANSI)
	BinaryToString(FileWrite($info, "IP Address 1=" & @IPAddress1 & @CR), $SB_ANSI)
	BinaryToString(FileWrite($info, "IP Address 2=" & @IPAddress2 & @CR), $SB_ANSI)
	BinaryToString(FileWrite($info, "IP Address 3=" & @IPAddress3 & @CR), $SB_ANSI)
	BinaryToString(FileWrite($info, "IP Address 4=" & @IPAddress4 & @CR), $SB_ANSI)
	FileClose($info)

	; read $info file to variables
	For $i = 0 To 29 Step 1
		$aInfoDAT[$i] = BinaryToString(IniRead($info, "systeminfo", $aInfoDB[$i], ""), $SB_ANSI)
	Next
	Global $i = 0 ; reset sequence variables

	; write variables to $cfg
	For $i = 0 To 29 Step 1
		BinaryToString(IniWrite($cfg, "Info", $aInfoDB[$i], $aInfoDAT[$i]), $SB_ANSI)
	Next
	Global $i = 0 ; reset sequence variables
EndFunc		;==>InfoWrite

Func InfoDisplay()
	; generate data
	Global $i = 0 ; sequence variables
	Global $n = 10, $o = 20, $p = 150, $q = 20 ; sequence variables

	; create info bars
	GUICtrlCreateGroup("", 5, 5, 580, 535)
	GUICtrlCreateGroup("", 590, 5, 440, 535)

	If StringLen($aInfoDAT[18]) = 100 Then
		StringReplace($aInfoDAT[18], StringLeft($aInfoDAT[18], 100), @CR)
	EndIf

	; create labels 1st row
	For $i = 0 To 25 Step 1
		GUICtrlSetBkColor(GUICtrlCreateLabel($aInfoDB[$i], $n, $o), $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetBkColor(GUICtrlCreateLabel($aInfoDAT[$i], $p, $q), $GUI_BKCOLOR_TRANSPARENT)
		$o += 20
		$q += 20
	Next
	Global $i = 0 ; reset sequence variables
	Global $n = 600, $o = 20, $p = 710, $q = 20 ; reset sequence variables

	; create labels 2nd row
	For $i = 26 To 29 Step 1
		GUICtrlSetBkColor(GUICtrlCreateLabel($aInfoDB[$i], $n, $o), $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetBkColor(GUICtrlCreateLabel($aInfoDAT[$i], $p, $q), $GUI_BKCOLOR_TRANSPARENT)
		$o += 20
		$q += 20
	Next
	Global $i = 0 ; reset sequence variables
	Global $n = 0, $o = 0, $p = 0, $q = 0 ; reset sequence variables

	; create free disk space bar
	GUICtrlCreateGroup("", 5, 540, 1190, 34)
	$dLabel = GUICtrlCreateLabel("Free disk space: ", 10, 552, -1, 16)
	GUICtrlSetBkColor($dLabel, $GUI_BKCOLOR_TRANSPARENT)
	$dProgress = GUICtrlCreateProgress(100, 555, 1090, 10, -1, -1)
	GUICtrlSetData($dProgress, $dPercent)
EndFunc		;==>InfoDisplay

Func ButtonDisplay()
	; create button group
	GUICtrlCreateGroup("", 1035, 5, 160, 535)

	; Control Admintools button
	$bCAT = GUICtrlCreateButton("  " & "Felügyeleti eszközök", 1040, 25, 150, 50, $BS_ICON)
	GUICtrlSetImage($bCAT, $iCAT, "", 2)
	GUICtrlSetCursor($bCAT, 0)
	GUICtrlSetStyle($bCAT, $BS_LEFT)

	; Control Panel button
	$bCP = GUICtrlCreateButton("  " & "Vezérlőpult", 1040, 85, 150, 50, $BS_ICON)
	GUICtrlSetImage($bCP, $iCP, "", 2)
	GUICtrlSetCursor($bCP, 0)
	GUICtrlSetStyle($bCP, $BS_LEFT)

	; Settings button
	$bS = GUICtrlCreateButton("  " & "Gépház", 1040, 145, 150, 50, $BS_ICON)
	GUICtrlSetImage($bS, $iS, "", 2)
	GUICtrlSetCursor($bS, 0)
	GUICtrlSetStyle($bS, $BS_LEFT)

	; PowerShell button
	$bPS = GUICtrlCreateButton("  " & "PowerShell", 1040, 205, 150, 50, $BS_ICON)
	GUICtrlSetImage($bPS, $iPS, "", 2)
	GUICtrlSetCursor($bPS, 0)
	GUICtrlSetStyle($bPS, $BS_LEFT)

	; CMD button
	$bCMD = GUICtrlCreateButton("  " & "CMD", 1040, 265, 150, 50, $BS_ICON)
	GUICtrlSetImage($bCMD, $iCMD, "", 2)
	GUICtrlSetCursor($bCMD, 0)
	GUICtrlSetStyle($bCMD, $BS_LEFT)

	; Add program
	$bAdd = GUICtrlCreateButton("  " & "Alkalmazás hozzáadása", 1040, 325, 150, 50, $BS_ICON)
	GUICtrlSetImage($bAdd, $iAdd, "", 2)
	GUICtrlSetCursor($bAdd, 0)
	GUICtrlSetStyle($bAdd, $BS_LEFT)
	GUICtrlSetTip($bAdd, "A program újraindításával jár!")

	; Remove program
	$bRem = GUICtrlCreateButton("  " & "Alkalmazás törlése", 1040, 385, 150, 50, $BS_ICON)
	GUICtrlSetImage($bRem, $iRem, "", 2)
	GUICtrlSetCursor($bRem, 0)
	GUICtrlSetStyle($bRem, $BS_LEFT)
	GUICtrlSetTip($bRem, "A program újraindításával jár!")

	; Exit button
	$bExit = GUICtrlCreateButton("  " & "Kilépés", 1040, 475, 150, 50, $BS_ICON)
	GUICtrlSetImage($bExit, $iExit, "", 2)
	GUICtrlSetCursor($bExit, 0)
	GUICtrlSetStyle($bExit, $BS_LEFT)
EndFunc		;==>ButtonDisplay

Func MenuDisplay()
	; generating data for menu
	Global $rCategory[16], $rName[256], $rExecutable[256] ; reset variables for create menu system
	Global $i = 0, $j = 0, $k = 0, $l = 0, $m = 0, $n = 0 ; sequence variables

	; reading menu category data from $cfg - menu
	For $i = 0 To 15 Step 1
		If IniRead($cfg, "rCategory", "$rCategory[" & $i & "]", "") <> "" Then
			$rCategory[$i] = IniRead($cfg, "rCategory", "$rCategory[" & $i & "]", "")
			$rCategory[$i] = BinaryToString($rCategory[$i], $SB_ANSI)
			; create menu
			If $rCategory[$i] <> "" Then $rCategory[$i] = Execute($rCategory[$i])
		Else
		EndIf
	Next

	; reading menu program name data from $cfg - menuitem
	For $j = 0 To 225 Step 1
		If IniRead($cfg, "rName", "$rName[" & $j & "]", "") <> "" Then
			$rName[$j] = IniRead($cfg, "rName", "$rName[" & $j & "]", "")
			$rName[$j] = BinaryToString($rName[$j], $SB_ANSI)
			; create menuitems
			If $rName[$j] <> "" Then $rName[$j] = Execute($rName[$j])
		Else
		EndIf
	Next

	; reading menu program path data from $cfg - submenuitem
	For $k = 0 To 255 Step 1
		If IniRead($cfg, "rExecutable", "$rExecutable[" & $k & "]", "") <> "" Then
			$rExecutable[$k] = IniRead($cfg, "rExecutable", "$rExecutable[" & $k & "]", "")
			$rExecutable[$k] = BinaryToString($rExecutable[$k], $SB_ANSI)
			; create submenuitems
			If $rExecutable[$k] <> "" Then $rExecutable[$k] = Execute($rExecutable[$k])
		Else
		EndIf
	Next
EndFunc		;==>MenuDisplay

Func PickDisplay()
	GUICtrlCreatePic($back, 0, 0, 1200, 600, $BS_BITMAP) ; create background from iamge
EndFunc		;==>PickDisplay

Func VideoDisplay()
	$oMP = ObjCreate("WMPlayer.OCX") ; create background from video
	GUICtrlCreateObj($oMP, -1, -1, 1200, 600)
	With $oMP
		.FullScreen = True
		.WindowlessVideo = True
		.StretchToFit = True
		.EnableContextMenu = False
		.Enabled = True
		.UIMode = "none" ; full / none / mini full
		.Settings.AutoStart = True
		.Settings.Mute = True ;
		.Settings.Volume = 0 ; 0 - 100
		.Settings.Balance = 0 ; -100 to 100
		.Settings.Repeat = True
		.URL = $back2 ; $back2 is an existing file
	EndWith
EndFunc		;==>VideoDisplay

Func AddBR()
	$cFod = FileSelectFolder("Alkalmazás hozzáadása", "", "", @ScriptDir, $AddGUI)
	GUICtrlSetData($cPathOr, $cFod)
EndFunc		;==>AddBR

Func AddApp()
	; read data
	$cPathOr = GUICtrlRead($cPathOr)
	$cCat = GUICtrlRead($cCat)
	$cPathMo = $cPathOr

	; modulate data
	For $i = 0 To 256 Step 1
		If StringInStr($cPathMo, "\") = True Then $cPathMo = StringTrimLeft($cPathMo, StringInStr($cPathMo, "\"))
	Next
	Global $i = 0 ; reset sequence variables

	; run dos
	_RunDos("MD " & $appD & "\"  & $cCat & "\" & $cPathMo & '"')
	_RunDos("XCOPY " & '"' & $cPathOr & '"' & " " & '"' & $appD & "\" & $cCat & "\" & $cPathMo & '"')

	; error check
	if @error Then
		MsgBox(16, "Error", "Alkalmazást nem sikerült hozzáadni!" & @CRLF & "A program újraindul!", 1, $RemGUI)
	Else
		MsgBox(64, "Info", "Alkalmazást sikerült hozzáadni!" & @CRLF & "A program újraindul!", 1, $RemGUI)
	EndIf
EndFunc		;==>AddApp

Func AddAppGUI()
	$AddGUI = GUICreate("Alkalmazás hozzáadása a menühöz", 600, 100, -1, -1, -1, -1, 0)
	GUISetFont(8, $FW_MEDIUM, "", "Comic Sans Ms", $AddGUI, $CLEARTYPE_QUALITY)
	GUISetBkColor(0x2D2D2D)
	GUICtrlSetDefColor(0xFFFFFF, $AddGUI)
	GUICtrlSetDefBkColor(0x2D2D2D, $AddGUI)

	; create controls
	GUICtrlCreateGroup("", 5, 5, 590, 90)
	GUICtrlSetBkColor(GUICtrlCreateLabel("Alkalmazás útvonala: ", 15, 15), $GUI_BKCOLOR_TRANSPARENT)
	$cPathOr = GUICtrlCreateInput("", 200, 15, 290, 20)
	GUICtrlSetBkColor(GUICtrlCreateLabel("Hozzáadás kategóriához: ", 15, 50), $GUI_BKCOLOR_TRANSPARENT)
	$cCat = GUICtrlCreateCombo("", 140, 50, 350, 25)

	GUICtrlSetData($cCat, $aCategory[0] & "|" & $aCategory[1] & "|" & $aCategory[2] & "|" & $aCategory[3] & "|" & _
	$aCategory[4] & "|" & $aCategory[5] & "|" & $aCategory[6] & "|" & $aCategory[7] & "|" & _
	$aCategory[8] & "|" & $aCategory[9] & "|" & $aCategory[10] & "|" & $aCategory[11] & "|" & _
	$aCategory[12] & "|" & $aCategory[13] & "|" & $aCategory[14] & "|" & $aCategory[15], " ")

	$bBR = GUICtrlCreateButton(" ... ", 140, 15, 50, 20)
	GUICtrlSetCursor($bBR, 0)
	GUICtrlSetStyle($bBR, $BS_CENTER)

	$bOK = GUICtrlCreateButton("Mentés", 500, 15, 90, 20)
	GUICtrlSetCursor($bOK, 0)
	GUICtrlSetStyle($bOK, $BS_CENTER)

	$bCA = GUICtrlCreateButton("Mégse", 500, 52, 90, 20)
	GUICtrlSetCursor($bCA, 0)
	GUICtrlSetStyle($bCA, $BS_CENTER)

	GUISetState(@SW_SHOW, $AddGUI)
	While - 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $bCA ; exit
				GUIDelete($AddGUI)
				ExitLoop
			Case $bBR ; save
				AddBR()
			Case $bOK ; browse
				AddApp()
				GUIDelete($AddGUI)
				ExitLoop
		EndSwitch
	WEnd
EndFunc		;==>AddAppGUI

Func RemApp()
	;read data
	$cNameOr = GUICtrlRead($cNameOr)
	$cNameMo = $cNameOr

	; modulate data
	For $i = 0 To 256 Step 1
		If StringInStr($cNameMo, "\") = True Then $cNameMo = StringTrimLeft($cNameMo, StringInStr($cNameMo, "\"))
	Next
	Global $i = 0 ; reset sequence variables

	; run dos
	_RunDos("MOVE " & '"' & $appD & "\" & $cNameOr & '"' & " " & '"' & $trashD & "\"  & $cNameMo & '"')

	; error check
	if @error Then
		MsgBox(16, "Error", "Alkalmazást nem sikerült törölni!" & @CRLF & "A program újraindul!", 1, $RemGUI)
	Else
		MsgBox(64, "Info", "Alkalmazás a lomtárba került!" & @CRLF & "A program újraindul!", 1, $RemGUI)
	EndIf
EndFunc		;==>RemApp

Func RemAppGUI()
	$RemGUI = GUICreate("Alaklmazás eltávolítása a menüből", 600, 600, -1, -1, -1, -1, 0)
	GUISetFont(8, $FW_MEDIUM, "", "Comic Sans Ms", $RemGUI, $CLEARTYPE_QUALITY)
	GUISetBkColor(0x2D2D2D)
	GUICtrlSetDefColor(0xFFFFFF, $RemGUI)
	GUICtrlSetDefBkColor(0x2D2D2D, $RemGUI)

	; create controls
	GUICtrlCreateGroup("", 5, 5, 590, 590)
	GUICtrlSetBkColor(GUICtrlCreateLabel("Alkalmazás kiválasztása: ", 15, 15), $GUI_BKCOLOR_TRANSPARENT)
	$cNameOr = GUICtrlCreateList("", 140, 15, 350, 590)

	Global $i = 0 ; reset sequence variables
	For $i = 0 To 255 Step 1
		If BinaryToString(IniRead($cfg, "Applications", $i, ""), $SB_ANSI) <> "" Then GUICtrlSetData($cNameOr, BinaryToString(IniRead($cfg, "Applications", $i, ""), $SB_ANSI))
	Next

	$bOK = GUICtrlCreateButton("Törlés", 500, 15, 90, 20)
	GUICtrlSetCursor($bOK, 0)
	GUICtrlSetStyle($bOK, $BS_CENTER)

	$bCA = GUICtrlCreateButton("Mégse", 500, 52, 90, 20)
	GUICtrlSetCursor($bCA, 0)
	GUICtrlSetStyle($bCA, $BS_CENTER)

	GUISetState(@SW_SHOW, $RemGUI)
	While - 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $bCA ; exit
				GUIDelete($RemGUI)
				ExitLoop
			Case $bOK ; browse
				RemApp()
				GUIDelete($RemGUI)
				ExitLoop
		EndSwitch
	WEnd
EndFunc		;==>RemAppGUI

Func Main()
	; delete old guis
	GUIDelete($initGUI)
	GUIDelete($mainGUI)

	; define gui
	Global $mainGUI = GUICreate($sysName, 1200, 600, -1, -1, -1, -1, 0)
	GUISetIcon($icon, 0)
	GUISetFont(8, $FW_MEDIUM, "", "Comic Sans Ms", $mainGUI, $CLEARTYPE_QUALITY)
	WinSetTrans($mainGUI, "", 250)
	GUISetBkColor(0x2D2D2D)
	GUICtrlSetDefColor(0xFFFFFF, $mainGUI)
	GUICtrlSetDefBkColor(0x2D2D2D, $mainGUI)

	; create background
	PickDisplay()
	;VideoDisplay()

	; create info
	InfoDisplay()

	; create buttons
	ButtonDisplay()

	; create menu
	MenuDisplay()

	; show gui
	GUISetState(@SW_SHOW, $mainGUI)
EndFunc		;==>mGUI

Func RunMenu()

EndFunc		;==>RunMenu

; *** SYSTEM CORE ***
While - 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE, $bExit ; exit
			GUIDelete($mainGUI)
			ExitLoop

		; open Control AdminTools
		Case $bCAT
			Run("control admintools")
		; open Control Panel
		Case $bCP
			Run("control")
		; open Settings
		Case $bS
			ShellExecute("ms-settings://")
		; open PowerShell
		Case $bPS
			Run("powershell")
		; open CMD
		Case $bCMD
			Run("cmd")
		; add program
		Case $bAdd
			AddAppGUI()
			GUIDelete($mainGUI)
			Init()
		; remove program
		Case $bRem
			RemAppGUI()
			GUIDelete($mainGUI)
			Init()

		; menu array
		Case $rExecutable[0]
			If $rRun[0] <> "" Then ShellExecute($rRun[0])
		Case $rExecutable[1]
			If $rRun[1] <> "" Then ShellExecute($rRun[1])
		Case $rExecutable[2]
			If $rRun[2] <> "" Then ShellExecute($rRun[2])
		Case $rExecutable[3]
			If $rRun[3] <> "" Then ShellExecute($rRun[3])
		Case $rExecutable[4]
			If $rRun[4] <> "" Then ShellExecute($rRun[4])
		Case $rExecutable[5]
			If $rRun[5] <> "" Then ShellExecute($rRun[5])
		Case $rExecutable[6]
			If $rRun[6] <> "" Then ShellExecute($rRun[6])
		Case $rExecutable[7]
			If $rRun[7] <> "" Then ShellExecute($rRun[7])
		Case $rExecutable[8]
			If $rRun[8] <> "" Then ShellExecute($rRun[8])
		Case $rExecutable[9]
			If $rRun[9] <> "" Then ShellExecute($rRun[9])
		Case $rExecutable[10]
			If $rRun[10] <> "" Then ShellExecute($rRun[10])
		Case $rExecutable[11]
			If $rRun[11] <> "" Then ShellExecute($rRun[11])
		Case $rExecutable[12]
			If $rRun[12] <> "" Then ShellExecute($rRun[12])
		Case $rExecutable[13]
			If $rRun[13] <> "" Then ShellExecute($rRun[13])
		Case $rExecutable[14]
			If $rRun[14] <> "" Then ShellExecute($rRun[14])
		Case $rExecutable[15]
			If $rRun[15] <> "" Then ShellExecute($rRun[15])
		Case $rExecutable[16]
			If $rRun[16] <> "" Then ShellExecute($rRun[16])
		Case $rExecutable[17]
			If $rRun[17] <> "" Then ShellExecute($rRun[17])
		Case $rExecutable[18]
			If $rRun[18] <> "" Then ShellExecute($rRun[18])
		Case $rExecutable[19]
			If $rRun[19] <> "" Then ShellExecute($rRun[19])
		Case $rExecutable[20]
			If $rRun[20] <> "" Then ShellExecute($rRun[20])
		Case $rExecutable[21]
			If $rRun[21] <> "" Then ShellExecute($rRun[21])
		Case $rExecutable[22]
			If $rRun[22] <> "" Then ShellExecute($rRun[22])
		Case $rExecutable[23]
			If $rRun[23] <> "" Then ShellExecute($rRun[23])
		Case $rExecutable[24]
			If $rRun[24] <> "" Then ShellExecute($rRun[24])
		Case $rExecutable[25]
			If $rRun[25] <> "" Then ShellExecute($rRun[25])
		Case $rExecutable[26]
			If $rRun[26] <> "" Then ShellExecute($rRun[26])
		Case $rExecutable[27]
			If $rRun[27] <> "" Then ShellExecute($rRun[27])
		Case $rExecutable[28]
			If $rRun[28] <> "" Then ShellExecute($rRun[28])
		Case $rExecutable[29]
			If $rRun[29] <> "" Then ShellExecute($rRun[29])
		Case $rExecutable[30]
			If $rRun[30] <> "" Then ShellExecute($rRun[30])
		Case $rExecutable[31]
			If $rRun[31] <> "" Then ShellExecute($rRun[31])
		Case $rExecutable[32]
			If $rRun[32] <> "" Then ShellExecute($rRun[32])
		Case $rExecutable[33]
			If $rRun[33] <> "" Then ShellExecute($rRun[33])
		Case $rExecutable[34]
			If $rRun[34] <> "" Then ShellExecute($rRun[34])
		Case $rExecutable[35]
			If $rRun[35] <> "" Then ShellExecute($rRun[35])
		Case $rExecutable[36]
			If $rRun[36] <> "" Then ShellExecute($rRun[36])
		Case $rExecutable[37]
			If $rRun[37] <> "" Then ShellExecute($rRun[37])
		Case $rExecutable[38]
			If $rRun[38] <> "" Then ShellExecute($rRun[38])
		Case $rExecutable[39]
			If $rRun[39] <> "" Then ShellExecute($rRun[39])
		Case $rExecutable[40]
			If $rRun[40] <> "" Then ShellExecute($rRun[40])
		Case $rExecutable[41]
			If $rRun[41] <> "" Then ShellExecute($rRun[41])
		Case $rExecutable[42]
			If $rRun[42] <> "" Then ShellExecute($rRun[42])
		Case $rExecutable[43]
			If $rRun[43] <> "" Then ShellExecute($rRun[43])
		Case $rExecutable[44]
			If $rRun[44] <> "" Then ShellExecute($rRun[44])
		Case $rExecutable[45]
			If $rRun[45] <> "" Then ShellExecute($rRun[45])
		Case $rExecutable[46]
			If $rRun[46] <> "" Then ShellExecute($rRun[46])
		Case $rExecutable[47]
			If $rRun[47] <> "" Then ShellExecute($rRun[47])
		Case $rExecutable[48]
			If $rRun[48] <> "" Then ShellExecute($rRun[48])
		Case $rExecutable[49]
			If $rRun[49] <> "" Then ShellExecute($rRun[49])
		Case $rExecutable[50]
			If $rRun[50] <> "" Then ShellExecute($rRun[50])
		Case $rExecutable[51]
			If $rRun[51] <> "" Then ShellExecute($rRun[51])
		Case $rExecutable[52]
			If $rRun[52] <> "" Then ShellExecute($rRun[52])
		Case $rExecutable[53]
			If $rRun[53] <> "" Then ShellExecute($rRun[53])
		Case $rExecutable[54]
			If $rRun[54] <> "" Then ShellExecute($rRun[54])
		Case $rExecutable[55]
			If $rRun[55] <> "" Then ShellExecute($rRun[55])
		Case $rExecutable[56]
			If $rRun[56] <> "" Then ShellExecute($rRun[56])
		Case $rExecutable[57]
			If $rRun[57] <> "" Then ShellExecute($rRun[57])
		Case $rExecutable[58]
			If $rRun[58] <> "" Then ShellExecute($rRun[58])
		Case $rExecutable[59]
			If $rRun[59] <> "" Then ShellExecute($rRun[59])
		Case $rExecutable[60]
			If $rRun[60] <> "" Then ShellExecute($rRun[60])
		Case $rExecutable[61]
			If $rRun[61] <> "" Then ShellExecute($rRun[61])
		Case $rExecutable[62]
			If $rRun[62] <> "" Then ShellExecute($rRun[62])
		Case $rExecutable[63]
			If $rRun[63] <> "" Then ShellExecute($rRun[63])
		Case $rExecutable[64]
			If $rRun[64] <> "" Then ShellExecute($rRun[64])
		Case $rExecutable[65]
			If $rRun[65] <> "" Then ShellExecute($rRun[65])
		Case $rExecutable[66]
			If $rRun[66] <> "" Then ShellExecute($rRun[66])
		Case $rExecutable[67]
			If $rRun[67] <> "" Then ShellExecute($rRun[67])
		Case $rExecutable[68]
			If $rRun[68] <> "" Then ShellExecute($rRun[68])
		Case $rExecutable[69]
			If $rRun[69] <> "" Then ShellExecute($rRun[69])
		Case $rExecutable[70]
			If $rRun[70] <> "" Then ShellExecute($rRun[70])
		Case $rExecutable[71]
			If $rRun[71] <> "" Then ShellExecute($rRun[71])
		Case $rExecutable[72]
			If $rRun[72] <> "" Then ShellExecute($rRun[72])
		Case $rExecutable[73]
			If $rRun[73] <> "" Then ShellExecute($rRun[73])
		Case $rExecutable[74]
			If $rRun[74] <> "" Then ShellExecute($rRun[74])
		Case $rExecutable[75]
			If $rRun[75] <> "" Then ShellExecute($rRun[75])
		Case $rExecutable[76]
			If $rRun[76] <> "" Then ShellExecute($rRun[76])
		Case $rExecutable[77]
			If $rRun[77] <> "" Then ShellExecute($rRun[77])
		Case $rExecutable[78]
			If $rRun[78] <> "" Then ShellExecute($rRun[78])
		Case $rExecutable[79]
			If $rRun[79] <> "" Then ShellExecute($rRun[79])
		Case $rExecutable[80]
			If $rRun[80] <> "" Then ShellExecute($rRun[80])
		Case $rExecutable[81]
			If $rRun[81] <> "" Then ShellExecute($rRun[81])
		Case $rExecutable[82]
			If $rRun[82] <> "" Then ShellExecute($rRun[82])
		Case $rExecutable[83]
			If $rRun[83] <> "" Then ShellExecute($rRun[83])
		Case $rExecutable[84]
			If $rRun[84] <> "" Then ShellExecute($rRun[84])
		Case $rExecutable[85]
			If $rRun[85] <> "" Then ShellExecute($rRun[85])
		Case $rExecutable[86]
			If $rRun[86] <> "" Then ShellExecute($rRun[86])
		Case $rExecutable[87]
			If $rRun[87] <> "" Then ShellExecute($rRun[87])
		Case $rExecutable[88]
			If $rRun[88] <> "" Then ShellExecute($rRun[88])
		Case $rExecutable[89]
			If $rRun[89] <> "" Then ShellExecute($rRun[89])
		Case $rExecutable[90]
			If $rRun[90] <> "" Then ShellExecute($rRun[90])
		Case $rExecutable[91]
			If $rRun[91] <> "" Then ShellExecute($rRun[91])
		Case $rExecutable[92]
			If $rRun[92] <> "" Then ShellExecute($rRun[92])
		Case $rExecutable[93]
			If $rRun[93] <> "" Then ShellExecute($rRun[93])
		Case $rExecutable[94]
			If $rRun[94] <> "" Then ShellExecute($rRun[94])
		Case $rExecutable[95]
			If $rRun[95] <> "" Then ShellExecute($rRun[95])
		Case $rExecutable[96]
			If $rRun[96] <> "" Then ShellExecute($rRun[96])
		Case $rExecutable[97]
			If $rRun[97] <> "" Then ShellExecute($rRun[97])
		Case $rExecutable[98]
			If $rRun[98] <> "" Then ShellExecute($rRun[98])
		Case $rExecutable[99]
			If $rRun[99] <> "" Then ShellExecute($rRun[99])
		Case $rExecutable[100]
			If $rRun[100] <> "" Then ShellExecute($rRun[100])
		Case $rExecutable[101]
			If $rRun[101] <> "" Then ShellExecute($rRun[101])
		Case $rExecutable[102]
			If $rRun[102] <> "" Then ShellExecute($rRun[102])
		Case $rExecutable[103]
			If $rRun[103] <> "" Then ShellExecute($rRun[103])
		Case $rExecutable[104]
			If $rRun[104] <> "" Then ShellExecute($rRun[104])
		Case $rExecutable[105]
			If $rRun[105] <> "" Then ShellExecute($rRun[105])
		Case $rExecutable[106]
			If $rRun[106] <> "" Then ShellExecute($rRun[106])
		Case $rExecutable[107]
			If $rRun[107] <> "" Then ShellExecute($rRun[107])
		Case $rExecutable[108]
			If $rRun[108] <> "" Then ShellExecute($rRun[108])
		Case $rExecutable[109]
			If $rRun[109] <> "" Then ShellExecute($rRun[109])
		Case $rExecutable[110]
			If $rRun[110] <> "" Then ShellExecute($rRun[110])
		Case $rExecutable[111]
			If $rRun[111] <> "" Then ShellExecute($rRun[111])
		Case $rExecutable[112]
			If $rRun[112] <> "" Then ShellExecute($rRun[112])
		Case $rExecutable[113]
			If $rRun[113] <> "" Then ShellExecute($rRun[113])
		Case $rExecutable[114]
			If $rRun[114] <> "" Then ShellExecute($rRun[114])
		Case $rExecutable[115]
			If $rRun[115] <> "" Then ShellExecute($rRun[115])
		Case $rExecutable[116]
			If $rRun[116] <> "" Then ShellExecute($rRun[116])
		Case $rExecutable[117]
			If $rRun[117] <> "" Then ShellExecute($rRun[117])
		Case $rExecutable[118]
			If $rRun[118] <> "" Then ShellExecute($rRun[118])
		Case $rExecutable[119]
			If $rRun[119] <> "" Then ShellExecute($rRun[119])
		Case $rExecutable[120]
			If $rRun[120] <> "" Then ShellExecute($rRun[120])
		Case $rExecutable[121]
			If $rRun[121] <> "" Then ShellExecute($rRun[121])
		Case $rExecutable[122]
			If $rRun[122] <> "" Then ShellExecute($rRun[122])
		Case $rExecutable[123]
			If $rRun[123] <> "" Then ShellExecute($rRun[123])
		Case $rExecutable[124]
			If $rRun[124] <> "" Then ShellExecute($rRun[124])
		Case $rExecutable[125]
			If $rRun[125] <> "" Then ShellExecute($rRun[125])
		Case $rExecutable[126]
			If $rRun[126] <> "" Then ShellExecute($rRun[126])
		Case $rExecutable[127]
			If $rRun[127] <> "" Then ShellExecute($rRun[127])
		Case $rExecutable[128]
			If $rRun[128] <> "" Then ShellExecute($rRun[128])
		Case $rExecutable[129]
			If $rRun[129] <> "" Then ShellExecute($rRun[129])
		Case $rExecutable[130]
			If $rRun[130] <> "" Then ShellExecute($rRun[130])
		Case $rExecutable[131]
			If $rRun[131] <> "" Then ShellExecute($rRun[131])
		Case $rExecutable[132]
			If $rRun[132] <> "" Then ShellExecute($rRun[132])
		Case $rExecutable[133]
			If $rRun[133] <> "" Then ShellExecute($rRun[133])
		Case $rExecutable[134]
			If $rRun[134] <> "" Then ShellExecute($rRun[134])
		Case $rExecutable[135]
			If $rRun[135] <> "" Then ShellExecute($rRun[135])
		Case $rExecutable[136]
			If $rRun[136] <> "" Then ShellExecute($rRun[136])
		Case $rExecutable[137]
			If $rRun[137] <> "" Then ShellExecute($rRun[137])
		Case $rExecutable[138]
			If $rRun[138] <> "" Then ShellExecute($rRun[138])
		Case $rExecutable[139]
			If $rRun[139] <> "" Then ShellExecute($rRun[139])
		Case $rExecutable[140]
			If $rRun[140] <> "" Then ShellExecute($rRun[140])
		Case $rExecutable[141]
			If $rRun[141] <> "" Then ShellExecute($rRun[141])
		Case $rExecutable[142]
			If $rRun[142] <> "" Then ShellExecute($rRun[142])
		Case $rExecutable[143]
			If $rRun[143] <> "" Then ShellExecute($rRun[143])
		Case $rExecutable[144]
			If $rRun[144] <> "" Then ShellExecute($rRun[144])
		Case $rExecutable[145]
			If $rRun[145] <> "" Then ShellExecute($rRun[145])
		Case $rExecutable[146]
			If $rRun[146] <> "" Then ShellExecute($rRun[146])
		Case $rExecutable[147]
			If $rRun[147] <> "" Then ShellExecute($rRun[147])
		Case $rExecutable[148]
			If $rRun[148] <> "" Then ShellExecute($rRun[148])
		Case $rExecutable[149]
			If $rRun[149] <> "" Then ShellExecute($rRun[149])
		Case $rExecutable[150]
			If $rRun[150] <> "" Then ShellExecute($rRun[150])
		Case $rExecutable[151]
			If $rRun[151] <> "" Then ShellExecute($rRun[151])
		Case $rExecutable[152]
			If $rRun[152] <> "" Then ShellExecute($rRun[152])
		Case $rExecutable[153]
			If $rRun[153] <> "" Then ShellExecute($rRun[153])
		Case $rExecutable[154]
			If $rRun[154] <> "" Then ShellExecute($rRun[154])
		Case $rExecutable[155]
			If $rRun[155] <> "" Then ShellExecute($rRun[155])
		Case $rExecutable[156]
			If $rRun[156] <> "" Then ShellExecute($rRun[156])
		Case $rExecutable[157]
			If $rRun[157] <> "" Then ShellExecute($rRun[157])
		Case $rExecutable[158]
			If $rRun[158] <> "" Then ShellExecute($rRun[158])
		Case $rExecutable[159]
			If $rRun[159] <> "" Then ShellExecute($rRun[159])
		Case $rExecutable[160]
			If $rRun[160] <> "" Then ShellExecute($rRun[160])
		Case $rExecutable[161]
			If $rRun[161] <> "" Then ShellExecute($rRun[161])
		Case $rExecutable[162]
			If $rRun[162] <> "" Then ShellExecute($rRun[162])
		Case $rExecutable[163]
			If $rRun[163] <> "" Then ShellExecute($rRun[163])
		Case $rExecutable[164]
			If $rRun[164] <> "" Then ShellExecute($rRun[164])
		Case $rExecutable[165]
			If $rRun[165] <> "" Then ShellExecute($rRun[165])
		Case $rExecutable[166]
			If $rRun[166] <> "" Then ShellExecute($rRun[166])
		Case $rExecutable[167]
			If $rRun[167] <> "" Then ShellExecute($rRun[167])
		Case $rExecutable[168]
			If $rRun[168] <> "" Then ShellExecute($rRun[168])
		Case $rExecutable[169]
			If $rRun[169] <> "" Then ShellExecute($rRun[169])
		Case $rExecutable[170]
			If $rRun[170] <> "" Then ShellExecute($rRun[170])
		Case $rExecutable[171]
			If $rRun[171] <> "" Then ShellExecute($rRun[171])
		Case $rExecutable[172]
			If $rRun[172] <> "" Then ShellExecute($rRun[172])
		Case $rExecutable[173]
			If $rRun[173] <> "" Then ShellExecute($rRun[173])
		Case $rExecutable[174]
			If $rRun[174] <> "" Then ShellExecute($rRun[174])
		Case $rExecutable[175]
			If $rRun[175] <> "" Then ShellExecute($rRun[175])
		Case $rExecutable[176]
			If $rRun[176] <> "" Then ShellExecute($rRun[176])
		Case $rExecutable[177]
			If $rRun[177] <> "" Then ShellExecute($rRun[177])
		Case $rExecutable[178]
			If $rRun[178] <> "" Then ShellExecute($rRun[178])
		Case $rExecutable[179]
			If $rRun[179] <> "" Then ShellExecute($rRun[179])
		Case $rExecutable[180]
			If $rRun[180] <> "" Then ShellExecute($rRun[180])
		Case $rExecutable[181]
			If $rRun[181] <> "" Then ShellExecute($rRun[181])
		Case $rExecutable[182]
			If $rRun[182] <> "" Then ShellExecute($rRun[182])
		Case $rExecutable[183]
			If $rRun[183] <> "" Then ShellExecute($rRun[183])
		Case $rExecutable[184]
			If $rRun[184] <> "" Then ShellExecute($rRun[184])
		Case $rExecutable[185]
			If $rRun[185] <> "" Then ShellExecute($rRun[185])
		Case $rExecutable[186]
			If $rRun[186] <> "" Then ShellExecute($rRun[186])
		Case $rExecutable[187]
			If $rRun[187] <> "" Then ShellExecute($rRun[187])
		Case $rExecutable[188]
			If $rRun[188] <> "" Then ShellExecute($rRun[188])
		Case $rExecutable[189]
			If $rRun[189] <> "" Then ShellExecute($rRun[189])
		Case $rExecutable[190]
			If $rRun[190] <> "" Then ShellExecute($rRun[190])
		Case $rExecutable[191]
			If $rRun[191] <> "" Then ShellExecute($rRun[191])
		Case $rExecutable[192]
			If $rRun[192] <> "" Then ShellExecute($rRun[192])
		Case $rExecutable[193]
			If $rRun[193] <> "" Then ShellExecute($rRun[193])
		Case $rExecutable[194]
			If $rRun[194] <> "" Then ShellExecute($rRun[194])
		Case $rExecutable[195]
			If $rRun[195] <> "" Then ShellExecute($rRun[195])
		Case $rExecutable[196]
			If $rRun[196] <> "" Then ShellExecute($rRun[196])
		Case $rExecutable[197]
			If $rRun[197] <> "" Then ShellExecute($rRun[197])
		Case $rExecutable[198]
			If $rRun[198] <> "" Then ShellExecute($rRun[198])
		Case $rExecutable[199]
			If $rRun[199] <> "" Then ShellExecute($rRun[199])
		Case $rExecutable[200]
			If $rRun[200] <> "" Then ShellExecute($rRun[200])
		Case $rExecutable[201]
			If $rRun[201] <> "" Then ShellExecute($rRun[201])
		Case $rExecutable[202]
			If $rRun[202] <> "" Then ShellExecute($rRun[202])
		Case $rExecutable[203]
			If $rRun[203] <> "" Then ShellExecute($rRun[203])
		Case $rExecutable[204]
			If $rRun[204] <> "" Then ShellExecute($rRun[204])
		Case $rExecutable[205]
			If $rRun[205] <> "" Then ShellExecute($rRun[205])
		Case $rExecutable[206]
			If $rRun[206] <> "" Then ShellExecute($rRun[206])
		Case $rExecutable[207]
			If $rRun[207] <> "" Then ShellExecute($rRun[207])
		Case $rExecutable[208]
			If $rRun[208] <> "" Then ShellExecute($rRun[208])
		Case $rExecutable[209]
			If $rRun[209] <> "" Then ShellExecute($rRun[209])
		Case $rExecutable[210]
			If $rRun[210] <> "" Then ShellExecute($rRun[210])
		Case $rExecutable[211]
			If $rRun[211] <> "" Then ShellExecute($rRun[211])
		Case $rExecutable[212]
			If $rRun[212] <> "" Then ShellExecute($rRun[212])
		Case $rExecutable[213]
			If $rRun[213] <> "" Then ShellExecute($rRun[213])
		Case $rExecutable[214]
			If $rRun[214] <> "" Then ShellExecute($rRun[214])
		Case $rExecutable[215]
			If $rRun[215] <> "" Then ShellExecute($rRun[215])
		Case $rExecutable[216]
			If $rRun[216] <> "" Then ShellExecute($rRun[216])
		Case $rExecutable[217]
			If $rRun[217] <> "" Then ShellExecute($rRun[217])
		Case $rExecutable[218]
			If $rRun[218] <> "" Then ShellExecute($rRun[218])
		Case $rExecutable[219]
			If $rRun[219] <> "" Then ShellExecute($rRun[219])
		Case $rExecutable[220]
			If $rRun[220] <> "" Then ShellExecute($rRun[220])
		Case $rExecutable[221]
			If $rRun[221] <> "" Then ShellExecute($rRun[221])
		Case $rExecutable[222]
			If $rRun[222] <> "" Then ShellExecute($rRun[222])
		Case $rExecutable[223]
			If $rRun[223] <> "" Then ShellExecute($rRun[223])
		Case $rExecutable[224]
			If $rRun[224] <> "" Then ShellExecute($rRun[224])
		Case $rExecutable[225]
			If $rRun[225] <> "" Then ShellExecute($rRun[225])
		Case $rExecutable[226]
			If $rRun[226] <> "" Then ShellExecute($rRun[226])
		Case $rExecutable[227]
			If $rRun[227] <> "" Then ShellExecute($rRun[227])
		Case $rExecutable[228]
			If $rRun[228] <> "" Then ShellExecute($rRun[228])
		Case $rExecutable[229]
			If $rRun[229] <> "" Then ShellExecute($rRun[229])
		Case $rExecutable[230]
			If $rRun[230] <> "" Then ShellExecute($rRun[230])
		Case $rExecutable[231]
			If $rRun[231] <> "" Then ShellExecute($rRun[231])
		Case $rExecutable[232]
			If $rRun[232] <> "" Then ShellExecute($rRun[232])
		Case $rExecutable[233]
			If $rRun[233] <> "" Then ShellExecute($rRun[233])
		Case $rExecutable[234]
			If $rRun[234] <> "" Then ShellExecute($rRun[234])
		Case $rExecutable[235]
			If $rRun[235] <> "" Then ShellExecute($rRun[235])
		Case $rExecutable[236]
			If $rRun[236] <> "" Then ShellExecute($rRun[236])
		Case $rExecutable[237]
			If $rRun[237] <> "" Then ShellExecute($rRun[237])
		Case $rExecutable[238]
			If $rRun[238] <> "" Then ShellExecute($rRun[238])
		Case $rExecutable[239]
			If $rRun[239] <> "" Then ShellExecute($rRun[239])
		Case $rExecutable[240]
			If $rRun[240] <> "" Then ShellExecute($rRun[240])
		Case $rExecutable[241]
			If $rRun[241] <> "" Then ShellExecute($rRun[241])
		Case $rExecutable[242]
			If $rRun[242] <> "" Then ShellExecute($rRun[242])
		Case $rExecutable[243]
			If $rRun[243] <> "" Then ShellExecute($rRun[243])
		Case $rExecutable[244]
			If $rRun[244] <> "" Then ShellExecute($rRun[244])
		Case $rExecutable[245]
			If $rRun[245] <> "" Then ShellExecute($rRun[245])
		Case $rExecutable[246]
			If $rRun[246] <> "" Then ShellExecute($rRun[246])
		Case $rExecutable[247]
			If $rRun[247] <> "" Then ShellExecute($rRun[247])
		Case $rExecutable[248]
			If $rRun[248] <> "" Then ShellExecute($rRun[248])
		Case $rExecutable[249]
			If $rRun[249] <> "" Then ShellExecute($rRun[249])
		Case $rExecutable[250]
			If $rRun[250] <> "" Then ShellExecute($rRun[250])
		Case $rExecutable[251]
			If $rRun[251] <> "" Then ShellExecute($rRun[251])
		Case $rExecutable[252]
			If $rRun[252] <> "" Then ShellExecute($rRun[252])
		Case $rExecutable[253]
			If $rRun[253] <> "" Then ShellExecute($rRun[253])
		Case $rExecutable[254]
			If $rRun[254] <> "" Then ShellExecute($rRun[254])
		Case $rExecutable[255]
			If $rRun[255] <> "" Then ShellExecute($rRun[255])
	EndSwitch
WEnd
