Windows:
scoop install diffsitter
Once diffsitter is installed, you can configure it to integrate with Git. To do this, add the following lines to your .gitconfig file:

[diff]
tool = diffsitter
[difftool]
prompt = false
[difftool "diffsitter"]
cmd = diffsitter "$LOCAL" "$REMOTE"
This will tell Git to use diffsitter as the default difftool.

Once you have configured diffsitter, you can start using it to view diffs between commits. To do this, simply run the git difftool command. Git will then open diffsitter with the two commits that you want to compare.

Diffsitter is a powerful tool for viewing diffs between commits. It provides a number of features that are not available in the default Git difftool, such as syntax highlighting and the ability to navigate between different files and lines of code.

Here are some additional tips for using diffsitter:

You can use the -s option to specify the specific languages that you want diffsitter to highlight. For example, to highlight diffs in Python and JavaScript, you would run the following command:
git difftool -s python,javascript
You can use the -f option to filter the output of diffsitter. For example, to filter out all diffs that are less than 5 lines long, you would run the following command:
git difftool -f "-l +5"
You can use the -p option to enable diffsitter's patch mode. This mode will show you a unified diff of the changes between the two commits.
Overall, diffsitter is a powerful and versatile tool for viewing diffs between commits. It is a good choice for developers who want a more comprehensive and informative diff experience.


To install and configure diffsitter and git integration, you will need to follow these steps:

Install diffsitter. You can do this using your package manager, or by compiling diffsitter from source.

Configure diffsitter. You can do this by creating a config file in the .config/diffsitter/config.json directory. In the config file, you can specify the file associations and formatting options for diffsitter.

Configure git to use diffsitter. To do this, add the following lines to your .git/config file:

[diff]
tool = diffsitter
[difftool]
prompt = false
[difftool "diffsitter"]
cmd = diffsitter "$LOCAL" "$REMOTE"
Once you have installed and configured diffsitter and git integration, you can use diffsitter to compare two branches of a git repository by running the following command:

git difftool <branch-name> <branch-name>
This will open diffsitter with the two branches that you specified. You can then use diffsitter to compare the two branches and resolve any conflicts.

Here are some additional tips for using diffsitter with git:

You can use the diffsitter --help command to see a list of all of the available commands and options.
You can use the diffsitter --config dump_default_config command to see the default config file.
You can use the diffsitter --config command to specify a different config file.
You can use the diffsitter --filter command to filter the output of diffsitter.
You can use the diffsitter --format command to specify the format of the output of diffsitter.
Overall, diffsitter is a powerful tool for comparing and resolving conflicts between two branches of a git repository. It can be helpful for complex merges, or for merges where you want to be able to test the changes before merging them in completely.