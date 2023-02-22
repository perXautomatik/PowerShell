<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1675688775330" ID="ID_1881331473" MODIFIED="1675754001439" TEXT="C# - Windows Presentation Foundations">
<node CREATED="1675689022616" FOLDED="true" ID="ID_877281150" MODIFIED="1675690165385" POSITION="right" TEXT="Windows.forms ">
<node CREATED="1675689032635" ID="ID_1160245949" MODIFIED="1675689047778" TEXT="was the first interface released c# 1.0, "/>
<node CREATED="1675689048644" ID="ID_1742722622" MODIFIED="1675689066095" TEXT="handles up to 2d but more advanced rendering requires other apis"/>
</node>
<node CREATED="1675689084861" FOLDED="true" ID="ID_1554481333" MODIFIED="1675691069040" POSITION="left" TEXT="Wpf ">
<node CREATED="1675689097135" ID="ID_653170842" MODIFIED="1675689115114" TEXT="t&#xe4;cker all funktionalitet inclusive forms"/>
<node CREATED="1675689158089" ID="ID_926575297" MODIFIED="1675689186542" TEXT="Utseende &#xe4;r separat implementerad via xaml formatet"/>
<node CREATED="1675689203239" ID="ID_1128378058" MODIFIED="1675689215716" TEXT="st&#xf6;djer &#xe4;ven css liknande funktionalitet"/>
<node CREATED="1675689220505" ID="ID_670188638" MODIFIED="1675689226809" TEXT="pdf-liknande api"/>
<node CREATED="1675689227141" ID="ID_946039554" MODIFIED="1675689235608" TEXT="suport for legacy windows.form"/>
<node CREATED="1675689256028" FOLDED="true" ID="ID_1248607208" MODIFIED="1675690165384">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      framf&#246;ralt innom namespace&#160;
    </p>
    <p>
      System.windows
    </p>
  </body>
</html>
</richcontent>
<node CREATED="1675689304278" FOLDED="true" ID="ID_1639441041" MODIFIED="1675690165384" TEXT="System.Windows.Application">
<node CREATED="1675689315559" ID="ID_1236232299" MODIFIED="1675689343436" TEXT="inneh&#xe5;ller en referens till aplikationen i propertyn Current"/>
<node CREATED="1675689344115" ID="ID_1383528305" MODIFIED="1675689355961" TEXT="inneh&#xe5;ller den statiska metoden run()"/>
<node CREATED="1675689364764" ID="ID_1187174189" MODIFIED="1675689395403" TEXT="StartupUri &#xe4;r en property vilket kan s&#xe4;ttas f&#xf6;r att best&#xe4;mma vilket f&#xf6;nster som skall visas vid start"/>
<node CREATED="1675689533860" FOLDED="true" ID="ID_775360694" MODIFIED="1675690165384" TEXT="Event">
<node CREATED="1675689541204" ID="ID_906579714" MODIFIED="1675689544977" TEXT="Startup"/>
<node CREATED="1675689546422" ID="ID_394603383" MODIFIED="1675689550180" TEXT="Exit"/>
</node>
</node>
<node CREATED="1675689422351" FOLDED="true" ID="ID_827245627" MODIFIED="1675690165384" TEXT="System.Windows.Window">
<node CREATED="1675689434705" ID="ID_1546649138" MODIFIED="1675689441908" TEXT="MainWindow"/>
</node>
<node CREATED="1675689448321" FOLDED="true" ID="ID_1998014343" MODIFIED="1675690165384" TEXT="">
<node CREATED="1675689449351" ID="ID_1396694987" MODIFIED="1675689470688" TEXT="Alla aplicationens f&#xf6;nster sparas i propertn Windows av typen WindowCollection"/>
</node>
<node CREATED="1675689484032" ID="ID_764937662" MODIFIED="1675689502519" TEXT="Property is accessable throught the whole ui for internal reference"/>
</node>
<node CREATED="1675689616700" ID="ID_1060929314" MODIFIED="1675689634322" TEXT="M&#xe5;ste &#xe4;rva fr&#xe5;n Application. samt ha en main() metod"/>
<node CREATED="1675689684145" FOLDED="true" ID="ID_1317713923" MODIFIED="1675690165384" TEXT="Main metoden m&#xe5;ste Noteras med attributet [STAThread]">
<node CREATED="1675689713320" ID="ID_377729501" MODIFIED="1675689727857" TEXT="ser till att lagacy object &#xe4;r tr&#xe5;ds&#xe4;kra"/>
</node>
<node CREATED="1675690177029" FOLDED="true" ID="ID_1689721742" MODIFIED="1675690184717" TEXT="Example">
<node CREATED="1675689804625" ID="ID_1643246657" MODIFIED="1675690180805">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Class App : Application {
    </p>
    <p>
      
    </p>
    <p>
      [STAThread]
    </p>
    <p>
      static void Main(string[] args) {
    </p>
    <p>
      
    </p>
    <p>
      App app = new App();
    </p>
    <p>
      
    </p>
    <p>
      app.Startup += ( s,e) =&gt; { /* start up the app */ }
    </p>
    <p>
      app.Exit += (s,e) =&gt; { /* Exit the app */ }
    </p>
    <p>
      
    </p>
    <p>
      app.Run()
    </p>
    <p>
      
    </p>
    <p>
      
    </p>
    <p>
      }
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
<node CREATED="1675690020214" ID="ID_459838530" MODIFIED="1675690089316">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      static void MinimizeAllWindows() {
    </p>
    <p>
      foreach (Window wnd in Application.Current.Window)
    </p>
    <p>
      wnd.WindowState = WindowState.Minimized;
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1675690191599" ID="ID_1453901279" MODIFIED="1675690293412" TEXT="System.Windows.Window">
<node CREATED="1675690204879" ID="ID_1920854134" MODIFIED="1675690280401" TEXT="Object -&gt; DlsPatcherObject -&gt; DendencyObject -&gt; VIsual -&gt; UiElement -&gt; FrameWorkElement -&gt; Control -&gt; ContentControl - Window"/>
<node CREATED="1675690310958" FOLDED="true" ID="ID_1126688785" MODIFIED="1675690603480" TEXT="ContentControl">
<node CREATED="1675690320965" ID="ID_1579324241" MODIFIED="1675690387600" TEXT="Ineh&#xe5;ller enstaka visuella object">
<node CREATED="1675690462311" ID="ID_911560390" MODIFIED="1675690480570" TEXT="c# : myButton.Content = &quot;ok&quot;"/>
<node CREATED="1675690481131" ID="ID_178442032" MODIFIED="1675690518535" TEXT="XAML : &lt;Button Height=&quot;80&quot; Width=&quot;100&quot; Content=&quot;ok&quot;/&gt;"/>
</node>
<node CREATED="1675690555680" ID="ID_1114041773" MODIFIED="1675690574577" TEXT="stackpanel">
<node CREATED="1675690575515" ID="ID_697726084" MODIFIED="1675690587696" TEXT="f&#xf6;r att l&#xe4;gga in fler object i ett visuellt object"/>
</node>
</node>
<node CREATED="1675690604704" FOLDED="true" ID="ID_1242288191" MODIFIED="1675690739037" TEXT="Control">
<node CREATED="1675690608765" ID="ID_952839785" MODIFIED="1675690667249" TEXT="tillhandar kontroll object"/>
<node CREATED="1675690671747" ID="ID_615353874" MODIFIED="1675690678554" TEXT="Storlek"/>
<node CREATED="1675690679450" ID="ID_234140544" MODIFIED="1675690684941" TEXT="Genomskinlighet"/>
<node CREATED="1675690685383" ID="ID_662955009" MODIFIED="1675690690069" TEXT="Tab-ordning"/>
<node CREATED="1675690690753" ID="ID_419894242" MODIFIED="1675690698061" TEXT="F&#xf6;r och bakgrundsf&#xf6;rg"/>
<node CREATED="1675690699065" ID="ID_660952056" MODIFIED="1675690713178" TEXT="templating services dvs css"/>
</node>
<node CREATED="1675690740295" FOLDED="true" ID="ID_464072251" MODIFIED="1675690841714" TEXT="FrameWorkElement">
<node CREATED="1675690746579" ID="ID_1140114408" MODIFIED="1675690750985" TEXT="Storyboarding">
<node CREATED="1675690778204" ID="ID_1299319865" MODIFIED="1675690780097" TEXT="animering"/>
</node>
<node CREATED="1675690751389" ID="ID_995418400" MODIFIED="1675690754340" TEXT="Data binding">
<node CREATED="1675690782814" ID="ID_1233907146" MODIFIED="1675690819659" TEXT="Gui elements databinding"/>
</node>
<node CREATED="1675690757974" ID="ID_936409323" MODIFIED="1675690760730" TEXT="Name">
<node CREATED="1675690826472" ID="ID_405343966" MODIFIED="1675690833960" TEXT="Identifiering bland andra element"/>
</node>
<node CREATED="1675690761232" ID="ID_1378184219" MODIFIED="1675690764634" TEXT="Resources"/>
<node CREATED="1675690765085" ID="ID_1721298366" MODIFIED="1675690767105" TEXT="Dimensions"/>
</node>
<node CREATED="1675690842878" FOLDED="true" ID="ID_1950201228" MODIFIED="1675690865646" TEXT="Ui Element">
<node CREATED="1675690848157" ID="ID_837885023" MODIFIED="1675690852258" TEXT="Fokus"/>
<node CREATED="1675690853456" ID="ID_816937" MODIFIED="1675690863102" TEXT="Mus och tangnetbordsh&#xe4;ndelser"/>
</node>
<node CREATED="1675690866809" FOLDED="true" ID="ID_326036755" MODIFIED="1675690935195" TEXT="Visual">
<node CREATED="1675690875441" ID="ID_100907914" MODIFIED="1675690878586" TEXT="Rendering"/>
<node CREATED="1675690880789" ID="ID_791731874" MODIFIED="1675690883855" TEXT="Hit testing"/>
<node CREATED="1675690884376" ID="ID_1872324393" MODIFIED="1675690890362" TEXT="Transfomationer"/>
<node CREATED="1675690890670" ID="ID_1091323677" MODIFIED="1675690895540" TEXT="Bounding box"/>
<node CREATED="1675690901441" ID="ID_539321245" MODIFIED="1675690901441" TEXT="">
<node CREATED="1675690902500" ID="ID_973370185" MODIFIED="1675690907986" TEXT="komunicerar med direct x"/>
</node>
</node>
<node CREATED="1675690936624" FOLDED="true" ID="ID_172569634" MODIFIED="1675690967587" TEXT="Dependensy object">
<node CREATED="1675690943074" ID="ID_410481845" MODIFIED="1675690950377" TEXT="Depensy properties"/>
<node CREATED="1675690950826" ID="ID_92681416" MODIFIED="1675690955586" TEXT="Styles "/>
<node CREATED="1675690956108" ID="ID_795959468" MODIFIED="1675690961325" TEXT="databinding"/>
<node CREATED="1675690961830" ID="ID_651980480" MODIFIED="1675690963929" TEXT="animering"/>
</node>
<node CREATED="1675690968603" FOLDED="true" ID="ID_105268207" MODIFIED="1675691028011" TEXT="DispatcherObject">
<node CREATED="1675690974465" ID="ID_1470298680" MODIFIED="1675690979189" TEXT="Dispatcher">
<node CREATED="1675690980510" ID="ID_891090134" MODIFIED="1675690992988" TEXT="WPFs eventk&#xf6;"/>
</node>
<node CREATED="1675691004736" ID="ID_102406116" MODIFIED="1675691007041" TEXT="tr&#xe5;dning"/>
<node CREATED="1675691009112" ID="ID_983438876" MODIFIED="1675691019685" TEXT="gui tr&#xe5;den &#xe4;r den &#xe4;nda tr&#xe5;den som anv&#xe4;nds"/>
</node>
</node>
</node>
<node CREATED="1675691125507" FOLDED="true" ID="ID_433922865" MODIFIED="1675696140211" POSITION="right" TEXT="xml">
<node CREATED="1675691075165" ID="ID_657146213" MODIFIED="1675691080466" TEXT="M&#xe4;rkspr&#xe5;k"/>
<node CREATED="1675691070435" FOLDED="true" ID="ID_1105197059" MODIFIED="1675696140211" TEXT="XAML">
<node CREATED="1675692185522" FOLDED="true" ID="ID_1871803010" MODIFIED="1675693372590" TEXT="tex">
<node CREATED="1675692193499" ID="ID_602497914" MODIFIED="1675692202641" TEXT="&lt;window&gt;">
<node CREATED="1675692203301" ID="ID_1854755101" MODIFIED="1675692207658" TEXT="&lt;grid&gt;">
<node CREATED="1675692208804" ID="ID_1634157621" MODIFIED="1675692212922" TEXT="&lt;button&gt;"/>
<node CREATED="1675692213464" ID="ID_447501722" MODIFIED="1675692223589" TEXT="&lt;Ellipse&gt;"/>
</node>
</node>
<node CREATED="1675692422963" ID="ID_1101271098" MODIFIED="1675692428258" TEXT="&lt;page&gt;"/>
<node CREATED="1675692428839" ID="ID_209710000" MODIFIED="1675692434056" TEXT="&lt;Application&gt;"/>
</node>
<node CREATED="1675694088741" FOLDED="true" ID="ID_1182275852" MODIFIED="1675696140210" TEXT="filer">
<node CREATED="1675693585342" FOLDED="true" ID="ID_1707962920" MODIFIED="1675694087323" TEXT="har en tillh&#xf6;rande .xaml.cs fil">
<node CREATED="1675693625106" ID="ID_154477365" MODIFIED="1675693632322" TEXT="tex h&#xe4;ndelsehanterare"/>
<node CREATED="1675693671217" ID="ID_37503962" MODIFIED="1675693685014" TEXT="class mappar mot &lt;window&gt; i xaml.cs">
<node CREATED="1675693722514" ID="ID_436772334" MODIFIED="1675693879496">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &lt;window x:class=&quot;mpfApp.MainWindow&quot;
    </p>
    <p>
      xmlns=&quot;http://schema.microsft.com/winfx/2006/xaml/presentation&quot;
    </p>
    <p>
      xmlns:s&quot;http://schema.microsft.com/winfx/2006/xaml&quot;&gt;
    </p>
    <p>
      
    </p>
    <p>
      &lt;grid&gt;
    </p>
    <p>
      &lt;Button x:Name=&quot;myButton&quot; Click=&quot;myButton_click&quot; /&gt;
    </p>
    <p>
      &lt;/Grid&gt;
    </p>
    <p>
      
    </p>
    <p>
      &lt;/Window&gt;
    </p>
  </body>
</html></richcontent>
<node CREATED="1675693881002" ID="ID_300136667" MODIFIED="1675694011739">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      namespace wpfApp
    </p>
    <p>
      {
    </p>
    <p>
      public partial class MainWindow : Window
    </p>
    <p>
      {
    </p>
    <p>
      Public MainWindow()
    </p>
    <p>
      {
    </p>
    <p>
      InitializeComponent();
    </p>
    <p>
      }
    </p>
    <p>
      
    </p>
    <p>
      private void myButten_Click(object sender, RoutedEventArgs e)
    </p>
    <p>
      {
    </p>
    <p>
      Enviroment.Exit(0);
    </p>
    <p>
      }
    </p>
    <p>
      }
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
</node>
<node CREATED="1675694203337" FOLDED="true" ID="ID_1137020124" MODIFIED="1675696140210" TEXT="autogenerade boilerplate">
<node CREATED="1675694104803" ID="ID_1691287839" MODIFIED="1675694111469" TEXT=".g.i.cs"/>
<node CREATED="1675694100823" ID="ID_674180037" MODIFIED="1675694104173" TEXT=".g.cs"/>
</node>
<node CREATED="1675694112182" ID="ID_267163671" MODIFIED="1675694114334" TEXT=".baml"/>
</node>
<node CREATED="1675693421807" FOLDED="true" ID="ID_1147572814" MODIFIED="1675696140210" TEXT="Nyckelord">
<node CREATED="1675693447491" FOLDED="true" ID="ID_1923278638" MODIFIED="1675693575785" TEXT="class">
<node CREATED="1675693525489" ID="ID_548935982" MODIFIED="1675693545643" TEXT="vilket element som mappas till vilket object"/>
</node>
<node CREATED="1675693471097" FOLDED="true" ID="ID_986160076" MODIFIED="1675693575785" TEXT="Name">
<node CREATED="1675693550756" ID="ID_363283170" MODIFIED="1675693554001" TEXT="identifiering"/>
</node>
<node CREATED="1675693450672" ID="ID_652739160" MODIFIED="1675693451932" TEXT="array"/>
<node CREATED="1675693452362" FOLDED="true" ID="ID_1039887451" MODIFIED="1675696140210" TEXT="classModifier">
<node CREATED="1675694307266" ID="ID_1684452032" MODIFIED="1675694319252" TEXT="best&#xe4;mmer tex synlighet"/>
</node>
<node CREATED="1675693461380" FOLDED="true" ID="ID_1734046035" MODIFIED="1675696140210" TEXT="FieldModifier">
<node CREATED="1675694323795" ID="ID_1421664428" MODIFIED="1675694325658" TEXT="best&#xe4;mmer tex synlighet "/>
</node>
<node CREATED="1675693467667" ID="ID_114382302" MODIFIED="1675693468977" TEXT="Key"/>
<node CREATED="1675693473487" ID="ID_1734892694" MODIFIED="1675693474741" TEXT="Null"/>
<node CREATED="1675693475901" ID="ID_280437611" MODIFIED="1675693478006" TEXT="Static"/>
<node CREATED="1675693478837" ID="ID_1217510841" MODIFIED="1675693480801" TEXT="Type"/>
<node CREATED="1675693481250" ID="ID_821187039" MODIFIED="1675693484586" TEXT="TypeArguments"/>
</node>
<node CREATED="1675692237048" FOLDED="true" ID="ID_1232879120" MODIFIED="1675695267488" TEXT="NamespaceDeclaration">
<node CREATED="1675692440193" ID="ID_1907102253" MODIFIED="1675692452990" TEXT="N&#xe4;stan alltid samma namespaces">
<node CREATED="1675692455068" ID="ID_1485803854" MODIFIED="1675692491428" TEXT="xmlns=&quot;http://schemas.microsoft.com/winfx/2006/xaml/presentation&quot;">
<node CREATED="1675692535424" ID="ID_704852222" MODIFIED="1675692543338" TEXT="grid och button tex"/>
</node>
<node CREATED="1675692492328" ID="ID_208934584" MODIFIED="1675692528242" TEXT="xmlns:x=&quot;http://schemas.microsoft.com/winfx/2006/xaml&quot;">
<node CREATED="1675692545847" ID="ID_487100221" MODIFIED="1675692550325" TEXT="name tex">
<node CREATED="1675692586635" ID="ID_761075045" MODIFIED="1675692599433" TEXT="vilket senare kan refereras via namn i c#"/>
</node>
</node>
</node>
<node CREATED="1675692690721" ID="ID_1201315575" MODIFIED="1675693311924" TEXT="om egna klasser speciferats m&#xe5;ste l&#xe4;mpligt namespace defineras">
<node CREATED="1675692737168" ID="ID_107141265" MODIFIED="1675692773194" TEXT="xmlns:myCtrls=&quot;clr-namespace:MyControls;assembly=MyControls&quot;">
<node CREATED="1675692840533" ID="ID_1349709476" MODIFIED="1675692870632" TEXT="&lt;grid&gt;&lt;myCtrls:MyCustomControl /&gt; &lt;/grid&gt;"/>
</node>
<node CREATED="1675693317478" ID="ID_16041095" MODIFIED="1675693354507" TEXT="om typen finns i samma assembly som xaml filen tillh&#xf6;r kan man skippa assembly"/>
</node>
<node CREATED="1675692928606" ID="ID_1887152650" MODIFIED="1675692951092" TEXT="Applikationens huvudnamespace importeras som default med prefix local">
<node CREATED="1675692956238" ID="ID_515628427" MODIFIED="1675692977608" TEXT="xmlns:local=&quot;crl-namespace:wpfApp&quot;"/>
</node>
<node CREATED="1675693019633" ID="ID_1826356522" MODIFIED="1675693170128" TEXT="xmlns:d &quot;https://...&quot; (designe time)"/>
<node CREATED="1675693103827" ID="ID_1945511601" MODIFIED="1675693171832" TEXT="xmlns:mc &quot;https://...&quot;"/>
<node CREATED="1675693125086" ID="ID_1839301059" MODIFIED="1675693149875" TEXT="mc:Ignorable=&quot;d&quot; - skippa allt med prefix d">
<node CREATED="1675693203974" ID="ID_528356073" MODIFIED="1675693224850" TEXT="l&#xe4;mpligt f&#xf6;r saker som inte inneh&#xe5;ller n&#xe5;gon kod"/>
</node>
</node>
<node CREATED="1675695270691" FOLDED="true" ID="ID_879319385" MODIFIED="1675696140210" TEXT="properties">
<node CREATED="1675694484724" FOLDED="true" ID="ID_1567910347" MODIFIED="1675695290983" TEXT="inkludear en automatisk typkonverterare">
<node CREATED="1675694498527" ID="ID_104563008" MODIFIED="1675694516400" TEXT="specifera v&#xe4;rden som str&#xe4;ngar s&#xe5; kommer dessa att konverteras till l&#xe4;mplig typ"/>
</node>
<node CREATED="1675694576412" FOLDED="true" ID="ID_344983735" MODIFIED="1675696140210" TEXT="komplexa object kr&#xe4;ver specifict syntax &quot;property-element syntax&quot;">
<node CREATED="1675694619231" FOLDED="true" ID="ID_1791333957" MODIFIED="1675696140209">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &lt;Button Content=&quot;OK! Foreground=&quot;Yellow&quot;&gt;
    </p>
    <p>
      &lt;Button.background&gt;
    </p>
    <p>
      &lt;LinearGradientBrush&gt;
    </p>
    <p>
      &lt;GradientStop Color=&quot;DarkGreen&quot; Offset=&quot;0&quot;/&gt;
    </p>
    <p>
      &lt;GradientStop Color=&quot;LightGreen&quot; Offset=&quot;1&quot;/&gt;
    </p>
    <p>
      &lt;/LinearGradientBrush&gt;
    </p>
    <p>
      &lt;/Button.Background&gt;
    </p>
    <p>
      &lt;/Button&gt;
    </p>
  </body>
</html></richcontent>
<node CREATED="1675694804080" FOLDED="true" ID="ID_1592708609" MODIFIED="1675696140209" TEXT="=">
<node CREATED="1675694818099" ID="ID_443760415" MODIFIED="1675694973577">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      public void MakeAButton()
    </p>
    <p>
      {
    </p>
    <p>
      Button myBtn = new Button();
    </p>
    <p>
      myBtn.Content = &quot;OK!&quot;;
    </p>
    <p>
      myBtn.Foreground = new SolidColorBrush(Colors.Yellow);
    </p>
    <p>
      
    </p>
    <p>
      LinearGradientBrush fancyBruch = New LinearGradientBruch (Colors.DarkGreen, Colors.LightGreen, 45) ;
    </p>
    <p>
      MyBtn.Background = fancyBruch;
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
</node>
<node CREATED="1675695338021" FOLDED="true" ID="ID_647679737" MODIFIED="1675696140209" TEXT="kan specifiera properties f&#xf6;r vissa f&#xf6;r&#xe4;lderobjectet via barnobjectet">
<node CREATED="1675695377139" ID="ID_106126581" MODIFIED="1675695429312" TEXT="&lt;ParentElement&gt; &lt;ChildElement ParentElement.PropertyOnParent = &quot;value&quot;&gt; &lt;/ParentElement&gt;"/>
<node CREATED="1675695589911" ID="ID_1829997432" MODIFIED="1675695601432" TEXT="l&#xe4;mpligt n&#xe4;r man positionerar gui object"/>
</node>
<node CREATED="1675695632642" FOLDED="true" ID="ID_655847466" MODIFIED="1675696140209" TEXT="markup Extensions">
<node CREATED="1675695641031" FOLDED="true" ID="ID_50978584" MODIFIED="1675696140209" TEXT="Erh&#xe5;ls fr&#xe5;n dedikerad extern klass">
<node CREATED="1675695666512" ID="ID_1873475794" MODIFIED="1675695713958" TEXT="&lt;Element PropertyToSet = &quot;{MarkupExtensionClass}&quot;&gt;"/>
</node>
<node CREATED="1675695722914" ID="ID_1478839373" MODIFIED="1675695758986" TEXT="x:Array, x:null,x:Static,x:Type &#xe4;rver redan fr&#xe5;n markupExtension"/>
<node CREATED="1675695844638" FOLDED="true" ID="ID_1526940037" MODIFIED="1675696140209" TEXT="h&#xe4;mta tex">
<node CREATED="1675695854040" FOLDED="true" ID="ID_1389547848" MODIFIED="1675696140209" TEXT="xmlns:CorLib=&quot;clr-namespace:System;assembly=mscorlib&quot;">
<node CREATED="1675695897865" ID="ID_267487940" MODIFIED="1675695937225" TEXT="&lt;Label Content = &quot;{x:Static CorLib:Enviroment.OSVersion}&quot;/&gt;"/>
<node CREATED="1675695946844" ID="ID_832167238" MODIFIED="1675695998742" TEXT="&lt;Label Content = &quot;{x:Type CorLib:Boolean}&quot; /&gt;"/>
</node>
</node>
</node>
</node>
<node CREATED="1675693403165" FOLDED="true" ID="ID_1273661034" MODIFIED="1675693575784" TEXT="">
<node CREATED="1675692145266" ID="ID_1325845087" MODIFIED="1675692182608" TEXT="Specefikt f&#xf6;r att beskriva visuella element i wpf"/>
</node>
</node>
<node CREATED="1675691134697" ID="ID_100741582" MODIFIED="1675691137134" TEXT="Html"/>
<node CREATED="1675691301676" FOLDED="true" ID="ID_1063862949" MODIFIED="1675692141380" TEXT="">
<node CREATED="1675691491668" ID="ID_1190345309" MODIFIED="1675692094430" TEXT="">
<node CREATED="1675691324201" ID="ID_1274889163" MODIFIED="1675691326886" TEXT="Kommentarer">
<node CREATED="1675691787460" ID="ID_1467149056" MODIFIED="1675691793238" TEXT="&lt;!-- --&gt;"/>
</node>
<node CREATED="1675691863336" ID="ID_1478593749" MODIFIED="1675691877086" TEXT="namespaces">
<node CREATED="1675691878771" ID="ID_440004692" MODIFIED="1675691898354" TEXT="f&#xf6;r logisk organisering av namn"/>
<node CREATED="1675691917594" ID="ID_1750517684" MODIFIED="1675691998765">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &lt;car
    </p>
    <p>
      xmlns=&quot;http://..asda&quot;
    </p>
    <p>
      xmlns:m=&quot;http://..asdahd&quot;
    </p>
    <p>
      
    </p>
    <p>
      &lt;model m:Name=&quot;volvo&quot; /&gt;
    </p>
    <p>
      
    </p>
    <p>
      &lt;/car&gt;
    </p>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1675692099369" ID="ID_417882647" MODIFIED="1675692129975" TEXT="Alla attribut som finns i primary namespace beh&#xf6;ver inte referas med sitt prefix, dvs m&apos;et ovan"/>
</node>
<node CREATED="1675691317735" ID="ID_89324331" MODIFIED="1675691323958" TEXT="Xml deklarationer">
<node CREATED="1675691743504" ID="ID_1931864228" MODIFIED="1675691748694" TEXT="&lt;? ?&gt;">
<node CREATED="1675691758549" ID="ID_1306659245" MODIFIED="1675691766114" TEXT="version och teckenkodning tex"/>
</node>
</node>
<node CREATED="1675691493593" ID="ID_1251328880" MODIFIED="1675691493593" TEXT="">
<node CREATED="1675691302729" ID="ID_910428978" MODIFIED="1675691305116" TEXT="Markup">
<node CREATED="1675691465421" ID="ID_87402935" MODIFIED="1675691470793" TEXT="&lt;&gt;"/>
</node>
<node CREATED="1675691306242" ID="ID_1684307393" MODIFIED="1675691308283" TEXT="Content">
<node CREATED="1675691472072" ID="ID_636576868" MODIFIED="1675691478888" TEXT="allt utan krok"/>
</node>
<node CREATED="1675691503847" ID="ID_139064164" MODIFIED="1675691503847" TEXT="">
<node CREATED="1675691310726" ID="ID_1224164080" MODIFIED="1675691312464" TEXT="Element">
<node CREATED="1675691313229" ID="ID_1807102656" MODIFIED="1675691461536" TEXT="Attribut">
<node CREATED="1675691376703" ID="ID_1649986902" MODIFIED="1675691394572" TEXT="tex &lt;car regno=&quot;asad&quot;&gt;"/>
<node CREATED="1675691395759" ID="ID_1348993758" MODIFIED="1675691407831" TEXT="element namn f&#xf6;ljt av attribut"/>
<node CREATED="1675691696812" ID="ID_688048556" MODIFIED="1675691702102" TEXT="Namn-v&#xe4;rdepar"/>
<node CREATED="1675691703863" ID="ID_858471691" MODIFIED="1675691714580" TEXT="delas up med ,; eller &apos; &apos;"/>
</node>
<node CREATED="1675691628960" ID="ID_1339696838" MODIFIED="1675691641999" TEXT="&lt; /&gt; tomot element"/>
</node>
<node CREATED="1675691308776" ID="ID_549893487" MODIFIED="1675691310123" TEXT="Taggar">
<node CREATED="1675691552598" ID="ID_1604272385" MODIFIED="1675691574220" TEXT="&lt;elementnamn /&gt; alternativit &lt;ad&gt;&lt;/ad&gt;"/>
</node>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1675696151982" ID="ID_801914006" MODIFIED="1675754033513" POSITION="left" TEXT="ProjektTypen Wpf">
<node CREATED="1675696164396" FOLDED="true" ID="ID_310179709" MODIFIED="1675753758313" TEXT="assemblies">
<node CREATED="1675696173483" ID="ID_1880035247" MODIFIED="1675696179083" TEXT="PresentationCore.dll"/>
<node CREATED="1675696179572" ID="ID_132755044" MODIFIED="1675696186102" TEXT="PresentationFramwork.dll"/>
<node CREATED="1675696186664" ID="ID_158082182" MODIFIED="1675696191460" TEXT="System.Xaml.dll"/>
<node CREATED="1675696198948" ID="ID_304295788" MODIFIED="1675696203885" TEXT="WindowsBase.dll"/>
</node>
<node CREATED="1675696208600" FOLDED="true" ID="ID_753541900" MODIFIED="1675754254543" TEXT="genererar">
<node CREATED="1675696216855" FOLDED="true" ID="ID_876524160" MODIFIED="1675753758313" TEXT="App.Xaml">
<node CREATED="1675696340489" ID="ID_813271227" MODIFIED="1675696476717">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &lt;Application x:Class=&quot;WpfTesterApp.App&quot;
    </p>
    <p>
      xmlns=&quot;http://...&quot;
    </p>
    <p>
      xmlns:x=&quot;http://...&quot;
    </p>
    <p>
      xmlns:local=&quot;clr-namespace:wpfTesterApp&quot;
    </p>
    <p>
      StartupUri=&quot;MainWindow.xaml&quot;&gt;
    </p>
    <p>
      &lt;Application.Resources&gt;
    </p>
    <p>
      &lt;/Application.Resources&gt;
    </p>
    <p>
      &lt;/Application&gt;
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node CREATED="1675696224631" ID="ID_252873855" MODIFIED="1675754071789" TEXT="App.xaml.cs">
<node CREATED="1675696499286" ID="ID_466065016" MODIFIED="1675754126562">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      using System;
    </p>
    <p>
      using System.Collections.Generic;
    </p>
    <p>
      using System.Configuration;
    </p>
    <p>
      using System.Data;
    </p>
    <p>
      using System.Linq;
    </p>
    <p>
      using System.Threading.Tasks;
    </p>
    <p>
      using System.Windows;
    </p>
    <p>
      
    </p>
    <p>
      Namespace WpfTesterApp
    </p>
    <p>
      {
    </p>
    <p>
      /// &lt;summary&gt;
    </p>
    <p>
      /// interaction logic for app.xml
    </p>
    <p>
      /// &lt;/summary&gt;
    </p>
    <p>
      public partial class App : Application
    </p>
    <p>
      {
    </p>
    <p>
      
    </p>
    <p>
      public void InitializeComponent()
    </p>
    <p>
      {
    </p>
    <p>
      <b>this.StatupUri = new System.uri(&quot;mainWindow.xml&quot;,System.uriKind.Relative);</b>
    </p>
    <p>
      }
    </p>
    <p>
      
    </p>
    <p>
      <b>public static void mainn() { </b>
    </p>
    <p>
      <b>WpfTesterApp.App app = new WpfTesterApp.app(); </b>
    </p>
    <p>
      <b>app.initizeComponent(); </b>
    </p>
    <p>
      <b>app.Run(); </b>
    </p>
    <p>
      <b>}</b>
    </p>
    <p>
      
    </p>
    <p>
      
    </p>
    <p>
      
    </p>
    <p>
      }
    </p>
    <p>
      }
    </p>
    <p>
      
    </p>
    <p>
      }
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node CREATED="1675696236480" FOLDED="true" ID="ID_460722393" MODIFIED="1675753758312" TEXT="MainWindow.xaml">
<node CREATED="1675696713485" ID="ID_1384434071" MODIFIED="1675697220567">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &lt;Window x:Class=&quot;WpfTesterApp.MainWindow&quot;
    </p>
    <p>
      xmlns=&quot;http://...&quot;
    </p>
    <p>
      xmlns:x=&quot;http://&quot;
    </p>
    <p>
      xmlns:d=&quot;http://&quot;
    </p>
    <p>
      xmlns:mc=&quot;http&quot;
    </p>
    <p>
      mc:Ignorable=&quot;d&quot;
    </p>
    <p>
      Title=&quot;MainWindow&quot; Height=&quot;450&quot; Width=&quot;800&quot;&gt;
    </p>
    <p>
      &lt;Grid&gt;
    </p>
    <p>
      &lt;/Grid&gt;
    </p>
    <p>
      &lt;/Window&gt;
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node CREATED="1675696244995" ID="ID_1275491860" MODIFIED="1675754043647" TEXT="MainWindow.xaml.cs">
<node CREATED="1675697223688" ID="ID_222817198" MODIFIED="1675754057911">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      using System;
    </p>
    <p>
      using System.Collections.Generic
    </p>
    <p>
      using System.Linq;
    </p>
    <p>
      using System.Text;
    </p>
    <p>
      using System.Threading.Tasks;
    </p>
    <p>
      using System.Windows;
    </p>
    <p>
      using System.Windows.Controls;
    </p>
    <p>
      using System.Windows.Data;
    </p>
    <p>
      using System.Windows.Documents;
    </p>
    <p>
      using System.Windows.Input;
    </p>
    <p>
      using System.Windows.Media;
    </p>
    <p>
      using System.Windows.Media.Imaging;
    </p>
    <p>
      using System.Windows.Navigation;
    </p>
    <p>
      using System.Windows.Shapes;
    </p>
    <p>
      
    </p>
    <p>
      namespace WpfTesterApp
    </p>
    <p>
      {
    </p>
    <p>
      public partial class MainWindow : Window
    </p>
    <p>
      {
    </p>
    <p>
      Public MainWindow()
    </p>
    <p>
      {
    </p>
    <p>
      InitializeComponent()
    </p>
    <p>
      {
    </p>
    <p>
      }
    </p>
    <p>
      }
    </p>
    <p>
      
    </p>
    <p>
      
    </p>
    <p>
      }
    </p>
    <p>
      
    </p>
    <p>
      }
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node CREATED="1675696319714" ID="ID_948736891" MODIFIED="1675696322774" TEXT="app.comfig"/>
</node>
<node CREATED="1675754255884" ID="ID_904132227" MODIFIED="1675754266128" TEXT="f&#xf6;rsta f&#xf6;nster program">
<node CREATED="1675754267312" ID="ID_787615226" MODIFIED="1675754279675" TEXT="MainWindow.xaml.cs">
<node CREATED="1675754369793" ID="ID_1337079829" MODIFIED="1675754428439" TEXT="private void myButton_Click(object sender, RoutedEventArgs e) {}"/>
</node>
<node CREATED="1675754290177" ID="ID_1093552467" MODIFIED="1675754295964" TEXT="MainWindow.xaml">
<node CREATED="1675754296676" ID="ID_1398856387" MODIFIED="1675754364873">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      &lt;Button x:Name&quot;myButton&quot; Content=&quot;ClickMe&quot; <b>Click</b>=&quot;myButton_Click&quot;/&gt;
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
</node>
</node>
</map>
