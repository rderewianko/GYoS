#!/bin/bash

userName=$3;
computerName=$2;

consumableName=$4;
consumableURL=$5;
consumableApprovalNeeded=$6;
orderDirectly=$7;
consumableCost=$8;
approver = $9;


if [ "$approver" = "Yes" ]; then 
{
    confirmation=$("/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" -windowType "utility" -title "Item Order" -heading "$consumableName" -description "Your order is ready to proceed. Something something legal about part orders. The cost of this order is $consumableCost. To confirm this order, press order." -icon "/opt/Package_Box_Emoji.png" -button1 "Order" -button2 "Cancel" -defaultButton 2 -cancelButton 2)
} elif [ "$approver" = "No" ]; then
{
    confirmation=$("/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" -windowType "utility" -title "Item Order - Approval Needed" -heading "$consumableName" -description "Your order requires Approval before ordering. Something something legal about part orders. The cost of this order is $consumableCost. To submit this order for approval, press Submit." -icon "/opt/Package_Box_Emoji.png" -button1 "Submit" -button2 "Cancel" -defaultButton 1 -cancelButton 1)
} fi

echo $confirmation

exit 0