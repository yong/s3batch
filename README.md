Summary
=======
upload/delete s3 objects in batch

Install
=======
gem install s3batch

Upload api
=======
S3Batch::Upload.run s3id, s3key, bucket, dir

There is optional pattern parameter, for example:

S3Batch::Upload.run s3id, s3key, bucket, dir, "**/*.rb"

It uploads everything from 'dir' that matches 'pattern' to s3 'bucket'. And it will check if a file is changed by comparing the md5 returned by s3 bucket listing API, and only upload files that are changed.

The advantage over s3sync or other solution is the upload requests run in parallel by using EvetMachine's reactor pattern ( https://github.com/eventmachine/eventmachine ) and happening gem ( https://github.com/peritor/happening )

Delete api
=======
S3Batch::Delete.run s3id, s3key, bucket, keys_array

The deletion is via Multi-Object Delete API ( http://intridea.com/posts/deleting-s3-objects-ruby )

Website api
=======
S3Batch::WebsiteEnabler.run s3id, s3key, bucket

Hosting static website on s3 ( http://docs.amazonwebservices.com/AmazonS3/latest/dev/WebsiteHosting.html )

TODO
=======
S3's list bucket api has 1000 objects limit

Copyright
=======
MIT license
