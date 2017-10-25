#!/bin/bash

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"



pashLoc="/Applications/Utilities/"
pashuaApp="Pashua.app"

pashBinLoc="/Applications/Utilities/Pashua.app/Contents/MacOS/Pashua"


itemName="$4"
itemURL="$5"
itemApproval="$6"
itemCost="$7"
userName="$3"

fullTitle="Welcome to the $itemName Store."


if [[ ! -a "$pashLoc$pashuaApp" ]]
then
	#sudo jamf policy -event installPashua
	exit 0
else
	echo "Pashua Found."
fi



# Include pashua.sh to be able to use the 2 functions defined in that file
source "$MYDIR/pashua.sh"

# Define what the dialog should be like
# Take a look at Pashua's Readme file for more info on the syntax

conf="
# Set window title
*.title = $fullTitle

# Introductory text
txt.type = text
txt.default = Pashua is an application for generating dialog windows from programming languages which lack support for creating native GUIs on Mac OS X. Any information you enter in this example window will be returned to the calling script when you hit “OK”; if you decide to click “Cancel” or press “Esc” instead, no values will be returned.[return][return]This window shows nine of the UI element types that are available. You can find a full list of all GUI elements and their corresponding attributes in the documentation (➔ Help menu) that is included with Pashua.
txt.height = 276
txt.width = 325
txt.x = 340
txt.y = 44
txt.tooltip = 

# Add a text field
fullName.type = textfield
fullName.label = Full Name:
fullName.default = 
fullName.width = 310
fullName.x = 0
fullName.y = 275
fullName.tooltip = Please Enter Your Full Name.

# Add a text field
userID.type = textfield
userID.label = User ID:
userID.default = $userName
userID.width = 310
userID.x = 0
userID.y = 230
userID.tooltip = Please Enter Your Associate ID.


# Add a text field
email.type = textfield
email.label = Email Address:
email.default = 
email.width = 310
email.x = 0
email.y = 185
email.tooltip = Please Enter Your Email Address.

# Add a popup menu
workLoc.type = popup
workLoc.label = Work Location:
workLoc.width = 310
workLoc.option = Office
workLoc.option = Remote
workLoc.default = Popup menu item #1
workLoc.x = 0
workLoc.y = 135
workLoc.tooltip = Please Select Your Location.

# Add a text field menu
workAddress.type = textfield
workAddress.label = Work Address:
workAddress.width = 310
workAddress.default = 
workAddress.x = 0
workAddress.y = 90
workAddress.tooltip = Please Enter Your Work Address.

# Add a text field menu
city.type = textfield
city.label = City:
city.width = 150
city.default = 
city.x = 0
city.y = 45
city.tooltip = Please Enter Your City.

# Add a text field menu
state.type = textfield
state.label = State:
state.width = 75
state.default = 
state.x = 151
state.y = 45
state.tooltip = Please Enter Your State.

# Add a text field menu
zip.type = textfield
zip.label = State:
zip.width = 50
zip.default = 
zip.x = 227
zip.y = 45
zip.tooltip = Please Enter Your Zip.

# Add a cancel button with default label
cancel.type = cancelbutton
cancel.tooltip = This is an element of type “cancelbutton”

db.type = defaultbutton
db.tooltip = This is an element of type “defaultbutton” (which is automatically added to each window, if not included in the configuration)
"

if [ -d '/Volumes/Pashua/Pashua.app' ]
then
	# Looks like the Pashua disk image is mounted. Run from there.
	customLocation='/Volumes/Pashua'
else
	# Search for Pashua in the standard locations
	customLocation=''
fi

# Get the icon from the application bundle
locate_pashua "$customLocation"
bundlecontents=$(dirname $(dirname "$pashuapath"))
if [ -e "/Applications/Utilities/Pashua.app/Contents/Resources/pingIdentity.png" ]

then
    conf="$conf
          img.type = image
          img.x = 435
          img.y = 248
          img.maxwidth = 128
          img.tooltip = This is an element of type “image”
          img.path = /Applications/Utilities/Pashua.app/Contents/Resources/pingIdentity.png"
fi


locate_pashua() {

    local bundlepath="Pashua.app/Contents/MacOS/Pashua"
    local mypath=`dirname "$0"`

    pashuapath=""

    if [ ! "$1" = "" ]
    then
        searchpaths[0]="$1/$bundlepath"
    fi
    searchpaths[1]="$mypath/Pashua"
    searchpaths[2]="$mypath/$bundlepath"
    searchpaths[3]="./$bundlepath"
    searchpaths[4]="/Applications/$bundlepath"
    searchpaths[5]="$HOME/Applications/$bundlepath"
    searchpaths[6]="/Applications/Utilities/Pashua"

    for searchpath in "${searchpaths[@]}"
    do
        if [ -f "$searchpath" -a -x "$searchpath" ]
        then
            pashuapath=$searchpath
            return 0
        fi
    done

    return 1
}


pashua_run() {

    # Write config file
    local pashua_configfile=`/usr/bin/mktemp /tmp/pashua_XXXXXXXXX`
    echo "$1" > "$pashua_configfile"

    locate_pashua "$2"

    if [ "" = "$pashuapath" ]
    then
        >&2 echo "Error: Pashua could not be found"
        exit 1
    fi

    # Get result
    local result=$("$pashuapath" "$pashua_configfile")

    # Remove config file
    rm "$pashua_configfile"

    oldIFS="$IFS"
    IFS=$'\n'

    # Parse result
    for line in $result
    do
        local name=$(echo $line | sed 's/^\([^=]*\)=.*$/\1/')
        local value=$(echo $line | sed 's/^[^=]*=\(.*\)$/\1/')
        eval $name='$value'
    done

    IFS="$oldIFS"
}



pashua_run "$conf" "$customLocation"

echo "Pashua created the following variables:"
echo "  Full Name  = $fullName"
echo "  User ID  = $userID"
echo "  Email Address  = $email"
echo "  Work Location = $workLoc"
echo "  Work Address = $workAddress"
echo "  City = $city"
echo "  State = $state"
echo "  Zip = $zip"
echo ""
