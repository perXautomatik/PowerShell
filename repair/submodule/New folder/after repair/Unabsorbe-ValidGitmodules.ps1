function Unabsorbe-ValidGitmodules {

<#
.SYNOPSIS
Unabsorbe-ValidGitmodules from a git repository.

.DESCRIPTION
Unabsorbe-ValidGitmodules from a git repository by moving the .git directories from the submodules to the parent repository and updating the configuration.

.PARAMETER Paths
The paths of the submodules to extract. If not specified, all submodules are extracted.

.EXAMPLE
Extract-Submodules

.EXAMPLE
Extract-Submodules "foo" "bar"
[alias]
    extract-submodules = "!gitextractsubmodules() { set -e && { if [ 0 -lt \"$#\" ]; then printf \"%s\\n\" \"$@\"; else git ls-files --stage | sed -n \"s/^160000 [a-fA-F0-9]\\+ [0-9]\\+\\s*//p\"; fi; } | { local path && while read -r path; do if [ -f \"${path}/.git\" ]; then local git_dir && git_dir=\"$(git -C \"${path}\" rev-parse --absolute-git-dir)\" && if [ -d \"${git_dir}\" ]; then printf \"%s\t%s\n\" \"${git_dir}\" \"${path}/.git\" && mv --no-target-directory --backup=simple -- \"${git_dir}\" \"${path}/.git\" && git --work-tree=\"${path}\" --git-dir=\"${path}/.git\" config --local --path --unset core.worktree && rm -f -- \"${path}/.git~\" && if 1>&- command -v attrib.exe; then MSYS2_ARG_CONV_EXCL=\"*\" attrib.exe \"+H\" \"/D\" \"${path}/.git\"; fi; fi; fi; done; }; } && gitextractsubmodules"

    git extract-submodules [<path>...]
#>

    param (
        [string[]]$Paths
    )

    # get the paths of all submodules if not specified
    if (-not $Paths) {
        $Paths = Get-SubmoduleDeep
    }

    # loop through each submodule path
    foreach ($Path in $Paths) {
        $gg = "$Path/.git"
        
        # check if the submodule has a .git file
        if (Test-Path -Path "$gg" -PathType Leaf) {
            # get the absolute path of the .git directory
            $GitDir = Get-GitDir -Path $Path

            # check if the .git directory exists
            if (Test-Path -Path $GitDir -PathType Container) {
                # display the .git directory and the .git file
                Write-Host "$GitDir`t$gg"

                # move the .git directory to the submodule path
                Move-Item -Path $GitDir -Destination "$gg" -Force -Backup

                # unset the core.worktree config for the submodule
                Remove-Worktree -ConfigPath "$gg/config"

                # remove the backup file if any
                Remove-Item -Path "$gg~" -Force -ErrorAction SilentlyContinue

                # hide the .git directory on Windows
                Hide-GitDir -Path $Path
            }
        }
    }
}
