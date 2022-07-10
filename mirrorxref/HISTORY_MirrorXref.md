
[`MirrorXref`](https://github.com/bakerjd99/jacks/blob/master/mirrorxref/MirrorXref.ijs) - change history
=========================================================================================================

### June 5, 2022

* Added `TODO_MirrorXref.md` to distribution and renamed `mirror_history.md` to
  `HISTORY_MirrorXref.md`. It's about time I standardized my
  haphazard notes and plans for frequently used complex scripts.

### June 4, 2022

* `BuildMirror` modified to generate a `mirror_temp.db` to resolve
  forward references when fixing bogus real dates.

### June 2, 2022

* Added `SetBogusRealDates` to group. This verb fetches
  real dates from the local primary thumbsplus database
  and inserts them in `.fix` real date files. I will still
  need to handle dates that are not in the local database
  and inspect the `.fix` files before mirror building
  but this verb will greatly ease the burden of patching
  these dates.

### May 27, 2022

* Added `CheckRealDates` to group. The python function that
  fetches real dates from SmugMug stopped working. For now
  I am returning a bogus real date that I fix manually. `CheckRealDates`
  makes sure these bogus dates not do get stored in `mirror.db`.

### November 3, 2020

* Fix typos in `CreateMirror_sql` foreign key definitions. I've been running
  `MirrorXref` for the last year without two foreign keys. I didn't notice the
  omission until I generated an ERD (Entity Relationship Diagram) for `mirror.db`
  while refining  `jodliterate` documentation for this system.  **See, literate
  programming helps you spot *problemos!***

### November 28, 2019

* Modified `Divisible` and `NotDivisble` to handle gallery
  counts that are divisible by 3 and 5. The iPhone SmugMug 
  app display images in rows of 3 and also 5 when rotated.

### October 3, 2019

* Added `Divisible` to  `MirrorXref.ijs` - this verb lists
  galleries that have image counts divisible by three.

### August 16, 2019

 * I have added code to `MirrorXref.ijs` to calculate various handy 
   `mirror.db` summary statistics like:

   1. Estimates of how many images I will upload in the current year.

   2. Gallery size statistics.

   3. A list of galleries that have sizes that are not divisible by three.

   The summaries are written to a text file that is version controlled.

### March 5, 2019

 * `mirror.db` related programs are now complex enough
   and important enough to merit better history tracking.
   
   The following changes have been been made.
   
   1. An online upload check for duplicate file names has been added.
      *The file name is a natural key for SmugMug accounts.* The upload
       utility skips duplicates when loading into a given gallery but
       I have seen duplicates when scanning files across all galleries.
       It simplifies `mirror.db` processing if online file names are unique.
       `uploadcheck.bat` checks uploads for duplicates.
	  
   2. I have modified `ThumbsMirror.ijs` to check for the presence of
      a test version of the SQLite Thumbsplus primary database and use it
      if present. `ThumbsMirror.ijs` is the only script that modifies
      a Thumbs database. The primary database is one of my most treasured
      files. Let's not screw it up!

   3. I have added a simple means to comment out lines in `manlocoxref.txt`
      The other night some manual corrections I entered into this file
      broke one of my galleries. One or more of the corrections are wrong.
      Now that I can easily switch to a primary test database and
      comment out data lines it should be easy to find the offending records.

   4. I am going to start making sure original files have different names
      than "developed files." `mirror.db` code paired some original
      `jp2` and other files with online names. These pairs are wrong
      and result from the original and developed files having the 
      same name but different extensions. In the future I will
      append the following suffixes to all scan files.
       
      1. `scb` flatbed scans `my flat bed scan name scb.jp2`
      2. `scf` film scans `my film scan name scf.jp2`
      3. `scc` camera scans `my camera scan name scc.tif`

      Digital image files are generally not a problem as the 
      names cameras assign to images are so hideous that I
      am forced to change their names.

 
 
