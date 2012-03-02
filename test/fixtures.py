#!/usr/bin/env python
# encoding: utf-8
"""
untitled.py

Created by Barry Wark on 2011-05-23.
Copyright (c) 2011 . All rights reserved.
"""

import sys
import os.path
from boto.s3.connection import S3Connection

PHYSION_FIXTURES_BUCKET = 'com.physionconsulting.test_fixtures'

def main(argv=None):
    fixture_file = argv[1]
    if not os.path.exists(fixture_file):
        connection = S3Connection()
        bucket = connection.get_bucket(PHYSION_FIXTURES_BUCKET)
        key = bucket.get_key(fixture_file)
        with open(fixture_file, 'w') as f:
            key.get_file(f)
        print("Fixture file available as {0}.".format(fixture_file))
    else:
        print("File {0} already exists.".format(fixture_file))




if __name__ == '__main__':
    main(sys.argv)

