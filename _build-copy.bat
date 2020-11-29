@echo off
echo rebuild the site
call bundle exec jekyll build --source _source --destination _source\_site
echo copy
call robocopy _source\_site . /NFL /NDL /NJH /NJS /nc /ns /np