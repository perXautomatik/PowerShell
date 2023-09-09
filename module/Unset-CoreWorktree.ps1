function Unset-CoreWorktree {

<#
.SYNOPSIS
Unsets the core.worktree configuration for a submodule.

.DESCRIPTION
Unsets the core.worktree configuration for a submodule by running git config --local --path --unset core.worktree.

.PARAMETER Path
The path of the submodule.
#>
    param (
	[Parameter(Mandatory)]
	[string]$Path
    )

    # run git config --local --path --unset core.worktree for the submodule
    git --work-tree=$Path --git-dir="$Path/.git" config --local --path --unset core.worktree
}
