#Created by leonluo
#/bin/bash

###############
# Shell Setting  
###############
DATE_TIME="`date +%Y%m%d%s`"

###################
# ebaoApp Setting
###################
PROJECT_DIR="/Users/leonluo/mcde_app/trunk/ios"
LOG_PATH="/Users/leonluo"
WORKSPACE_PATH="/Users/leonluo/mcde_app/trunk/ios/McDE.xcworkspace"
SCHEME_NAME="McDE"

OPTION_PLIST_PROD="EBaoProdExportPlist.plist"
OPTION_PLIST_UAT="EBaoUATExportPlist.plist"
EXPORT_OPTIONS_PLIST_DIR="$PROJECT_DIR/McDE/Application/"

CONFIG_EBAO_UAT="UAT"
CONFIG_EBAO_PROD="Release"
CONFIG_TSRI_UAT="Tsri-UAT"
CONFIG_TSRI_PROD="Tsri-Release"

while getopts "c:p:" Option
do 
  case $Option in 
    c)
      case $OPTARG in 
        $CONFIG_EBAO_UAT)
          ARCHIVE_CONFIG_NAME="$CONFIG_EBAO_UAT"
          ;;
        $CONFIG_EBAO_PROD)
          ARCHIVE_CONFIG_NAME="$CONFIG_EBAO_PROD"
          ;;
        $CONFIG_TSRI_UAT)
          ARCHIVE_CONFIG_NAME="$CONFIG_TSRI_UAT"
          ;;
        $CONFIG_TSRI_PROD)
          ARCHIVE_CONFIG_NAME="$CONFIG_TSRI_PROD"
          ;;
        esac
        ;;
    p)
      if [ ! -x "$OPTARG" ]; then
        mkdir $OPTARG
      fi
      ARCHIVE_PATH="$OPTARG/$SCHEME_NAME-$ARCHIVE_CONFIG_NAME-$DATE_TIME/$SCHEME_NAME.xcarchive"
      IPA_EXPORT_PATH="$OPTARG/$SCHEME_NAME-$ARCHIVE_CONFIG_NAME-$DATE_TIME/"
      ;;
    ?)
      echo "unknown argument $Option"
      echo "-c <Configuration>[UAT, Release, Demo...]"
      exit 1
      ;;
  esac
done



if [ $ARCHIVE_CONFIG_NAME = "$CONFIG_EBAO_UAT" ];then
  EXPORT_OPTIONS_PLIST_PATH="$EXPORT_OPTIONS_PLIST_DIR""$OPTION_PLIST_UAT"
elif [ $ARCHIVE_CONFIG_NAME = "$CONFIG_EBAO_PROD" ];then
  EXPORT_OPTIONS_PLIST_PATH="$EXPORT_OPTIONS_PLIST_DIR""$OPTION_PLIST_PROD"
elif [ $ARCHIVE_CONFIG_NAME = "$CONFIG_TSRI_UAT" ];then
  EXPORT_OPTIONS_PLIST_PATH="$EXPORT_OPTIONS_PLIST_DIR""$OPTION_PLIST_UAT"
elif [ $ARCHIVE_CONFIG_NAME = "$CONFIG_TSRI_PROD" ];then
  EXPORT_OPTIONS_PLIST_PATH="$EXPORT_OPTIONS_PLIST_DIR""$OPTION_PLIST_PROD"
else
  EXPORT_OPTIONS_PLIST_PATH="$EXPORT_OPTIONS_PLIST_DIR""$OPTION_PLIST_UAT"
fi

echo "*******Configuration: $ARCHIVE_CONFIG_NAME  archivePath: $ARCHIVE_PATH OptionPlistPath: $EXPORT_OPTIONS_PLIST_PATH*******"

# validate
if [  -z "$ARCHIVE_CONFIG_NAME" -a "$ARCHIVE_CONFIG_NAME"=" " ];then
  echo "********[ERROR]'configuration' must be provided********"
  exit 1
fi

# clean before build
if [ ! -x "$LOG_PATH" ];then
  echo "********[WARNING]'LOG_PATH' doesnt exists, ignore 'clean before archive'********"
  sleep 1
else
  xcodebuild clean -configuration "$ARCHIVE_CONFIG_NAME" -alltargets >> $LOG_PATH
fi

# build before archive
xcodebuild -workspace "$WORKSPACE_PATH" -scheme "$SCHEME_NAME" -configuration "$ARCHIVE_CONFIG_NAME"

exit 1

# archive
xcodebuild archive -workspace "$WORKSPACE_PATH" -scheme "$SCHEME_NAME" -configuration "$ARCHIVE_CONFIG_NAME" -archivePath "$ARCHIVE_PATH"

#TODO - read from console - continue export ipa 

###################################################################
# export 
# CODE_SIGN_IDENTITY=证书 
# PROVISIONING_PROFILE=描述文件UUID
###################################################################
xcodebuild -exportArchive -archivePath "$ARCHIVE_PATH"  -exportPath "$IPA_EXPORT_PATH" -exportOptionsPlist "$EXPORT_OPTIONS_PLIST_PATH" 

if [ "$ARCHIVE_CONFIG_NAME" = "$CONFIG_EBAO_UAT" || "$ARCHIVE_CONFIG_NAME" = "$CONFIG_TSRI_UAT" ]; then
#upload to fir
  echo "configuration is $ARCHIVE_CONFIG_NAME."
fi          






