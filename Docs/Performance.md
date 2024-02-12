#  Performance research

## 1. .background Optimisation from 1.7.2 version

This code can increase performance:
```swift
    var body: some View {
        ...
        .background (
            EmptyView()
                .navigation(...)
        )
    }
```
I have used it in `backgroundModifier` for optimisation and show you my research on [performance example](Example/NavigationExample/NavigationExample/Standard/PerformView.swift).

### 1.1 Test with many modifiers many calls

Condition of the test:
100 modifier calls, 1000 times to update UI. Total: 100 000 items.
Test in MacBook with M1 processor with 16 Gb RAM on iPhone SE simulator with different iOS version.
Result with millisecond:

#### Table 1.1.1
| Modifier                           | iOS 15    | iOS 15.5  | iOS 16.4  | iOS 17.2  |
| :--------------------------------- | :-------: | :-------: | :-------: | :-------: |
| empty                              | 27584     | 28383     | 3844      | 2618      |
| .navigation isActive               | 63691     | 62498     | 6945      | 4267      |
| .navigation isActive optimised     | 29178     | 30342     | 5023      | 4156      |
| .fullScreenCover standart          | 28344     | 29360     | 3971      | 3279      |
| .sheet standart                    | 28264     | 29426     | 4011      | 3287      |

We can calculate relative value for 1 modifier on 1 UI update with formule:

```math
t = {t_m - t_e \over 100000}
```
when

$t$ - time of once invocation of the modifier.

$t_m$ - time of batch invocation of the modifier.

$t_e$ - time of batch invocation without modifier.


Result in milliseconds:

#### Table 1.1.2
| Modifier                           | iOS 15    | iOS 15.5  | iOS 16.4  | iOS 17.2  |
| :--------------------------------- | :-------: | :-------: | :-------: | :-------: |
| .navigation isActive               | 0.361     | 0.341     | 0.031     | 0.016     |
| .navigation isActive optimised     | 0.016     | 0.019     | 0.011     | 0.015     |
| standart, .sheet for example       | 0.007     | 0.010     | 0.002     | 0.006     |

### 1.2 The same test for first showing

First showing is slow every start the application, it makes sense to conduct similar tests.
Condition of the test:
100 modifier calls on first time from click button to call onAppear with the same hardware

Result with millisecond:

#### Table 1.2.1
| Modifier                           | iOS 15    | iOS 15.5  | iOS 16.4  | iOS 17.2  |
| :--------------------------------- | :-------: | :-------: | :-------: | :-------: |
| empty                              | 143.391   | 180.878   | 148.336   | 171.249   |
| .navigation isActive optimised     | 139.462   | 185.340   | 175.301   | 191.538   |
| .fullScreenCover standart          | 139.240   | 178.775   | 173.486   | 195.984   |
| .sheet standart                    | 138.346   | 179.621   | 173.338   | 196.761   |
| .sheet standart optimised          | 137.029   | 178.738   | 171.597   | 196.217   |

There seems to be no correlation at all: the choice of modifier has little effect on the result.
In addition the same measurement gave a wide range. For example, `.sheets optimised` on iOS 17 give [159..196] msec.
There is an opinion that related things have a big influence, and since the relative result on so many tests may be inadequate, it is necessary to modify the test itself:

### 1.3 First showing on clear tests

let's rewrite te part of [performance example](Example/NavigationExample/NavigationExample/Standard/PerformView.swift):

```swift
    func manyModifiers(_ performLoad: PerformLoad) -> some View {
        ZStack{
            self
            switch performLoad {
            case .empty:
                EmptyView()
            case .navigation:
                let _ = boolIndex+=1
                let id = "Bool\(boolIndex)"
                EmptyView().navigation(isActive: .constant(false), id: id) {
                    BoolView()
                }
            case .full:
                EmptyView().fullScreenCover(item: .constant(Int?(nil))) { _ in
                    BoolView()
                }
            case .sheet:
                EmptyView().sheet(item: .constant(Int?(nil))) { _ in
                    BoolView()
                }
            case .sheetOptimized:
                EmptyView().background(
                    EmptyView().sheet(item: .constant(Int?(nil))) { _ in
                        BoolView()
                    }
                )
            }
        }
    }
```

to clear variant (without ZStack and EmptyView) for concrete performLoad:

```swift
    func manyModifiers(_ performLoad: PerformLoad) -> some View {
        // ignored performLoad: just edit this every test:
        self.navigation(isActive: .constant(false), id: id) {
            BoolView()
        }
    }
```

And get the same table:

#### Table 1.3.1
| Modifier                           | iOS 15    | iOS 15.5  | iOS 16.4  | iOS 17.2  |
| :--------------------------------- | :-------: | :-------: | :-------: | :-------: |
| empty: just uncall .manyModifiers2 | 16.422    | 12.173    | 18.764    | 30.098    |
| .navigation isActive               | 80.179    | 88.883    | 46.468    | 44.959    |
| .navigation isActive optimised     | 49.860    | 56.001    | 60.623    | 55.224    |
| .fullScreenCover standart          | 20.400    | 28.005    | 55.665    | 57.407    |
| .sheet standart                    | 24.498    | 30.501    | 55.270    | 42.255    |
| .sheet standart optimised          | 20.669    | 25.633    | 44.391    | 45.826    |

In addition the same measurement gave a wide range. For example, `.fullScreenCover` on iOS 17 give [44..110] msec.
We see that methods `.navigation`...`.sheet` invocation costs takes place, but cannot be compared to each other due to the high entropy.

### 1.4 Conclusion

[In the table](#table-111) we can see that Apple work at optimisation too. [These researches](#11-test-with-many-modifiers-many-calls) trace the degradation and progress of performance in the solutions used.

[In the table](#table-112) shows more reliable values of the impact of modifier invocation. Here you can see how calling different modifiers affects performance, and how this optimisation has helped.

Also initializing the view during the first display can cause a significant performance hit. The latter is difficult to verify and evaluate, but results of [Table 1.2.1](#table-121) and [Table 1.3.1](#table-131) indicates that other structures (EmptyView, ZStack, and others) are more likely to cause a significant drop in performance.


