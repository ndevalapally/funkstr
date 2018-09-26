# funkstr
Sample XMPP application with XMPP and NoChat framework integration


## Pre-requisites
* Xcode 9.3 or higher
* Cocoapods


## Install and run

* clone the repo to your computer
* Go to `Funkstr` folder in terminal and run `pod install` command
* Once all the dependencies are downloaded, open the `.xcworkspace` file


## Features
* Shows the availability of friends
* Can send text message to a friend
* Has message history for each of the friends


## Limitations
* The application connects the XMPP server at `im.koderoot.net`
* All the accounts are registered at [koderoot](https://www.koderoot.net/) XMPPA server
* The profile pictures are local to the application.
* Registration of a new account can be done [here](https://im.koderoot.net/register-on-im.koderoot.net)
* No avatar information is got


## Attributions
The following libraries were used for developing the application
* XMPP Framework
* Realm (for storing the chat and user information)
* NoChat (for chat UI)

## Test accounts
There are currently 3 test accounts in use
* testin1
* testin2
* testin3
All the accounts have the same password `testin123`