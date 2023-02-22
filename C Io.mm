<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1675677517253" ID="ID_566457496" MODIFIED="1675688046630" TEXT="C# Io">
<node CREATED="1675677613293" FOLDED="true" ID="ID_1006585115" MODIFIED="1675687394810" POSITION="right" TEXT="using system.io">
<node CREATED="1675677695527" FOLDED="true" ID="ID_527112802" MODIFIED="1675682030280">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Directory
    </p>
  </body>
</html></richcontent>
<node CREATED="1675679384344" FOLDED="true" ID="ID_1788856346" MODIFIED="1675681693572" TEXT="GetLogicalDrives">
<node CREATED="1675679393469" ID="ID_686738978" MODIFIED="1675679400547" TEXT="Returnerar diskenheter"/>
</node>
<node CREATED="1675679447602" FOLDED="true" ID="ID_1718181516" MODIFIED="1675681693572" TEXT="Delete()">
<node CREATED="1675679470063" ID="ID_641128489" MODIFIED="1675679485543" TEXT="tar bort allt i mappen s&#xf6;kv&#xe4;g"/>
<node CREATED="1675679486430" ID="ID_554574605" MODIFIED="1675679530063" TEXT="om true specifieras efter s&#xf6;kv&#xe4;g tas &#xe4;ven mappen bort"/>
</node>
</node>
<node CREATED="1675679353904" FOLDED="true" ID="ID_999967310" MODIFIED="1675682075360">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      file
    </p>
  </body>
</html></richcontent>
<node CREATED="1675681413710" ID="ID_1357178768" MODIFIED="1675681419853" TEXT="I och med att File &#xe4;r statisk, ">
<node CREATED="1675681421440" ID="ID_1537910054" MODIFIED="1675681461470" TEXT="kan man kalla Filestream = File.Create() "/>
</node>
<node CREATED="1675681515644" FOLDED="true" ID="ID_804797021" MODIFIED="1675681693572" TEXT="har metoder med automatiska st&#xe4;ng">
<node CREATED="1675681547558" ID="ID_1157296111" MODIFIED="1675681557653" TEXT="WriteAllLines()"/>
<node CREATED="1675681558156" ID="ID_745965134" MODIFIED="1675681565333" TEXT="ReadAllLines()"/>
</node>
</node>
<node CREATED="1675681919834" FOLDED="true" ID="ID_1667024739" MODIFIED="1675682079417" TEXT="">
<node CREATED="1675679360914" ID="ID_1646913281" MODIFIED="1675679379970">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &#228;r statiska classer
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1675679614299" ID="ID_27953348" MODIFIED="1675681969946" TEXT="returnerar detlajerade object"/>
</node>
</node>
<node CREATED="1675677795964" FOLDED="true" ID="ID_217663425" MODIFIED="1675687394810" POSITION="left" TEXT="filsysteminfo">
<node CREATED="1675678275019" FOLDED="true" ID="ID_861297997" MODIFIED="1675682110145" TEXT="Directoryinfo">
<node CREATED="1675677683203" FOLDED="true" ID="ID_1630975655" MODIFIED="1675681693571" TEXT="Skapa en ny mapp">
<node CREATED="1675678077923" ID="ID_1477389564" MODIFIED="1675678134454">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      directoryinfo dirName = new DirectoryIinfo(@&quot;path&quot;);
    </p>
    <p>
      dirName.create()
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1675678749803" FOLDED="true" ID="ID_1039053129" MODIFIED="1675681693571" TEXT="CreateSubdirectory()">
<node CREATED="1675678761493" ID="ID_657776000" MODIFIED="1675678771837" TEXT="accepterar en relative path som input"/>
<node CREATED="1675678815829" ID="ID_1448788382" MODIFIED="1675678829378" TEXT="will create any needed folders according to relative path"/>
</node>
</node>
<node CREATED="1675678283527" FOLDED="true" ID="ID_10396666" MODIFIED="1675681693571" TEXT="GetFiles()">
<node CREATED="1675678298297" FOLDED="true" ID="ID_58815836" MODIFIED="1675681693571" TEXT="argument : searchPatern tex *.jpg,SearchOptions...">
<node CREATED="1675678344456" ID="ID_1710825379" MODIFIED="1675678350649" TEXT="searchoptions = enum"/>
<node CREATED="1675678451235" ID="ID_227320214" MODIFIED="1675678465123" TEXT="returnerar FileInfo[] array"/>
</node>
</node>
</node>
<node CREATED="1675677832425" FOLDED="true" ID="ID_528446185" MODIFIED="1675687394810" TEXT="fileInfo">
<node CREATED="1675680611875" FOLDED="true" ID="ID_351222780" MODIFIED="1675687394810" TEXT="Stream">
<node CREATED="1675679882824" FOLDED="true" ID="ID_660962408" MODIFIED="1675681693570" TEXT="Interfacet IDisposable">
<node CREATED="1675679899479" FOLDED="true" ID="ID_1396638527" MODIFIED="1675681693570" TEXT="alla opertivesystemresuerser ">
<node CREATED="1675679909100" ID="ID_1318217842" MODIFIED="1675679918469" TEXT="sockets, filestreams, database connections"/>
</node>
<node CREATED="1675679807081" FOLDED="true" ID="ID_144424037" MODIFIED="1675681693570" TEXT="St&#xe4;ngs med Dispose()">
<node CREATED="1675679919205" ID="ID_107257352" MODIFIED="1675679936009" TEXT="m&#xe5;ste st&#xe4;ngas efter anv&#xe4;nding d&#xe4;rav metoden Dispose"/>
</node>
<node CREATED="1675679975757" FOLDED="true" ID="ID_663740445" MODIFIED="1675681693570">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Kan dock f&#246;renklas med
    </p>
  </body>
</html></richcontent>
<node CREATED="1675680071172" ID="ID_788713362" MODIFIED="1675680218367">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Using(&quot;variableNamn&quot;){}
    </p>
    <p>
      dvs.
    </p>
    <p>
      Using(FileStream fs = VariableName.Create()) {}
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1675680044026" ID="ID_1594272009" MODIFIED="1675680082223">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      scope block, som auto disposar utanf&#246;r skope
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1675681193669" FOLDED="true" ID="ID_421128543" MODIFIED="1675687394810" TEXT="Filestream Byte">
<node CREATED="1675680693498" FOLDED="true" ID="ID_198239876" MODIFIED="1675681693569" TEXT="FileStream Bytes Create">
<node CREATED="1675679771137" FOLDED="true" ID="ID_625612012" MODIFIED="1675681693569" TEXT="Create()">
<node CREATED="1675679776332" ID="ID_938517085" MODIFIED="1675679789121" TEXT="returnerar generellt ett filestream object"/>
</node>
<node CREATED="1675680328190" FOLDED="true" ID="ID_440796738" MODIFIED="1675681693569" TEXT="Open()">
<node CREATED="1675680825068" FOLDED="true" ID="ID_1203125267" MODIFIED="1675681693569" TEXT="F&#xf6;renkling utan enums">
<node CREATED="1675680652060" ID="ID_40067089" MODIFIED="1675680764080" TEXT="OpenWrite()"/>
<node CREATED="1675680641649" ID="ID_1455584139" MODIFIED="1675680651517" TEXT="OpenRead()"/>
<node CREATED="1675680841607" FOLDED="true" ID="ID_1128532398" MODIFIED="1675681693569" TEXT="">
<node CREATED="1675680842749" ID="ID_344643110" MODIFIED="1675680862720" TEXT="filstr&#xf6;ms object l&#xe4;mpliga till using()"/>
</node>
</node>
<node CREATED="1675680338634" FOLDED="true" ID="ID_95365527" MODIFIED="1675681693569" TEXT="enum.Filemode">
<node CREATED="1675680355759" ID="ID_569862633" MODIFIED="1675680362971" TEXT="CreateNew"/>
<node CREATED="1675680363663" FOLDED="true" ID="ID_1060990721" MODIFIED="1675681693569" TEXT="Create">
<node CREATED="1675680402762" ID="ID_1476889629" MODIFIED="1675680408437" TEXT="lyckas ej om fil finns"/>
</node>
<node CREATED="1675680370402" ID="ID_1249950217" MODIFIED="1675680373267" TEXT="Open"/>
<node CREATED="1675680373940" FOLDED="true" ID="ID_1452789185" MODIFIED="1675681693569" TEXT="OpenOrCreate">
<node CREATED="1675680413458" ID="ID_712656192" MODIFIED="1675680418488" TEXT="oppna eller skapa"/>
</node>
<node CREATED="1675680381592" FOLDED="true" ID="ID_1213686621" MODIFIED="1675681693569" TEXT="Turncate">
<node CREATED="1675680420606" ID="ID_1388724708" MODIFIED="1675680425832" TEXT="radera ineh&#xe5;ll"/>
</node>
<node CREATED="1675680390957" ID="ID_990918868" MODIFIED="1675680392689" TEXT="Append"/>
</node>
<node CREATED="1675680436611" FOLDED="true" ID="ID_1811016467" MODIFIED="1675681693569" TEXT="enum.FileAccess">
<node CREATED="1675680450631" ID="ID_426739517" MODIFIED="1675680456237" TEXT="Read"/>
<node CREATED="1675680456741" ID="ID_906622948" MODIFIED="1675680458971" TEXT="Write"/>
<node CREATED="1675680459696" ID="ID_1883887327" MODIFIED="1675680462079" TEXT="ReadWrite"/>
</node>
<node CREATED="1675680468160" FOLDED="true" ID="ID_780469756" MODIFIED="1675681693568" TEXT="Enum.FileShare">
<node CREATED="1675680485313" ID="ID_774133934" MODIFIED="1675680492753" TEXT="Delete"/>
<node CREATED="1675680494873" ID="ID_66406856" MODIFIED="1675680504838" TEXT="Inheritable"/>
<node CREATED="1675680505448" ID="ID_1901170808" MODIFIED="1675680511222" TEXT="none"/>
<node CREATED="1675680511795" ID="ID_111301046" MODIFIED="1675680513579" TEXT="Read"/>
<node CREATED="1675680514835" ID="ID_331518451" MODIFIED="1675680518373" TEXT="ReadWrite"/>
<node CREATED="1675680520102" ID="ID_834240246" MODIFIED="1675680521745" TEXT="write"/>
<node CREATED="1675680527291" FOLDED="true" ID="ID_1970616510" MODIFIED="1675681693568" TEXT="">
<node CREATED="1675680529168" ID="ID_575461582" MODIFIED="1675680534684" TEXT="Other process may"/>
</node>
</node>
</node>
</node>
<node CREATED="1675682634707" ID="ID_740379317" MODIFIED="1675682654329" TEXT="Kan l&#xe4;sa Enstaka bytes eller byteArrayes"/>
<node CREATED="1675682669642" FOLDED="true" ID="ID_1840023637" MODIFIED="1675687394810" TEXT="System.Text.Encoding">
<node CREATED="1675682942184" ID="ID_811383701" MODIFIED="1675682992576" TEXT="byte[] msgAsByteArray = Encoding.Default.GetBytes(msg)"/>
<node CREATED="1675683121823" FOLDED="true" ID="ID_1612841837" MODIFIED="1675687394809" TEXT="fstream.Position = 0">
<node CREATED="1675682776093" ID="ID_1502058687" MODIFIED="1675682832760" TEXT="om Filestream &#xe5;kallas fr&#xe5;n samma variabel vid skrivning och l&#xe4;sning m&#xe5;ste Position propertyn &#xe5;terst&#xe4;llas im&#xe4;llan"/>
</node>
<node CREATED="1675683018267" ID="ID_1843635853" MODIFIED="1675683062990" TEXT="fstream.write(msgAsByteArray,offset,msgAsByteArray.Length"/>
<node CREATED="1675683183028" ID="ID_1602482106" MODIFIED="1675683226409" TEXT="bytesFromFile[i]= (byte) fstream.ReadByte()"/>
<node CREATED="1675683227072" ID="ID_1837504419" MODIFIED="1675683256172" TEXT="Console.WriteLine(Encoding.Default.GetString(bytesFromFile))"/>
</node>
<node CREATED="1675683313230" FOLDED="true" ID="ID_1490945088" MODIFIED="1675687394809" TEXT="filpekare">
<node CREATED="1675683328677" ID="ID_243366737" MODIFIED="1675683367724" TEXT="alla l&#xe4;s och skriv operationer sker p&#xe5; den specifika filepekaren pekade v&#xe4;rde"/>
</node>
</node>
<node CREATED="1675680688961" FOLDED="true" ID="ID_1697916679" MODIFIED="1675687394809" TEXT="Read/Write Stream Text">
<node COLOR="#338800" CREATED="1675680954313" FOLDED="true" ID="ID_1685599634" MODIFIED="1675687394809" TEXT="StreamWriter">
<node CREATED="1675680976359" FOLDED="true" ID="ID_980336905" MODIFIED="1675687394809" TEXT="CreateText()">
<node CREATED="1675686680651" ID="ID_1480021717" MODIFIED="1675686691345" TEXT="Write &amp; WriteLine"/>
</node>
<node CREATED="1675680989181" ID="ID_1349667674" MODIFIED="1675680993519" TEXT="AppendText()"/>
<node CREATED="1675686644055" ID="ID_1069945876" MODIFIED="1675686664209" TEXT="File.CreateText(&quot;path&quot;)"/>
</node>
<node CREATED="1675681227031" FOLDED="true" ID="ID_1319457468" MODIFIED="1675687394809" TEXT="StreamReader">
<node CREATED="1675680965037" ID="ID_1501522332" MODIFIED="1675686725560" TEXT="File.OpenText()"/>
<node CREATED="1675686700834" ID="ID_1528845411" MODIFIED="1675686707316" TEXT="Read()"/>
<node CREATED="1675686707867" ID="ID_631582578" MODIFIED="1675686710602" TEXT="ReadLine()"/>
</node>
<node CREATED="1675686519845" FOLDED="true" ID="ID_331683240" MODIFIED="1675686563297" TEXT="Unicode standard">
<node CREATED="1675686527133" ID="ID_1914854934" MODIFIED="1675686552910" TEXT="kan initiseras med System.text.encoding object vid konstruktion"/>
</node>
<node CREATED="1675686573137" FOLDED="true" ID="ID_1173129827" MODIFIED="1675687394809" TEXT="">
<node CREATED="1675686574784" ID="ID_429277561" MODIFIED="1675686591726" TEXT="&#xc4;r en buffer, och har d&#xe4;rf&#xf6;r flush ocks&#xe5;"/>
</node>
<node CREATED="1675686806149" ID="ID_412466117" MODIFIED="1675686821518" TEXT="kan ocks&#xe5; intiaras direct med &quot;path&quot; i construktorn"/>
</node>
</node>
</node>
<node CREATED="1675682116185" FOLDED="true" ID="ID_22431200" MODIFIED="1675687394809" TEXT="">
<node CREATED="1675679602408" ID="ID_1881420814" MODIFIED="1675679611874" TEXT="Returnerar str&#xe4;ngar generellt"/>
<node CREATED="1675677810365" ID="ID_1775765090" MODIFIED="1675677815604" TEXT="&#xe4;rver serializable"/>
</node>
</node>
<node CREATED="1675681874747" FOLDED="true" ID="ID_1222567413" MODIFIED="1675682198512" POSITION="right" TEXT="">
<node CREATED="1675677930165" ID="ID_1846282696" MODIFIED="1675677943028" TEXT="@&quot;&quot; verbatim &#xe4;r rekomenderat n&#xe4;r man jobbar med paths"/>
<node CREATED="1675677893388" ID="ID_632104112" MODIFIED="1675677904816" TEXT="Programmets exkverings path = &quot;.&quot;"/>
</node>
<node CREATED="1675686847230" FOLDED="true" ID="ID_529281646" MODIFIED="1675688046630" POSITION="left" TEXT="Streams">
<node CREATED="1675687052058" ID="ID_339772373" MODIFIED="1675687056384" TEXT="fileStream"/>
<node CREATED="1675683429738" ID="ID_1010111240" MODIFIED="1675683435601" TEXT="MemmoryStream"/>
<node CREATED="1675687351644" FOLDED="true" ID="ID_1311998676" MODIFIED="1675687394809" TEXT="buffers">
<node CREATED="1675683436170" FOLDED="true" ID="ID_1454577569" MODIFIED="1675687049276" TEXT="BufferedStream">
<node CREATED="1675683508459" ID="ID_900773255" MODIFIED="1675683516496" TEXT="har ett begr&#xe4;nsat internminne"/>
<node CREATED="1675683516837" ID="ID_725612215" MODIFIED="1675683524105" TEXT="flush() t&#xf6;mmer internminnet"/>
<node CREATED="1675683540477" ID="ID_1446537612" MODIFIED="1675683569267" TEXT="vid provocerad eller automatisk t&#xf6;mning skickas ineh&#xe5;llet i minnet till assosiserad out str&#xf6;m"/>
<node CREATED="1675683584436" ID="ID_1180325380" MODIFIED="1675683630336" TEXT="flush b&#xf6;r altid &#xe5;kallas sissta som g&#xf6;rs f&#xf6;r att inte bytes stannar kvar"/>
<node CREATED="1675686406093" ID="ID_863538065" MODIFIED="1675686417116" TEXT="alternativt AutoFlush = true"/>
</node>
<node CREATED="1675687060757" FOLDED="true" ID="ID_711114671" MODIFIED="1675687394809" TEXT="BinaryWriter">
<node CREATED="1675687108353" ID="ID_224033897" MODIFIED="1675687125959" TEXT="N&#xe5;s i andra streams genom att &#xe5;kalla &quot;BaseStream&quot;"/>
<node CREATED="1675687144316" FOLDED="true" ID="ID_1359609392" MODIFIED="1675687394809" TEXT="Seek()">
<node CREATED="1675687165365" ID="ID_1706846219" MODIFIED="1675687173037" TEXT="sets position of current stream"/>
</node>
</node>
<node CREATED="1675687203458" FOLDED="true" ID="ID_43261143" MODIFIED="1675687394809" TEXT="BinaryReader">
<node CREATED="1675687246722" ID="ID_1690074193" MODIFIED="1675687251074" TEXT="Read()"/>
<node CREATED="1675687251492" FOLDED="true" ID="ID_1377183779" MODIFIED="1675687394808" TEXT="Read(typeName)">
<node CREATED="1675687259337" ID="ID_1739878610" MODIFIED="1675687278905" TEXT="d&#xe5; de andra readers &#xf6;verlagrar denna men sina egna implementationer"/>
<node CREATED="1675687290947" ID="ID_527613756" MODIFIED="1675687295747" TEXT="ReadBoolean()"/>
<node CREATED="1675687296197" ID="ID_1245805106" MODIFIED="1675687307305" TEXT="ReadByte()"/>
<node CREATED="1675687308130" ID="ID_1242209334" MODIFIED="1675687314133" TEXT="ReadInt32()"/>
</node>
<node CREATED="1675687229197" FOLDED="true" ID="ID_260055005" MODIFIED="1675687394808" TEXT="peekChar()">
<node CREATED="1675687239041" ID="ID_745794087" MODIFIED="1675687245255" TEXT="next char without advancing"/>
</node>
</node>
<node CREATED="1675686877089" FOLDED="true" ID="ID_1700058198" MODIFIED="1675687394808" TEXT="minneshanterad string buffer">
<node CREATED="1675686866713" FOLDED="true" ID="ID_1993728275" MODIFIED="1675687394808" TEXT="StringWrite">
<node CREATED="1675686944307" FOLDED="true" ID="ID_1182450336" MODIFIED="1675687394808" TEXT="getStringBuilder()">
<node CREATED="1675686988534" ID="ID_1517202376" MODIFIED="1675687000399" TEXT="Insert(0,&quot;&quot;)"/>
<node CREATED="1675687000989" ID="ID_1615331416" MODIFIED="1675687013459" TEXT="Remove(0,&quot;&quot;.length)"/>
</node>
</node>
<node CREATED="1675686871128" ID="ID_1914528628" MODIFIED="1675686875291" TEXT="StringReader"/>
</node>
</node>
<node CREATED="1675687414859" FOLDED="true" ID="ID_1395558061" MODIFIED="1675688046630" TEXT="PipeLine">
<node CREATED="1675687444164" FOLDED="true" ID="ID_678929584" MODIFIED="1675688046630" TEXT="ex Filestream innesluts av en binaryWrite s&#xe5; att primitiva datatyper kan skrivas till fil">
<node CREATED="1675687657647" ID="ID_1620109078" MODIFIED="1675687683407" TEXT="till&#xe5;ter oss att tex b&#xe5;de l&#xe4;sa text samt l&#xe4;sa typ specific v&#xe4;rden som byte eller int32"/>
<node CREATED="1675687715011" ID="ID_37293170" MODIFIED="1675687744531" TEXT="write och read metoder kommer d&#xe5; &#xf6;verlagras och anropas enligt typ"/>
<node CREATED="1675687586968" ID="ID_823588634" MODIFIED="1675687620381" TEXT="tex Using BinaryWriter bw = new BinaryWriter(f.OpenWrite())"/>
</node>
<node CREATED="1675687828615" FOLDED="true" ID="ID_1190170452" MODIFIED="1675688046630" TEXT="ex BinaryWriter bufferstream,Filestream">
<node CREATED="1675687849363" ID="ID_694432256" MODIFIED="1675687880388" TEXT="using(binaryWriter bw = new binaryWriter(new bufferdStream(f.openWrite)"/>
<node CREATED="1675687897029" ID="ID_469288507" MODIFIED="1675687920259" TEXT="ett effektivt s&#xe4;tt"/>
</node>
<node CREATED="1675687797509" FOLDED="true" ID="ID_615558369" MODIFIED="1675688046629" TEXT="">
<node CREATED="1675687798458" FOLDED="true" ID="ID_1778327103" MODIFIED="1675688046629" TEXT="">
<node CREATED="1675687422133" ID="ID_355078761" MODIFIED="1675687437986" TEXT="str&#xf6;m som innesluter annan str&#xf6;m"/>
</node>
</node>
</node>
</node>
<node CREATED="1675688202193" ID="ID_365336139" MODIFIED="1675688203992" POSITION="left" TEXT="encoding">
<node CREATED="1675688183927" ID="ID_196839499" MODIFIED="1675688189216" TEXT="unicode ascii utf">
<node CREATED="1675688091896" ID="ID_245702286" MODIFIED="1675688111434" TEXT="Utf-8 lagrar ascii som 1 byte teken">
<node CREATED="1675688114343" ID="ID_1169229880" MODIFIED="1675688132653" TEXT="och unicode som 2 byte per tecken"/>
<node CREATED="1675688136613" ID="ID_1168457429" MODIFIED="1675688144656" TEXT="extenden unicode lagras som 3 byte"/>
</node>
<node CREATED="1675688060151" ID="ID_645345087" MODIFIED="1675688090830" TEXT="ascii 4byte per tecken"/>
<node CREATED="1675688048751" ID="ID_1799665382" MODIFIED="1675688059711" TEXT="Unicode 8 byte per tecken"/>
</node>
</node>
<node CREATED="1675688165527" ID="ID_1155595317" MODIFIED="1675688171612" POSITION="left" TEXT="Serialzation">
<node CREATED="1675688233235" ID="ID_970776791" MODIFIED="1675688264852" TEXT="Classen m&#xe5;ste Anoteras med [Serializable] innan class namn och prefix"/>
<node CREATED="1675688341095" ID="ID_1784891528" MODIFIED="1675688351706" TEXT="BinaryFormatter">
<node CREATED="1675688352431" ID="ID_555927221" MODIFIED="1675688367411" TEXT=".Serialize(Stream,Object)"/>
<node CREATED="1675688403650" ID="ID_1720088890" MODIFIED="1675688425764" TEXT="(Type)Deseralize(Stream)"/>
</node>
<node CREATED="1675688500663" ID="ID_1953307274" MODIFIED="1675688538285">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      [NonSerialized]
    </p>
    <p>
      
    </p>
    <p>
      ger medlem standardv&#228;rde ist&#228;llet f&#246;r att l&#228;sa v&#228;rde
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
</map>
