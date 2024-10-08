NB. graphviz window

WD=: 0 : 0
pc graphviz;
bin v;
bin h;
 splitv;
  cc wv webview;
  splitsep;
  bin h;
   cc Addr static;cn "File ";
   cc turl edit;
   cc gvmsglab static;cn " Message ";
   cc gvmsg edit;
   cc Generate button;cn "Generate ☝︎";
  bin z;
  cc sels tab;

  tabnew Source;
   cc src editm;

  tabnew Options;
   bin v;
    bin h;
     cc Prog static;cn "Program ";
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
  
 splitend;
bin z;
bin z;
)

fix00=: 3 : 0
'"',((LF;'" "')stringreplace y),'"'
)

graphviz_run=: 3 : 0
if. 0=checklibrary'' do. return. end.
graphviz ''
navigate 'data:,blank'
SRCNAME=: ''
if. LF e.y do. setshow y else. loader jpath y end.
gvlocate''
wd 'pshow;'
)

graphviz_close=: 3 : 0
wd 'pclose'
codestroy''
)

fixsl=: 3 : 0
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
wd'menu generate "Generate" "Ctrl+F5"'
wd'menupopz'
wd 'menupop "Help"'
wd'menu help "Contents" "Ctrl+F1"'
wd'menu helplic "License"'
NB. not yet in J8
NB. wd'menu helpsm "Sequential Machine Legend"'
NB. wd'menu helpsmlab "Sequential Machine Lab"'
NB. wd'menusep'
NB. wd'menu dotguide "Dot Guide"'
NB. wd'menu neatoguide "Neato Guide"'
wd'menusep'
wd'menu about "About"'
wd'menupopz'

wd 'set wv minwh 500 500'

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
  loader fname
  OLDDIR=: (( ]i:&PATHSEP){. ])fname
end.
)

graphviz_clean_button=: 3 : 0
r=. ":+/0>.ferase fpaths jpath'~temp/graphview_*'
wdinfo 'Cleaning ...';'Erased ',r,' temporary file(s)'
)

graphviz_generate_button=: 3 : 0
show src
)

graphviz_Generate_button=: graphviz_generate_button

graphviz_about_button=: navigate bind ('file:///',ADDONDIR,'/about.html')
graphviz_help_button=: navigate bind ('file:///',ADDONDIR,'/help.html')
graphviz_helplic_button=: navigate bind ('file:///',ADDONDIR,'/license.html')
graphviz_helpsm_button=: navigate bind ('file:///',ADDONDIR,'/doc/smlegend.gif')
graphviz_helpsmlab_button=: navigate bind ('file:///',ADDONDIR,'/doc/seq_lab.html')
graphviz_dotguide_button=: navigate bind ('file:///',ADDONDIR,'/doc/dotguide.html')
graphviz_neatoguide_button=: navigate bind ('file:///',ADDONDIR,'/doc/neatoguide.html')

graphviz_proghelp_button=: 3 : 0
navigate 'file:///',ADDONDIR,'/dot.html'
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

loader=: 3 : 0
if. 0=#y do. message TITLE return. end.
if. _1=s=. fread y do. error 'Reading file ',y return. end.
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
fname=. TEMPDIR,'/',TEMPFILE,(": ? 1e6),'.',FMT,ASTEXT
if. IFWIN do.
  cmdline=. '-T',FMT,' -o',unixpath fname
  ferase fname
  PROG=: selitem prog
  out=. y spawn_jtask_ ADDONDIR,'\bin\',PROG,' ',cmdline
else.
  tf=. TEMPDIR,'/gv',((-.@e.&' .')#])":6!:0''
  cmdline=. '-T',FMT,' -o',(unixpath fname),' "',tf,'" 2>"',tf,'.out"'
  ferase fname
  PROG=: selitem prog
  y fwrite tf
  if. UNAME-:'Darwin' do.
    if. (9!:56'cpu')-:'arm64' do.
      PROG=: '/opt/homebrew/bin/',PROG
    else.
      PROG=: '/usr/local/bin/',PROG
    end.
  end.
  spawn_jtask_,PROG,' ',cmdline
  out=. fread tf,'.out'
  ferase tf
  ferase tf,'.out'
end.
if. *#out do.
  wd 'set gvmsg text "',out,'"'
  if. 0=+/'WARNING' E. toupper out do. return. end.
end.
if. 0=fexist fname do. error 'Nothing is generated' return. end.
navigate 'file:///',fname
)

NB. =========================================================
gvlocate=: 3 : 0
if. IFWIN do. OLDDIR=: jpath '~addons/graphics/graphviz'
elseif. UNAME-:'Darwin' do.
  if. (9!:56'cpu')-:'arm64' do.
    OLDDIR=:'/opt/homebrew/share/graphviz/graphs'
  else.
    OLDDIR=:'/usr/local/share/graphviz/graphs'
  end.
elseif. +/'Ubuntu' E. spawn_jtask_'uname -a' do. OLDDIR=: '/usr/share/doc/graphviz/examples/graphs'
elseif. +/'CentOS' E. spawn_jtask_'lsb_release -a' do. OLDDIR=: '/usr/share/graphviz/graphs'
elseif. 1 do. OLDDIR=: jpath '~addons/graphics/graphviz'
end.
)

NB. =========================================================
checklibrary=: 3 : 0
if. -.IFWIN do. 1 return. end.
if. fexist '~addons/graphics/graphviz/bin/gvc.dll' do. 1 return. end.
if. 0=checkaccess'' do. return. end.
msg=. 'The graphviz binaries have not yet been installed.',LF2,'To install, '
msg=. msg, ' run the getbin_pgraphview_'''' line written to the session.'
smoutput '   getbin_pgraphview_'''''
sminfo 'Graphviz';msg
0
)

NB. =========================================================
NB. check for needed access
NB. uses routines from pacman
checkaccess=: 3 : 0
if. -.IFWIN do. 1 return. end.
if. fexist '~addons/graphics/graphviz/bin/gvc.dll' do. 1 return. end.
require 'pacman'
if. testaccess_jpacman_'' do. 1 [ HASFILEACCESS_jpacman_=: 1 return. end.
msg=. 'You need to install the graphviz libraries.  This requries access to the J directories.  Exit and restart JQT as administrator to get access to the installation folder.'
if. IFWIN do.
  msg=. msg,LF2,'To run as Administrator, right-click the JQT icon, select Run as... and '
  msg=. msg,'then select Adminstrator.'
else.
  msg=. msg,LF2,'To run as root, open a terminal and use sudo to run J.'
end.
info_jpacman_ msg
0
)

NB. =========================================================
NB. get graphviz binaries
NB. uses routines from pacman
getbin=: 3 : 0
require 'pacman'
arg=. HTTPCMD_jpacman_
tm=. TIMEOUT_jpacman_
dq=. dquote_jpacman_ f.
fm=. 'http://graphviz.gitlab.io/_pages/Download/windows/graphviz-2.38.zip'
mkdir_j_ jpath '~temp/graphviz'
lg=. jpath '~temp/getbin.log'
temp=. jpath '~temp/graphviz'
to=. temp,'/graphviz.zip'
cmd=. arg rplc '%O';(dq to);'%L';(dq lg);'%t';'3';'%T';(":tm);'%U';fm
res=. ''
fail=. 0
try.
  fail=. _1-: res=. shellcmd_jpacman_ cmd
catch. fail=. 1 end.
if. fail +. 0 >: fsize to do.
  if. _1-:msg=. freads lg do.
    if. (_1-:msg) +. 0=#msg=. res do. msg=. 'Unexpected error' end. end.
  ferase to;lg
  smoutput 'Connection failed: ',msg
  return.
end.
ferase lg
shellcmd_jpacman_ UNZIP_jpacman_,to,' -d ',temp
dircopy_jpacman_ (temp,'/release/bin');jpath '~addons/graphics/graphviz/bin'
dircopy_jpacman_ (temp,'/release/fonts');jpath '~addons/graphics/graphviz/fonts'
dircopy_jpacman_ (temp,'/release/share/graphviz/graphs');jpath '~addons/graphics/graphviz/graphs'
dircopy_jpacman_ (temp,'/release/share/graphviz/doc');jpath '~addons/graphics/graphviz/doc'
deltree_jpacman_ jpath '~temp/graphviz'
smoutput 'Graphviz binaries installed.'
)
