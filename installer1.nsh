!include nsDialogs.nsh
!include LogicLib.nsh
XPStyle on
Var Dialog
Var Label
Var Text
Page custom nsDialogsPage nsDialogsPageLeave
Page instfiles
Function nsDialogsPage
	nsDialogs::Create /NOUNLOAD 1018
	Pop $Dialog
	${If} $Dialog == error
	Abort
	${EndIf}
	${NSD_CreateLabel} 0 0 100% 12u "Hello, welcome to nsDialogs!"
	Pop $Label
	${NSD_CreateText} 0 13u 100% -13u "Type something here..."
	Pop $Text
	${NSD_OnChange} $Text nsDialogsPageTextChange
	nsDialogs::Show
FunctionEnd
Function nsDialogsPageLeave
	${NSD_GetText} $Text $0
	MessageBox MB_OK "You typed:"
FunctionEnd
Function nsDialogsPageTextChange
	Pop $1 # $1 == $ Text
	${NSD_GetText} $Text $0
	${If} $0 == "hello"
		MessageBox MB_OK "right back at ya!"
	${EndIf}
FunctionEnd
Section
	DetailPrint "hello world"
SectionEnd
