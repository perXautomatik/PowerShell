split

defeine pattern, as object 
    field = url, title, depth
    match = what to match in field
    logic = 'and,or,xor' 
    group = N if no group specified, applies logic to complete expression, else resolve groups separately before resolving

define wrapper for finished process
    prefix
    sufix


merge
    list of templates
        a template is simply a matching statement, and a wrapper statement.
    asuming a merge is given a list of objects
    assume each object has a identifing key
    assume that each key is unique, and if key is not unique, treat entry as a child of key rather than a sibling
    !give each input object a sorted list as inputkey
    from whom unique key resolution whill happen, 
        if key is resolved as unique, 
            create a sibling node, 
        if key is not unique, 
            select konflicting key as root, 
                then resolve next key if more than one is given,
                    repeat until no more keys given.




