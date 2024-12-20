# Deeplinks

## Using in project

`SUINavigation` has functions of getting and applying the URL which allows you to organize deep links without special costs. Modifier `.navigationAction` identical `.navigation`, but support navigate by `append` or `replace` from URL (URI). If you want custom navigate or use presentation type of navigation (alert, botomsheet, fullScreenCover, TabBar, etc) you can use part of `.navigationAction` as `.navigateUrlParams`. Modifiers `.navigationAction` as `.navigateUrlParams` have addition sets of params for customisation an URL representation.

![Deeplinks1](/Docs/Deeplinks1.svg "Deeplinks1")
![Deeplinks2](/Docs/Deeplinks2.svg "Deeplinks2")

## Сustom processing of deep links

You have two way to orginize deep links. The first involves automatic parsing with `.navigationAction`. The second manual change view state for navigation transition. Let's look at them.

### Automatic parsing

You need organise your state object as inherited by `NavigationParameterValue` protocol: 

```swift

struct ObjectDTO: Equatable {
    var id: Int
    var name: String
    var date: Date
}

extension ObjectDTO: NavigationParameterValue {
    static var defaultValue: ObjectDTO {
        ObjectDTO(id: 0, name: "", date: dateFormatter.date(from: "2020-02-20")!)
    }

    init?(_ description: String) {
        self.id = parse id from description
        self.name = parse name from description
        self.date = parse date from description
    }
}

```

And call `.navigationAction` with trigger item of this object:


```swift

struct TargetView: View {

    @State
    private var object: ObjectDTO? = nil
    
    var body: some View {
        ZStack {
            contentView
        }.navigationAction(item: $object, id: "objectPath" paramName: "objectParam") { objectValue in
            ObjectView(object: objectValue)
        }
    }
}

```

Next step you just handle mapped url at replace or appending method of the `NavigationStorage` API like that:

```swift

struct RootView: View {

    @State
    private var isTargetShowing = false

    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?

    var body: some View {
        ZStack{
            contentView
        }
        .onOpenURL(perform: { url in
            let targetURL = url.absoluteString.replacingOccurrences(of: "navigator://", with: "")
            navigationStorage?.append(from: targetURL)
        })
        .navigationAction(isActive: $isTargetShowing, id: "target") {
            TargetView()
        }
    }
}

```

### Manual parsing

Manual parsing is no different from the example above. It does not require inheritance of `ObjectDTO` from `NavigationParameterValue`, although it does require calling an additional modifier where parsing and serialisation is performed.

You need call standart `.navigation` modifier for navigation transition and call `.navigateUrlParams` modifier for parsing and serialisation (if add optional save handler). For connection `.navigation` with `.navigateUrlParams` you need just use the same `id` and `urlComponent` params. Yuo can make it as const, for example `objectPathId`, so the example above will now look like this:

```swift

struct TargetView: View {

    private let objectPathId = "objectPath"

    @State
    private var objectDTO: ObjectDTO? = nil
    
    var body: some View {
        ZStack {
            contentView
        }.navigation(item: $object, id: objectPathId) { objectValue in
            ObjectView(object: objectValue)
        }.navigateUrlParams(objectPathId) { path in
            guard let id = path.getIntParam("object.id"),
                  let name = path.getStringParam("object.name"),
                  let rawDate = path.getStringParam("object.date"),
                  let date = ObjectDTO.dateFormatter.date(from: rawDate)
            else {
                return
            }
            objectDTO = ObjectDTO(id: id, name: name, date: date)
        } save: { path in
            guard let object = objectDTO else {
                return
            }
            path.pushIntParam("object.id", value: object.id)
            path.pushStringParam("object.name", value: object.name)
            path.pushStringParam("object.date", value: ObjectDTO.dateFormatter.string(from: object.date))
        }
    }
}

```

That's it. In a closures of `navigateUrlParams` you can use `NavigationActionPathProtocol` and `NavigationActionSavePathProtocol` path objects. Who can parse (getIntParam, getIntParam, getParam) and serialise (pushIntParam, pushStringParam, pushParam) your trigger object.

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
