# SUINavigation

# Overview

Simple Navigation framework for SwiftUI. Alternate NavigationStack with supporting from iOS 14 and better features. Compatible with Routing, Coordinator and each other architecture patterms. This navigation has functions of getting and applying the URL which allows you to organize deep links without special costs.

## Motivation

Now Developers have standard framework SwiftUI. Correct navigation features were introduced since iOS 16 as [NavigationStack](https://developer.apple.com/documentation/swiftui/navigationstack), but developers can not use that becase should support a iOS 14.x as target commonly. Now we have solutions to backport NavigationStack: [NavigationBackport](https://github.com/johnpatrickmorgan/NavigationBackport) but it's too bold and different from the declarative approach. We want a simpler interface. In addition, the NavigationStack and NavigationBackport havn't many functions such as `skip` and each others. Functions `append` from URL and `replace` with URL allows store and backup navigation state without special costs. Also allows you to use deep links as an additional feature.

## Features

- [x] Full support SwiftUI, has declarative style
- [x] Supporting iOS 14,  iOS 15,  iOS 16,  iOS 17
- [x] Fixing known Apple bugs
- [x] Has popTo, skip, isRoot and each other functions
- [x] Works with URL: simple supporting the deep links
- [x] UI tests coverage

## Installation

### Swift Package Manager (SPM)

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but `SUINavigation` does support its use on supported platforms. 

Once you have your Swift package set up, adding `SUINavigation` as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .Package(url: "https://github.com/ozontech/SUINavigation.git", majorVersion: 1)
]
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate `SUINavigation` into your project manually.

## Build & test

Just open `Example/NavigationExample/NavigationExample.xcodeproj` from Xcode and you can build, test this from IDE.

## Using

```swift

import SwiftUI
import SUINavigation

class RootView: View {
    var body: some View {
        NavigationViewStorage{
            FirstView
        }
    }
}

class FirstView: View {

    // It's View Model of Navigation.
    // You can return to your View Model to manage of navigation state.
    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

    // Standart feature of a dissmiss works too.
    @Environment(\.presentationMode)
    private var presentationMode
    
    // Not null value trigger navigation transition to SecondView, nill value to dissmiss to this View.
    @State
    var numberForSecond: Int? = nil
    
    var body: some View {
        Button("to Root") {
            // managing of navigation transition
            navigationStorage?.popToRoot()
        }
        // declare of navigation transition
        .navigation(item: $numberForSecond) { numberValue in
            SecondView(number: numberValue)
        }
    }
}

```

 Use `NavigationViewStorage` instead of `NavigationView`.
 In parent view use modifiers `.navigation(..)` with string `id` param or without (for using class name):

```swift

     struct FirstView: View {

       var body: some View {
         VStack(spacing: 0) {
           //...
         }.navigation(id: "second", isActive: $isShowingSecond){
           SecondView()
         }
       }
     }

    struct SecondView: View {

       var body: some View {
         VStack(spacing: 0) {
           //...
         }.navigation(item: $optionalValue){ item in
           ThirdView()
         }
       }
    }

    struct SomeView: View {

        // This optional everywhere, because in a test can use NavigationView without navigationStorage object
        @OptionalEnvironmentObject
        var navigationStorage: NavigationStorage?

        var body: some View {
            Button("Go to SecondView") {
                // You should use id for navigate to SecondView, because it determinate as id
                navigationStorage?.popTo("second")
            }
            Button("Go to ThirdView") {
                // You should use struct for navigate, because it determinate without id
                navigationStorage?.popTo(ThirdView.self)
            }
            Button("Go to Root") {
                navigationStorage.popToRoot()
            }
        }
    }

```

## Common Functions

### NavigationStorage


```swift
    func popTo<ViewType: View>(_ type: ViewType.Type)
```
Dissmiss all Views before a last ViewType of navigation stack.
You can use variation popTo(_ id: NavigatinID) if you have enum with all identifier


```swift
    func popToRoot()
```
Dissmiss all Views before the root View of navigation stack.


```swift
    func skip<ViewType: View>(_ type: ViewType.Type)
```
Marking last ViewType as skipped: when user want to dismiss current screen and go to ViewType then this screen should dismiss too.
You can use variation skip(_ id: NavigatinID) if you have enum with all identifier

```swift
    var currentUrl: String
```
The url of current navigation state with params. It have x-www-form-urlencoded format. Params may duplicated for different path components.

```swift
    func append(from url: String)
```
Add new screens from url to current opened screens. See `currentUrl`

```swift
    func replace(with url: String)
```
Open new screens from url to replace current opened screens. See `append`


### View


```swift
    func navigation<Item: Equatable, Destination: View>(
        item: Binding<Item?>,
        id: NavigationID? = nil,
        @ViewBuilder destination: @escaping (Item) -> Destination
    )
```
View modifier for declare navigation to `destination` View from trigger value of `item` to not null value. Working as `.fullScreenCover`


```swift
    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        id: NavigationID? = nil,
        @ViewBuilder destination: () -> Destination
    )
```
View modifier for declare navigation to `destination` View from trigger bool `isActive` to true value.


### View with deep links

```swift
    func navigationAction<Item: Equatable, Destination: View>(
        item: Binding<Item?>,
        id: NavigationID? = nil,
        paramName: String? = nil,
        isRemovingParam: Bool = false,
        @ViewBuilder destination: @escaping (Item) -> Destination
    )
```
View modifier for declare navigation to `destination` View from trigger value of `item` or action deep link with `paramName` corresponding `item`. If you wan to remove tish param for next navigation change `isRemovingParam` to true.


```swift
    func navigationAction<Destination: View>(
        isActive: Binding<Bool>,
        id: NavigationID? = nil,
        @ViewBuilder destination: () -> Destination,
        action: @escaping NavigateUrlParamsHandler
    )
```
View modifier for declare navigation to `destination` View from trigger bool `isActive` to true value or action deep link.


```swift
    func navigateUrlParams<Destination: View>(_ urlComponent: String, action: @escaping NavigateUrlParamsHandler)
```
This view modifier need to customise navigationAction if you want custome handle url for a deep link.


## Versions

We have been improving the framework and you can help with them: create issue, pull request or just contact with Me. You can view all changes from [CHANGELOG](CHANGELOG.md)

## License

Our [LICENSE](LICENSE) totally coincides
[APACHE LICENSE, VERSION 2.0](https://www.apache.org/licenses/LICENSE-2.0)
