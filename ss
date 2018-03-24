
G:\home\ARM_EDITOR>C:\Java\jdk1.8.0_121\bin\java -jar bfg.jar --strip-blobs-bigger-than 2M  

Using repo : G:\home\ARM_EDITOR\.git


This repo has been processed by The BFG before! Will prune repo before proceeding - to avoid unnecessary cleaning work on unused objects...
Completed prune of old objects - will now proceed with the main job!

Scanning packfile for large blobs completed in 180 ms.
Found 91 blob ids for large blobs - biggest=1351209371 smallest=2144293
Total size (unpacked)=2281009521
Found 4847 objects to protect
Found 3 commit-pointing refs : HEAD, refs/heads/master, refs/remotes/origin/master

Protected commits
-----------------

These are your protected commits, and so their contents will NOT be altered:

 * commit af1da431 (protected by 'HEAD') - contains 5 dirty files : 
	- Vlc-qt сборка - Qt - Киберфорум.pdf (3,7 MB)
	- bfg.jar (12,8 MB)
	- ...

WARNING: The dirty content above may be removed from other commits, but as
the *protected* commits still use it, it will STILL exist in your repository.

Details of protected dirty content have been recorded here :

G:\home\ARM_EDITOR.bfg-report\2018-03-24\19-08-10\protected-dirt\

If you *really* want this content gone, make a manual commit that removes it,
and then run the BFG on a fresh copy of your repo.
       

Cleaning
--------

Found 66 commits
Cleaning commits completed in 599 ms.

BFG aborting: No refs to update - no dirty commits found??



--
You can rewrite history in Git - don't let Trump do it for real!
Trump's administration has lied consistently, to make people give up on ever
being told the truth. Don't give up: https://github.com/bkeepers/stop-trump
--


