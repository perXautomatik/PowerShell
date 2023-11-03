<#
    # 设置 PowerShell 主题
 * Author: 刘 鹏
 * Email: littleNewton6@outlook.com
 * Date: 2021, Aug. 21
   # 引入 ps-read-line # useful history related actions      
   # example: https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1
#>
   if (Test-ModuleExists 'PSReadLine')
    {
# 引入 ps-read-line
 	    if(!(TryImport-Module PSReadLine)) #null if fail to load
        {        
         

                if ( $(Test-CommandExists 'Set-PSReadLineOption') )
                {                               
				
				

	                if ( $(Get-Module PSReadline).Version -ge 2.2 ) {
	                    # 设置预测文本来源为历史记录
	                    Set-PSReadLineOption -predictionsource history -ea SilentlyContinue
	                }

		            $PSReadLineOptions = @{
		                HistorySavePath = $global:historyPath
					# 设置预测文本来源为历史记录
		                PredictionSource = "HistoryAndPlugin"
					# 每次回溯输入历史，光标定位于输入内容末尾
		                HistorySearchCursorMovesToEnd = $true                        
		            }
            
		            Set-PSReadLineOption @PSReadLineOptions
            
		            echo ($host.Name -eq 'ConsoleHost')
		}
# 设置 Tab 为菜单补全和 Intellisense
                Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete       
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

# 设置 Ctrl+d 为退出 PowerShell
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit

# 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

            # 设置向上键为后向搜索历史记录 # Autocompletion for arrow keys @ https://dev.to/ofhouse/add-a-bash-like-autocomplete-to-your-powershell-4257
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
#-------------------------------  Set Hot-keys END    -------------------------------

                if ( $(Test-CommandExists 'Set-PSReadLineOption') )
                {
                    #------------------------------- Styling begin --------------------------------------					      
                    #change selection to neongreen
                    #https://stackoverflow.com/questions/44758698/change-powershell-psreadline-menucomplete-functions-colors
                    $colors = @{
                    "Selection" = "$([char]0x1b)[38;2;0;0;0;48;2;178;255;102m"
                    }
                    Set-PSReadLineOption -Colors $colors
                }
                echo "historyPath: $global:historyPath"
        }
        else
        {
            Write-Verbose "psReadLineNotimported"
        }
    }
    else
    {
        Write-Verbose "psReadLineNotpresent"
    }