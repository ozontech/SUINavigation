# SUINavigation

# Overview

Simple navigation framework for SwiftUI. Alternative `NavigationStack` with support for iOS 14, Apple bug fixes and better features. Compatible with Routing, Coordinator and each other architecture patterms. This navigation framework has functions of getting and applying the URL which allows you to organize deep links without special costs. In addition, the package contains a separate public framework `SUINavigationTest` for testing navigation with unit tests and snapshot tests. We care about quality and performance what why we have UI tests.

## Motivation

Now Developers have standard framework SwiftUI. Correct navigation features were introduced since iOS 16 as [NavigationStack](https://developer.apple.com/documentation/swiftui/navigationstack), but developers can not use that becase should support a iOS 14.x as target commonly. Now we have solutions to backport NavigationStack: [NavigationBackport](https://github.com/johnpatrickmorgan/NavigationBackport) but it's too bold and different from the declarative approach. We want a simpler interface. In addition, the NavigationStack and NavigationBackport havn't many functions such as `skip` and each others. Functions `append` from URL and `replace` with URL allows store and backup navigation state without special costs. Also allows you to use deep links as an additional feature. If you want to use microapp-architecture you can inject views to your modules closed by value object.

## Features

- [x] Full support SwiftUI, has declarative style.
- [x] Supporting iOS 14, iOS 15, iOS 16, iOS 17.
- [x] Target switching between NavigationView and NavigationStack.
- [x] Fixing known Apple bugs.
- [x] Has popTo, skip, isRoot and each other functions.
- [x] Works with URL: simple supporting the deep links.
- [x] Multy-module supporting (views injecting)
- [x] Contains unit and snapshot tests framework
- [x] UI tests full coverage.
- [x] Performance concern.

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

### Bash script

For tests on popular iOS versions you just call script:

```bash
sh Scripts/release.sh
```

The same script can prepare release with detection version from [CHANGELOG](CHANGELOG.md) and you can use it for tag new version.
For the creating release notes I use [GL](https://cli.github.com/manual/gh), installed and setup and call next script:

```bash
brew install gh
gh auth login
sh Scripts/releasenotes.sh
```

### Manually

Just open `Example/NavigationExample/NavigationExample.xcodeproj` from Xcode and you can build, test this from IDE.

## Using

 Use `NavigationViewStorage` instead of `NavigationView` or `NavigationStack`.
 In parent view use modifiers `.navigation(..)` with string `id` param or without (for using struct name) in addition features:

```swift

import SwiftUI
import SUINavigation

struct RootView: View {
    // True value trigger navigation transition to FirstView
    @State
    private var isShowingFirst: Bool = false

    var body: some View {
        NavigationViewStorage{
            VStack {
                Text("Root")
                Button("to First"){
                    isShowingFirst = true
                }
            }.navigation(isActive: $isShowingFirst){
                FirstView()
            }
        }
    }
}

struct FirstView: View {
    // Not null value trigger navigation transition to SecondView with this value, nil value to dissmiss to this View.
    @State
    private var optionalValue: Int? = nil

    var body: some View {
        VStack(spacing: 0) {
            Text("First")
            Button("to Second"){
                optionalValue = 777
            }
        }.navigation(item: $optionalValue, id: "second"){ item in
            // item is unwrapped optionalValue where can used by SecondView
            SecondView(number: item)
        }
    }
}

struct SecondView: View {
    @State
    private var isShowingLast: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Text("Second")
            Button("to Last"){
                isShowingLast = true
            }
        }.navigation(isActive: $isShowingLast, id: "last"){
            SomeView()
        }
    }
}

struct SomeView: View {
    // This optional everywhere, because in a test can use NavigationView without navigationStorage object
    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?

    // Standard feature of a dissmiss works too. Swipe to right works too.
    @Environment(\.presentationMode)
    private var presentationMode

    var body: some View {
        Button("Go to First") {
            // You should use struct for navigate, because it determinate without id
            navigationStorage?.popTo(FirstView.self)
        }
        Button("Go to SecondView") {
            // You should use id for navigate to SecondView, because it determinate as id
            navigationStorage?.popTo("second")
        }
        Button("Go to Root") {
            navigationStorage?.popToRoot()
        }
        Button("Skip First") {
            navigationStorage?.skip(FirstView.self)
        }
        Button("Skip Second") {
            navigationStorage?.skip("second")
        }
    }
}

```

## Test of Navigation

`SUINavigation` includes `SUINavigationTest` framework, which allows you to cover your views with Unit and Snapshot tests. 
More details about why this is needed and how to implement it are written in a separate article [SUINavigationTest](Docs/SUINavigationTest.md).
The Next example just shows how to write tests:

```swift

import SUINavigationTest

final class NavigationExampleTests: XCTestCase {

    /// Unit Test
    func testView1ToView2() throws {
        let view1 = View1()
        test(sourceView: view1, destinationView: View2.self) {
            view1.triggerValue = "trigger"
        } destination: { view2 in
            XCTAssertEqual(view2.inputValue, "trigger")
        }
    }
    
    /// Snapshot Test
    func testAllItemsOfTheRoot() throws {
        let rootView = RootView()
        try assertItemsSnapshot(rootView)
    }
}

```

## Deeplinks supporting

`SUINavigation` has functions of getting and applying the URL which allows you to organize deep links without special costs. Modifier `.navigationAction` identical `.navigation`, but support navigate by `append` or `replace` from URL (URI). If you want custom navigate or use presentation type of navigation (alert, botomsheet, fullScreenCover, TabBar, etc) you can use part of `.navigationAction` as `.navigateUrlParams`. Modifiers `.navigationAction` as `.navigateUrlParams` have addition sets of params for customisation an URL representation.

More about Deeplinks in separated article page [Deeplinks](Docs/Deeplinks.md).

The Next example just shows how to navigate from url:

```swift

import SwiftUI
import SUINavigation

struct SomeView: View {

    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?
    
    @State
    private var optionalValue: Int? = nil
    
    let url = "second?secondValue=777"

    var body: some View {
        VStack() {
            Text("Some")
            Button("to Second from URL"){
                navigationStorage.append(url)
            }
        }.navigationAction(item: $optionalValue, id: "second", paramName: "secondValue") { item in
            SecondView(number: item)
        }
    }
}

```

## Features of Nested Navigation

Since `NavigationStack` don't support nested `NavigationStack` it affected to `NavigationViewStorage` too. But it reproduced on iOS 16 and leter. On iOS 15.x and lower it work fine because `NavigationView` haven't this problem.

You can also seporate nested `NavigationViewStorage` with help another navigation for example .fullScreenCover or TabBar then you can use fearlessly nested `NavigationViewStorage` even with iOS 16 and leter. For this case, we even provided support for deep links of nested navigation.

## Multi-module supporting (coordinator pattern)

`NavigationStorage` has mirror functions for supporting the Coordinator pattern. I show You how does it differ from the classical approach with SwiftUI:
 1. You need registry all `View's` with and binding to special value type. For that use `.navigationStorageBinding` modifier before triger navigation.
 2. You need switch from using `.navigation` modifier with some View as destination to the same `.navigation` modifier with this special value type as destination. An Enum can be used as this value type.
 
### Example

```swift

enum Destination: Equatable {
    case first(String)
    case second(Int)
    case bool
}

struct RootView: View {
    var body: some View {
        NavigationViewStorage{
            ZStack{
                mainView
            }.navigationStorageBinding(for: Destination.self) { destination in
                switch self {
                case .first(let string):
                    ModularFirstView(string: string)
                case .second(let number):
                    ModularSecondView(number: number)
                case .bool:
                    ModularBoolView()
                }
            }
        }
    }
}

struct ModularFirstView: View {

    @State
    private var numberForSecond: Int? = nil

    var body: some View {
        ZStack {
            VStack {
                Text("This is First")
                Button("to Second with 22") {
                    numberForSecond = 22
                }
            }
        }
        .navigationAction(item: $numberForSecond) { numberValue in
            Destination.second(numberValue)
        }
    }
}

```

## Performance

We did [performance research](Docs/Performance.md) and found weaknesses in the component and tried to fix them. This is covered in a separate article in the documentation: [Performance Research](Docs/Performance.md).

## Apple bugs: NavigationView vs NavigationStorage

Ohh, you know my friend what the hell in use SwiftUI navigation?
But yes, we try to fixed bugs on SwiftUI navigation as soon as we can.
All test who demonstration they you can found on NavigationExample project with tests on class [BugUITests](Example/NavigationExample/NavigationExampleUITests/BugUITests.swift).
From iOS 16.0 Apple deprecated NavigationView and it really stopped working stably but to iOS 17 NavigationStorage working unstably too. It forced me introduce `NavigationStorageStrategy` for chousing to you way: wath do you use with iOS 16.x: `NavigationView` or `NavigationStorage`. More details [in the description](Sources/SUINavigation/Core/NavigationStorageStrategy.swift).

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
    func navigateUrlParams<Destination: View>(
        _ urlComponent: String,
        action: @escaping NavigateUrlParamsHandler
    )
```
This view modifier need to customise navigationAction if you want custome handle url for a deep link.


## Versions

We have been improving the framework and you can help with them: create issue, pull request or just contact with Me. You can view all changes from [CHANGELOG](CHANGELOG.md)

## License

Our [LICENSE](LICENSE) totally coincides
[APACHE LICENSE, VERSION 2.0](https://www.apache.org/licenses/LICENSE-2.0)
