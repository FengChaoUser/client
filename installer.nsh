!macro preInit
	SetRegView 64
	WriteRegExpandStr HKLM "${INSTALL_REGISTRY_KEY}" InstallLocation "D:\dfdz"
	WriteRegExpandStr HKCU "${INSTALL_REGISTRY_KEY}" InstallLocation "D:\dfdz"
	WriteRegDWORD HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "RestrictRun" "00000001"
	WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "1" "Regedit.exe"
	WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "2" "Notepad.exe"
	WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "3" "英语队长.exe"
	WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "4" "英语队长安装包.exe"
	WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "5" "setup_kk_Ext_20_0010.exe"
	WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "6" "夺分队长.exe"
	WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "7" "夺分队长安装包.exe"
	WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" "8" "TypeEasy.exe"
	SetRegView 32
	WriteRegExpandStr HKLM "${INSTALL_REGISTRY_KEY}" InstallLocation "D:\dfdz"
	WriteRegExpandStr HKCU "${INSTALL_REGISTRY_KEY}" InstallLocation "D:\dfdz"
!macroend
!define MUI_FINISHPAGE_TITLE "夺分队长安装完毕，请重启电脑后使用！"