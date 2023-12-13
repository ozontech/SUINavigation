 
# Changelog

All notable changes to this project will be documented in this file.

## [1.6.1] - 2023-13-21

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
