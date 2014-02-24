# This script is run on build
# Place custom build stuff here, such as copying files in place etc.

PWD=$1
BUILDDIR=$2

cp $PWD/conf/_ping.php $BUILDDIR
