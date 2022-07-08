# Whereby iOS SDK demo

This repository contains a sample app in Swift using the [Whereby iOS SDK](https://github.com/whereby/ios-sdk).

Other platforms: 
- [Android SDK](https://github.com/whereby/android-sdk)
- [Browser SDK](https://github.com/whereby/browser-sdk)

## Prerequisites
- The latest stable version of [Xcode](https://apps.apple.com/us/app/xcode/id497799835)
- The latest stable version of [cocoapods](https://cocoapods.org/)
- Sign up to [Whereby Embedded](https://whereby.com/information/embedded/) account
- [Create a room](https://docs.whereby.com/creating-and-deleting-rooms) in your Whereby Embedded account

## Running the app
1. Install WherebySDK dependency using cocoapods. Starting at the root folder of this repo:
```
cd WherebySDKDemo
pod install
```
2. Open `WherebySDKDemo.xcworkspace` in Xcode.
3. In `DemoViewController.swift` provide your room URL to open in the demo app.
4. Run the project.
