---
layout: post
title: ePubCheck Helper
date: 2013-09-07
comments: true
categories: projects software
image: https://c1.staticflickr.com/7/6231/6364275277_7dcaf17e88_z.jpg
image-source: https://www.flickr.com/photos/neilharvey/6364275277/
image-desc: Kobo eReader
image-credit: https://www.flickr.com/photos/neilharvey/
image-creator: Neil Harvey
summary: A simple helper script for <a href="https://github.com/IDPF/epubcheck">ePubCheck</a>
---

-[&nbsp;**background**&nbsp;]-

**[ePubCheck](https://github.com/IDPF/epubcheck "ePubCheck")**&nbsp;is a great command line utility that validates&nbsp;[EPUB](http://en.wikipedia.org/wiki/EPUB "EPUB") files to ensure proper structure and formatting. &nbsp;It provides a detailed log of issues, including improper html tags, indicating which row(s) of which file(s) in the EPUB contain the errors. &nbsp;It is an invaluable resource when creating EPUB files.

**[ePubCheck Helper](https://github.com/scumdogsteev/epc-helper)** is a simple batch file that allows the user to drag and drop an EPUB file (or a .zip file, as .epub files are renamed .zip files) to run ePubCheck, taking care of the [command line details](https://code.google.com/p/epubcheck/wiki/Running) for you. &nbsp;The script outputs ePubCheck's log to a .txt file in the directory with the original EPUB file.

-[ **notes** ]-

I know this isn't the first [utility of its kind](https://code.google.com/p/epubcheck/wiki/Running#Third-party_apps_with_GUI) (for instance, [EPUB-CHECKER](http://www.pagina-online.de/software/epub-checker/) seems to be a good one and there is also the web-based [EPUB validator](http://validator.idpf.org/ "EPUB validator")), and it likely isn't the best. &nbsp;I wanted to learn more about batch scripting and this seemed like a good way to do so. &nbsp;The results might be helpful for someone.

I am by no means an expert at batch scripting. &nbsp;I welcome comments on this script.

-[&nbsp;**requirements/limitations**&nbsp;]-

*   The user must have&nbsp;[ePubCheck](https://code.google.com/p/epubcheck/ "ePubCheck")&nbsp;installed.
*   This assumes the user is running Windows (checked with Windows 7, may work with earlier/later versions).

    *   The date/time stamp on the log filename only works properly for users whose Windows installation uses US-formatted dates (MM-DD-YYYY).

-[ **instructions**&nbsp;]-

_Installation:_

1.  Make sure you are running java (1.6 or above). &nbsp;This is a requirement of&nbsp;ePubCheck.
2.  Install&nbsp;[ePubCheck](https://code.google.com/p/epubcheck/ "ePubCheck"). &nbsp;The latest version (as of 2013-09-07) is 3.0.1, but this should work with other versions.
3.  Download the .zip file (epc-helper.zip).
4.  Extract the .bat file (epc-helper.bat) to the same folder where you have previously installed ePubCheck.

_Running ePubCheck Helper:_

1.  [Create a shortcut](http://support.microsoft.com/kb/140443)&nbsp;to epc-helper.bat in the folder where your EPUB file(s) is (are) located.
2.  Drag and drop an EPUB file onto the shortcut you created in step 1. &nbsp;This runs ePubCheck.
    *   The script checks for a .epub extension.
    *   Dragging and dropping a file with a .zip extension also works.
		*   In this case, the script copies the .zip file to a new file with the same filename and an extension of .epub. &nbsp;(This can help save time, as it automates the required renaming step in EPUB creation.)
    *   Dragging and dropping files with any extension other than .epub or .zip terminates the script.
3.  When ePubCheck has finished, a pop-up window will tell you the status.
    *   **Successful completion:**&nbsp; the filename of the log file where the results are stored is displayed ("Successful" in this case refers to ePubCheck running successfully,&nbsp;_not_ to successful validation of the .epub file itself)
    *   **Unsuccessful completion:** &nbsp;you attempted to run ePubCheck on a file with the wrong extension (not .epub or .zip)
    *   **Unsuccessful completion:** &nbsp;ePubCheck cannot be found in the same folder where epc-helper.bat is located. &nbsp;If you receive this message, make sure you followed the instructions above (under "installation") and try again.
4.  Check the log file for errors. &nbsp;The log file's name will be [EPUB name]-[date/time stamp].log.
    *   The date/time stamp is added so you can easily keep track of which validation attempt you are looking at.
    *   Date/time stamp format: &nbsp;YYYYMMDD-HH_MM_SS
    *   Example: &nbsp;epub-20130907-17_46_31.log
5.  Fix the errors in your EPUB (as noted in the log file) and try again (go to step 2) if necessary. &nbsp;If your&nbsp;EPUB&nbsp;file successfully validates, congratulations!

-[&nbsp;**to do**&nbsp;]-

*   Make the time stamp work with systems having non-US formatted dates

-[&nbsp;**acknowledgment**&nbsp;]-

*   Date parsing is taken from [Rob van der Woude](http://www.robvanderwoude.com/datetimentparse.php "Rob van der Woude")

-[&nbsp;**license**&nbsp;]-

*   Licensed under the [MIT License](https://github.com/scumdogsteev/epc-helper/blob/master/LICENSE "MIT License")

-[&nbsp;**changelog**&nbsp;]-

0.1.0-a (2015-01-19)

*   moving files to GitHub

0.1.0 (2013-09-07)

*   first release

-[&nbsp;**download**&nbsp;]-

[ [batch file + documentation](https://github.com/scumdogsteev/epc-helper/releases) ] &#124; [ [all files](https://github.com/scumdogsteev/epc-helper) ] &#124; [ [.zip (v.0.1.0)](http://steve.mylesandmyles.info/projects/epc-helper/epc-helper_0.1.0.zip) ]