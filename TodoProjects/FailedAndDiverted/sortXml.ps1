Install-Package chilkat-x64 -Version 9.5.0.91

#Add-Type -Path "C:\chilkat\ChilkatDotNet47-9.5.0-x64\ChilkatDotNet47.dll"

$xml = New-Object Chilkat.Xml

# The sample input XML is available at http://www.chilkatsoft.com/data/fruitSort2.xml
$success = $xml.LoadXmlFile("fruitSort2.xml")
if ($success -ne $true) {
    $($xml.LastErrorText)
    exit
}

# Sort the direct children under the "fruits" node by tag:
$xSortRoot = $xml.FindChild("fruits")

# Sort in ascending order.
$bAscending = $true
$xSortRoot.SortByContent($bAscending)

# Show the result:
$($xml.GetXml())

# Note:  The "apples" node contains child nodes, but its 
# text content is 0-length (empty).  Therefore, when sorting in
# ascending order, it will be positioned before the direct
# children containing non-empty content.

# <root>
#     <fruits>
#         <apples>
#             <apple>granny smith</apple>
#             <apple>gala</apple>
#             <apple>fuji</apple>
#             <apple>mcintosh</apple>
#             <apple>honeycrisp</apple>
#         </apples>
#         <fruit>banana</fruit>
#         <fruit>blackberry</fruit>
#         <fruit>blueberry</fruit>
#         <fruit>orange</fruit>
#         <fruit>pear</fruit>
#     </fruits>
# </root>

# Sort the direct children under the "apples" node:
$success = $xSortRoot.FindChild2("apples")

$xSortRoot.SortByContent($bAscending)
$($xml.GetXml())

# <root>
#     <fruits>
#         <apples>
#             <apple>fuji</apple>
#             <apple>gala</apple>
#             <apple>granny smith</apple>
#             <apple>honeycrisp</apple>
#             <apple>mcintosh</apple>
#         </apples>
#         <fruit>banana</fruit>
#         <fruit>blackberry</fruit>
#         <fruit>blueberry</fruit>
#         <fruit>orange</fruit>
#         <fruit>pear</fruit>
#     </fruits>
# </root>