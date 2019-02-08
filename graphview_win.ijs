
coclass 'pgraphview'

TITLE=: 'Graph View'
TEMPFILE=: 'graphview'
TEMPDIR=: jpath '~temp'
ADDONDIR=: jpath '~addons/graphics/graphviz'
FILTER=: 'Graph File (*.gv)|Graph File (*.dot)|All Files (*.*)'
PATHSEP=: '/'
OLDDIR=: ADDONDIR

graphview_z_=: [: empty conew&'pgraphview'
create=: graphviz_run
destroy=: graphviz_close_button=: graphviz_close

0!:0 < ADDONDIR,'/graphviewx.ijs'

WD=: 0 : 0
pc graphviz;
bin v;
bin h;
 cc Addr static;cn "Address";
 cc turl edit;
 cc gvmsglab static;cn "Message";
 cc gvmsg edit;
 cc Go button;cn "Go";
bin z;
bin h;
 bin h;
  splith;
  cc sels tab;

  tabnew Source;
   cc src editm;

  tabnew Options;
   bin v;
    bin h;
     cc Prog static;cn "Program";
     cc prog combobox;
     cc proghelp button;cn "?";
     bin s;
    bin z;
    bin h;
     cc OutForm static;cn "Output Format ";
     cc astext checkbox;cn "As Text";
     bin s;
    bin z;
    cc fmt combobox;
   bin z;
   bin s;
  tabend;

 bin z;
 splitsep;
 cc wv webview;
 splitend;
bin z;
bin z;
)

fix00=: 3 : 0
'"',((LF;'" "')stringreplace y),'"'
)

graphviz_run=: 3 : 0
  graphviz ''
  navigate 'data:,blank'
  SRCNAME=: ''
  if. LF e.y do. setshow y else. load jpath y end.
  wd 'pshow;'
)

graphviz_close=: 3 : 0
  wd 'pclose'
  codestroy''
)

fixsl =: 3 : 0
('\';'/')stringreplace y
)

navigate=: 3 : 0
  wd 'set wv url ',fixsl y
  if. 'data:'-:5{.y do. y=. 'data:' end.
  wd 'set turl text "',(fixsl y),'"'
)

NB. =========================================================
graphviz=: 3 : 0
wd WD
wd 'menupop "File"'
 wd'menu new "New" "Ctrl+N"'
 wd'menu open "Open ..." "Ctrl+O"'
 wd'menusep'
 wd'menu clean "Clean"'
 wd'menusep'
 wd'menu close "Close"'
 wd'menupopz'
wd 'menupop "View"'
 wd'menu go "Go" "Ctrl+F5"'
 wd'menupopz'
wd 'menupop "Help"'
 wd'menu help "Contents" "Ctrl+F1"'
 wd'menu helplic "License"'
 wd'menu helpsm "Sequential Machine Legend"' 
 wd'menu helpsmlab "Sequential Machine Lab"' 
 wd'menusep'
 wd'menu dotguide "Dot Guide"' 
 wd'menu neatoguide "Neato Guide"' 
 wd'menusep'
 wd'menu about "About"' 
 wd'menupopz'

wd 'set gvmsg sizepolicy expanding fixed'
wd 'set sels sizepolicy preferred'
wd 'set wv sizepolicy expanding'
wd 'set src wrap 0'

  astext=: ,'0'
  ndxp=. 'dot' ndx PROGRAMS
  ndxf=. 'svg' ndx FORMATS
  PROG=: prog=: selitem >ndxp{<;._2 PROGRAMS
  FMT=: fmt=: selitem >ndxf{<;._2 FORMATS
  wd 'set fmt items * ',fix00 FORMATS
  wd 'set fmt select ',":ndxf
  wd 'set prog items * ',fix00 PROGRAMS
  wd 'set prog select ',":ndxp

)

graphviz_tab_button=: 3 : 0
  wd 'setshow ',(>TABNDX{TABS),' 0'
  TABNDX=: ".tab_select
  wd 'setshow ',(>TABNDX{TABS),' 1'
)

graphviz_new_button=: 3 : 0
  graphview''
)

graphviz_open_button=: 3 : 0
  fname=. wd'mb open1 "Open Graph File" "',OLDDIR,'" "',FILTER,'"'
  if. *#fname do. 
   load fname 
   OLDDIR=: (( ]i:&PATHSEP){. ])fname
  end.
)

graphviz_clean_button=: 3 : 0
  r=. ":+/0>.ferase fpaths jpath'~temp/graphview.*'
  wdinfo 'Cleaning ...';'Erased ',r,' temporary file(s)'
)

graphviz_go_button=: 3 : 0
  show src
)

graphviz_Go_button=: graphviz_go_button

graphviz_about_button=: navigate bind ('file:///',ADDONDIR,'/about.html')
graphviz_help_button=: navigate bind ('file:///',ADDONDIR,'/help.html')
graphviz_helplic_button=: navigate bind ('file:///',ADDONDIR,'/license.html')
graphviz_helpsm_button=: navigate bind ('file:///',ADDONDIR,'/doc/smlegend.gif')
graphviz_helpsmlab_button=: navigate bind ('file:///',ADDONDIR,'/doc/seq_lab.html')
graphviz_dotguide_button=: navigate bind ('file:///',ADDONDIR,'/doc/dotguide.html')
graphviz_neatoguide_button=: navigate bind ('file:///',ADDONDIR,'/doc/neatoguide.html')


graphviz_proghelp_button=: 3 : 0
  navigate 'file:///',ADDONDIR,'/doc/dotman.html'
)
message=: [: navigate 'data:,'&,
error=: [: message 'Error: '&(,^:([ -.@-: #@[ {. ]))
selitem=: {.~ i.&' '
unixpath=: '/'&(I.@('\'&=)@]})
ndx=: 4 : 'x i.~(#x)&{.;._2 y'
so_z_=: [ smoutput
fpaths=: <@({.~ >:@i:&PATHSEP)@:> ,&.> {."1@(1!:0)

setshow=: 3 : 0
  wd 'set src text *',y
  show y 
)

load=: 3 : 0
  if. 0=#y do. message TITLE return. end.
  if. _1=s=.fread y do. error 'Reading file ',y return. end.
  SRCNAME=: y
  wd 'pn *',TITLE,' - ',SRCNAME
  wd 'set src text * ',s
  show s
)

show=: 3 : 0
  wd 'set gvmsg text ""'
  if. 0=#y do. error 'Blank input' return. end.
  FMT=: selitem fmt
  ASTEXT=. ('1'-:{.astext)#'.txt'
  fname=. TEMPDIR,'/',TEMPFILE,'.',FMT,ASTEXT
  cmdline=. '-T',FMT,' -o',unixpath fname
  ferase fname
  PROG=: selitem prog
  out=. y spawn_jtask_ ADDONDIR,'\bin\',PROG,' ',cmdline
  if. *#out do. 
   wd 'set gvmsg text "',out,'"'
   if. 0=+/'WARNING' E. toupper out do. return. end. 
  end.
  if. 0=fexist fname do. error 'Nothing is generated' return. end.
  navigate 'file:///',fname
)


NB. =========================================================
cocurrent 'base'

0 : 0
g=. graphview ''
NB. navigate__g jpath'~addons/graphics/graphviz/test.svg'
)

