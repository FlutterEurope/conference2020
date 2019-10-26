fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios tst
```
fastlane ios tst
```
Submit a new build to Firebase App Distribution
### ios prod
```
fastlane ios prod
```
Deploy a new version to the AppStore

----

## Android
### android tst
```
fastlane android tst
```
Submit a new build to Firebase App Distribution
### android prod
```
fastlane android prod
```
Deploy a new version to the Google Play

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
