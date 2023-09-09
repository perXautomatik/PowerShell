function Get-GitRoot {
    	# Define a function to get the root of the git repository
	    (git rev-parse --show-toplevel)
	}
