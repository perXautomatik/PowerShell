<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1675342869801" ID="ID_205275957" MODIFIED="1675344689193" TEXT="C#Undantag">
<node CREATED="1675343631058" ID="ID_1011766470" MODIFIED="1675343651800" POSITION="right" TEXT="throw new &quot;exceptionType&quot;"/>
<node CREATED="1675343652301" ID="ID_1963684293" MODIFIED="1675343669291" POSITION="right" TEXT="CustomExceptiontypes = ApplicationException">
<node CREATED="1675343674574" ID="ID_250240532" MODIFIED="1675343686384" TEXT="egendefinerade fel"/>
</node>
<node CREATED="1675343670084" ID="ID_541831028" MODIFIED="1675344043386" POSITION="right" TEXT="catch">
<node CREATED="1675344044522" ID="ID_629743972" MODIFIED="1675344092705" TEXT="om flera catch block defineras, m&#xe5;ste blocken organiseras efter hirarki, dvs superklasser l&#xe4;ngst ner"/>
<node CREATED="1675345543456" ID="ID_1902405670" MODIFIED="1675345588973" TEXT="catchblocket kan ocks&#xe5; throw, och d&#xe5; anv&#xe4;nds bara den f&#xe5;ngade variabeln"/>
<node CREATED="1675345591626" ID="ID_1244641950" MODIFIED="1675345619076" TEXT="man kan dock utnyttja en annan exception construktor och wrappa felmedelandet i en annan typ av felmedelande"/>
<node CREATED="1675345754020" ID="ID_793541986" MODIFIED="1675345816133" TEXT="i vissa exceptiontyper finns det &quot;inner&quot; exception, dessa kan d&#xe5; kallas f&#xf6;r att f&#xe5; djupare f&#xf6;rst&#xe5;else om felets natur"/>
<node CREATED="1675346178459" ID="ID_1888549518" MODIFIED="1675346183758" TEXT="finally">
<node CREATED="1675346151241" ID="ID_1512356693" MODIFIED="1675346169245" TEXT="Finally exekveras &#xe4;ven innan return"/>
<node CREATED="1675346025627" ID="ID_1994865732" MODIFIED="1675346104701" TEXT="Finnaly exekveras efter ett try blocket &#xe4;ven om throw upst&#xe5;r i call stacken, &#xe4;ven ifall inget block kan hantera exception thrown, och exekveras innan hela callstacken unwinds"/>
</node>
<node CREATED="1675346303952" ID="ID_113863078" MODIFIED="1675346325079" TEXT="anv&#xe4;nd hellre if else &#xe4;n try catch d&#xe5; felhantering &#xe4;r mer resurskr&#xe4;vande"/>
<node CREATED="1675346385629" ID="ID_1036874702" MODIFIED="1675346390930" TEXT="Egendefinerade">
<node CREATED="1675346345342" ID="ID_18609493" MODIFIED="1675346362638" TEXT="anv&#xe4;nd de f&#xf6;rdefinerade undantagen s&#xe5; ofta som m&#xf6;jligt"/>
<node CREATED="1675346396828" ID="ID_638047991" MODIFIED="1675346409028" TEXT="om egen kalla den d&#xe5; &quot;namnException&quot;"/>
</node>
</node>
<node CREATED="1675344246266" ID="ID_162492790" MODIFIED="1675344259826" POSITION="left" TEXT="anropsstack">
<node CREATED="1675344262034" ID="ID_420672482" MODIFIED="1675344294789" TEXT="all invokations of methods add to the call stack"/>
<node CREATED="1675344295701" ID="ID_1982341347" MODIFIED="1675344340447" TEXT="the callstack consists of identity and location where continued execution will ocure afterwards"/>
<node CREATED="1675344340924" ID="ID_1357889649" MODIFIED="1675344392533" TEXT="when error occurs, the call stack will unwind untill a suitable catch block encercles the invokation node."/>
<node CREATED="1675344393534" ID="ID_667232384" MODIFIED="1675344439840" TEXT="basicly, by throwing exceptions without handling them instantly, you can make sure that no unsafe execution occures, "/>
<node CREATED="1675344440450" ID="ID_1229003315" MODIFIED="1675344517960" TEXT="basicly, don&apos;t halfrun the code or handle most exceptions in the outershell which handles file read and write and more general exceptions by there less cruical segments"/>
</node>
<node CREATED="1675344692436" ID="ID_88485968" MODIFIED="1675344730676" POSITION="left" TEXT="Alla exceptions &#xe4;rver propretien stacktrace, vilket blandannat ger s&#xf6;kv&#xe4;g till assamble samt radnummer"/>
</node>
</map>
