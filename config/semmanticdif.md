# Semantic Diff Tool (sdt)

Welcome to [Atlantis Techology](https://www.atlantistech.com/)’s [Semantic Diff Tool](https://github.com/atlantistechnology/sdt). This tool is Free Libre Open Source Software (FLOSS) which we hope will prove useful to software developers (please contribute also).

The command-line tool `sdt` compares source files to identify which changes create semantic differences in the program operation, and specifically to exclude many changes which cannot be _functionally important_ to the operation of a program or library.

Use of `sdt` will allow code reviewers or submitters to assure that modifications made to improve stylistic formatting of the code—whether made by hand or using code-formatting tools—does not modify the underlying _meaning_ of the code.

As designed, the tool is much more likely to produce false positives for the presence of semantic changes than false negatives. That is to say, `sdt` might indicate that a certain segment of the diff between versions is _likely_ to contain a semantic difference in code, but upon human examination, a developer might decide that no actual behavior will change (or, of course, she might decide that the change in code behavior is a desired change).

It is unlikely that `sdt` will identify an overall file change, or any change to a particular segment of a diff as semantically irrelevant where that change actually does change behavior. However, this tool provides NO WARRANTY, and it remains up to your human developers and your CI/CD process to make final decisions on whether to accept code changes.

A quick example of usage shows an overview of capabilities (the switches added simply minimize the output context and remove reliance on colorized output). The comparison shown compares what is currently on disk to the HEAD of the working git branch (many other combinations are enabled with command flags).

% sdt semantic --dumbterm --minimal 2>/dev/null
Changes to be committed:
    modified:   .github/workflows/test-treesit.yaml
| No available semantic analyzer for this format
    new file:   pkg/types/types\_test.go
Changes not staged for commit:
    modified:   samples/filter.rb
| Segments with likely semantic changes
| @@ -3,4 +3,4 @@ def mod5?(items)
| -puts mod5? 1..100
| +puts mod5? 1..50
    modified:   samples/funcs.py
| No semantic differences detected
    modified:   samples/running-total.sql
|        count(DISTINCT co.order\_id) AS {{-num\_}}order{{-s}}{{+\_count}},

Integration with version control workflows, programming editors, and git subcommands is straightforward, and largely discussed in these docs.

Feel free to check out a brief discussion of [related tools](https://www.sdt.dev/related_tools.html). We believe that SDT addresses a particular need for code reviewers and CI/CD processes that is modestly novel, but it’s part of a space occupied by many other wonderful developer tools.

## Installation[](https://www.sdt.dev/#installation)

If the Go language is installed on your system, you may install `sdt` by cloning its source repository, and installing the tool using `go install`. For example:

```
% git clone https://github.com/atlantistechnology/sdt.git
% cd sdt
% go install ./...
```

These commands will install `sdt` itself, and also the small support tools `jsonformat`, `gotree`, and `treesit`. These latter tools may be used to evaluate changed JSON, Golang, and languages with installed tree-sitter grammar files, respectively. Additional similar tools are likely to be added as new languages are supported.

However, you may also simply download pre-built binaries for all available Go cross-compilation targets directly to your system path. For example, on a Linux operating system and an AMD64 architecture, you might download with:

```
% sudo curl https://sdt.dev/linux/amd64/sdt > /usr/local/bin/sdt
% sudo curl https://sdt.dev/linux/amd64/jsonformat > /usr/local/bin/jsonformat
% sudo curl https://sdt.dev/linux/amd64/gotree > /usr/local/bin/gotree
% sudo curl https://sdt.dev/linux/amd64/treesit > /usr/local/bin/treesit
% sudo chmod a+x /usr/local/bin/sdt \
  /usr/local/bin/jsonformat /usr/local/bin/gotree /usr/local/bin/treesit
```

The extra tool `jsonformat` is not needed for users who prefer to use the much more powerful [`jq`](https://stedolan.github.io/jq/) in their `.sdt.toml` configuration. The tool `gotree` produces a somewhat customized parse tree, so a different tool is unlikely to be compatible with `sdt`.

The separate step of setting the “executable bit” is probably not needed, but does no harm. If you are installing to a PATH that only needs user permission, the `sudo` is not necessary.

Jump to a [list of all downloadable files](https://www.sdt.dev/binaries.html) to locate those compiled for your operating system and CPU architecture.

## Integrations[](https://www.sdt.dev/#integrations)

### Editor plugins[](https://www.sdt.dev/#editor-plugins)

- [Vim](https://www.sdt.dev/plugins/vim.html)
- [VS Code](https://www.sdt.dev/plugins/vscode.html)
- [Atom](https://www.sdt.dev/plugins/atom.md)
- [Notepad++](https://www.sdt.dev/plugins/notepadplus.md)
- [Emacs](https://www.sdt.dev/plugins/emacs.md)
- [Sublime Text](https://www.sdt.dev/plugins/sublime.md)
- [Nano](https://www.sdt.dev/plugins/nano.md)

### Subcommand of git[](https://www.sdt.dev/#subcommand-of-git)

You may wish to use `sdt` as a `git` subcommand. To do so, you can create an alias either locally within `<repo>/.git/config` or globally within `$HOME/.gitconfig`, depending on which better suits your workflow.

A straightforward and useful alias can provide something akin to an enhanced `git diff`. This alias will either compare current files to the `HEAD` of the working branch, compare current files to another branch, or compare to branches/revisions to each other. For example:

```
% git sdt
INFO: Comparing HEAD to current changes on-disk
Changes not staged for commit:
    modified:   .gitignore
| No available semantic analyzer for this format
    modified:   README.md
| No available semantic analyzer for this format
```

```
% git sdt f7f6b934 ruby-samples
INFO: Comparing branches/revisions f7f6b934: to ruby-samples:
Changes between branches/revisions:
    samples/simple-filter.rb
| Segments with likely semantic changes
| @@ -3,6 +3,4 @@
|    items.to_a.select {|item| item % 5 == 0}
|  end
|
| -puts mod5? 1..50
| -puts mod5? 1..101
| -
| +puts mod5? 1..100
```

The alias for this behavior is:

```
[alias]
    sdt = "!f() { \
        if [ -z \"$1\" ]; then A=''; else A=\"--src $1:\"; fi; \
        if [ -z \"$2\" ]; then B=''; else B=\"--dst $2:\"; fi; \
        sdt semantic $A $B; }; f"
```

# Checking for semantic changes within a GitHub Action

You may wish to have a semantic analysis of changes performed along with every PR. This can be accomplished using a GitHub Action, or in an analogous way on other repository management services such as GitLab or BitBucket. The workflow shown below adds the analysis performed by SDT as a comment to every submitted pull request.

A discussion of the [workflows used in the SDT repository](https://www.sdt.dev/gh_action.html) contains illustrations of how to perform an integration with your collaborative merging and code reviews.

# Supported languages

Much of the work that Semantic Diff Tool accomplishes is done by means of utilizing other tools. You will need to install those other tools in your development environment separately. However, this requirement is generally fairly trivial, since the tools used are often the underlying runtime engines or compilers for the very same programming languages of those files whose changes are analyzed (in other words, the programming languages your project uses).

The configuration file `$HOME/.sdt.toml` allows you to choose specific versions of tools and specific switches to use. This is useful especially if a particular project utilizes a different version of a programming language than the one installed to the default path of a development environment. Absent an overriding configuration, each tool is assumed to reside on your $PATH, and a default collection of flags and switches are used.

For example, for Ruby files, the default command `ruby --dump=parsetree` is used to create an AST of the file being analyzed. Similarly, for Python files, `python -m ast -a` is used for the same purpose. Other tools produce canonical representations rather than ASTs, depending on what best serves the needs of a particular language (and depending on what tools are available, and their quality). While overriding the configuration between different versions of a programming language or tool will _probably_ not break the code that performs the semantic comparison, not all languages have been tested in all versions (especially for versions that will be created in the future and do not yet exist).

## Ruby[](https://www.sdt.dev/#ruby)

Initial support created. Supports both `semantic` and `parsetree` subcommands.

Only a `ruby` interpreter is required (by default)

## Python[](https://www.sdt.dev/#python)

Initial support created. Supports both `semantic` and `parsetree` subcommands.

Only a `python` interpreter is required (by default).

Note that for versions of Python before and including 3.8, the more complicated invocation shown in `samples/.sdt.toml` is needed rather than the simpler external call used by default in the SDT source code.

A summary of [all the syntax changes](https://www.sdt.dev/assets/Nikita_Denissov_discuss.html) in Python (and hence parse tree changes) was written by Nikita Denissov. This goes all the way back to Python 2.0, with links to corresponding PEPs and BPOs.

## SQL[](https://www.sdt.dev/#sql)

Initial support created. Uses canonicalization rather than parsing, so only the `semantic` subcommand is supported.

Requires the tool `sqlformat` (by default). See:

- https://github.com/andialbrecht/sqlparse
- https://manpages.ubuntu.com/manpages/jammy/man1/sqlformat.1.html

## JavaScript[](https://www.sdt.dev/#javascript)

Initial support created. Supports both `semantic` and `parsetree` subcommands.

Requires the `node` interpreter and the library `acorn` (by default). See:

- https://github.com/acornjs/acorn/tree/master/acorn/

Use of the error-tolerant variant `acorn-loose` was contemplated and rejected (as a default). We believe this tool would be more likely to produce spurious difference in parse trees. See:

- https://github.com/acornjs/acorn/tree/master/acorn-loose/

Note that Node 18.10 was used during development. However, any node version supported by Acorn should work identically. However, if you wish to treat the files being analyzed as a specific ECMAScript version, see the option `ecmaVersion` that can be configured in `.sdt.toml` and is discussed in the sample version of that file.

## JSON[](https://www.sdt.dev/#json)

JSON is supported by the bundled tool `jsonformat` which uses the internal Go library `json` to canonicalized documents. The much more sophisticated, and commonly installed third-party tool `jq` may also be used, and is illustrated within the sample `.sdt.toml`.

## Golang[](https://www.sdt.dev/#golang)

Go is supported by the bundled tool `gotree` which uses the internal Go libraries `go/ast`, `go/parser`, and `go/token`. The parse tree format produced by this tool is designed to make the work SDT does easy, but another library is very unlikely to produce a format compatible with the assumptions made in evaluating this parse tree.

## Tree-Sitter languages[](https://www.sdt.dev/#tree-sitter-languages)

The widely used parser generator `Tree-sitter` has had a great many grammars designed for it. This tool is used by the Atom editor and by GitHub in its code highlighting and analysis facilities. As noted relative to Difftastic, these grammars are all at “some version of the language” rather than allowing an arbitrary version to be configued; however, by utilizing this tool, SDT gets support for 63 languages (at time of this writing; some grammars are more complete than others, and some are independently supported by SDT “out of the box”).

Installing the command-line tool `tree-sitter` requires building a project using Rust’s `cargo` or Node.js’ `npm`, and generating each grammar requires that Node.js is installed. A C compiler is also needed to build the core parser.

There are a number of moving pieces needed to install each supported language, but the instructions in [the tree-sitter project documentation](https://tree-sitter.github.io/tree-sitter/) are fairly straightforward. If no more specialized language parser is defined in SDT specific code, a final effort is made to use the bundled tool `treesit` to produce a parse tree for a modified file.

The tool `treesit` wraps a call to `tree-sitter parse`, and merely massages the output slightly to produce a format compatible with that produced by `gotree`. This allows SDT to produce semantic analysis for all languages having installed tree-sitter grammars. Available grammars include: Agda; Bash; C; C#; C++; Common Lisp; CSS; CUDA; D; Dockerfile; DOT; Elixir; Elm; Emacs Lisp; Eno; ERB/EJS; Erlang; Fennel; GLSL (OpenGL Shading Language); Go; Go mod; Hack; Haskell; HCL; HTML; Java; JavaScript; JSON; Julia; Kotlin; Lua; Make; Markdown; Nix; Objective-C; OCaml; Perl; PHP; Protocol Buffers; Python; R; Racket; Ruby; Rust; Scala; S-expressions; SPARQL; SQL; Svelte; Swift; SystemRDL; TOML; Turtle; Twig; TypeScript; Verilog; VHDL; Vue; WASM; WGSL WebGPU Shading Language; YAML.