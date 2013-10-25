# Sepp: A markdown compatible plain text parser for Sente. 
Version 0.1.2, 15 May 2013

Sepp stands for Sente Plain Text Parser. [Sente](http://www.thirdstreetsoftware.com) is an academic reference manager by for Mac. After stints with Bookends, Zotero, Endnotes, Papers, Mendelay, bibtex and citeproc, I have kept coming back to it. 

However, my one big problem was that Sente's built in parser for plain text files is not markdown compatible. It does not output markdown style *italics*, for example, which makes it essentially useless for markdown workflows. Sepp fills this gap and offers additional options, such as scanning in place and a (somewhat experimental) "unscan" feature.

Sepp is a simple command-line tool written in Ruby.

## Installation

*Sepp* depends on *thor* and *terminal-notifier* (if you use the -n option; see below). Install both gems if you do not already have them:

    gem install thor
    gem install terminal-notifier

Put the *sepp*-folder anywhere, and create a symbolic link in /usr/local/bin: open the terminal, navigate to the *sepp*-folder, and run:

    ln -s sepp /usr/local/bin/sepp

Type `sepp` in your terminal and you should be presented with a summary of the commands. Tested under Mac OSX 10.7 and Ruby 1.9 and nowhere else...

## Usage

*Sepp* has two commands: scan and unscan:

### Scan

`sepp scan manuscript.md` will update the document with a bibliography in the last used bibliography style.

*Arguments:* 

`--backup` or  `-b`: backup the source file instead of overwriting it.
`--notify` or `-n`: use Mac OS X notifications. This may be helpful if you plan to integrate *sepp* into other scripts or Automator workflows.

### Unscan

`sepp unscan manuscript.md` will (try to) "unscan" your manuscript and put back the original Sente citation markers – {Doe 2013@123}, for example. 

This feature is somewhat experimental. It should work for round-tripping with moderate editing, but will probably fail in the case of a complete rewrite of the document. Feel free to look at the code and suggest better options.

The `unscan` is primarily meant to allow simple round-tripping: send a document to an editor with a formatted bibliography, get it back, "unscan" it again to continue working. As a rule of thumb, bibliographies should still be produced as late as possible.

 *Arguments:* 

`-b`: as above
`-n`: as above
`-r`: remove bibliography, or try to do so. This only works if there is a markdown header 'Bibliography' or 'Reference' in the document. Unless specified, unscan will only change inline citations, but leave the bibliography untouched. This option is not well tested. Back up your document using the `-b` option.

## Important warning

I frequently use *sepp* for my own writing but I have not tested it widely. Be prepared for errors or unexpected results. Use git or another version control system and commit all changes before scanning or unscanning documents.






