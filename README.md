210 Library Documentation

# Uploading the book onto Diderot
The book maybe uploaded onto diderot volume by volume or chapter by chapter.  See the Makefile for chapter by chapter uploads.  You can un for example

```
$ make upload_sequences_interface
```

A simpler way to upload the book is to use the diderot admin.

Follow the following steps
I.1) Create book with label LIBDOC
I.2) Make all xml and pdf files
```
$ make all
```
I.3) run 
```
$ ../../diderot-cli/diderot_admin [--url https://api.diderot.one]  upload_book <course-label> book.json
```


