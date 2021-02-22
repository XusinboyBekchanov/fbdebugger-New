''gui for fbdebuuger_new
''dbg_gui.bas

''Loading of buttons
sub load_button(id as integer,button_name as zstring ptr,xcoord as integer,tooltiptext as zstring ptr=0,idtooltip as integer=-1,disab as long=1)
	Var HIMAGE=Load_image(*button_name)
	ButtonImageGadget(id,xcoord,0,30,26,HIMAGE,  BS_BITMAP)
	if tooltiptext then
		if idtooltip<>-1 then
			GadgetToolTip(id,*tooltiptext,idtooltip)
		else
			GadgetToolTip(id,*tooltiptext)
		endif
	end if
	disablegadget(id,disab)
end sub

sub line_color(byval pline as integer,byval style as ulong)
	var begpos=Send_sci(SCI_POSITIONFROMLINE,pline-1,0)
	var endpos=Send_sci(SCI_GETLINEENDPOSITION,pline-1,0)
	'begin styling at pos=c
	Send_sci(SCI_StartStyling, begpos, 0)
	 'style next chars with style #x
	Send_sci(SCI_SetStyling, endpos-begpos,style)
end sub
''''''======================================
function create_sci2(byval wind as hwnd,byval gadget as long) as hwnd
	
var result = DyLibLoad ( "D:\laurent_divers\fb dev\En-cours\FBDEBUG NEW\asm64_via_llvm\test_a_garder/Scintilla" )
print "dll=";result
dim as hwnd editor_win 
	
	
dim as RECT rc
dim as wstring *50 wstrg =wstr("TEST SCINTILLA")
'dim as byte ptr bptr=strptr(wstrg)
'print bptr
'for i as integer =0 to 15:print bptr[i]:next
print "create",len(wstrg)
       GetClientRect(wind, @rc)
		'WS_SIZEBOX      Or _
		' WS_CAPTION or WS_SYSMENU or WS_MAXIMIZEBOX or WS_MINIMIZEBOX or  WS_POPUP, _
		editor_win = createwindowex(0,"Scintilla", wstrg, _
		WS_CHILD or WS_VSCROLL or WS_HSCROLL or WS_CLIPCHILDREN , _
		0,65,400,rc.bottom-90,_
		wind,Cast(HMENU,CInt(gadget)),GetModuleHandle(0), 0)
		
		'print rc.left, rc.top,rc.right,rc.bottom
		'print "editor=";editor_win,getlasterror
       	
       
		SendMessage(editor_win,SCI_SETMARGINTYPEN,0,SC_MARGIN_NUMBER )
		sendmessage(editor_win,SCI_SETMARGINWIDTHN,0,40)
		SendMessage(editor_win,SCI_SETMARGINTYPEN,1,SC_MARGIN_SYMBOL )
		SendMessage(editor_win,SCI_SETMARGINWIDTHN,1,12)
		SendMessage(editor_win,SCI_SETFOLDMARGINCOLOUR,0,BLACK_BRUSH )
		showwindow(editor_win , SW_SHOW)
		win9AddNewGadget(gadget,editor_win)
		
		
		
		'Set default FG/BG
		SendMessage editor_win, SCI_SetLexer, SCLEX_Null, 0
		SendMessage editor_win, SCI_StyleSetFore, Style_Default, &h404040'&h0 ''writes in black KBLUE
		SendMessage editor_win, SCI_StyleSetBack, Style_Default, &hFFFFFF 'white background
		SendMessage editor_win, SCI_StyleClearAll, 0, 0     'set all styles to style_default
		

		SendMessage editor_win, SCI_MarkerDefine, 0,SC_MARK_CIRCLE
		SendMessage editor_win, SCI_MarkerDefine, 1,SC_MARK_FULLRECT
		SendMessage editor_win, SCI_MarkerDefine, 2,SC_MARK_ARROW
		SendMessage editor_win, SCI_MarkerDefine, 3,SC_MARK_SMALLRECT
		SendMessage editor_win, SCI_MarkerDefine, 4,SC_MARK_SHORTARROW
		sendmessage editor_win, SCI_MarkerDefine, 5,SC_MARK_CHARACTER+65

		SendMessage editor_win,SCI_MARKERSETFORE,0,KBLUE
		SendMessage editor_win,SCI_MARKERSETBACK,0,KBLUE
		sendmessage editor_win,SCI_MARKERSETFORE,1,KRED
		SendMessage editor_win,SCI_MARKERSETBACK,1,KRED
		sendmessage editor_win,SCI_MARKERSETFORE,2,KRED
		SendMessage editor_win,SCI_MARKERSETBACK,2,KRED
		sendmessage editor_win,SCI_MARKERSETFORE,3,KORANGE
		SendMessage editor_win,SCI_MARKERSETBACK,3,KORANGE
		
		dim txt As String
		txt = "Dim as integer test_var ''dummy code" + chr(13) + "If x = 2 Then" + chr(13) + "   'do nothing" + chr(13)
		txt = txt + "Else" + chr(13) + "   x = 0" + chr(13) + "End If" + Chr$(0)
		SendMessage editor_win, SCI_SetText, 0, cast(lparam,strptr(txt))
		
		SendMessage editor_win, SCI_StyleSetFore, 2, KRED   'style #2 FG set to red
		SendMessage editor_win, SCI_StyleSetBack, 2, KYELLOW 'style #2 BB set to green

		'line_color(editor_win,5,2)
	   For imark as Integer = 0 To 5
	      SendMessage editor_win, SCI_SetMarginMaskN, 1,-1  'all symbols allowed
	      SendMessage editor_win, SCI_MarkerAdd, imark, imark       'line, marker#
	   Next
		
	return editor_win
end function
''======================================
''create scintilla windows
function create_sci(byval wind as hwnd,byval gadget as long) as hwnd
	
	var result = DyLibLoad ( "D:\laurent_divers\fb dev\En-cours\FBDEBUG NEW\asm64_via_llvm\test_a_garder/Scintilla" )

	dim as hwnd editor_win 
	
	dim as RECT rc
	GetClientRect(wind, @rc)
	'WS_SIZEBOX      Or _
	' WS_CAPTION or WS_SYSMENU or WS_MAXIMIZEBOX or WS_MINIMIZEBOX or  WS_POPUP, _
	editor_win = createwindowex(0,"Scintilla","", _
	WS_CHILD or WS_VSCROLL or WS_HSCROLL or WS_CLIPCHILDREN , _
	0,65,400,rc.bottom-90,_
	wind,Cast(HMENU,CInt(gadget)),GetModuleHandle(0), 0)
	scint=editor_win
	'print rc.left, rc.top,rc.right,rc.bottom
	'print "editor=";editor_win,getlasterror
		
		'sendmessage(editor_win,SCI_SETMARGINTYPEN,0,SC_MARGIN_NUMBER )
		'sendmessage(editor_win,SCI_SETMARGINWIDTHN,0,40)
		'SendMessage(editor_win,SCI_SETMARGINTYPEN,1,SC_MARGIN_SYMBOL )
		'SendMessage(editor_win,SCI_SETMARGINWIDTHN,1,12)
		'SendMessage(editor_win,SCI_SETFOLDMARGINCOLOUR,0,BLACK_BRUSH )
	send_sci(SCI_SETMARGINTYPEN,0,SC_MARGIN_NUMBER )
	send_sci(SCI_SETMARGINWIDTHN,0,40)
	send_sci(SCI_SETMARGINTYPEN,1,SC_MARGIN_SYMBOL )
	send_sci(SCI_SETMARGINWIDTHN,1,12)
	send_sci(SCI_SETFOLDMARGINCOLOUR,0,BLACK_BRUSH )
	
	win9AddNewGadget(gadget,editor_win)

	'Set default FG/BG
	send_sci(SCI_SetLexer, SCLEX_Null, 0)
	send_sci(SCI_StyleSetFore, Style_Default, &h404040)''grey
	send_sci(SCI_StyleSetBack, Style_Default, &hFFFFFF) ''white background
	send_sci(SCI_StyleClearAll, 0, 0)     ''set all styles to style_default
	
	''markers
	send_sci(SCI_MarkerDefine, 0,SC_MARK_CIRCLE)
	send_sci(SCI_MarkerDefine, 1,SC_MARK_FULLRECT)
	send_sci(SCI_MarkerDefine, 2,SC_MARK_ARROW)
	send_sci(SCI_MarkerDefine, 3,SC_MARK_SMALLRECT)
	send_sci(SCI_MarkerDefine, 4,SC_MARK_SHORTARROW)
	send_sci(SCI_MarkerDefine, 5,SC_MARK_CHARACTER+65)
	''color markers
	send_sci(SCI_MARKERSETFORE,0,KBLUE)
	send_sci(SCI_MARKERSETBACK,0,KBLUE)
	send_sci(SCI_MARKERSETFORE,1,KRED)
	send_sci(SCI_MARKERSETBACK,1,KRED)
	send_sci(SCI_MARKERSETFORE,2,KRED)
	send_sci(SCI_MARKERSETBACK,2,KRED)
	send_sci(SCI_MARKERSETFORE,3,KORANGE)
	send_sci(SCI_MARKERSETBACK,3,KORANGE)
	
	send_sci(SCI_StyleSetFore, 2, KRED)    ''style #2 FG set to red
	send_sci(SCI_StyleSetBack, 2, KYELLOW) ''style #2 BB set to green

	for imark as Integer = 0 To 5
	    send_sci(SCI_SetMarginMaskN, 1,-1)  ''all symbols allowed
	next
	
	return editor_win
end function
private sub gui_init

	''main windows
	mainwindow=OpenWindow("New FBDEBUGGER with window9 :-)",10,10,1100,500)
	
	''scintilla gadget
	scint=create_sci(mainwindow,GSCINTILLA)

	''source panel
	'Var font=LoadFont("Arial",40)

	PanelGadget(GSRCTAB,2,42,400,20)
    SetGadgetFont(GSRCTAB,CINT(LoadFont("Courier New",11)))	
		
	''file combo/buuton ''idee mettre dans le menu affichage de la liste (du combo)
	ComboBoxGadget(GFILELIST,790,0,200,80)
	ButtonGadget(GFILESEL,992,2,30,20,"Go")
	
	''status bar
	StatusBarGadget(1,"")
	SetStatusBarField(1,0,100,"Status")
	SetStatusBarField(1,1,200,"Thread number")
	setstatusbarfield(1,2,-1,"Current file")
	
	''current line
	textGadget(GCURRENTLINE,2,28,400,20,"Next exec line : ",SS_NOTIFY )
	GadgetToolTip(GCURRENTLINE,"next executed line"+chr(13)+"Click on me to reach the line",GCURLINETTIP)


	''buttons
	load_button(IDBUTSTEP,@".\buttons\step.bmp",8,@"[S]tep/line by line",)
	load_button(IDCONTHR,@".\buttons\runto.bmp",40,@"Run to [C]ursor",)
	load_button(IDBUTSTEPP,@".\buttons\step_over.bmp",72,@"Step [O]ver sub/func",)
	load_button(IDBUTSTEPT,@".\buttons\step_start.bmp",104,@"[T]op next called sub/func",)
	load_button(IDBUTSTEPB,@".\buttons\step_end.bmp",136,@"[B}ottom current sub/func",)
	load_button(IDBUTSTEPM,@".\buttons\step_out.bmp",168,@"[E]xit current sub/func",)
	load_button(IDBUTAUTO,@".\buttons\auto.bmp",200,@"Step [A]utomatically, stopped by [H]alt",)
	load_button(IDBUTRUN,@".\buttons\run.bmp",232,@"[R]un, stopped by [H]alt",)
	load_button(IDBUTSTOP,@".\buttons\stop.bmp",264,@"[H]alt running pgm",)
	load_button(IDFASTRUN,@".\buttons\fastrun.bmp",328,@"[F]AST Run to cursor",)
	load_button(IDEXEMOD,@".\buttons\exemod.bmp",360,@"[M]odify execution, continue with line under cursor",)
	load_button(IDBUTFREE,@".\buttons\free.bmp",392,@"Release debuged prgm",)
	load_button(IDBUTKILL,@".\buttons\kill.bmp",424,@"CAUTION [K]ill process",)
	load_button(IDBUTRRUNE,@".\buttons\restart.bmp",466,@"Restart debugging (exe)",,0)
	load_button(IDLSTEXE,@".\buttons\multiexe.bmp",498,@"Last 10 exe(s)",,0)
	load_button(IDBUTATTCH,@".\buttons\attachexe.bmp",530,@"Attach running program",,0)
	load_button(IDBUTFILE,@".\buttons\files.bmp",562,@"Select EXE/BAS",,0)
	load_button(IDNOTES,@".\buttons\notes.bmp",600,@"Open or close notes",,0)
	''missing line for the icon of the second notes
	load_button(IDBUTTOOL,@".\buttons\tools.bmp",632,"Some usefull....Tools",,0)
	load_button(IDUPDATE,@".\buttons\update.bmp",663,@"Update On /Update off : variables, dump",,0)
	load_button(ENLRSRC,@".\buttons\source.bmp",690,@"Enlarge/reduce source",)
	load_button(ENLRVAR,@".\buttons\varproc.bmp",720,@"Enlarge/reduce proc/var",)
	load_button(ENLRMEM,@".\buttons\memory.bmp",750,@ "Enlarge/reduce dump memory",)
	
	''bmb(25)=Loadbitmap(fb_hinstance,Cast(LPSTR,MAKEINTRESOURCE(1025))) 'if toogle noupdate
	''no sure to implement this one	 
	''load_button(IDBUTMINI,@".\buttons\minicmd.bmp",296,@ "Mini window",)
	
	''icon on title bar
	''-----> ONLY WINDOWS
	'Var icon=LoadIcon(null,@"D:\telechargements\win9\tmp\fbdebugger.ico")
	'print icon,getlasterror()
	'    'SendMessage(hwnd,WM_SETICON,ICON_BIG,Cast(Lparam,icon))
	'    sendmessage(hwnd,WM_SETICON,ICON_SMALL,Cast(Lparam,LoadIcon(GetModuleHandle(0),@".\fbdebugger.ico")))
	'Var icon=LoadIcon(GetModuleHandle(0),MAKEINTRESOURCE(100))
	'  SendMessage(hwnd,WM_SETICON,ICON_BIG,Cast(Lparam,icon))
	'  SendMessage(hwnd,WM_SETICON,ICON_SMALL,Cast(Lparam,icon))
	'D:\telechargements\win9\tmp\
	var icon=loadimage(0,@"fbdebugger.ico",IMAGE_ICON,0,0,LR_LOADFROMFILE or LR_DEFAULTSIZE)
	sendmessage(mainwindow,WM_SETICON,ICON_BIG,Cast(Lparam,icon))
	
	''right panels
	PanelGadget(GRIGHTTABS,500,30,499,300)
	SetGadgetFont(GRIGHTTABS,CINT(LoadFont("Courier New",11)))
	''treeview proc/var
	var htabvar=AddPanelGadgetItem(GRIGHTTABS,0,"Proc/var",,1)
	'var hbmp = load_Icon("1.ico")
	'var hbmp1 = load_Icon("2.ico")	
	treeviewgadget(GTVIEWVAR,0,0,499,299,KTRRESTYLE)
	''filling treeview for example
	var Pos_=AddTreeViewItem(GTVIEWVAR,"Myvar udt ",0,0,0)
	AddTreeViewItem(GTVIEWVAR,"first field",0,0,1,Pos_)
	Pos_=AddTreeViewItem(GTVIEWVAR,"my second var",0,0,0)
	AddTreeViewItem(GTVIEWVAR,"first field",0,0,0,Pos_)
	
	HideWindow(htabvar,0)
	''treeview procs
	var htabprc=AddPanelGadgetItem(GRIGHTTABS,1,"Procs",,1)
	treeviewgadget(GTVIEWPRC,0,0,499,299,KTRRESTYLE)
	AddTreeViewItem(GTVIEWPRC,"first proc",0,0,0)
	AddTreeViewItem(GTVIEWPRC,"second proc",0,0,0)
	AddTreeViewItem(GTVIEWPRC,"third proc",0,0,0)
	''treeview threads
	var htabthrd=AddPanelGadgetItem(GRIGHTTABS,2,"Threads")
	''treeview watched
	var htabwatch=AddPanelGadgetItem(GRIGHTTABS,3,"Watched")
	
	''dump memory
	var htabmem=AddPanelGadgetItem(GRIGHTTABS,4,"Memory",,1)
	ListViewGadget(GDUMPMEM,0,0,499,299,LVS_EX_GRIDLINES)
	AddListViewColumn(GDUMPMEM, "Address",0,0,100)
	for icol as integer =1 to 4
		AddListViewColumn(GDUMPMEM, "+0"+str((icol-1)*4),icol,icol,40)
	next
	AddListViewColumn(GDUMPMEM, "Ascii value",5,5,100)
	
end sub
