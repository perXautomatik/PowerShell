function about-Repo()
	{

			$vb = ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent -eq $true)

				# Write some information to the console
			Write-Verbos '************************************************************' -Verbose: $vb
			Write-Verbos $targetFolder.ToString() -Verbose: $vb
			Write-Verbos $name.ToString() -Verbose: $vb
			Write-Verbos $path.ToString() -Verbose: $vb
			Write-Verbos $configFile.ToString() -Verbose: $vb
			Write-Verbos '************************************************************'-Verbose: $vb

	}
