# Deeplinks

## Using in project

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
            FirstView(string: value)
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

```
