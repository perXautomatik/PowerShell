<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1675347027286" ID="ID_277510308" MODIFIED="1675347063005" TEXT="C#Collection Classes">
<node CREATED="1675347570275" ID="ID_1033789319" MODIFIED="1675347576898" POSITION="left" TEXT="legacy">
<node CREATED="1675347585508" ID="ID_1310117890" MODIFIED="1675347590527" TEXT="System.collections">
<node CREATED="1675347178295" ID="ID_1069506990" MODIFIED="1675347181964" TEXT="ArrayList"/>
<node CREATED="1675347182756" ID="ID_547438674" MODIFIED="1675347186007" TEXT="hashtable"/>
<node CREATED="1675347186530" ID="ID_628741875" MODIFIED="1675347187691" TEXT="que"/>
<node CREATED="1675347191240" ID="ID_1585189867" MODIFIED="1675347194405" TEXT="sortedList"/>
<node CREATED="1675347195065" ID="ID_1227150573" MODIFIED="1675347197461" TEXT="stack"/>
<node CREATED="1675347198099" ID="ID_560993891" MODIFIED="1675347198868" TEXT="mm"/>
<node CREATED="1675347205189" ID="ID_375864890" MODIFIED="1675347249415" TEXT="till&#xe5;ter lagring av alla typer, p&#xe5; grund av att de internt sparar som system.object."/>
</node>
<node CREATED="1675413329408" ID="ID_89489432" MODIFIED="1675413335902" TEXT="Hetrogena"/>
<node CREATED="1675413369802" ID="ID_1374168947" MODIFIED="1675413498875" TEXT="kr&#xe4;ver ompackning(boxing) av object vid varje operation, vilket ressulterar i on&#xf6;d overhead"/>
</node>
<node CREATED="1675347577769" ID="ID_1498673761" MODIFIED="1675347579567" POSITION="left" TEXT="modern">
<node CREATED="1675347593184" ID="ID_530152033" MODIFIED="1675347604916" TEXT="System.collections.generic">
<node CREATED="1675347630852" ID="ID_1406905598" MODIFIED="1675347636455" TEXT="List"/>
<node CREATED="1675347637366" ID="ID_283054595" MODIFIED="1675347640185" TEXT="SortedList"/>
<node CREATED="1675347640980" ID="ID_1583828303" MODIFIED="1675347643116" TEXT="LinkedList"/>
<node CREATED="1675347643879" ID="ID_920521102" MODIFIED="1675347645942" TEXT="HashSet"/>
<node CREATED="1675347647044" ID="ID_1175658227" MODIFIED="1675347649961" TEXT="SortedSet"/>
<node CREATED="1675347651105" ID="ID_895793064" MODIFIED="1675347652389" TEXT="Que"/>
<node CREATED="1675347652958" ID="ID_1623227926" MODIFIED="1675347658499" TEXT="Stack"/>
<node CREATED="1675347659008" ID="ID_1355000393" MODIFIED="1675347666678" TEXT="Dictionary"/>
<node CREATED="1675347667155" ID="ID_669280846" MODIFIED="1675347671548" TEXT="SortedDictionary"/>
<node CREATED="1675347688568" ID="ID_1530082780" MODIFIED="1675347688568" TEXT="">
<node CREATED="1675347690315" ID="ID_1526516161" MODIFIED="1675348034123" TEXT="&#xc4;r typ specifika med &lt;&gt;"/>
</node>
</node>
<node CREATED="1675413337410" ID="ID_1725474983" MODIFIED="1675413341374" TEXT="generic"/>
</node>
<node CREATED="1675348246410" ID="ID_476055639" MODIFIED="1675348249481" POSITION="right" TEXT="itteratorer">
<node CREATED="1675348250930" ID="ID_182290327" MODIFIED="1675348257336" TEXT="reset()">
<node CREATED="1675348319501" ID="ID_518530486" MODIFIED="1675348335511" TEXT="move to before first object"/>
</node>
<node CREATED="1675348257695" ID="ID_526412459" MODIFIED="1675348263208" TEXT="moveNext()">
<node CREATED="1675348271720" ID="ID_1400812159" MODIFIED="1675348306733" TEXT="returns true if element is pointed at"/>
<node CREATED="1675348307282" ID="ID_1946729701" MODIFIED="1675348316239" TEXT="false if no more objects to itterate over"/>
</node>
<node CREATED="1675348263497" ID="ID_1602362288" MODIFIED="1675348267395" TEXT="current()">
<node CREATED="1675348421920" ID="ID_462480746" MODIFIED="1675348435463" TEXT="returnerar elementet som itteratorn pekar p&#xe5;"/>
</node>
<node CREATED="1675348550957" ID="ID_1242021001" MODIFIED="1675348582038" TEXT="alla typer som implementerar IEnumerable dvs itterator, kan anv&#xe4;ndas i en forEach loop"/>
</node>
<node CREATED="1675348914835" ID="ID_1289726063" MODIFIED="1675411996180" POSITION="right">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Generiska metoder
    </p>
  </body>
</html>
</richcontent>
<node CREATED="1675411988369" ID="ID_1458396037" MODIFIED="1675411988373">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#228;r ett s&#228;tt att inte beh&#246;va skriva samma metoder f&#246;r olika typer
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1675411998590" ID="ID_625184328" MODIFIED="1675412064189" TEXT="F&#xf6;r att ge variabler av ok&#xe4;nd typ, sitt default v&#xe4;rde, kan man anv&#xe4;nda &quot;=default()&quot;"/>
<node CREATED="1675412065663" ID="ID_1480290645" MODIFIED="1675412162212" TEXT="&quot;T&quot; &#xe4;r den viktigaste delen av de generiska typerna, vilket f&#xf6;rv&#xe4;ntar sig att vid &#xe5;kallning, typen specificeras"/>
<node CREATED="1675412163205" ID="ID_421572606" MODIFIED="1675412205445" TEXT="default(T) returnerar default f&#xf6;r specifierad typ, "/>
<node CREATED="1675412271388" ID="ID_1153397575" MODIFIED="1675412277913" TEXT="fr&#xe5;ga">
<node CREATED="1675412237037" ID="ID_548735545" MODIFIED="1675412260817" TEXT="f&#xf6;r referenser default(t) blir null">
<node CREATED="1675412285842" ID="ID_1227144191" MODIFIED="1675412299436" TEXT="kan man kalla new &lt;T&gt;() ?"/>
</node>
</node>
<node CREATED="1675412360309" ID="ID_573426716" MODIFIED="1675412371888" TEXT="Generic Constraints">
<node CREATED="1675412677113" ID="ID_1127364496" MODIFIED="1675412928547">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Syntax :&#160;
    </p>
    <p>
      public class MyGenericClass&lt;T&gt; where T : ... list of contraints (separated with , )
    </p>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1675412783936" ID="ID_1391393306" MODIFIED="1675412789839" TEXT="list of constraints">
<node CREATED="1675412373116" ID="ID_1856360616" MODIFIED="1675412893504" TEXT="&quot; struct&quot; = T m&#xe5;ste vara en v&#xe4;rdetyp aka be a subtype of System.valueType"/>
<node CREATED="1675412428012" ID="ID_1601929037" MODIFIED="1675412893505" TEXT="&quot; class&quot; = T m&#xe5;ste vara en referenstyp aka not be a subtype of System.valueType"/>
<node CREATED="1675412476861" ID="ID_644136639" MODIFIED="1675412893506" TEXT="&quot; NameOfBaseKlass&quot; = T m&#xe5;ste &#xe4;rva fr&#xe5; en viss typ"/>
<node CREATED="1675412510644" ID="ID_36956319" MODIFIED="1675412893506" TEXT="&quot; NameOfInterface&quot; = T m&#xe5;ste implementera visst interface"/>
<node CREATED="1675412448130" ID="ID_1301389531" MODIFIED="1675412893505" TEXT="&quot; new()&quot; = T m&#xe5;ste ha en DefaultKonstruktor">
<node CREATED="1675413040436" ID="ID_1435317752" MODIFIED="1675413054889" TEXT="M&#xe5;ste vara sisst i en constrain  lista"/>
</node>
</node>
</node>
<node CREATED="1675413137750" ID="ID_1383586324" MODIFIED="1675413173751" TEXT="Egendefinerade Generiska metoder till&#xe5;ter inte normal operatorer s&#xe5; som">
<node CREATED="1675413175918" ID="ID_1335816522" MODIFIED="1675413184638" TEXT="+,-,/,*"/>
<node CREATED="1675413190377" ID="ID_1667967426" MODIFIED="1675413245120" TEXT="p&#xe5; tex where struct d&#xe5; &#xe4;gendefinerade klasser inte har krav p&#xe5; att ge s&#xe4;tt att handskas med detta, kanske b&#xe4;ttre att implementera ett interface snarare"/>
</node>
</node>
</node>
</map>
