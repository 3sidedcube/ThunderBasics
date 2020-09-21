# Thunder Basics

[![Build Status](https://travis-ci.org/3sidedcube/ThunderBasics.svg)](https://travis-ci.org/3sidedcube/ThunderBasics) [![Swift 5.3](http://img.shields.io/badge/swift-5.3-brightgreen.svg)](https://swift.org/blog/swift-5-3-released/) [![Apache 2](https://img.shields.io/badge/license-Apache%202-brightgreen.svg)](LICENSE.md)

Thunder Basics is a set of useful utilities for handling basic iOS development tasks.

# Installation

Setting up your app to use ThunderBasics is a simple and quick process. You can choose between a manual installation, or use Carthage.

## Carthage

- Add `github "3sidedcube/ThunderBasics" == 2.0.1` to your Cartfile.
- Run `carthage update --platform ios` to fetch the framework.
- Drag `ThunderBasics` into your project's _Linked Frameworks and Libraries_ section from the `Carthage/Build` folder.
- Add the Build Phases script step as defined [here](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos).

## Manual

- Clone as a submodule, or download this repo
- Import ThunderBasics.xcproject into your project
- Add ThunderBasics.framework to your Embedded Binaries.
- Wherever you want to use ThunderBasics use `import ThunderBasics` if you're using swift.

## Building Binaries for Carthage

Since Xcode 12 there has been issues with building Carthage binaries caused by the inclusion of a secondary arm64 slice in the generated binary needed for Apple Silicon on macOS. This means that rather than simply using `carthage build --archive` you need to use the `./carthage-build build --archive` command which uses the script included with this repo. For more information, see the issue on Carthage's github [here](https://github.com/Carthage/Carthage/issues/3019)

We will be investigating moving over to use SPM as an agency soon, and will also look into migrating to use .xcframeworks as soon as Carthage have support for it.


# Code level documentation

Documentation is available for the entire library in AppleDoc format. This is available in the framework itself or in the [Hosted Version](http://3sidedcube.github.io/iOS-ThunderBasics/)

# License

See [LICENSE.md](LICENSE.md)
