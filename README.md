# Puma Encoding Bug

- Reproduces a bug that was added in puma v5.0.3.
- The bug is not present if you change the puma version to v5.0.2 or earlier.
- On puma v5.0.2 the controller action sends a valid CSV file download.
- To download the file on puma v5.0.2 do `curl http://localhost:3000/ > file.csv`.
- The reason for using `Encoding::UTF_16LE` is so that Excel will open the file directly without requiring user input for the CSV type.
- There's no stack trace for the error.

To reproduce the bug:

```
$ bundle
$ bundle exec rails s
$ curl -v http://localhost:3000/
...
* Illegal or missing hexadecimal sequence in chunked-encoding
```
```
# Rails log output:

Started GET "/" for ::1 at 2021-03-24 13:40:41 -0500
   (1.6ms)  SELECT sqlite_version(*)
Processing by ApplicationController#root as */*
Completed 200 OK in 9ms (ActiveRecord: 0.0ms | Allocations: 1132)

2021-03-24 13:40:42 -0500 Read: #<Encoding::CompatibilityError: incompatible character encodings: US-ASCII and UTF-16LE>
```
