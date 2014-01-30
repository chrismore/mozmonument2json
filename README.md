mozmonument2json
================

This repository contains scripts and json files from [Mozilla's SF monument][monwiki]. 

Both json files contain the same data, but just in a different structure.

mozmonument-nested.json -- nested by side.

mozmonument.json -- flat.

mozmonument2json-nested.sh -- shell script to create the nested json.

mozmonument2json.sh -- shell script used to create the flat json.

mozmonument.csv -- names in csv format.

SFMonumentNamesPerPanelPlainText.txt -- raw data from Adobe Illustrator with some regex applied to make it easier to parse.

Side key:

* 1 and 4 face the embarcadero
* 1 and 2 face harrison
* 2 and 3 face the building 
* 3 and 4 face the stairs

If you have created an app, please file a Github [issue][githubissues] to have it listed on the [wiki][monwiki].

A couple ideas:

* Mobile name finder
* CSS rotating monument
* SVG monument

[monwiki]: https://wiki.mozilla.org/Monument
[githubissues]: https://github.com/chrismore/mozmonument2json/issues