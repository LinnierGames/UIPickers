# UIPickers

[![CI Status](https://img.shields.io/travis/linniergames/UIPickers.svg?style=flat)](https://travis-ci.org/linniergames/UIPickers)
[![Version](https://img.shields.io/cocoapods/v/UIPickers.svg?style=flat)](https://cocoapods.org/pods/UIPickers)
[![License](https://img.shields.io/cocoapods/l/UIPickers.svg?style=flat)](https://cocoapods.org/pods/UIPickers)
[![Platform](https://img.shields.io/cocoapods/p/UIPickers.svg?style=flat)](https://cocoapods.org/pods/UIPickers)

## Examples

### Basic Message and Date Picker

![basic message and date picker 2x](https://user-images.githubusercontent.com/1758210/40519096-aa01fdea-5f72-11e8-96d5-8164b481b69d.png)

### UIEntryPickerViewController

![uientrypickervc 2x](https://user-images.githubusercontent.com/1758210/40519108-b4aa380c-5f72-11e8-896e-27f161df03e0.png)

### With a Custom UIView

![subclassing uipickervc 2x](https://user-images.githubusercontent.com/1758210/40519203-35903d54-5f73-11e8-940f-862ef3a247b8.png)

You'll need to subclass `UIPickerViewController` and override `func layoutConent() -> [UIView]`. This currently returns an empty array.

```swift
  open override func layoutConent() -> [UIView] {
      ...
      
      return [viewA, viewB, viewC, ...]
  }
```

This method, `layoutContent()` is invoked when the view controller is becoming presented.

## Installation

UIPickers is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UIPickers'
```

## Author

LinnierGames

## License

UIPickers is available under the MIT license. See the LICENSE file for more info.
