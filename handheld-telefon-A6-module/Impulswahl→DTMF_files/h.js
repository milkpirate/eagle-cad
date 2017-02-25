// Common style support for ~heha web pages
// This script should run on any browser (to be checked)
// The web pages using this script should also have these (optional) content:

// <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
//	Page must be UTF-8 encoded

// <meta name=date content="1996-01-23">
//	This is the creation date, for the footer

// <link rel=alternate href="index.de.htm">
//	Available language versions of this page; a language selection bar will be created

// <link rel=next href="../Piezomess/">
//	The next recommended page for linear navigation

// <link rel=stylesheet href="h.css">
//	Some formatting relies on that style sheet

// Show a link to content frame if not in a frameset
// For use at top of document
"use strict";

function info(link,text) {
if (top == self)
  document.writeln("<A href='"+link+"' target=_top>"+text+"</A>");
}

// Global variable for language detection
var lang;

// External link, show an icon, and open in a new window?
function e_de(url,text) {
 document.write("<IMG src='icons/extern.gif' align=top alt=''> <A href='"+url+"'>"+text+"</A>");
}

function E_de(url,tip,text) {
 document.write("<IMG src='icons/extern.gif' align=top alt=''> <A href='"+url+"' title='"+tip+"'>"+text+"</A>");
}

function strDateFormat(y,m,d) {
 y=parseInt(y,10);
 m=parseInt(m,10);
 d=parseInt(d,10);	// führende Nullen entfernen
 switch (lang) {
  case "en":
  var mo=new Array("January","February","March","April","May","June","July","August","September","October","November","December");
  return mo[m-1]+" "+d+". "+y;
  case "jp":
  case "cn":
  return y+"年"+m+"月"+d+"日";
  default:
  var mo=new Array("Januar","Februar","März","April","Mai","Juni","Juli","August","September","Oktober","November","Dezember");
  return d+". "+mo[m-1]+" "+y;
 }
}

function strErstellt() {
 switch (lang) {
  case "en": return "created";
  case "jp": return "作成日";
  case "cn": return "创建日期";
  default: return "erstellt";
 }
}

function strAenderung() {
 switch (lang) {
  case "en": return "last modified";
  case "jp": return "最終更新日";
  case "cn": return "上次修改日期";
  default: return "letzte Änderung";
 }
}

function strOhneTitel() {
 switch (lang) {
  case "en": return "unnamed";
  default: return "ohne Name";
 }
}

// <creat> in der Form yymmdd (Zahl) oder "yyyy-mm-dd" (String)
function address(creat) {
 var s="<a href='email?"+document.title+"'>Henrik Haftmann</a>, ";
 switch (typeof(creat)) {
  case "string": s+=strErstellt()+": "+strDateFormat(creat.substr(0,4),creat.substr(5,2),creat.substr(8,2))+" — "; break;
  case "number": s+=strErstellt()+": "+strDateFormat((Math.floor(creat/10000)+2000),Math.floor(creat/100)%100,creat%100)+" — "; break;
 }
 var time=document.lastModified;	// in der Form "mm/dd/yyyy HH:MM:SS"
 s+=strAenderung()+": "+strDateFormat(time.substr(6,4),time.substr(0,2),time.substr(3,2));
 return s;
}

// Setze Bild auf URL (ID fest = 'B')
// Nur für ein Bild pro HTML-Datei! (Veraltet!)
function Bild(name) {
 document.getElementById('B').src=name;
}

var MultiBildNr=0;
// Umformen von <ul><li><a href=bildname.ext>text</a>
// in <table><tr><td><img src=erstesbild.ext><td><p class=roundbox><input...>
function MultiBild(uls) {
 ++MultiBildNr;
 var s="";
 var pic1=null;
 var extra=" "+uls[0].getAttribute("extra");
 for (var h=0; h<uls.length; h++) {
  s+="<p class=roundbox>\n";	// eine Box beginnt mit jenem <ul>
  var subttl=uls[h].innerHTML;
  var e=subttl.toLowerCase().indexOf("<li");	// Untertitel einfügen wenn etwas zwischen <ul> und <li>
  subttl=subttl.substr(0,e);
  if (subttl.search(/[!-z]/)>=0) s+=subttl;
  else subttl=null;		// weg wenn nur Weißraum!
  var lis=uls[h].getElementsByTagName("LI");
  for (var i=0; i<lis.length; i++) {
   var img=lis[i].getElementsByTagName("A")[0];	// MUSS ein <a>-Tag enthalten!
   if (i || subttl) s+="<br>";
   var id="B"+MultiBildNr+"_"+h+"_"+i;
   s+="<input type=radio name=B"+MultiBildNr+" id="+id;
   var src=img.href;
   s+=" onClick='document.getElementById(\"B"+MultiBildNr+"\").src=\""+src+"\"";
   var width=img.getAttribute("width");
   if (width) s+=";document.getElementById(\"B"+MultiBildNr+"\").width=\""+width+"\"";
   else s+=";document.getElementById(\"B"+MultiBildNr+"\").removeAttribute(\"width\")";
   s+="'";
   if (!pic1) {
    s+=" checked";
    pic1=src;
   }
   var title=img.innerHTML;	// auch mit Formatierungen
   if (!title) {
    var a=src.lastIndexOf("/")+1;	// Bild-Dateiname
    var e=src.indexOf(".",a);		// … ohne Endung
    title=src.substring(a,e);
   }
   s+="><label for="+id+">"+title+"</label>";
   var rest=lis[i].innerHTML;
   var e=rest.toLowerCase().indexOf("</a>");
   rest=rest.substr(e+4);
   if (rest) s+=rest; else s+="\n";
  }
  s+="</p>\n"
  if (h) uls[h].parentElement.removeChild(uls[h]);
 }
 var p=uls[0].parentNode;
 var table=document.createElement("table");
 table.cellspacing=0;
 table.cellpadding=4;
 table.align="center";
 table.innerHTML="<tr><td><img src='"+pic1+"' id=B"+MultiBildNr+extra
   +"><td bgcolor=#F0F0F0><form>"+s+"</form>";
 p.replaceChild(table,uls[0]);
 for (var h=1; h<uls.length; h++) p.removeChild(uls[h]);
}

var tocLevel;

function adjustLevel(lev) {
 var s="";
 while (lev>tocLevel) {
  s+=tocLevel==4?"<ul>\n":"<ol>\n";
  tocLevel++;		// dürfte nur 1x passieren!
 }
 while (lev<tocLevel) {
  s+=tocLevel==5?"</ul>\n":"</ol>\n";
  tocLevel--;		// kann mehrfach passieren!
 }
 return s;
}

function createToc(n) {
 var s="";
 for (var m=n.firstChild;m;m=m.nextSibling) {
  if (m.nodeType==1 && m.tagName.length==2 && m.tagName.charAt(0)=='H') {
   var lev=parseInt(m.tagName.charAt(1));
   if (2<=lev && lev<6) {	// nur H2 bis H5
    s+=adjustLevel(lev);
    var t=m.textContent;
    if (!t) t=m.innerText;
    if (t) {
     if (t.substr(t.length-1)=="¶")
       t=t.substr(0,t.length-1);	// ¶ entfernen
     for(;;){		// alle Klammern
      var k=t.indexOf("(");
      if (k<0) break;
      var l=t.indexOf(")",k);
      if (l<0) break;
      t=t.substr(0,k)+t.substr(l+1);	// Klammerinhalt entfernen
     }
    }else t="<i>"+strOhneTitel()+"</i>";
    s+="<li><a href=#"+m.id+">"+t+"</a>\n"	// Link auf Anker generieren
   }
  }else s+=createToc(m);	// Rekursion durch Unterelemente
 }
 return s;
}

function showContent() {
 document.body.style.overflowX="hidden"
 var nav=document.getElementById("Nav");
 nav.style.visibility="visible"
 nav.className="slidein";	// Zuweisung = Animation starten
 nav=document.getElementById("NavBar");
 nav.style.visibility="hidden"
}

function hideContent() {
 var nav=document.getElementById("Nav");
 nav.className="";		// erneuten Animationsstart vorbereiten
 nav.style.visibility="hidden"
 nav=document.getElementById("NavBar");
 nav.style.visibility="visible"
}

var InvisId=1;	// Laufende ID für mehrere zuschaltbare Textblöcke pro Datei

// Der Textblock nach SpanInvisible() muss mit </span> abgeschlossen werden
function SpanInvisible() {
 document.writeln("<a href='javascript:Anzeige(",InvisId,")'><IMG id='A",InvisId,"' src='icons/plus.gif' alt='[+]' title='Hier klicken für Zusatzinformation' border='0'></a>");
 document.writeln("<span id='E",InvisId,"' style='display:none'>");
 InvisId++;
}

function Anzeige(id) {
 var al=document.getElementById("A"+id);
 var el=document.getElementById("E"+id);
 if (el.style.display=="") {
  al.src="icons/plus.gif";
  al.alt="[+]";
  al.title="Hier klicken für Zusatzinformation";
  el.style.display="none";
 }else{
  al.src="icons/minus.gif";
  al.alt="[-]";
  al.title="Hier klicken um Zusatzinformation auszublenden";
  el.style.display="";
 }
}
/*
function paraShow(h,state) {
// alert(state);
 a=h.getElementsByTagName("a");	// innere Anker-Elemente
 a=a[a.length-1];		// letztes
 a.style.display=state;
}
*/
// Automatische Header-IDs
function attachIdToHeaders(n,numbers) {
 for (var m=n.firstChild;m;m=m.nextSibling) {
  if (m.nodeType==1 && m.tagName.length==2 && m.tagName.charAt(0)=='H') {
   var level=parseInt(m.tagName.charAt(1))-2;	// mit H2 beginnen (H1 ist stets HTML-Seitenüberschrift)
   if (0<=level && level<numbers.length) {
    numbers[level++]++;			// diesen Level um 1 erhöhen
    if (level<numbers.length) numbers[level]=0;	// folgenden Level rücksetzen
    if (!m.id) {			// H-Element ohne ID?
     var sec="";
     for (var i=0; i<level; i++) {
      if (sec) sec+=".";		// ID der Form 1.2.3 generieren (wie CSS-Autonummerierung)
      sec+=numbers[i];
     }
     m.id=sec;				// ID zuweisen
    }
   }
  }else attachIdToHeaders(m,numbers);	// Rekursion durch Unterelemente
 }
}

function strSelfLink() {
 switch (lang) {
  case "en": return "link for reference: use “copy address” to reference in email etc.";
  default: return "Referenz-Link: Benutze „Link-Adresse kopieren“ für Bezugnahme in E-Mail u.ä.";
 }
}

function attachSelfLinks(h) {
 var n=document.body.getElementsByTagName(h);
 for (var i=0; i<n.length; i++) {
  var m=n[i];
  var a=document.createElement("a");
  a.className="hl";	// Link auf Anker generieren
  a.href="#"+m.id;
  a.textContent="¶";
  m.appendChild(a);	// wird tatsächlich hinter den Überschriftentext gesetzt
 }
}

function strInhalt() {
 switch (lang) {
  case "en": return "Content";
  case "jp": return "コンテンツ";
  case "cn": return "内容";
  default: return "Inhalt";
 }
}

function strSchliessen() {
 switch (lang) {
  case "en": return "Close content overlay";
  default: return "Inhaltsverzeichnis schließen";
 }
}

function appendUrlLastElem(s,url) {
 if (url) {
  if (url.lastIndexOf('/') == url.length-1) url=url.substr(0,url.length-1);
  url=url.substr(url.lastIndexOf('/')+1);
  s+=" ("+decodeURI(url)+")";
 }
 return s;
}

function strNextTheme(url) {
 var s;
 switch (lang) {
  case "en": s="Next article"; break;
  default: s="Nächster Artikel";
 }
 return appendUrlLastElem(s,url);
}

function strUpDir(url) {
 var s;
 switch (lang) {
  case "en": s="Directory above"; break;
  default: s="Übergeordnetes Verzeichnis";
 }
 return appendUrlLastElem(s,url);
}
/*****************
 * Popup-Fenster *
 *****************/
 
var pop = null;

function popdown() {
  if (pop && !pop.closed) pop.close();
}

function popup(obj,w,h) {
  var url = obj.href;
  if (!url) return true;
  w = (w) ? w += 20 : 150;  // 150px*150px is the default size
  h = (h) ? h += 25 : 150;
  var args = 'width='+w+',height='+h+',resizable';
  popdown();
  pop = window.open(url,'',args);
  return (pop) ? false : true;
}

if (window.addEventListener) {
 window.addEventListener("focus",popdown,false);
 window.addEventListener("unload",popdown,false);
}else{
 window.attachEvent("onfocus",popdown);
 window.attachEvent("onunload",popdown);
}

/***************************
 ** Quelltext-Highlighter **
 ***************************/
// TODO: JavaScript-Interpreter blockieren, die keine anonymen Funktionen kennen

// Dieses Objekt hält den Input-Quelltext (der bereits
// von < und > befreit sein muss und anwenderspezifische <>-Anmerkungen aufweisen darf)
// sowie die aktuelle Parse-Position.
// Mit zusätzlichen Rückgabewerten (etwa <hi>) ist das Funktions-Handling erleichtert.
// Die (anonymen) Funktionen bearbeiten den pre.innerHTML und ergänzen die
// Hervorhebungen für Kommentare, Schlüsselwörter, Zahlen, Strings usw.
// Deren Formatierung ist Sache von CSS.
// C und C++ ist eingebaut, Pascal/Delphi vorbereitet.
function Parser(txt) {
 this.txt=txt;
 this.pos=0;
 this.end=function() {
  return this.pos>=this.txt.length;
 }
 this.peek=function() {		// Nächstes Zeichen lesen zum Prüfen
  return this.txt.charAt(this.pos);
 }
 this.get=function() {		// Nächstes Zeichen abholen
  return this.txt.charAt(this.pos++);
 }
// Escaptes Zeichen holen, notfalls "\r\n" oder "\n\r" (also 2 Zeichen) bei DOS-Zeilenenden
 this.getEscaped=function() {
  var ret=this.get();
  if (ret=='\r' && this.peek()=='\n') ret+=this.get();
  else if (ret=='\n' && this.peek()=='\r') ret+=this.get();
  return ret;
 }

 this.getWhite=function() {
  var ret="";
  for(;;) switch (this.peek()) {
   case ' ':
   case '\t':
   case '\r':
   case '\n':
   case '\v': ret+=this.get(); break;
   default: return ret;
  }
 }
// Präprozessor, Kommentare, Strings und reguläre Ausdrücke erkennen (C, evtl. Pascal usw.)
// Liefert null wenn <start> nicht passt
// Ist <end> gegeben wird mit <end>, dem Zeilenende oder Stringende abgebrochen
// Ist <ml> gegeben und true, wird nicht mit dem Zeilenende abgebrochen
 this.getRun=function(start,end,ml) {
  if (this.txt.substr(this.pos,start.length)!==start) return null;
  this.pos+=start.length;	// Der erste Stern muss hier verschluckt werden. (Nicht /*/)
  loop:for(;;){
   switch (this.peek()) {
    case '': break loop;	// Ende (bei Strings: Fehlerhaftes Dateiende!)
    case '\\': start+=this.get(); start+=this.getEscaped(); break;	// ggf. Zeilenfortsetzung
    case '\r':
    case '\n': if (!ml) break loop;	// Multiline-Kommentar hier nicht abbrechen!
    default: if (end && this.txt.substr(this.pos,end.length)===end) {
     start+=end;
     this.pos+=end.length;	// Ende erkannt
     break loop;
    }else start+=this.get();
   }
  }
  return start;
 }
 
 this.getToken=function() {
  this.hi="";
  var ret;
  if (ret=this.getRun("<span class=\"ln\"","</span>",true)) this.hi=null; // Zeilennummern
  else if (ret=this.getRun("<",">")) this.hi=null;	// handgemachte HTML-Zusätze
		// TODO: Zwischengeschaltete Strings können ">" enthalten!
  return ret;
 }

 this.getCToken=function(inpre) {
  var ret;
  if (ret=this.getToken()) ;
  else if (!inpre && (ret=this.getRun("#"))) this.hi="dfn";	// Präprozessor-Anweisung
  else if (inpre && (ret=this.getRun("&lt;","&gt;"))) this.hi="strong";	// #include <stdio.h> wie String
  else if (ret=this.getRun("'","'")) this.hi="strong";	// Zeichen-Konstante
  else if (ret=this.getRun('"','"')) this.hi="strong";	// String-Konstante
  else if (ret=this.getRun("/*","*/",true)) this.hi="i";// C-Kommentar
  else if (ret=this.getRun("//")) this.hi="i";		// C++-Kommentar
  else{
   var alpha=/[A-Za-z_$]/;	// Dollarzeichen für GNU-C (huch?)
   var alnum=/[0-9A-Za-z_$]/;	// für Ende des Bezeichners
   var num=/[0-9]/;
   var numal=/[0-9A-Za-z_.]/;	// Punkt (Dezimaltrennzeichen!) erlauben
   var c;
   ret=this.get();
   if (alpha.test(ret)) while (alnum.test(this.peek())) ret+=this.get();	// Bezeichner
   else if (num.test(ret)) {
    while (numal.test(this.peek())) ret+=this.get();	// Zahl
    this.hi="em";
   }
   else if (ret==='&') do ret+=c=this.get(); while(c!==';');	// &amp; &lt; &gt; als /ein/ Token
  }
  return ret;	// Ansonsten liefert diese Funktion Einzelzeichen (nicht "++", "+=" oder so)
 }

 this.getPasToken=function() {
  var ret;
  if (ret=this.getToken()) ;	// TODO: Unsauber! Pascal kennt den Backslash nicht!
  else if (ret=this.getRun("'","'")) this.hi="strong";	// Zeichen-Konstante
  else if (ret=this.getRun('"','"')) this.hi="strong";	// String-Konstante
  else if (ret=this.getRun("{","}",true)) this.hi="i";	// Pascal-Kommentar
  else if (ret=this.getRun("//")) this.hi="i";		// Delphi-Kommentar
  else{
   var alpha=/[A-Za-z_]/;
   var alnum=/[0-9A-Za-z_]/;
   var num=/[0-9$]/;		// $ für Hexzahlen
   var numal=/[0-9A-Za-z_.]/;	// Punkt (Dezimaltrennzeichen!) erlauben
   var c;
   ret=this.get();
   if (alpha.test(ret)) while (alnum.test(this.peek())) ret+=this.get();	// Bezeichner
   else if (num.test(ret)) {
    while (numal.test(this.peek())) ret+=this.get();	// Zahl
    this.hi="em";
   }
   else if (ret==='^') {				// Zeichen-Konstante
    ret+=this.get();					// Buchstabe dahinter
    this.hi="strong";
   }
   else if (ret==='&') do ret+=c=this.get(); while(c!==';');	// &amp; &lt; &gt; als /ein/ Token
  }
  return ret;	// Ansonsten liefert diese Funktion Einzelzeichen (nicht "++", "+=" oder so)
 }
 
 this.getAsmToken=function() {
  var ret;
  if (ret=this.getToken()) ;	
  else if (ret=this.getRun("'","'")) this.hi="strong";	// Zeichen-Konstante
  else if (ret=this.getRun('"','"')) this.hi="strong";	// String-Konstante
  else if (ret=this.getRun("/*","*/",true)) this.hi="i";// C-Kommentar
  else if (ret=this.getRun("//")) this.hi="i";		// C++-Kommentar
  else if (ret=this.getRun(";")) this.hi="i";		// Assembler-Kommentar
  else if (ret=this.getRun("#")) this.hi="dfn";	// Präprozessor-Anweisung
  else if (ret=this.getRun("."," ")) this.hi="dfn";	// Direktive
  else{
   var alpha=/[A-Za-z_$]/;	// Dollarzeichen für GNU-C (huch?)
   var alnum=/[0-9A-Za-z_$]/;	// für Ende des Bezeichners
   var num=/[0-9]/;
   var numal=/[0-9A-Za-z_.]/;	// Punkt (Dezimaltrennzeichen!) erlauben
   var c;
   ret=this.get();
   if (alpha.test(ret)) {
    while (alnum.test(this.peek())) ret+=this.get();	// Bezeichner
    if (this.peek()==':') this.hi="label";
   }
   else if (num.test(ret)) {
    while (numal.test(this.peek())) ret+=this.get();	// Zahl
    this.hi="em";
   }
   else if (ret==='&') do ret+=c=this.get(); while(c!==';');	// &amp; &lt; &gt; als /ein/ Token
  }
  return ret;
 }
}

function hiliteC(txt,lng,inpre) {
 var out="";
 var parser=new Parser(txt);
 var c_keywords=Array(
	"auto","break","case","char","const","continue","default","do","double","else","enum",
	"extern","float","for","goto","if","inline","int","long","register","return","short","signed","sizeof",
	"static","struct","switch","typedef","union","unsigned","void","volatile","wchar_t","while");
 var c_nonstandard=Array(
	"asm","based","_catch","cdecl","compl","_cs","_ds","_es","export","far","fastcall","_finally","_forceinline","fortran","huge","interrupt",
	"_leave","_loadds","near","_oldcall","pascal","_saveregs","_seg","_ss","stdcall","_syscall","_try","_unaligned");
 var cpp_keywords=Array(
	"bool","catch","class","const_cast","delete","dynamic_cast","except","false","final","friend",
	"new","null","operator","namespace","override","private","protected","public",
	"reinterpret_cast","static_cast","template","this","throw","true","try","typedef","typeid","virtual");
 var cpp_nonstandard=Array(
	"each","in");
 Array.prototype.contains=function(needle) {
  for (var i in this) if (this[i] == needle) return true;
  return false;
 }
 Array.prototype.contains_=function(needle) {
  for (var i in this) if (this[i] == needle || "_"+this[i] == needle) return true;
  return false;
 }
 
 while (!parser.end()) {
  out+=parser.getWhite();
  var token=parser.getCToken(inpre);
  if (parser.hi) {
   if (parser.hi=="dfn") {	// sub-tokenize!
    token=hiliteC(token,lng,true);
   }
   token="<"+parser.hi+">"+token+"</"+parser.hi+">";	// gefundenes Highlight
  }
  else if (parser.hi==="") {	// bei <null> ist's HTML
   if (c_keywords.contains(token)
   || lng==="cpp" && cpp_keywords.contains(token)) token="<b>"+token+"</b>";
   else if (c_nonstandard.contains_(token)
   || lng==="cpp" && cpp_nonstandard.contains_(token)) token="<b class=e>"+token+"</b>";
  }
  out+=token;
 }
 return out;
 // in Strings und Kommentaren könnte man noch nach URLs suchen ...
 // Sowie Funktionsreferenzen anlegen, Windows-API-Funktionen verlinken u.v.a.m.
}

function hiliteAsm(txt,lng) {
 var out="";
 var parser=new Parser(txt);
 var avr_keywords=Array("add","adc","adiw","sub","subi","sbc","sbci","sbiw","and","andi","or","ori",
   "eor","com","neg","sbr","cbr","inc","dec","tst","clr","ser","mul","muls","mulsu","fmul","fmuls","fmulsu",
   "mov","movw","ldi","lds","ld","ldd","sts","st","std","lpm","elpm","spm","in","out","push","pop",
   "break","nop","sleep","wdr","rjmp","ijmp","eijmp","jmp","rcall","icall","eicall","call","ret","reti",
   "cpse","cp","cpc","cpi","sbrc","sbrs","sbic","sbis","brbs","brbc","breq","brne","brcs","brcc",
   "brsh","brlo","brmi","brpl","brge","brlt","brhs","brhc","brts","brtc","brvs","brvc","brie","brid",
   "sbi","cbi","lsl","lsr","rol","ror","asr","swap","bset","bclr","bst","bld",
   "sec","clc","sen","cln","sez","clz","sei","cli","ses","cls","sev","clv","set","clt","seh","clh");
 var pic_keywords=Array("clrf","call","btfss","btfsc","bsf","bcf","movlw","movwf",
   "call","goto","decf","decfsz","return");
 var z80_keywords=Array("add","adc","sub","sbc","and","or","xor","cp","cmp","bit","set","res","inc","dec",
   "rr","rrc","srl","sra","rl","rlc","sll","rld","rrd","ld",
   "ccf","scf","ex","exx","halt","im","in","out","push","pop",
   "cpi","cpir","cpd","cpdr","ldi","ldir","ldd","lddr","ini","inir","ind","indr","outi","otir","outd","otdr",
   "call","rst","ret","reti","retn","di","ei",
   "jp","jpc","jpnc","jpz","jpnz","jpm","jpp","jppe","jppo",
   "jr","jc","jnc","jz","jnz","jmi","jpl","jpe","jpo","djnz");
 var general_keywords=Array("org","equ");
 Array.prototype.contains=function(needle) {
  for (var i in this) if (this[i]==needle) return true;
  return false;
 }

 while (!parser.end()) {
  out+=parser.getWhite();
  var token=parser.getAsmToken();
  if (parser.hi==="") switch (lng) {	// bei <null> ist's HTML
   case "asm avr": if (avr_keywords.contains(token.toLowerCase())) parser.hi="b"; break;
   case "asm pic": if (pic_keywords.contains(token.toLowerCase())) parser.hi="b"; break;
   case "asm z80": if (z80_keywords.contains(token.toLowerCase())) parser.hi="b"; break;
  }
  if (parser.hi==="") {
   if (general_keywords.contains(token.toLowerCase())) parser.hi="dfn";
  }
  if (parser.hi) token="<"+parser.hi+">"+token+"</"+parser.hi+">";
  out+=token;
 }
 return out;
}

function hilitePre(pre) {
 var style=pre.className;
 switch (style) {
  case "c":
  case "cpp": pre.innerHTML=hiliteC(pre.innerHTML,style); break;
  default: if (style.substr(0,3)=="asm")
   pre.innerHTML=hiliteAsm(pre.innerHTML,style);
 }
}

/********************************
 ** Ende Quelltext-Highlighter **
 ********************************/

// Alle Zahlen mit Einheit (1 Leerzeichen dazwischen) suchen
// und das Leerzeichen durch &nbsp; ersetzen, später mal durch ein dünnes Leerzeichen
function ErsZahlEinheit(node) {
 var nodes=node.childNodes;
 if (nodes && nodes.length) for (var i=0; i<nodes.length; i++) ErsZahlEinheit(nodes[i]);
 else{
  var s=node.textContent;
  if (!s) s=node.innerText;
  if (s) {
   var sn=s.replace(/(\b[0-9]+?) ([pnµm°kMGT]?[A-z%€ΩÅ][A-z]?\b)/g,"$1 $2");
   if (sn!=s) if (node.textContent) node.textContent=sn; else node.innerText=sn;
  }
 }
}

// Muss wiederholt aufgerufen werden, wenn sich entsprechende Listen ändern
function Lupen() {
 if (!document.querySelectorAll) return;	// alte Browser: nichts tun!
 var imgs=document.querySelectorAll("img.tn");
 for (var i=0; i<imgs.length; i++) {
  imgs[i].onmouseover=function(e) {
   var z=document.createElement("img");
   z.className="tnh";
   z.src=this.src;	// von außen übernehmen (geht das so?)
   z.style.left=e.clientX+10;
   z.style.top=e.clientY+10;
   document.body.appendChild(z);
   window.setTimeout(function() {	// Timeout von 0 erforderlich, sonst frisst der Browser den nächsten Befehl nicht als Übergangs-Start
    z.style.opacity=1;
    this.onmousemove=function(e) {
     z.style.left=e.clientX+10;
     z.style.top=e.clientY+10;
    }
    this.onmouseout=function(e) {
     z.style.opacity=0;
     window.setTimeout(function(e) {
      document.body.removeChild(z);
     },300);
    }
   },0);
  }
 }
}

var collectedIDs;
function BezugRichtung(node) {
 if (node.id) collectedIDs[collectedIDs.length]=node.id;	// IDs sammeln
 if (node.nodeName=="A"
 && !node.className
 && node.href
 && node.href.substr(0,location.href.length+1)==location.href+"#") {
  var id=node.href.substr(location.href.length+1);
  var found=false;
  for (var i=0; i<collectedIDs.length; i++) {
   if (id==collectedIDs[i]) {found=true; break;}
  }
  node.className=found?"lb":"lf";	// "local link forward" oder "local link back"
  if (!node.title) node.title=found?"siehe oben":"siehe unten";
 }
 var nodes=node.childNodes;
 if (nodes && nodes.length) for (var i=0; i<nodes.length; i++) BezugRichtung(nodes[i]);
}

// Riesige Funktion, Aufruf nach dem Laden der Webseite:
function onLoad() {
 function restorescroll() {
  document.body.style.overflowX="auto";
 }
// addEventListener
 var numbers=new Array(0,0,0,0);		// nur h2..h5
 attachIdToHeaders(document.body,numbers);
// Titel von Verzeichnislisten ändern
 if (document.title.substr(0,9)=="Index of ") {	// Vorgabe von Apache
  var h1=document.getElementsByTagName("h1")[0];
  var t=h1.textContent;
  if (!t) t=h1.innerText;
  if (t) document.title=t;
 }
// Sprache der HTML-Datei feststellen
 lang = document.getElementsByTagName("html")[0].getAttribute("lang");
 var url=document.URL;
 if (!lang) {
  var p=url.indexOf(".htm");
  if (p>10 && url.charAt(p-3)==".") lang=url.substr(p-2,2);
 }
 if (!lang && document.title.indexOf("freeware list")>=0) lang="en";	// Extrawurst
// Dynamisches Inhaltsverzeichnis davorsetzen (nur wenn es <h2> gibt)
 tocLevel=1;
 var s=createToc(document.body)+adjustLevel(1);
 if (s) {
  var toc1=document.createElement("div");
  toc1.id="NavBar";
  toc1.onmousedown=showContent;
  toc1.innerHTML=strInhalt();
  var toc2=document.createElement("div");
  toc2.id="Nav";
  toc2.onclick=hideContent;
  toc2.innerHTML="<div id=X title=\""+strSchliessen()+"\">X</div>"+s;
 }
// Für Handy optimieren
 var e=document.createElement("META");
 e.name="viewport";
 e.content="width=device-width, initial-scale=1";
 document.getElementsByTagName("head")[0].appendChild(e);
// Sprachauswahl davorsetzen, Erstelldatum parsen
 var metas = document.getElementsByTagName("meta");
 var value = metas.namedItem("date");
 var a=null;
 if (value) a=address(value.content);
 var l="";
 var links=document.getElementsByTagName("link");
 var n="";
 for (var i=0; i<links.length; i++) {
  var rel=links[i].getAttribute("rel");
  var href=links[i].getAttribute("href");
  var title=links[i].getAttribute("title");
  switch (rel) {
   case "alternate": {	// Sprach-Alternative vorhanden?
    var lng=links[i].getAttribute("lang");
    if (!lng) {
     var dot1=href.indexOf('.')+1;
     var dot2=href.indexOf('.',dot1);
     lng=href.substring(dot1,dot2);
    }
    switch (lng) {
     case "de": l+=" <a href=\""+href+"\"><IMG src=\"icons/de.png\" alt=\"[deutsch]\" title=\"Deutscher Originaltext\" border=0></a>"; break;
     case "en": l+=" <a href=\""+href+"\"><IMG src=\"icons/uk.png\" alt=\"[english]\" title=\"English hand-made translation\" border=0></a>"; break;
     case "jp": l+=" <a href=\""+href+"\"><IMG src=\"icons/jp.png\" alt=\"[日本語]\" title=\"日本語\" border=0></a>"; break;
     case "cn": l+=" <a href=\""+href+"\"><IMG src=\"icons/cn.png\" alt=\"[中文]\" title=\" 中文\" border=0></a>"; break;
    }
   }break;
   case "next": {
    if (!title) title=strNextTheme(href);
    n="<a href=\""+href+"\">"+title+"</a>";
   }
  }
 }
// "Eine Verzeichnisebene hoch" anbieten
 var updir="";
 url=url.substring(url.indexOf("~heha/")+5);
 var p=url.indexOf("#");
 if (p>=0) url=url.substring(0,p);
 var text=url;
 p=url.lastIndexOf("/");
 if (p>=0) {
  text=text.substr(0,text.lastIndexOf('/'));
  url=url.substr(p);
  if (url.indexOf("index")>=0 || url.length==1) {
   text=text.substr(0,text.lastIndexOf('/'));
   updir="../";
  }else updir="./";
 }
 if (updir) {
  if (n) n+="   ";
  n+="<a href=\""+updir+"\">"+strUpDir(text)+"</a>";
 }
// Quelltext-Abschnitte mit Syntaxhervorhebung
 var pres=document.body.getElementsByTagName("pre");
 for (var i=0; i<pres.length; i++) hilitePre(pres[i]);
// Lokale Links mit Suchrichtung versehen
 collectedIDs=new Array();
 BezugRichtung(document.getElementsByTagName("body")[0]);
// Texte nach Zahl mit Einheit durchsuchen und Leerzeichen durch &nbsp; ersetzen
 ErsZahlEinheit(document.getElementsByTagName("body")[0]);
// Miniaturgrafiken mit Lupenfunktion versehen
 Lupen();
// Externe Links mit "extern"-Grafik markieren
 links=document.body.getElementsByTagName("A");
 for (var i=0; i<links.length; i++) {
  var href=links[i].getAttribute("href");
  var grafik="", desc="";
  if (href && href.indexOf("://")>=0
   && href.indexOf("tu-chemnitz.de")<0) {	// IE
   if (href.indexOf("reichelt")>=0
    || href.indexOf("conrad")>=0
    || href.indexOf("farnell")>=0
    || href.indexOf("digikey")>=0
    || href.indexOf("pollin")>=0
    || href.indexOf("trade-shop")>=0) grafik="einkauf.gif", desc="Einkauf";
   else if (href.indexOf("wikipedia")>=0) grafik="wikipedia.png", desc="Wikipedia-Artikel";
   else grafik="extern.gif", desc="Externer Link";
  }
  if (grafik) {
   var img=document.createElement("img");
   img.src="icons/"+grafik;
   img.className="prelink";
   img.title=desc;
   links[i].insertBefore(img,links[i].firstChild);
  }
 }
// Multi-Bilder (innerhalb von <div class=fig> gibt's genau ein <ul>)
// umformatieren zu einem Formular mit Radiobuttons
 var figures=document.body.getElementsByTagName("figure");
 if (figures) for (var i=0; i<figures.length; i++) {
  uls=figures[i].getElementsByTagName("ul");
  if (uls.length) MultiBild(uls);
 }
 figures=document.body.getElementsByTagName("div");
 if (figures) for (var i=0; i<figures.length; i++) {
  if (figures[i].className=="fig") {
   var uls=figures[i].getElementsByTagName("ul");
   if (uls.length) MultiBild(uls);
  }
 }
// Kopf- und Fuß-Strings anfügen
 var b=document.body;
 if (n) {
  var div=document.createElement("div");
  div.className="r";
  div.innerHTML=n;
  b.appendChild(div);
 }
 if (l) {
  var div=document.createElement("div");
  div.id="LangSel";
  div.innerHTML=l;
  b.insertBefore(div,b.firstChild);
 }
 if (s) {
  b.insertBefore(toc2,b.firstChild);
  b.insertBefore(toc1,b.firstChild);
 }
 if (a) {
  var adr=document.createElement("address");
  adr.innerHTML=a;
  b.appendChild(document.createElement("hr"));
  b.appendChild(adr);
 }
// addEventListener - Das hier geht nur am Ende richtig!!
 attachSelfLinks("h2");
 attachSelfLinks("h3");
 attachSelfLinks("h4");
 attachSelfLinks("h5");
 var nav=document.getElementById("Nav");
 if (nav && nav.addEventListener) {
  nav.addEventListener("animationend",restorescroll,false);
  nav.addEventListener("webkitAnimationEnd",restorescroll,false);
 }
}

//window.onload=onLoad;	// Handler zuweisen
if (window.addEventListener) window.addEventListener("load",onLoad,false);
else window.attachEvent("onload",onLoad);

// Hilfsfunktionen (Canvas)
function line(dc,x,y,xe,ye) {
 dc.beginPath();
 dc.moveTo(x,y);
 dc.lineTo(xe,ye);
 dc.stroke();
}
function circle(dc,x,y,r) {
 dc.beginPath()
 dc.arc(x,y,r,0,2*Math.PI);
 dc.stroke();
}
