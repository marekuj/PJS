#!/bin/bash

mkdir -p ~/rpmbuild rpm backup ~/rpmbuild/SOURCES ~/rpmbuild/SPECS
mv rpm/*.rpm backup
python2.7 ./make_rpm.py -d './example_project' --rpm_store_dir './rpm' --rpmbuild_dir '~/rpmbuild'