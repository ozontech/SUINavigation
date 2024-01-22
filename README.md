# SUINavigation

# Overview

Simple Navigation framework for SwiftUI. Alternate `NavigationStack` with supporting from iOS 14 and better features. Compatible with Routing, Coordinator and each other architecture patterms. This navigation framework has functions of getting and applying the URL which allows you to organize deep links without special costs. In addition, the package contains a separate public framework `SUINavigationTest` for testing navigation with unit tests and snapshot tests.

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
            SecondView()
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

## UnitTests supporting

`SUINavigation` includes `SUINavigationTest` framework whith you can covare your Views with UnitTests.
The Best solution who you have ViewModel whith manage navigation. In next example I show you how test navigation push and deeplinks with `SUINavigationTest`.

```swift

import SUINavigationTest

final class NavigationExampleTests: XCTestCase {

    func testMainToFirst() throws {
        let viewModel = MainViewModelMock()
        let mainContentView = MainContentView(viewModel: viewModel)
        test(sourceView: mainContentView, destinationView: FirstView.self) {
            viewModel.stringForFirst = "New"
        } destination: { view in
            XCTAssertEqual(view.string, "New")
        }
    }
}
```

## SnapshotTests supporting

From `SUINavigationTest` you will find many other way for make a stable navigation. 
For example use snapshot tests. Snapshot tests can ensure that changes are authorised and I found two ways for they organization:

1. Saving all transition tree of nodes to one file.
2. Saving each View to separate files.

Pros and cons:

| Item                      | One Tree node file | Many Views files |
| :------------------------ | :----------------: | :--------------: |
| Accuracy place of error   |         ⛔         |        ✅        |
| Details accuracy          |         ✅         |        ⛔        |
| Merge conflicts           |         ⛔         |        ✅        |
| Deeplink validation       |         ✅         |        ⛔        |
| Recursive loop detection  |         ✅         |        ⛔        |
| Duplication id checking   |         ✅         |        ✅        |

How do you see better use both way.

### One Tree node Snapshot file

This way store result to one file. Format you can found [this snapshot file](/Example/NavigationExample/NavigationExampleTests/__Snapshots__/NodesTests/NodesTests.swift).
First run of the test to create snapshot file, next run compare this file with current navigation nodes.
If you wan to update this file just delete [this snapshot file](/Example/NavigationExample/NavigationExampleTests/__Snapshots__/NodesTests/NodesTests.swift) and run again.
Example how you can organize:

```swift

import SUINavigationTest

final class NavigationExampleTests: XCTestCase {

    func testSnapshot() throws {
        let viewModel = RootViewModelMock()
        let rootView = RootView(viewModel: viewModel)
        try assertSnapshot(rootView, mock: mock)
    }
}

```

### Many Views Snapshot files

This way store many files with name of a View which find from tree transition nodes. Format you can found [on this snapshot directory](/Example/NavigationExample/NavigationExampleTests/__Snapshots__/NodesTests/testItemsSnapshot).
First run of the test to create snapshot files, next run compare all files in this directory with current navigation nodes.
If you wan to update all files just delete [this snapshot directory](/Example/NavigationExample/NavigationExampleTests/__Snapshots__/NodesTests/testItemsSnapshot) and run again.
Example how you can organize:

```swift

import SUINavigationTest

final class NavigationExampleTests: XCTestCase {

    func testItemsSnapshot() throws {
        let viewModel = RootViewModelMock()
        let rootView = RootView(viewModel: viewModel)
        try assertItemsSnapshot(rootView, mock: mock)
    }
}

```

## Deeplinks supporting

`SUINavigation` has functions of getting and applying the URL which allows you to organize deep links without special costs. Modifier `.navigationAction` identical `.navigation`, but support navigate by `append` or `replace` from URL (URI). If you want custom navigate or use presentation type of navigation (alert, botomsheet, fullScreenCover, TabBar, etc) you can use part of `.navigationAction` as `.navigateUrlParams`. Modifiers `.navigationAction` as `.navigateUrlParams` have addition sets of params for customisation an URL representation.

![Deeplinks1](/Docs/Deeplinks1.svg "Deeplinks1")
![Deeplinks2](/Docs/Deeplinks2.svg "Deeplinks2")

## Deeplinks supporting at custom navigation

You can use `.navigateUrlParams` with `TabBar`, `.fullScreenCover`, and your custom approach of showing a screen. I Just show it in example, how it passible. More info find you in examples of the project.

### fullScreenCover

```swift

var body: some View {
    ContentView()
        .fullScreenCover(item: $data) { value in
            FirstView(value)
        }
        .navigateUrlParams("FirstView") { params in
            if let value = params.popStringParam("firstModalParam") {
                data = FirstModalData(value)
            }
        }
}

```

### TabBar

```swift

enum MyTab: String, Hashable, NavigationParameterValue {
    case first = "First Tab"
    case second = "Second Tab"
    
    // NavigationParameterValue implementation
    init?(_ description: String) {
        self.init(rawValue: description)
    }
}

struct MyTabView: View {

    @State
    private var selectedTab: MyTab = .first

    var body: some View {
        NavigationViewStorage{
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    FirstView()
                        .tag(MyTab.first)
                    SecondView()
                        .tag(MyTab.second)
                }
                .navigateUrlParams("MyTabView") { params in
                    if let tab: MyTab = params.popParam("tab") {
                        selectedTab = tab
                    }
                }
            }
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
