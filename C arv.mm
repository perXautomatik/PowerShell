<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1675333428512" ID="ID_713346475" MODIFIED="1675333905841" TEXT="C# arv">
<node CREATED="1675334440710" ID="ID_1690504638" MODIFIED="1675334453931" POSITION="right" TEXT="f&#xf6;r att kunna anv&#xe4;nda en standardtyp m&#xe5;ste ">
<node CREATED="1675334455241" ID="ID_649504040" MODIFIED="1675334479952" TEXT="assemblyn referas (dll eller exe)"/>
<node CREATED="1675334481080" ID="ID_450346468" MODIFIED="1675334493330" TEXT="namespace importeras med using"/>
</node>
<node CREATED="1675336522731" ID="ID_321518771" MODIFIED="1675338943602" POSITION="right" TEXT="partial">
<node CREATED="1675336531622" ID="ID_1182152675" MODIFIED="1675336546101" TEXT="definitionen f&#xf6;r en class kan specifieras &#xf6;ver flera cs filer"/>
<node CREATED="1675336575965" ID="ID_215230223" MODIFIED="1675336615595" TEXT="detta till&#xe5;ter b&#xe4;ttre versionhantering d&#xe5; inte all kod beh&#xf6;ver updaters under loppet av utveckling"/>
</node>
<node CREATED="1675334398126" ID="ID_269763045" MODIFIED="1675334400596" POSITION="right" TEXT="namespaces">
<node CREATED="1675334292489" ID="ID_1853338556" MODIFIED="1675334314676" TEXT="alla typer organiseras i x antal namespaces">
<node CREATED="1675334318106" ID="ID_1148048455" MODIFIED="1675334341756" TEXT="namespaces lagras i dll och exe filer"/>
<node CREATED="1675334357891" ID="ID_1775261703" MODIFIED="1675334365013" TEXT="f&#xf6;r versionhantering etc"/>
</node>
<node CREATED="1675334248879" ID="ID_1861656310" MODIFIED="1675334262653" TEXT=".net ineh&#xe5;ller f&#xf6;ljande standardtyper">
<node CREATED="1675334266526" ID="ID_37681494" MODIFIED="1675334269495" TEXT="class"/>
<node CREATED="1675334270020" ID="ID_862671539" MODIFIED="1675334271350" TEXT="enum"/>
<node CREATED="1675334274919" ID="ID_742766157" MODIFIED="1675334277949" TEXT="interface"/>
<node CREATED="1675334278554" ID="ID_138107775" MODIFIED="1675334280873" TEXT="delegate"/>
</node>
</node>
<node CREATED="1675334934085" ID="ID_1710819757" MODIFIED="1675334949230" POSITION="right" TEXT="synlighet">
<node CREATED="1675334940102" ID="ID_1498983295" MODIFIED="1675334943334" TEXT="klass synlighet">
<node CREATED="1675334767446" ID="ID_1047427060" MODIFIED="1675334968504" TEXT="internal">
<node CREATED="1675334801505" ID="ID_1425078927" MODIFIED="1675334821615" TEXT="internal kan endast access fr&#xe5;n assosierad ansammble"/>
</node>
<node CREATED="1675334969372" ID="ID_539920106" MODIFIED="1675334971311" TEXT="public">
<node CREATED="1675334885748" ID="ID_1725604349" MODIFIED="1675334914264" TEXT="classer kan &#xe4;rva fr&#xe5;n andra ansambles om de &#xe4;r publica"/>
</node>
</node>
<node CREATED="1675337975852" ID="ID_1573721109" MODIFIED="1675337984374" TEXT="Sealed f&#xf6;rbjuder arv"/>
<node CREATED="1675334951240" ID="ID_671338030" MODIFIED="1675334977724" TEXT="typ synlighet">
<node CREATED="1675334956310" ID="ID_1391900391" MODIFIED="1675334983067" TEXT="public"/>
<node CREATED="1675334983752" ID="ID_1892663217" MODIFIED="1675334990636" TEXT="protected internal">
<node CREATED="1675335055044" ID="ID_1675418193" MODIFIED="1675335107253" TEXT="endast access d&#xe5;"/>
<node CREATED="1675335083901" ID="ID_1883670202" MODIFIED="1675335119982" TEXT="samma assamble"/>
<node CREATED="1675335120555" ID="ID_1749993255" MODIFIED="1675335123263" TEXT="samma typ"/>
<node CREATED="1675335124134" ID="ID_1509337232" MODIFIED="1675335126826" TEXT="samma subtyp"/>
</node>
<node CREATED="1675334991050" ID="ID_1434131938" MODIFIED="1675334993931" TEXT="protected">
<node CREATED="1675335055044" ID="ID_1172494725" MODIFIED="1675335107253" TEXT="endast access d&#xe5;"/>
<node CREATED="1675335120555" ID="ID_980772630" MODIFIED="1675335123263" TEXT="samma typ"/>
<node CREATED="1675335124134" ID="ID_773450989" MODIFIED="1675335126826" TEXT="samma subtyp"/>
</node>
<node CREATED="1675334995153" ID="ID_1541150322" MODIFIED="1675334996786" TEXT="internal">
<node CREATED="1675335055044" ID="ID_903646453" MODIFIED="1675335107253" TEXT="endast access d&#xe5;"/>
<node CREATED="1675335083901" ID="ID_615875874" MODIFIED="1675335119982" TEXT="samma assamble"/>
</node>
<node CREATED="1675334997407" ID="ID_199406903" MODIFIED="1675334999910" TEXT="private">
<node CREATED="1675335055044" ID="ID_546009158" MODIFIED="1675335107253" TEXT="endast access d&#xe5;"/>
<node CREATED="1675335120555" ID="ID_762187543" MODIFIED="1675335123263" TEXT="samma typ"/>
</node>
</node>
</node>
<node CREATED="1675334681230" ID="ID_306929204" MODIFIED="1675334685655" POSITION="left" TEXT="referenstyperna">
<node CREATED="1675334695229" ID="ID_1421892700" MODIFIED="1675334698163" TEXT="class"/>
<node CREATED="1675334700529" ID="ID_554336395" MODIFIED="1675334703760" TEXT="delegate"/>
<node CREATED="1675334704265" ID="ID_828158568" MODIFIED="1675334706449" TEXT="array"/>
<node CREATED="1675334707023" ID="ID_904007910" MODIFIED="1675334709541" TEXT="string"/>
</node>
<node CREATED="1675340912054" ID="ID_895340854" MODIFIED="1675340940589" POSITION="left" TEXT="Struct kan inte &#xe4;rva, men kan implementera interface"/>
<node CREATED="1675335624797" ID="ID_1948021606" MODIFIED="1675335628185" POSITION="left" TEXT="konstruktorer">
<node CREATED="1675335629208" ID="ID_273610856" MODIFIED="1675335752420">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      kan anropa andra konstruktorer med
    </p>
    <p>
      : this(parameterlist)
    </p>
    <p>
      {
    </p>
    <p>
      /konstruktorkropp/
    </p>
    <p>
      }
    </p>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1675335889097" ID="ID_1827540277" MODIFIED="1675335935304" TEXT="om inte konstruktor av &#xe4;rvande object &#xe5;kallar sin superklass kommer f&#xf6;rst&#xe5;ss standardkonstruktor f&#xf6;r denna anv&#xe4;ndas"/>
<node CREATED="1675335974837" ID="ID_1522874915" MODIFIED="1675336043675">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      f&#246;r att undvika detta anropas superkonstruktorn med
    </p>
    <p>
      : base(parameterlist)
    </p>
    <p>
      
    </p>
    <p>
      i och med att c# inte till&#229;ter mer &#228;n en arvande klass beh&#246;vs inte superklassen refereras via namn
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node CREATED="1675336827053" ID="ID_1625748175" MODIFIED="1675336833069" POSITION="left" TEXT="polymorphism">
<node CREATED="1675339134295" ID="ID_63315515" MODIFIED="1675339137508" TEXT="Interface">
<node CREATED="1675339141048" ID="ID_1391576943" MODIFIED="1675339152810" TEXT="en totalt abstract class"/>
<node CREATED="1675339153472" ID="ID_1575605127" MODIFIED="1675339168813" TEXT="en class kan &#xe4;rva flera interfaces"/>
<node CREATED="1675339200479" ID="ID_1439923657" MODIFIED="1675339232941" TEXT="om en klass &#xe4;rver fr&#xe5;n b&#xe5;de en superklass och ett interface n&#xe4;mns superklassen f&#xf6;rst efter colon sedan interface namnen"/>
<node CREATED="1675339292372" ID="ID_161217716" MODIFIED="1675339317666" TEXT="interface arv kr&#xe4;ver att alla metoder och properties som arvts m&#xe5;ste implementeras som public"/>
</node>
<node CREATED="1675339549981" ID="ID_1791666690" MODIFIED="1675339556066" TEXT="arvsbaserad">
<node CREATED="1675338091815" ID="ID_1271535069" MODIFIED="1675338096077" TEXT="shadowing">
<node CREATED="1675338097770" ID="ID_177486518" MODIFIED="1675338210054" TEXT="om inte override nyckelordet anv&#xe4;nds kommer en identisk metod defenition inneb&#xe4;ra Shadowing, slipp kompileringsvarningar genom att s&#xe4;tta new framf&#xf6;r metoden som inte skall overridas"/>
<node CREATED="1675338333598" ID="ID_1725355865" MODIFIED="1675338415684" TEXT="om man &#xe5;kallar en skuggad metod fr&#xe5;n ett object som initierats via en variabel av superklassens typ, kommer att ignorera den underskuggade metoden, alts&#xe5; m&#xe5;ste man initiera objectet med skuggad metod som sin egen typ och inte sin supertyp"/>
</node>
<node CREATED="1675336834013" ID="ID_1629795963" MODIFIED="1675336845539" TEXT="Override">
<node CREATED="1675336846461" ID="ID_1275754437" MODIFIED="1675336900873" TEXT="metoden har samma namn som en superklass med override nyckelordet innan metodnamn."/>
<node CREATED="1675336911817" ID="ID_293376772" MODIFIED="1675336941210" TEXT="superklass som f&#xf6;rv&#xe4;ntar polymorphism markerar sina metoder med &quot;virtual&quot; eller &quot;abstract&quot;"/>
<node CREATED="1675337010603" ID="ID_1194547304" MODIFIED="1675337058815" TEXT="v&#xe4;rt att notera &#xe4;r att den overridade metoden &#xe5;kallar en instans av superklassenens object och inte sig sj&#xe4;lv"/>
<node CREATED="1675337447491" ID="ID_177822904" MODIFIED="1675337503883" TEXT="virtual noterar att en metod &#xe4;r &#xf6;verlagningsbar men k&#xf6;rbar"/>
<node CREATED="1675337504331" ID="ID_17978641" MODIFIED="1675337521799" TEXT="abstract betyder att object inte kan initieras utan att bidra med &#xf6;verlagring"/>
</node>
</node>
</node>
<node CREATED="1675338851865" ID="ID_224113550" MODIFIED="1675338864256" POSITION="left" TEXT="Typ kompatibilitet / omvandling">
<node CREATED="1675338873096" ID="ID_1571979005" MODIFIED="1675338877231" TEXT="as / is">
<node CREATED="1675338844230" ID="ID_518665025" MODIFIED="1675338847278" TEXT="is">
<node CREATED="1675338892952" ID="ID_499699528" MODIFIED="1675338907465" TEXT="som as men returnrar true eller false"/>
<node CREATED="1675338975737" ID="ID_1014599430" MODIFIED="1675339012099" TEXT="kan ocks&#xe5; l&#xe4;gga till ett variablenamn efter is, f&#xf6;r att d&#xe5; f&#xe5; det konverterade v&#xe4;rdet returnerat"/>
</node>
<node CREATED="1675338620930" ID="ID_374229100" MODIFIED="1675338884671" TEXT="as">
<node CREATED="1675338638555" ID="ID_92700901" MODIFIED="1675338696462" TEXT="testa om arv &#xe4;r m&#xf6;jligt genom att s&#xe4;ga &quot;variabel &apos;as&apos; typNamn&apos; om detta &#xe4;r m&#xf6;jligt returnernas instans annars null"/>
<node CREATED="1675338778056" ID="ID_1971489617" MODIFIED="1675338834591" TEXT="detta &#xe4;r l&#xe4;mpligt efter att man itterar &#xf6;ver ne blandad sammling av objekt, alla typer &#xe4;r objekt men det kanske inte &#xe4;r s&#xe5; anv&#xe4;ndbart"/>
</node>
</node>
<node CREATED="1675336232684" ID="ID_41707087" MODIFIED="1675336264406" TEXT="typovandling ">
<node CREATED="1675336265715" ID="ID_118279851" MODIFIED="1675336280918" TEXT="var = () varName"/>
</node>
</node>
<node CREATED="1675340194187" FOLDED="true" ID="ID_515093307" MODIFIED="1675341299160" POSITION="right" TEXT="att utforska">
<node CREATED="1675340205380" ID="ID_831638987" MODIFIED="1675340209358" TEXT="instanslagring"/>
<node CREATED="1675340209807" ID="ID_225082969" MODIFIED="1675340281099" TEXT="m&#xe5;ste ett object referas fr&#xe5;n en variabel av supertyp efter arv, ? skriv program som testar interface och arv override och shadowing"/>
</node>
<node CREATED="1675341240022" ID="ID_1723695290" MODIFIED="1675341310527" POSITION="right" TEXT="Instansiering">
<node CREATED="1675342094054" ID="ID_646148619" MODIFIED="1675342097450" TEXT="Statiska">
<node CREATED="1675341956551" ID="ID_579723996" MODIFIED="1675341958388" TEXT="Const">
<node CREATED="1675341777107" ID="ID_465745222" MODIFIED="1675341876102" TEXT="public Const variabler &#xe5;kallas som static med klassnamnet , d&#xe5; de inte kan &#xe4;ndras oavs&#xe4;tt om instans av klass g&#xf6;rs"/>
</node>
<node CREATED="1675341311817" ID="ID_1325168171" MODIFIED="1675341313834" TEXT="static">
<node CREATED="1675341345244" ID="ID_1222586557" MODIFIED="1675341369312" TEXT="assosieras med klassen som helhet snarare en instansen"/>
<node CREATED="1675341466376" ID="ID_699286849" MODIFIED="1675341532498" TEXT="kan inte accessa fr&#xe5;n non static metoder,properterties eller atributer "/>
<node CREATED="1675341566408" ID="ID_630637999" MODIFIED="1675341644732" TEXT="object med statiska attribut kan inte initialiseras med en normal konsturktor och inte med mer &#xe4;n en konstruktor, den Statiska konstruktorn, defeault konstruktor med static framf&#xf6;r"/>
<node CREATED="1675341655444" ID="ID_444374599" MODIFIED="1675341671437" TEXT="men kan skapa en statisk klass, d&#xe5; finns endast statiska medlemmar"/>
</node>
</node>
<node CREATED="1675341317172" ID="ID_216675860" MODIFIED="1675341339470" TEXT="inte ">
<node CREATED="1675341314768" ID="ID_510454190" MODIFIED="1675341315742" TEXT=", s&#xe5; l&#xe4;nge inte static anv&#xe4;dns kommer all &#xe5;kallanden ske mot repsektive instans av objectet"/>
<node CREATED="1675341959333" ID="ID_956004054" MODIFIED="1675341962011" TEXT="Read only">
<node CREATED="1675341933798" ID="ID_620874577" MODIFIED="1675342010876" TEXT="Dessa variabler kan endast tilldelas sitt v&#xe4;rde en g&#xe5;ng, genom konstruktorn"/>
<node CREATED="1675342696388" ID="ID_1764817573" MODIFIED="1675342702084" TEXT="alternativt vid declaration"/>
<node CREATED="1675342124606" ID="ID_664467759" MODIFIED="1675342133135" TEXT="Read only kan intieras som static"/>
</node>
</node>
</node>
</node>
</map>
