 
# Changelog

All notable changes to this project will be documented in this file.

## [1.11.0] - 2024-12-26

#### Added

- Synonym NavigationStorageView as NavigationViewStorage.
- `.navigationStorageDestination` view modifiers, method `changeDestination` and `replaceDestination` to NavigationStorage for change navigation state.
- `.navigationStorageDestinationAction` view modifiers for deeplinks.
- `.navigationStorageBinding` default Item.Type param.
- Example 'NavigationFromTab' with mixing using TabView with NavigationStorageView.

#### Fixed

- Corrected 'storge' to 'storage' in all.
- All extensions from Navigation+UrlParam.swift to separate files.


## [1.10.4] - 2024-12-04

#### Added

- New simple example with list and details.
- Description of using .navigation's modifiers.

## [1.10.3] - 2024-11-01

#### Added

- Added tests for iOS 18.1 on build server.

## [1.10.2] - 2024-09-13 (Friday)

#### Added

- New tests to Skip functions + Root message, Pop to back view.

#### Fixed

- One point to func popTo.
- Broken tests after update to iOS 18.

## [1.10.1] - 2024-08-28

#### Added

- Default property of Strategy and deprecation of Strategy change from navigation's init.
- To UI tests option to change default Strategy.

#### Fixed

- #1 Issue where application freezes when opening the second screen in MVVM+Coordinator example on iOS 17: Issue was with cyclic update of environment object from navigation item modifier.
- Unsynchronised updates of the Strategy using from init.

## [1.10.0] - 2024-07-23

#### Added

- `NavigationStorageStrategy` for chousing use `NavigationView` or `NavigationStack` on iOS 16.x.
- Test of navigation with closing Application.
- Description about bugs of `NavigationView` and `NavigationStack`.

## [1.9.4] - 2024-04-01

#### Fixed

- Apple bug with StateObject double creation on 16.4 with NavigationStack and YES, this is no joke again.

## [1.9.3] - 2024-03-12

#### Added

- Information about automatic test scripts.

## [1.9.2] - 2024-03-07

#### Added

- Automatisation: CI scripts for public release notes on GitHub.

## [1.9.1] - 2024-02-26

#### Added

- Automatisation: CI scripts for testing and release.

## [1.9.0] - 2024-02-21

#### Added

- Save section to `navigateUrlParams` modifier for making custom deeplink url.
- The preferMode at snapshot tests for chousing the rendering type.
- Many tests of deeplinks.

#### Fixed

- Detection of custom types at snapshot tests.
- The preferMode with other position from Unit tests.
- @Published to custom @NavigationPublished (higher performance).
- Logic of NavigationNodeRenderingAnalyser.
- Documentation of deeplinks.

## [1.8.1] - 2024-02-16

#### Fixed

- Apple Bug with dismissing view by trigger on iOS 16.0, iOS 16.1, iOS 16.2, iOS 16.3.
- Now on iOS 16.x you can see "NavigationLink presenting a value must appear inside a NavigationContent-based NavigationView. Link will be disabled.". Just ignore it. All works fine and fixed a problem of using of the NavigationStack on iOS 16.x.

## [1.8.0] - 2024-02-12

#### Added

- Example with Router SwiftUI pattern.

#### Fixed

- Bug with dismissing view by triggering to nil state.
- UnitTests showing error. Extracted from `XCTestCase`.
- `preferMode` removed as static property `XCTestCase` and added to tests functions.

## [1.7.4] - 2024-02-02

#### Fixed

- Fatal error from unit and snapshot tests of the `SUINavigationTest` for Text view destination.
- Add the `SUINavigationTest` documentation to a separate page.
- Move the `Deeplinks` documentation to a separate page.

## [1.7.3] - 2024-01-31

#### Fixed

- Cleaning prints from SUINavigation.
- SUINavigationTest with static analysis of optional views

## [1.7.2] - 2024-01-29

#### Added

- View modifier `.navigationModifier` for increase performance.
- Performance test to the example.
- Article with performance research in documentation

#### Fixed

- The Performance degradation on iOS 15.5 with many `.navigation` invocation.

## [1.7.1] - 2024-01-24

#### Added

- View mock to `NavigationMockStore` from `SUINavigationTest`.

#### Fixed

- Stable UI tests at iOS 17.2.
- Up to date the documentation.
- Extract snapshot tests from XCTestCase.

## [1.7.0] - 2024-01-19

#### Added

- Static unit tests without expectation (run faster).
- Snapshot tests with render/static analyser.
- Mock injection approach for snapshot tests.

## [1.6.2] - 2023-12-15

#### Fixed

- Hotfix unlimited recursion when using `.navigationStorageBinding` from parent NavigationStorage (when pushing modal FirstView screen).
- Corrected 'storge' to 'storage' where possible.

## [1.6.1] - 2023-12-13

#### Fixed

- Hotfix stack overflow when using Environments from `navigation' modifiers with item trigger.
- Issue with UnitTests

## [1.6.0] - 2023-12-11

#### Added

- Multy-module supporting with coordinator and modifiers: `navigationStorageBinding`, `navigation's` with value destination.
- Update UI tests to support dual-mode: Standard (classic SwiftUI) and Modular (with coordinator).

## [1.5.0] - 2023-11-30

#### Added

- Added SUINavigationTest framework for UnitTests coverage.

## [1.4.2] - 2023-11-20

#### Added

- Deep links support for nested NavigationStorages.
- Updated docs, tests and code comments.

#### Fixed

- Issue with async call in MainActor from deeplink methods `checkSubAction` and `replace`. This was reproduced only from iOS 16 (iOS 15, 17 don't).

## [1.4.1] - 2023-11-17

#### Added

- Many examples and tests for deep links using at custom Navigation.

#### Fixed

- Deep links support for other custom navigation.

## [1.4.0] - 2023-11-13

#### Added

- Using the NavigationStack from iOS 16.
- Many examples for deep links using.

#### Fixed

- Tests changed: Strong test case checking.
- Tests changed: Added tests with TabView at the root screen.
- Updated examples in code and descriptions.
- Internal interfaces of NavigationLinkWrapperView, NavigationItemModifier, NavigationModifier.

## [1.3.1] - 2023-10-31

#### Fixed

- Build: Removed artifact file with duplicates.

## [1.3.0] - 2023-10-30

#### Added

- Simple supporting the deep link with functions: append from url, replace with url.
- New modifiers for supporting the deep link: .navigationAction, .navigateUrlParams corresponding to ютфмшпфеу
- Changing the NavigationID type to protocol

## [1.2.1] - 2023-10-16

#### Added

- UI-tests, coverage all functions of navigation.

#### Fixed

- NavigationStorage bug: introduced a unique id for navigation to correct duplicates in the stack.
- NavigationStorage bug: fixed pop to last View with duplicated id in the stack.
- NavigationStorage bug: fixed skip to root View.


## [1.2.0] - 2023-10-09

#### Added

- UI-tests, coverage common functions of standard navigation.
- Improve example features.
- The Description and the changelog of library.

#### Fixed

- Apple bug: when using NavigationLink not in .stack style.
- Apple bug: return to the second screen in the stack when any screen changes in the stack.
- NavigationStorage bug: return to the root screen of the same type in the stack if you go to the last screen of this type when you press "Back".

## [1.1.1] - 2023-09-28

#### Fixed

- isRoot made public.

## [1.1.0] - 2023-09-28

#### Added

- Example of using the library.
- Access to getting isRoot via modifier.

## [1.0.0] - 2023-09-28

#### Added
- New modifiers .navigation as change of NavigationLink.
- NavigationStorage as ViewModel for storage the navigation stack, accessible from OptionalEnvironment.
- Functions: popTo, popToRoot, skip with supporting from iOS 14.

#### Fixed
- Apple bug: missing transition when there are multiple .navigation on screen.
