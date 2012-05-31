Summary
=======
upload/delete s3 objects in batch

Install
=======
gem install s3batch

Usage
=======
S3Batch::Upload.run s3id, s3key, bucket, dir

There is optional pattern parameter, for example:

S3Batch::Upload.run s3id, s3key, bucket, dir, "**/*.rb"

It uploads everything from 'dir' that matches 'pattern' to s3 'bucket'. And it will check if a file is changed by comparing the md5 returned by s3 bucket listing API, and only upload files that are changed.

The advantage over s3sync or other solution is the upload requests run in parallel by using EvetMachine's reactor pattern ( https://github.com/eventmachine/eventmachine ) and happening gem ( https://github.com/peritor/happening )

Copyright
=======
MIT license
