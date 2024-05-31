#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Icon=bin\s_main.ico
#AutoIt3Wrapper_Outfile=system.x86.exe
#AutoIt3Wrapper_Outfile_x64=system.x64.exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=SYSTEM - Categorized Portable Software Loader created by AutoIt3
#AutoIt3Wrapper_Res_Description=SYSTEM   v2.4.5.5   Enterprise Edition
#AutoIt3Wrapper_Res_Fileversion=2.4.5.5
#AutoIt3Wrapper_Res_ProductName=SYSTEM
#AutoIt3Wrapper_Res_ProductVersion=2.4.5.5
#AutoIt3Wrapper_Res_CompanyName=László Kártik - Senior IT System Engineer
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2020, László Kártik
#AutoIt3Wrapper_Res_Language=1038
#AutoIt3Wrapper_Res_Field=Website|"https://github.com/lacikartik88"
#AutoIt3Wrapper_Res_Field=Comment|"Categorized Portable Software Loader created by AutoIt3"
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
#include <MsgBoxConstants.au3>
#include <StaticConstants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Init()

Func Init()
	; define laod screen gui
	Global $iGUI
	$iGUI = GUICreate("", 320, 60, -1, -1, $WS_POPUP, -1)
	GUISetFont(8, $FW_MEDIUM, "", "Comic Sans Ms", $iGUI, $CLEARTYPE_QUALITY)
	;WinSetTrans($iGUI, "", 250)
	GUISetBkColor(0x2D2D2D)
	GUICtrlSetDefColor(0xFFFFFF, $iGUI)
	GUICtrlSetDefBkColor(0x2D2D2D, $iGUI)


	; show gui, define progress
	GUISetState(@SW_SHOW, $iGUI)
	$iProgress = GUICtrlCreateProgress(10, 10, 300, 25, -1, -1)

	; *** step 1: define variables
	GUICtrlCreateLabel("Define variables...                               ", 10, 35, -1, -1)
	GUICtrlSetData($iProgress, "10")
	Sleep(50)

	; define main gui vars
	Global $mGUI
	Global $CatD[16], $NameD[256], $AppF[256] ; read directories, files and write data to $cfg, create menu system
	Global $i = 0, $j = 0, $k = 0, $l = 0, $m = 0, $n = 0 ; sequence variables
	Global $icon, $back, $bExit, $Btn ; theme variables

	; set directories
	Global $appD = @ScriptDir & "\apps" ; applications directory

	; define cfg file
	Global $cfg = @ScriptDir & "\bin\config.ini" ; setup application main config file

	; *** step 2: setting up themes
	GUICtrlCreateLabel("Setting up themes...                              ", 10, 35, -1, -1)
	GUICtrlSetData($iProgress, "20")
	Sleep(50)

	; define theme variables
	Global $icon = @ScriptDir & "\bin\s_main.ico"
	Global $back = @ScriptDir & "\bin\s_back.bmp" ; 1000x400
	Global $back = @ScriptDir & "\bin\s_matrix.mp4" ; -1, -1, 1000, 400 if 1080p resolution video file
	Global $bExit = @ScriptDir & "\bin\s_exit.ico"

	; *** step 4: create head
	GUICtrlCreateLabel("Createing head...                                 ", 10, 35, -1, -1)
	GUICtrlSetData($iProgress, "40")
	Sleep(50)

	; define head
	Global $sysName = "SYSTEM    v2.4.05.05    Enterprise Edition"

	; *** step 5: creating menu structure
	GUICtrlCreateLabel("Creating menu structure...                        ", 10, 35, -1, -1)
	GUICtrlSetData($iProgress, "50")
	Sleep(100)

	; delete old menu system
	IniDelete($cfg, "CatD")
	IniDelete($cfg, "NameD")
	IniDelete($cfg, "AppF")
	IniDelete($cfg, "ShellExecute")

	; generate data
	Global $i = "", $j = 0, $k = "", $l = 0, $m = "", $n = 0 ; sequence variables
	Global $o = 0, $p = 0, $q = 0 ; sequence variables
	Global $r = 10, $s = 0 ; localize combo position
	; $i = value of $CatD | $k = value of $NameD | $m = value of $AppF
	; $j, $l, $n, $o, $p, $q = counters
	$CatD = _FileListToArray($appD, "*", $FLTA_FOLDERS, False)
	For $i In $CatD
		If IsString($i) Then
			; IniWrite($cfg, "CatD", $j, $i)
			$NameD = _FileListToArray($appD & "\" & $i, "*", $FLTA_FOLDERS, False)
			$j += 1
			If IsArray($NameD) Then
				For $k In $NameD
					If IsString($k) Then
						; IniWrite($cfg, $i, $l, $k)
						$AppF = _FileListToArray($appD & "\" & $i & "\" & $k, "*.exe", $FLTA_FILES, False)
						$l += 1
						If IsArray($AppF) Then
							For $m In $AppF
								If IsString($m) Then
									; IniWrite($cfg, $k, $n, $m)
									BinaryToString(IniWrite($cfg, "CatD", "$CatD[" & $o & "]", "GUICtrlCreateMenu(" & '"' & $i & '"' & ")"), $SB_ANSI)
									BinaryToString(IniWrite($cfg, "NameD", "$NameD[" & $p & "]", "GUICtrlCreateMenu(" & '"' & $k & '"' & ", $CatD[" & $o & "])"), $SB_ANSI)
									BinaryToString(IniWrite($cfg, "AppF", "$AppF[" & $q & "]", "GUICtrlCreateMenuItem(" & '"' & $m & '"' & ", $NameD[" & $p & "])"), $SB_ANSI)
									BinaryToString(IniWrite($cfg, "ShellExecute", $q, $appD & "\" & $i & "\" & $k & "\" & $m), $SB_ANSI)
									$n += 1
									$q += 1
								Else
								EndIf
							Next
							$n = 0
							$p += 1
							$r = $r + 220
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

	; *** step 6: done
	GUICtrlCreateLabel("Done...                                           ", 10, 35, -1, -1)
	GUICtrlSetData($iProgress, "100")
	; wait 0.50s
	Sleep(50)

	; delete gui and run main gui
	GUIDelete($iGUI)
	mGUI()
EndFunc   ;==>Init

Func MP()
	$oMP = ObjCreate("WMPlayer.OCX")
	GUICtrlCreateObj($oMP, -1, -1, 1000, 400)
	With $oMP
		.FullScreen = True
		.WindowlessVideo = True
		.StretchToFit = True
		.EnableContextMenu = False
		.Enabled = True
		.UIMode = "none" ; full / none / mini full
		.Eettings.AutoStart = True
		.Settings.Mute = True ;
		.Settings.Volume = 0 ; 0 - 100
		.Settings.Balance = 0 ; -100 to 100
		.Settings.Repeat = True
		.URL = $back ; $back is an existing file
	EndWith
EndFunc

Func mGUI()
	; delete old guis
	GUIDelete($iGUI)
	GUIDelete($mGUI)

	; define gui
	Global $mGUI = GUICreate($sysName, 1000, 400, -1, -1, -1, -1, 0)
	GUISetIcon($icon, 0)
	GUISetFont(8, $FW_MEDIUM, "", "Comic Sans Ms", $mGUI, $CLEARTYPE_QUALITY)
	WinSetTrans($mGUI, "", 250)
	GUISetBkColor(0x2D2D2D)
	GUICtrlSetDefColor(0xFFFFFF, $mGUI)
	GUICtrlSetDefBkColor(0x2D2D2D, $mGUI)

	; load background
	GUICtrlCreatePic($back, 0, 0, 1000, 400, $BS_BITMAP) ; if bitmap
	MP()

	; generating data
	Global $CatD[16], $NameD[256], $AppF[256] ; reset variables for create menu system
	Global $i = 0, $j = 0, $k = 0, $l = 0, $m = 0, $n = 0 ; sequence variables

	; reading menu category data from $cfg - menu
	For $i = 0 To 15 Step 1
		If IniRead($cfg, "CatD", "$CatD[" & $i & "]", "") <> "" Then
			$CatD[$i] = IniRead($cfg, "CatD", "$CatD[" & $i & "]", "")
			$CatD[$i] = BinaryToString($CatD[$i], $SB_ANSI)
			; create menu
			If $CatD[$i] <> "" Then $CatD[$i] = Execute($CatD[$i])
		Else
		EndIf
	Next

	; reading menu program name data from $cfg - submenu
	For $j = 0 To 225 Step 1
		If IniRead($cfg, "NameD", "$NameD[" & $j & "]", "") <> "" Then
			$NameD[$j] = IniRead($cfg, "NameD", "$NameD[" & $j & "]", "")
			$NameD[$j] = BinaryToString($NameD[$j], $SB_ANSI)
			; create submenu
			If $NameD[$j] <> "" Then $NameD[$j] = Execute($NameD[$j])
		Else
		EndIf
	Next

	; reading menu program path data from $cfg - menuitem
	For $k = 0 To 255 Step 1
		If IniRead($cfg, "AppF", "$AppF[" & $k & "]", "") <> "" Then
			$AppF[$k] = IniRead($cfg, "AppF", "$AppF[" & $k & "]", "")
			$AppF[$k] = BinaryToString($AppF[$k], $SB_ANSI)
			; create menuitems
			If $AppF[$k] <> "" Then $AppF[$k] = Execute($AppF[$k])
		Else
		EndIf
	Next

	; exit button [0]
	;$Btn = GUICtrlCreateButton("  " & "Kilépés", 840, 320, 150, 50, $BS_ICON)
	;GUICtrlSetImage($Btn, $bExit, "", 2)
	;GUICtrlSetCursor($Btn, 0)
	;GUICtrlSetStyle($Btn, $BS_LEFT)

	; show gui
	GUISetState(@SW_SHOW, $mGUI)
EndFunc   ;==>mGUI

; *** SYSTEM CORE ***
While - 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE;, $Btn ; exit
			GUIDelete($mGUI)
			ExitLoop

			; menu array
		Case $AppF[0]
			If $AppF[0] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "0", ""), $SB_ANSI))
		Case $AppF[1]
			If $AppF[1] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "1", ""), $SB_ANSI))
		Case $AppF[2]
			If $AppF[2] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "2", ""), $SB_ANSI))
		Case $AppF[3]
			If $AppF[3] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "3", ""), $SB_ANSI))
		Case $AppF[4]
			If $AppF[4] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "4", ""), $SB_ANSI))
		Case $AppF[5]
			If $AppF[5] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "5", ""), $SB_ANSI))
		Case $AppF[6]
			If $AppF[6] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "6", ""), $SB_ANSI))
		Case $AppF[7]
			If $AppF[7] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "7", ""), $SB_ANSI))
		Case $AppF[8]
			If $AppF[8] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "8", ""), $SB_ANSI))
		Case $AppF[9]
			If $AppF[9] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "9", ""), $SB_ANSI))
		Case $AppF[10]
			If $AppF[10] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "10", ""), $SB_ANSI))
		Case $AppF[11]
			If $AppF[11] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "11", ""), $SB_ANSI))
		Case $AppF[12]
			If $AppF[12] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "12", ""), $SB_ANSI))
		Case $AppF[13]
			If $AppF[13] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "13", ""), $SB_ANSI))
		Case $AppF[14]
			If $AppF[14] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "14", ""), $SB_ANSI))
		Case $AppF[15]
			If $AppF[15] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "15", ""), $SB_ANSI))
		Case $AppF[16]
			If $AppF[16] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "16", ""), $SB_ANSI))
		Case $AppF[17]
			If $AppF[17] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "17", ""), $SB_ANSI))
		Case $AppF[18]
			If $AppF[18] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "18", ""), $SB_ANSI))
		Case $AppF[19]
			If $AppF[19] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "19", ""), $SB_ANSI))
		Case $AppF[20]
			If $AppF[20] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "20", ""), $SB_ANSI))
		Case $AppF[21]
			If $AppF[21] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "21", ""), $SB_ANSI))
		Case $AppF[22]
			If $AppF[22] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "22", ""), $SB_ANSI))
		Case $AppF[23]
			If $AppF[23] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "23", ""), $SB_ANSI))
		Case $AppF[24]
			If $AppF[24] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "24", ""), $SB_ANSI))
		Case $AppF[25]
			If $AppF[25] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "25", ""), $SB_ANSI))
		Case $AppF[26]
			If $AppF[26] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "26", ""), $SB_ANSI))
		Case $AppF[27]
			If $AppF[27] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "27", ""), $SB_ANSI))
		Case $AppF[28]
			If $AppF[28] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "28", ""), $SB_ANSI))
		Case $AppF[29]
			If $AppF[29] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "29", ""), $SB_ANSI))
		Case $AppF[30]
			If $AppF[30] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "30", ""), $SB_ANSI))
		Case $AppF[31]
			If $AppF[31] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "31", ""), $SB_ANSI))
		Case $AppF[32]
			If $AppF[32] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "32", ""), $SB_ANSI))
		Case $AppF[33]
			If $AppF[33] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "33", ""), $SB_ANSI))
		Case $AppF[34]
			If $AppF[34] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "34", ""), $SB_ANSI))
		Case $AppF[35]
			If $AppF[35] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "35", ""), $SB_ANSI))
		Case $AppF[36]
			If $AppF[36] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "36", ""), $SB_ANSI))
		Case $AppF[37]
			If $AppF[37] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "37", ""), $SB_ANSI))
		Case $AppF[38]
			If $AppF[38] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "38", ""), $SB_ANSI))
		Case $AppF[39]
			If $AppF[39] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "39", ""), $SB_ANSI))
		Case $AppF[40]
			If $AppF[40] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "40", ""), $SB_ANSI))
		Case $AppF[41]
			If $AppF[41] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "41", ""), $SB_ANSI))
		Case $AppF[42]
			If $AppF[42] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "42", ""), $SB_ANSI))
		Case $AppF[43]
			If $AppF[43] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "43", ""), $SB_ANSI))
		Case $AppF[44]
			If $AppF[44] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "44", ""), $SB_ANSI))
		Case $AppF[45]
			If $AppF[45] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "45", ""), $SB_ANSI))
		Case $AppF[46]
			If $AppF[46] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "46", ""), $SB_ANSI))
		Case $AppF[47]
			If $AppF[47] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "47", ""), $SB_ANSI))
		Case $AppF[48]
			If $AppF[48] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "48", ""), $SB_ANSI))
		Case $AppF[49]
			If $AppF[49] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "49", ""), $SB_ANSI))
		Case $AppF[50]
			If $AppF[50] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "50", ""), $SB_ANSI))
		Case $AppF[51]
			If $AppF[51] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "51", ""), $SB_ANSI))
		Case $AppF[52]
			If $AppF[52] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "52", ""), $SB_ANSI))
		Case $AppF[53]
			If $AppF[53] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "53", ""), $SB_ANSI))
		Case $AppF[54]
			If $AppF[54] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "54", ""), $SB_ANSI))
		Case $AppF[55]
			If $AppF[55] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "55", ""), $SB_ANSI))
		Case $AppF[56]
			If $AppF[56] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "56", ""), $SB_ANSI))
		Case $AppF[57]
			If $AppF[57] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "57", ""), $SB_ANSI))
		Case $AppF[58]
			If $AppF[58] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "58", ""), $SB_ANSI))
		Case $AppF[59]
			If $AppF[59] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "59", ""), $SB_ANSI))
		Case $AppF[60]
			If $AppF[60] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "60", ""), $SB_ANSI))
		Case $AppF[61]
			If $AppF[61] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "61", ""), $SB_ANSI))
		Case $AppF[62]
			If $AppF[62] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "62", ""), $SB_ANSI))
		Case $AppF[63]
			If $AppF[63] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "63", ""), $SB_ANSI))
		Case $AppF[64]
			If $AppF[64] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "64", ""), $SB_ANSI))
		Case $AppF[65]
			If $AppF[65] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "65", ""), $SB_ANSI))
		Case $AppF[66]
			If $AppF[66] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "66", ""), $SB_ANSI))
		Case $AppF[67]
			If $AppF[67] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "67", ""), $SB_ANSI))
		Case $AppF[68]
			If $AppF[68] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "68", ""), $SB_ANSI))
		Case $AppF[69]
			If $AppF[69] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "69", ""), $SB_ANSI))
		Case $AppF[70]
			If $AppF[70] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "70", ""), $SB_ANSI))
		Case $AppF[71]
			If $AppF[71] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "71", ""), $SB_ANSI))
		Case $AppF[72]
			If $AppF[72] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "72", ""), $SB_ANSI))
		Case $AppF[73]
			If $AppF[73] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "73", ""), $SB_ANSI))
		Case $AppF[74]
			If $AppF[74] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "74", ""), $SB_ANSI))
		Case $AppF[75]
			If $AppF[75] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "75", ""), $SB_ANSI))
		Case $AppF[76]
			If $AppF[76] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "76", ""), $SB_ANSI))
		Case $AppF[77]
			If $AppF[77] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "77", ""), $SB_ANSI))
		Case $AppF[78]
			If $AppF[78] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "78", ""), $SB_ANSI))
		Case $AppF[79]
			If $AppF[79] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "79", ""), $SB_ANSI))
		Case $AppF[80]
			If $AppF[80] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "80", ""), $SB_ANSI))
		Case $AppF[81]
			If $AppF[81] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "81", ""), $SB_ANSI))
		Case $AppF[82]
			If $AppF[82] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "82", ""), $SB_ANSI))
		Case $AppF[83]
			If $AppF[83] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "83", ""), $SB_ANSI))
		Case $AppF[84]
			If $AppF[84] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "84", ""), $SB_ANSI))
		Case $AppF[85]
			If $AppF[85] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "85", ""), $SB_ANSI))
		Case $AppF[86]
			If $AppF[86] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "86", ""), $SB_ANSI))
		Case $AppF[87]
			If $AppF[87] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "87", ""), $SB_ANSI))
		Case $AppF[88]
			If $AppF[88] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "88", ""), $SB_ANSI))
		Case $AppF[89]
			If $AppF[89] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "89", ""), $SB_ANSI))
		Case $AppF[90]
			If $AppF[90] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "90", ""), $SB_ANSI))
		Case $AppF[91]
			If $AppF[91] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "91", ""), $SB_ANSI))
		Case $AppF[92]
			If $AppF[92] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "92", ""), $SB_ANSI))
		Case $AppF[93]
			If $AppF[93] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "93", ""), $SB_ANSI))
		Case $AppF[94]
			If $AppF[94] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "94", ""), $SB_ANSI))
		Case $AppF[95]
			If $AppF[95] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "95", ""), $SB_ANSI))
		Case $AppF[96]
			If $AppF[96] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "96", ""), $SB_ANSI))
		Case $AppF[97]
			If $AppF[97] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "97", ""), $SB_ANSI))
		Case $AppF[98]
			If $AppF[98] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "98", ""), $SB_ANSI))
		Case $AppF[99]
			If $AppF[99] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "99", ""), $SB_ANSI))
		Case $AppF[100]
			If $AppF[100] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "100", ""), $SB_ANSI))
		Case $AppF[101]
			If $AppF[101] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "101", ""), $SB_ANSI))
		Case $AppF[102]
			If $AppF[102] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "102", ""), $SB_ANSI))
		Case $AppF[103]
			If $AppF[103] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "103", ""), $SB_ANSI))
		Case $AppF[104]
			If $AppF[104] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "104", ""), $SB_ANSI))
		Case $AppF[105]
			If $AppF[105] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "105", ""), $SB_ANSI))
		Case $AppF[106]
			If $AppF[106] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "106", ""), $SB_ANSI))
		Case $AppF[107]
			If $AppF[107] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "107", ""), $SB_ANSI))
		Case $AppF[108]
			If $AppF[108] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "108", ""), $SB_ANSI))
		Case $AppF[109]
			If $AppF[109] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "109", ""), $SB_ANSI))
		Case $AppF[110]
			If $AppF[110] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "110", ""), $SB_ANSI))
		Case $AppF[111]
			If $AppF[111] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "111", ""), $SB_ANSI))
		Case $AppF[112]
			If $AppF[112] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "112", ""), $SB_ANSI))
		Case $AppF[113]
			If $AppF[113] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "113", ""), $SB_ANSI))
		Case $AppF[114]
			If $AppF[114] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "114", ""), $SB_ANSI))
		Case $AppF[115]
			If $AppF[115] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "115", ""), $SB_ANSI))
		Case $AppF[116]
			If $AppF[116] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "116", ""), $SB_ANSI))
		Case $AppF[117]
			If $AppF[117] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "117", ""), $SB_ANSI))
		Case $AppF[118]
			If $AppF[118] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "118", ""), $SB_ANSI))
		Case $AppF[119]
			If $AppF[119] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "119", ""), $SB_ANSI))
		Case $AppF[120]
			If $AppF[120] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "120", ""), $SB_ANSI))
		Case $AppF[121]
			If $AppF[121] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "121", ""), $SB_ANSI))
		Case $AppF[122]
			If $AppF[122] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "122", ""), $SB_ANSI))
		Case $AppF[123]
			If $AppF[123] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "123", ""), $SB_ANSI))
		Case $AppF[124]
			If $AppF[124] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "124", ""), $SB_ANSI))
		Case $AppF[125]
			If $AppF[125] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "125", ""), $SB_ANSI))
		Case $AppF[126]
			If $AppF[126] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "126", ""), $SB_ANSI))
		Case $AppF[127]
			If $AppF[127] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "127", ""), $SB_ANSI))
		Case $AppF[128]
			If $AppF[128] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "128", ""), $SB_ANSI))
		Case $AppF[129]
			If $AppF[129] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "129", ""), $SB_ANSI))
		Case $AppF[130]
			If $AppF[130] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "130", ""), $SB_ANSI))
		Case $AppF[131]
			If $AppF[131] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "131", ""), $SB_ANSI))
		Case $AppF[132]
			If $AppF[132] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "132", ""), $SB_ANSI))
		Case $AppF[133]
			If $AppF[133] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "133", ""), $SB_ANSI))
		Case $AppF[134]
			If $AppF[134] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "134", ""), $SB_ANSI))
		Case $AppF[135]
			If $AppF[135] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "135", ""), $SB_ANSI))
		Case $AppF[136]
			If $AppF[136] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "136", ""), $SB_ANSI))
		Case $AppF[137]
			If $AppF[137] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "137", ""), $SB_ANSI))
		Case $AppF[138]
			If $AppF[138] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "138", ""), $SB_ANSI))
		Case $AppF[139]
			If $AppF[139] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "139", ""), $SB_ANSI))
		Case $AppF[140]
			If $AppF[140] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "140", ""), $SB_ANSI))
		Case $AppF[141]
			If $AppF[141] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "141", ""), $SB_ANSI))
		Case $AppF[142]
			If $AppF[142] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "142", ""), $SB_ANSI))
		Case $AppF[143]
			If $AppF[143] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "143", ""), $SB_ANSI))
		Case $AppF[144]
			If $AppF[144] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "144", ""), $SB_ANSI))
		Case $AppF[145]
			If $AppF[145] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "145", ""), $SB_ANSI))
		Case $AppF[146]
			If $AppF[146] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "146", ""), $SB_ANSI))
		Case $AppF[147]
			If $AppF[147] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "147", ""), $SB_ANSI))
		Case $AppF[148]
			If $AppF[148] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "148", ""), $SB_ANSI))
		Case $AppF[149]
			If $AppF[149] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "149", ""), $SB_ANSI))
		Case $AppF[150]
			If $AppF[150] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "150", ""), $SB_ANSI))
		Case $AppF[151]
			If $AppF[151] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "151", ""), $SB_ANSI))
		Case $AppF[152]
			If $AppF[155] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "152", ""), $SB_ANSI))
		Case $AppF[153]
			If $AppF[155] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "153", ""), $SB_ANSI))
		Case $AppF[154]
			If $AppF[155] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "154", ""), $SB_ANSI))
		Case $AppF[155]
			If $AppF[155] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "155", ""), $SB_ANSI))
		Case $AppF[156]
			If $AppF[156] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "156", ""), $SB_ANSI))
		Case $AppF[157]
			If $AppF[157] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "157", ""), $SB_ANSI))
		Case $AppF[158]
			If $AppF[158] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "158", ""), $SB_ANSI))
		Case $AppF[159]
			If $AppF[159] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "159", ""), $SB_ANSI))
		Case $AppF[160]
			If $AppF[160] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "160", ""), $SB_ANSI))
		Case $AppF[161]
			If $AppF[161] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "161", ""), $SB_ANSI))
		Case $AppF[162]
			If $AppF[162] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "162", ""), $SB_ANSI))
		Case $AppF[163]
			If $AppF[163] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "163", ""), $SB_ANSI))
		Case $AppF[164]
			If $AppF[164] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "164", ""), $SB_ANSI))
		Case $AppF[165]
			If $AppF[165] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "165", ""), $SB_ANSI))
		Case $AppF[166]
			If $AppF[166] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "166", ""), $SB_ANSI))
		Case $AppF[167]
			If $AppF[167] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "167", ""), $SB_ANSI))
		Case $AppF[168]
			If $AppF[168] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "168", ""), $SB_ANSI))
		Case $AppF[169]
			If $AppF[169] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "169", ""), $SB_ANSI))
		Case $AppF[170]
			If $AppF[170] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "170", ""), $SB_ANSI))
		Case $AppF[171]
			If $AppF[171] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "171", ""), $SB_ANSI))
		Case $AppF[172]
			If $AppF[172] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "172", ""), $SB_ANSI))
		Case $AppF[173]
			If $AppF[173] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "173", ""), $SB_ANSI))
		Case $AppF[174]
			If $AppF[174] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "174", ""), $SB_ANSI))
		Case $AppF[175]
			If $AppF[175] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "175", ""), $SB_ANSI))
		Case $AppF[176]
			If $AppF[176] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "176", ""), $SB_ANSI))
		Case $AppF[177]
			If $AppF[177] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "177", ""), $SB_ANSI))
		Case $AppF[178]
			If $AppF[178] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "178", ""), $SB_ANSI))
		Case $AppF[179]
			If $AppF[179] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "179", ""), $SB_ANSI))
		Case $AppF[180]
			If $AppF[180] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "180", ""), $SB_ANSI))
		Case $AppF[181]
			If $AppF[181] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "181", ""), $SB_ANSI))
		Case $AppF[182]
			If $AppF[182] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "182", ""), $SB_ANSI))
		Case $AppF[183]
			If $AppF[183] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "183", ""), $SB_ANSI))
		Case $AppF[184]
			If $AppF[184] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "184", ""), $SB_ANSI))
		Case $AppF[185]
			If $AppF[185] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "185", ""), $SB_ANSI))
		Case $AppF[186]
			If $AppF[186] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "186", ""), $SB_ANSI))
		Case $AppF[187]
			If $AppF[187] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "187", ""), $SB_ANSI))
		Case $AppF[188]
			If $AppF[188] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "188", ""), $SB_ANSI))
		Case $AppF[189]
			If $AppF[189] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "189", ""), $SB_ANSI))
		Case $AppF[190]
			If $AppF[190] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "190", ""), $SB_ANSI))
		Case $AppF[191]
			If $AppF[191] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "191", ""), $SB_ANSI))
		Case $AppF[192]
			If $AppF[192] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "192", ""), $SB_ANSI))
		Case $AppF[193]
			If $AppF[193] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "193", ""), $SB_ANSI))
		Case $AppF[194]
			If $AppF[194] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "194", ""), $SB_ANSI))
		Case $AppF[195]
			If $AppF[195] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "195", ""), $SB_ANSI))
		Case $AppF[196]
			If $AppF[196] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "196", ""), $SB_ANSI))
		Case $AppF[197]
			If $AppF[197] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "197", ""), $SB_ANSI))
		Case $AppF[198]
			If $AppF[198] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "198", ""), $SB_ANSI))
		Case $AppF[199]
			If $AppF[199] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "199", ""), $SB_ANSI))
		Case $AppF[200]
			If $AppF[200] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "200", ""), $SB_ANSI))
		Case $AppF[201]
			If $AppF[201] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "201", ""), $SB_ANSI))
		Case $AppF[202]
			If $AppF[202] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "202", ""), $SB_ANSI))
		Case $AppF[203]
			If $AppF[203] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "203", ""), $SB_ANSI))
		Case $AppF[204]
			If $AppF[204] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "204", ""), $SB_ANSI))
		Case $AppF[205]
			If $AppF[205] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "205", ""), $SB_ANSI))
		Case $AppF[206]
			If $AppF[206] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "206", ""), $SB_ANSI))
		Case $AppF[207]
			If $AppF[207] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "207", ""), $SB_ANSI))
		Case $AppF[208]
			If $AppF[208] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "208", ""), $SB_ANSI))
		Case $AppF[209]
			If $AppF[209] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "209", ""), $SB_ANSI))
		Case $AppF[210]
			If $AppF[210] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "210", ""), $SB_ANSI))
		Case $AppF[211]
			If $AppF[211] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "211", ""), $SB_ANSI))
		Case $AppF[212]
			If $AppF[212] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "212", ""), $SB_ANSI))
		Case $AppF[213]
			If $AppF[213] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "213", ""), $SB_ANSI))
		Case $AppF[214]
			If $AppF[214] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "214", ""), $SB_ANSI))
		Case $AppF[215]
			If $AppF[215] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "215", ""), $SB_ANSI))
		Case $AppF[216]
			If $AppF[216] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "216", ""), $SB_ANSI))
		Case $AppF[217]
			If $AppF[217] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "217", ""), $SB_ANSI))
		Case $AppF[218]
			If $AppF[218] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "218", ""), $SB_ANSI))
		Case $AppF[219]
			If $AppF[219] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "219", ""), $SB_ANSI))
		Case $AppF[220]
			If $AppF[220] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "220", ""), $SB_ANSI))
		Case $AppF[221]
			If $AppF[221] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "221", ""), $SB_ANSI))
		Case $AppF[222]
			If $AppF[222] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "222", ""), $SB_ANSI))
		Case $AppF[223]
			If $AppF[223] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "223", ""), $SB_ANSI))
		Case $AppF[224]
			If $AppF[224] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "224", ""), $SB_ANSI))
		Case $AppF[225]
			If $AppF[225] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "225", ""), $SB_ANSI))
		Case $AppF[226]
			If $AppF[226] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "226", ""), $SB_ANSI))
		Case $AppF[227]
			If $AppF[227] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "227", ""), $SB_ANSI))
		Case $AppF[228]
			If $AppF[228] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "228", ""), $SB_ANSI))
		Case $AppF[229]
			If $AppF[229] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "229", ""), $SB_ANSI))
		Case $AppF[230]
			If $AppF[230] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "230", ""), $SB_ANSI))
		Case $AppF[231]
			If $AppF[231] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "231", ""), $SB_ANSI))
		Case $AppF[232]
			If $AppF[232] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "232", ""), $SB_ANSI))
		Case $AppF[233]
			If $AppF[233] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "233", ""), $SB_ANSI))
		Case $AppF[234]
			If $AppF[234] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "234", ""), $SB_ANSI))
		Case $AppF[235]
			If $AppF[235] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "235", ""), $SB_ANSI))
		Case $AppF[236]
			If $AppF[236] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "236", ""), $SB_ANSI))
		Case $AppF[237]
			If $AppF[237] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "237", ""), $SB_ANSI))
		Case $AppF[238]
			If $AppF[238] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "238", ""), $SB_ANSI))
		Case $AppF[239]
			If $AppF[239] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "239", ""), $SB_ANSI))
		Case $AppF[240]
			If $AppF[240] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "240", ""), $SB_ANSI))
		Case $AppF[241]
			If $AppF[241] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "241", ""), $SB_ANSI))
		Case $AppF[242]
			If $AppF[242] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "242", ""), $SB_ANSI))
		Case $AppF[243]
			If $AppF[243] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "243", ""), $SB_ANSI))
		Case $AppF[244]
			If $AppF[244] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "244", ""), $SB_ANSI))
		Case $AppF[245]
			If $AppF[245] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "245", ""), $SB_ANSI))
		Case $AppF[246]
			If $AppF[246] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "246", ""), $SB_ANSI))
		Case $AppF[247]
			If $AppF[247] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "247", ""), $SB_ANSI))
		Case $AppF[248]
			If $AppF[248] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "248", ""), $SB_ANSI))
		Case $AppF[249]
			If $AppF[249] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "249", ""), $SB_ANSI))
		Case $AppF[250]
			If $AppF[250] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "250", ""), $SB_ANSI))
		Case $AppF[251]
			If $AppF[251] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "251", ""), $SB_ANSI))
		Case $AppF[252]
			If $AppF[252] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "252", ""), $SB_ANSI))
		Case $AppF[253]
			If $AppF[253] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "253", ""), $SB_ANSI))
		Case $AppF[254]
			If $AppF[254] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "254", ""), $SB_ANSI))
		Case $AppF[255]
			If $AppF[255] <> "" Then ShellExecute(BinaryToString(IniRead($cfg, "ShellExecute", "255", ""), $SB_ANSI))
	EndSwitch
WEnd
