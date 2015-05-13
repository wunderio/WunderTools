Development instructions
========================

Clone the git repo and build the vagrant machine by running

vagrant up

Once the machine is built and provisioned you can login with

vagrant ssh

## Git flow instructions

###Feature

####Make sure to have the latest version of the code

git pull origin develop
git co master

####Make sure to have latest version of master too

git pull origin master --tags 
git flow feature start [ISSUE#-DESC]

do the work for this given feature

####Publish the feature

git flow release publish [ISSUE#-DESC]
git push origin master --tags

###Release

####Make sure to have the latest version of the code

git pull origin develop
git co master
git pull origin master --tags 

####Start the release

git flow release start [RELEASE]

merge all the features branches

####Bump version in .info file

vim code/profiles/[project]/[project].info
git add code/profiles/[project]/[project].info
git commit -m "Bumping version number"

####Finish release

git flow release finish [RELEASE]
git push origin master --tags
