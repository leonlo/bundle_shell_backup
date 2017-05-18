#Created by leonluo
#/bin/bash

###############
# Shell Setting  
###############
DATE_TIME="`date +%Y%m%d`"

###################
# ebaoApp Setting
###################
PROJECT_DIR="/Users/leonluo/mcde_app/trunk/android/"
ORIGIN_OUTPUT_PATH="/Users/leonluo/mcde_app/trunk/android/app/build/outputs/apk"

###############################################
# same as [project:build.gradle:productFlavors]
###############################################
ASSEMBLE_EBABO_PLAYSTORE="GooglePlay"
ASSEMBLE_EBAO_UAT="UAT"
ASSEMBLE_TSRI_PLAYSTORE="TsriGooglePlay"
ASSEMBLE_TSRI_UAT="TsriUAT"

CONFIG_EBAO_UAT="UAT"
CONFIG_EBAO_PROD="Release"
CONFIG_TSRI_UAT="Tsri-UAT"
CONFIG_TSRI_PROD="Tsri-Release"

ASSEMBLE_NAME="$ASSEMBLE_EBAO_UAT"
APK_EXPORT_PATH=""

while getopts "c:p:" Option
do 
  case $Option in 
    c)
      case $OPTARG in 
        $CONFIG_EBAO_UAT)
          ASSEMBLE_NAME="$ASSEMBLE_EBAO_UAT"
          ;;
        $CONFIG_EBAO_PROD)
          ASSEMBLE_NAME="$ASSEMBLE_EBABO_PLAYSTORE"
          ;;
        $CONFIG_TSRI_UAT)
          ASSEMBLE_NAME="$ASSEMBLE_TSRI_UAT"
          ;;
        $CONFIG_TSRI_PROD)
          ASSEMBLE_NAME="$ASSEMBLE_TSRI_PLAYSTORE"
          ;;
        esac
        ;;
    p)
      if [ ! -x "$OPTARG$ASSEMBLE_NAME-$DATE_TIME" ]; then
        mkdir $OPTARG$ASSEMBLE_NAME-$DATE_TIME
      fi
      APK_EXPORT_PATH="$OPTARG$ASSEMBLE_NAME-$DATE_TIME/"
      ;;
    ?)
      echo "unknown argument $Option"
      echo "-c <Configuration>[UAT, Release, Demo...]"
      exit 1
      ;;
  esac
done

ASSEMBLE_COMMOND="assemble$ASSEMBLE_NAME"
echo "$ASSEMBLE_COMMOND"
cd $PROJECT_DIR
#gradle clean build

# clean before build
./gradlew clean

# assemble Release
./gradlew $ASSEMBLE_COMMOND

if [ $APK_EXPORT_PATH != "" ]; then
  echo "export apk to $APK_EXPORT_PATH"
  mv $ORIGIN_OUTPUT_PATH/* $APK_EXPORT_PATH
fi

