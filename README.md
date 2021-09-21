# Thunder Basics

[![Build Status](https://travis-ci.org/3sidedcube/ThunderBasics.svg)](https://travis-ci.org/3sidedcube/ThunderBasics) [![Swift 5.5](http://img.shields.io/badge/swift-5.5-brightgreen.svg)](https://swift.org/blog/swift-5-5-released/) [![Apache 2](https://img.shields.io/badge/license-Apache%202-brightgreen.svg)](LICENSE.md)

Thunder Basics is a set of useful utilities for handling basic iOS development tasks.

# Installation

Setting up your app to use ThunderBasics is a simple and quick process. You can choose between a manual installation, or use Carthage.

## Carthage

- Add `github "3sidedcube/ThunderBasics" == 3.0.0` to your Cartfile.
- Run `carthage update --platform ios --use-xcframeworks` to fetch the framework.
- Drag `ThunderBasics` into your project's _Frameworks and Libraries_ section from the `Carthage/Build` folder (Embed).
- Add the Build Phases script step as defined [here](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos).

## Manual

- Clone as a submodule, or download this repo
- Import ThunderBasics.xcproject into your project
- Add ThunderBasics.framework to your Embedded Binaries.
- Wherever you want to use ThunderBasics use `import ThunderBasics` if you're using swift.

# Code level documentation

Documentation is available for the entire library in AppleDoc format. This is available in the framework itself or in the [Hosted Version](http://3sidedcube.github.io/iOS-ThunderBasics/)

# License

See [LICENSE.md](LICENSE.md)
