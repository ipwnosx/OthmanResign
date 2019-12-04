BASEDIR = $ (dirname "$ 0")

 IPAIN = "$ BASEDIR" '/ in'

 IPAOUT = "$ BASEDIR" '/ out'

 MOBILEPROV = "$ BASEDIR" '/ embedded.mobileprovision'

 DEVID = "$ 1"

 echo "This program made by Othman Almutairi @othman_tech"

 echo "The purpose of this program is to resign ipa files with a specific Entitlements"
 echo "without changing the original Bundle Identifier to allow Push Notification"
 echo "Using Individuals Developer certificate."
 if [$ # -le 0]

 then
 echo 'usage:' $ programname '"iPhone Distribution: xxxx (xxxx)"'

 exit 1

 fi

 echo ""

 cd $ IPAIN

 find -d.  -type f -name "* .ipa"> /tmp/N_files.txt

 while IFS = '' read -r line ||  [[-n "$ line"]];  do

 filename = $ (basename "$ line" .ipa)

 echo "Resigning: $ filename" ". ipa"

 currentipa = $ IPAIN "/" $ filename ".ipa"

 tempextracted = "/ tmp / N_extracted" $ filename

 echo $ currentipa

 unzip -qo "$ currentipa" -d $ tempextracted

 APPLICATION = $ (ls "$ tempextracted" / Payload /)

 rm -rf $ tempextracted "/ __ MACOSX"

 cp "$ MOBILEPROV" $ tempextracted "/Payload/$APPLICATION/embedded.mobileprovision"

 echo "Resigning" $ filename ".ipa"


 find "$ tempextracted / Payload / $ APPLICATION / libloader" -type f> /tmp/N_directories"$filename".txt 2> / dev / null

 find -d $ tempextracted \ (-name "* .app" -o -name "* .appex" -o -name "* .framework" -o -name "* .dylib" -o -name "CSub" \)  >> /tmp/N_directories"$filename".txt

 security cms -D -i $ tempextracted "/Payload/$APPLICATION/embedded.mobileprovision" >> /tmp/N_entitlements_full"$filename".plist 2> / dev / null

 / usr / libexec / PlistBuddy -x -c 'Print: Entitlements' /tmp/N_entitlements_full"$filename".plist >> /tmp/N_entitlements"$filename".plist

 ############################## This path to solve the problem of icons in XR ###########  ################### //
 / usr / libexec / PlistBuddy -c "delete: CFBundleIcons: CFBundlePrimaryIcon: CFBundleIconName" $ ​​tempextracted "/Payload/$APPLICATION/Info.plist" 2> / dev / null
 ############################## // ِ #################  ############# //

 ############################## // This path to delete the certificate after merging ############  ##################
 ############################## // rm To activate deletion, delete the # sign before ##########  ####################
 #rm $ tempextracted "/Payload/$APPLICATION/embedded.mobileprovision"
 ############################## // ِ #################  ############# //

 ######################## This path is for deleting the UISupportedDevices file from the InfoPlease file ###############  ### //
 / usr / libexec / PlistBuddy -c "delete: UISupportedDevices" $ tempextracted "/Payload/$APPLICATION/Info.plist" 2> / dev / null


 while IFS = '' read -r line ||  [[-n "$ line"]];  do

 / usr / bin / codesign --continue -f -s "$ DEVID" --entitlements "/tmp/N_entitlements"$filename".plist" "$ line"> / dev / null 2> & 1

 done </tmp/N_directories"$filename".txt

 echo "Creating the Signed IPA for" $ filename ".ipa"

 cd $ tempextracted

 zip -qry $ IPAOUT "/" $ filename ".ipa" *

 rm -rf $ tempextracted

 rm /tmp/N_directories"$filename".txt

 rm /tmp/N_entitlements"$filename".plist

 rm /tmp/N_entitlements_full"$filename".plist

 done </tmp/N_files.txt

 rm /tmp/N_files.txt

 echo "Done .. Thank you for using Resign from Othman Almutairi @othman_tech"