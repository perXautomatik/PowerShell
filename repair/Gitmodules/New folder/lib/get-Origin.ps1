function get-Origin
{
		# Get the remote url of the git repository
		$ref = (git remote get-url origin)

		# Write some information to the console
		Write-Verbos '************************** ref *****************************'
		Write-Verbos $ref.ToString()
		Write-Verbos '************************** ref *****************************'
		return $ref
}
