@echo off
echo rebuild the site
call bundle exec jekyll build --source _source --destination _source\_site
echo copy
call xcopy _source\_site /s /y