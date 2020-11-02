# Keepnote to Cherrytree migration script

A simple bash tool to migrate a Keepnote HTML directory to CherryTree HTML format.
The tool is a quick a dirty script and some work needs to be done manually. A better job can be done with a HTML/XML parser.

I built this tool because of KeepNote EOL with Python2 and to quick fix import HTML format.

## Features
* Migrate first level of ```<ul>``` / ```<ol>``` lists
* Removes empty ```<li>```
* Migrate directory structure to avoid having single nodes named "page"
* Migrate embedded images files with MD5 renaming
* Clean empty nodes

## What it does not do
* Migrate nested ```<ul>``` / ```<ol>``` lists
* Preserve initial orders of nodes

## Usage
```
chmod +x migrate.sh
./migrate.sh ~/my-notes/
```

A new directory will be created in:
```
~/my-notes-migrated/
```

Then use HTML directory import feature from Cherry Tree:
```
Import > From Directory of HTML Files > Enter into ~/my-notes-migrated/ and choose "Open" 
```
