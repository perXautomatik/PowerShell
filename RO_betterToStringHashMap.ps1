#https://www.sapien.com/blog/2014/10/21/a-better-tostring-method-for-hash-tables/

#better hashtable ToString method
Update-TypeData -TypeName "System.Collections.HashTable"   `
-MemberType ScriptMethod `
-MemberName "ToString" -Value { $hashstr = "@{"; $keys = $this.keys; foreach ($key in $keys) { $v = $this[$key];
       if ($key -match "\s") { $hashstr += "`"$key`"" + "=" + "`"$v`"" + ";" }
       else { $hashstr += $key + "=" + "`"$v`"" + ";" } }; $hashstr += "}";
       return $hashstr }