#!/bin/bash

UAT="UAT"
RELEASE="Release"

containUAT=$(echo $CONFIGURATION | grep "$UAT")
containRelease=$(echo $CONFIGURATION | grep "$Release")

echo "$containUAT $containRelease"

if [ "$containRelease" != "" ]; then
echo 'Release'
ProdVersion=$(/usr/libexec/PlistBuddy -c "Print ProdVersion" "$INFOPLIST_FILE")
ProdBuildNumber=$(/usr/libexec/PlistBuddy -c "Print ProdBuildNumber" "$INFOPLIST_FILE")
ProdBuildNumber=$(($ProdBuildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :ProdBuildNumber $ProdBuildNumber" "$INFOPLIST_FILE"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $ProdBuildNumber" "$INFOPLIST_FILE"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $ProdVersion.$ProdBuildNumber" "$INFOPLIST_FILE"
elif [ "$containUAT" != "" ]; then
echo 'UAT'
UATVersion=$(/usr/libexec/PlistBuddy -c "Print UATVersion" "$INFOPLIST_FILE")
UATBuildNumber=$(/usr/libexec/PlistBuddy -c "Print UATBuildNumber" "$INFOPLIST_FILE")
UATBuildNumber=$(($UATBuildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :UATBuildNumber $UATBuildNumber" "$INFOPLIST_FILE"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $UATBuildNumber" "$INFOPLIST_FILE"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $UATVersion.$UATBuildNumber" "$INFOPLIST_FILE"
# else
#   UATVersion=$(/usr/libexec/PlistBuddy -c "Print UATVersion" "$INFOPLIST_FILE")
#   buildNumber=$(/usr/libexec/PlistBuddy -c "Print UATBuildNumber" "$INFOPLIST_FILE")
#   buildNumber=$(($buildNumber + 1))
#   /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$INFOPLIST_FILE"
#   /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $UATVersion.$buildNumber" "$INFOPLIST_FILE"
fi

# platform='iOS'
# buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")
# currentDate=`date +%Y%m%d%H%M`
# fileName=${currentDate}_'artf287169_dml'.'sql'
# find ./ -name "*.sql" | xargs rm -rf
# touch ${fileName}

# deleteSql="delete from t_app_version where platform='$platform' and build_no=$buildNumber;"
# insertSql1="insert into t_app_version(platform, build_no, version, release_date, is_force_update, is_production_version)"
# insertSql2="values('iOS', $buildNumber, '$versionName', str_to_date('$currentDate','%Y%m%d%H%i'), '$forceUpdate', '$isProductionVersion');"
# echo "$deleteSql" > "$fileName" | echo "$insertSql1" >> "$fileName" | echo "$insertSql2" >> "$fileName" | echo "commit;" >> "$fileName"