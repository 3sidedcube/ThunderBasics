#Thunder Basics

Thunder Basics is a set of useful utilities for handling basic iOS development tasks.

#Installation

Setting up your app to use Thunder Basics is a simple and quick process. For now Thunder Basics is built as a static framework, meaning you will need to include the whole Xcode project in your workspace.

+ Drag all included files and folders to a location within your existing project.
+ Add ThunderBasics.framework to your Embedded Binaries.
+ Wherever you want to use ThunderTable use `@import ThunderBasics` or `import ThunderBasics` if you're using swift.

#Tools

###TSCAlertController
Block based alert and action sheet system.

###TSCMapView
Standard iOS Map View with support for grouping pins.

###TSCLineGraphView
Customisable line graph control for plotting data.

###TSCWebViewController
Web view with all the standard browser controls added.

###TSCAppInfoController
Allows easy access to properties in the info.plist.

###UIColor+TSCColor
Adds support for hex colours to UIColor.

###TSCDatabase
Takes object models and stores them into a sqlite database. (Basically an easier version of Apples Core Data)

###TSCObject
Base object that adds serialisation to NSObjects. (All properties from the subclassing objects will be serialised)

###NSJSONSerialization+TSCJSONSerialization
Adds JSON serialisation from a file path

###NSArray+TSCArray
Adds easy serialisation of JSON arrays into models.

###NSDictionary+TSCDictionary
Adds easy serialisation of JSON Dictionarys into models.

#License
See [LICENSE.md](LICENSE.md)