# Thunder Basics

[![Build Status](https://travis-ci.org/3sidedcube/ThunderBasics.svg)](https://travis-ci.org/3sidedcube/ThunderBasics) [![Swift 5.5](http://img.shields.io/badge/swift-5.5-brightgreen.svg)](https://swift.org/blog/swift-5-5-released/) [![Apache 2](https://img.shields.io/badge/license-Apache%202-brightgreen.svg)](LICENSE.md)

Thunder Basics is a set of useful utilities for handling basic iOS development tasks.

# Installation

Add the package with Swift Package Manager, either in Xcode (File › Add Package Dependencies…) or in a `Package.swift`:

```swift
.package(url: "https://github.com/3sidedcube/ThunderBasics.git", branch: "feature/spm-v27")
```

`ThunderBasics` is a dynamic library product. Add it to your app target with **Embed & Sign**; other targets that use it (frameworks, app extensions, test bundles) link it without embedding, so the app loads a single copy.

# Code level documentation

Documentation is available for the entire library in AppleDoc format. This is available in the framework itself or in the [Hosted Version](http://3sidedcube.github.io/iOS-ThunderBasics/)

# License

See [LICENSE.md](LICENSE.md)
