[`MirrorXref`](https://github.com/bakerjd99/jacks/blob/master/mirrorxref/MirrorXref.ijs) TODO
======================================================

Pending and considered changes for `MirrorXref`.

`MirrorXref` is a [J/JOD](https://analyzethedatanotthedrivel.org/the-jod-page/) class group that
converts a directory of metadata text and image thumbnail files to a single consolidated 
SQLite `mirror.db` database file, see:

* https://github.com/bakerjd99/jacks/blob/master/mirrorxref/MirrorXref.pdf

The base 36 case insensitive GUID key is stable over the lifetime of a task. It uniquely
labels each task and makes it possible compile detailed change histories
by trolling over the version history of this file.

`[begin-todo]`

1. `<_bbi74vorh3swa5369bpqrwjhk_>` Add two new tables to `mirror.db` to support non SmugMug image groups.

`[end-todo]`