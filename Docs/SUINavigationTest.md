#  SUINavigationTest

`SUINavigation` includes `SUINavigationTest` framework whith you can covare your Views with UnitTests and Snapshot tests.

## UnitTests

### Motivation

UnitTests need to check avalability of navigation transition from View1 to View2. Also you can check data transfer from View1 to View2.

### Using

The Best solution who you have ViewModel whith manage navigation. In next example I show you how test navigation push with `SUINavigationTest`.

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

From `SUINavigationTest` you will find many other way for make a stable navigation. For example use snapshot tests.

### Motivation

Navigation snapshot tests allow you to track changes in the behaviour of the application in navigation, such as

- [x] Checking duplication of identifier, which used for transition (navigation uncertainty).
- [x] Recursive loop (View1 transition to View2, View2 transition to View3, View3 transition to View1 and new circle...).
- [x] Class (struct) name of transition with generic (target of transition).
- [x] Deeplinks: available or not, what url component and parameters used for target transition.

### Types of navigation snapshot tests

Snapshot tests can ensure that changes are authorised and I found two ways for they organization:

1. Saving all transition tree of nodes to one file.
2. Saving each View to separate files.

Pros and cons:

| Feature                   | One Tree node file | Many Views files |
| :------------------------ | :----------------: | :--------------: |
| Accuracy place of error   |         ⛔         |        ✅        |
| Details accuracy          |         ✅         |        ⛔        |
| Merge conflicts           |         ⛔         |        ✅        |
| Deeplink validation       |         ✅         |        ⛔        |
| Recursive loop detection  |         ✅         |        ⛔        |
| Duplication id checking   |         ✅         |        ✅        |

How do you see better use both way.

### One Tree node Snapshot file

This way store result to one file. Format you can found [this snapshot file](/Example/NavigationExample/NavigationExampleTests/__Snapshots__/NodesTests/testSnapshot.json).
First run of the test to create snapshot file, next run compare this file with current navigation nodes.
If you wan to update this file just delete [this snapshot file](/Example/NavigationExample/NavigationExampleTests/__Snapshots__/NodesTests/testSnapshot.json) and run again.
Example how you can organize:

```swift

import SUINavigationTest

final class NavigationExampleTests: XCTestCase {

    let mock = NavigationMockStore(items: ["Test", Int(0)])

    func testSnapshot() throws {
        let viewModel = RootViewModelMock()
        let rootView = RootView(viewModel: viewModel)
        try assertSnapshot(rootView, mock: mock)
    }
}

```

### Many Views Snapshot files

This way store many files with name of a View which find from tree transition nodes. Format you can found [on this snapshot directory](/Example/NavigationExample/NavigationExampleTests/__Snapshots__/NodesTests/testItemsSnapshot).
This way is based on one Tree node, use `NavigationNodeTestItem`'s which created by `NavigationNode`.
First run of the test to create snapshot files, next run compare all files in this directory with current navigation nodes.
If you wan to update all files just delete [this snapshot directory](/Example/NavigationExample/NavigationExampleTests/__Snapshots__/NodesTests/testItemsSnapshot) and run again.
Example how you can organize:

```swift

import SUINavigationTest

final class NavigationExampleTests: XCTestCase {

    let mock = NavigationMockStore(items: ["Test", Int(0)])

    func testItemsSnapshot() throws {
        let viewModel = RootViewModelMock()
        let rootView = RootView(viewModel: viewModel)
        try assertItemsSnapshot(rootView, mock: mock)
    }
}

```

## About analysers for snapshot and unit tests processing from SUINavigationTest

Snapshot of navigation require creation tree nods with root `NavigationNode` object. In order to get a `NavigationNode`, it is necessary to analyze all `View`'s start from Root. I have found 2 ways how to do it:

1. `NavigationNodeRenderingAnalyser` analyse render view as is need for presentation.
2. `NavigationNodeStaticAnalyser` call creation body objects without environments and state objects.

Unit tests have the same analysers for processing.

So far the static one is leading, and it is chosen as default. However, you have the right to make a choice at your discretion. It is possible that there will be a third because both have advantages and disadvantages:

| Feature                         |  Rendering  |   Static    |
| :------------------------------ | :---------: | :---------: |
| Speed of process                |     ⛔      |     ✅      |
| Stable of work, constant result |     ⛔      |     ✅      |
| Environments object supporting  |     ✅      |     ⛔      |
| State value/object supporting   |     ✅      |     ⛔      |
| Published value supporting      |     ✅      |     ✅      |
| Deeplink transition detect      |     ✅      |     ✅      |
| Static transition detect        |     ⛔      |     ✅      |
| Recursion loop detection        |     ✅      |     ✅      |
| Can mock trigger values         |     ⛔      |     ✅      |
| Can mock result views           |     ⛔      |     ⛔      |

## Complete navigating tests

If you want diverse test coverage, avoid UI tests as much as possible, in order to provide a real guarantee of the functionality of your navigation, you need a set of measures consisting of coverage of 3 types of tests:

1. Extract Router (with transiton declaration) and ViewModel (with busines logic usage of transiton) class from View, make UnitTest of ViewModel and check Router changes.
2. Make UnitTest of transition from View1 to View2 with checking routing data for initialisation last.
3. Make Snapshot tests for fixation deeplinks, identifier and dependencies between screens.
