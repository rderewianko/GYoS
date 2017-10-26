# This is a hackathon project for [#JNUC2017](https://www.jamf.com/events/jamf-nation-user-conference/2017/)
### We decided to move to *github* as Charles informed us that Joel did. 

# GYoS - Get Your Stuff

## Self Service Item Store for Jamf Pro

Get Your Stuff (GYoS) is a customizable framework for creating an Item Store in the Jamf Pro Self Service app.

## Documentation

### Create a Pashua Install PKG

* https://www.bluem.net/en/mac/pashua/
* Included is a Pashua.pkg with an embedded Company asset as an example.
* Built with Packages. http://s.sudre.free.fr/Software/Packages/about.html

### Install Pashua from Jamf, then Hide the Application

* The application is installed to `/Applications/Utilities/` by the .pkg.
* Create a Jamf Policy that installs the .pkg, then using a `Files and Processes` action to run `chflags hidden /Application/Utilities/Pashua.app` to hide the application.
* Scope to All Computer and All Users, set to Ongoing, and set it to run from the Custom Event `installPashua`

### Script installed to Jamf Pro

* Add the Script into Jamf Pro in the Scripts section.
* Create Script Options for the Script in Jamf Mapped to these Script Parameters.
  * Parameter 4 - `itemName`
  * Parameter 5 - `itemURL`
  * Parameter 6 - `itemApproval`
  * Parameter 7 - `itemCost`

  ![Image of Script Options](https://imgur.com/8oBl4XA.png)

### Create a SendGrid account

* Create an account at https://sendgrid.com/free/
  * This will allow 100 emails per day for free. If you scale higher than this, paid options are available.
* Create an API Key, and add to the beginning of the script in Jamf

### Create a policy for the Item you would like to be ordered

* You will need:
  * Item Image
  * Name
  * Ordering URL
  * Approval Status
    * This lets the Help Desk know if they will need to get approval from the Budget Holder for that department. When GYoS allows direct ordering from Amazon, no approval will order the item for remote employees directly.
  * Item Cost
* Create the Policy, add the Script as an option, and fill out the details required, and the image for the icon.
  * Transparent PNG of the correct size preferred.

![Image of Policy Object for Script](https://imgur.com/oMkvEds.png)

### Application Window

When you run the script, it will generate a popup application procedurally generated in Pashua. The application has custom editable text, and currently shows two different messages based upon the Approval stat.

![Image of Application Window](https://imgur.com/CYJEzn0.png)

The application will run, collect the user's input, and send an email to the Help Desk with the request. Future versions will allow you to have an item ordered directly from Amazon for delivery if you are a remote employee.

If the user selects Remote but does not fill in any information, the application will relaunch so the user can input the correct information.

