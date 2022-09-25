The script and the directory where it's stored must use the same name. 
    For example, a script named MyPsScript.psm1 is stored in a directory named MyPsScript.

The module's directory needs to be in a path specified in $env:PSModulePath.

To control user access to certain functions or variables, 
    call Export-ModuleMember at the end of your script.

If you have modules that your own module needs to load,
    you can use Import-Module, at the top of your module.

module manifest is a file that 
    contains the names of other modules, 
    directory layouts, 
    versioning numbers, 
    author data, 
    and other pieces of information.


    todo: autogenerate moudlue manifest template
    todo: autogenerate module manifest for git repos,