#!/usr/bin/env bash
if [ "$#" -eq 2 ]
    then
    apkfile=$1
    outdir=$2
    
    elif [ "$#" -eq 1 ]
    then
    apkfile=$1
    outdir=${apkfile/.apk/}
    
    else
    echo "****************************************************************************"
    echo "  Usage:"
    echo "      $0 sample.apk"
    echo "  or"
    echo "      $0 sample.apk outdir"
    echo "****************************************************************************"
    exit 1
   
fi

### begin configure tool path
apktool=~/lib/decompile/apktool_2.3.4.jar
dextool=~/lib/decompile/dex-tools-2.1-SNAPSHOT/d2j-dex2jar.sh
jdgui=~/lib/decompile/jd-gui-1.4.0.jar
### end configure tool path

java -jar $apktool -o $outdir $apkfile
unzip -o -d $outdir $apkfile

cd $outdir 
classdir=class

$dextool *.dex
find . -name "*.jar" -exec unzip -o -d $classdir {} \;

rm -rf *.jar
rm -rf *.dex

cd $classdir
zip -r ../src.jar *

cd ..
java -jar $jdgui src.jar 

