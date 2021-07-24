!include nsDialogs.nsh
!include LogicLib.nsh
;!insertmacro MUI_LANGUAGE "SimpChinese"

XPStyle on

Var Dialog
Var Checkbox_State
Var Checkbox

Page custom myCustomPage nsDialogsPageLeave
;Page instfiles
Function myCustomPage
    nsDialogs::Create 1018
    Pop $Dialog

    ${If} $Dialog == error
        Abort
    ${EndIf}
	
	${NSD_CreateCheckbox} 20 20 15 15 ""
	Pop $Checkbox
	${NSD_UNCheck} $Checkbox
	${NSD_CreateLabel} 42 25 100 15 "屏蔽其他软件使用"
    nsDialogs::Show

FunctionEnd
Section
SectionEnd
!macro preInit
	SetRegView 64
	WriteRegExpandStr HKLM "${INSTALL_REGISTRY_KEY}" InstallLocation "D:\dfdz"
	WriteRegExpandStr HKCU "${INSTALL_REGISTRY_KEY}" InstallLocation "D:\dfdz"
	SetRegView 32
	WriteRegExpandStr HKLM "${INSTALL_REGISTRY_KEY}" InstallLocation "D:\dfdz"
	WriteRegExpandStr HKCU "${INSTALL_REGISTRY_KEY}" InstallLocation "D:\dfdz"
!macroend

Function nsDialogsPageLeave
	${NSD_GetState} $Checkbox $Checkbox_State
	${If} $Checkbox_State == ${BST_CHECKED}
		MessageBox MB_OK "确定屏蔽其他软件使用"
		WriteRegDWORD HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "RestrictRun" "00000001"
		WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "1" "Regedit.exe"
		WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "2" "Notepad.exe"
		WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "3" "默认.exe"
		WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "4" "默认.exe"
		WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "5" "setup_kk_Ext_20_0010.exe"
		WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "6" "默认.exe"
		WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "7" "默认安装包.exe"
		WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "8" "TypeEasy.exe"
	${Else}
		MessageBox MB_OK "确定不屏蔽其他软件"
		WriteRegDWORD HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "RestrictRun" "00000000"
	${EndIf}
FunctionEnd

!define MUI_FINISHPAGE_TITLE "默认安装完毕，请重启电脑后使用！"


