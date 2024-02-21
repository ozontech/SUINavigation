//
//  ObjectView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 15.02.2024.
//

import SwiftUI
import SUINavigation
import RegexBuilder

struct ObjectDTO: Equatable {
    var id: Int
    var name: String
    var date: Date
}

extension ObjectDTO {

    static var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateFormat = "yyyy-MM-dd"
        return result
    }()

    var formattedDate: String {
        Self.dateFormatter.string(from: date)
    }

    public static let empty = ObjectDTO(id: 0, name: "", date: Self.dateFormatter.date(from: "2020-02-20")!)
    public static let testValue1 = ObjectDTO(id: 10203, name: "NAME of Test1", date: Self.dateFormatter.date(from: "2024-02-15")!)
}

extension ObjectDTO: NavigationParameterValue {
    static var defaultValue: ObjectDTO {
        .empty
    }

    private static let regex = try! NSRegularExpression(pattern: "^Object: id:(.*); name:(.*); date:(.*)", options: [])

    init?(_ description: String) {
        let range = NSRange(location: 0, length: (description as NSString).length)
        let result = Self.regex.matches(in: description, options: [], range: range)
        guard let result = result.first, result.numberOfRanges == 4,
              let id = Int((description as NSString).substring(with: result.range(at: 1))),
              let date = Self.dateFormatter.date(from: String((description as NSString).substring(with: result.range(at: 3))))
        else {
            return nil
        }
        self.id = id
        self.name = String((description as NSString).substring(with: result.range(at: 2)))
        self.date = date
    }
}

extension ObjectDTO: CustomStringConvertible {
    var description: String {
        "Object: id:\(self.id); name:\(self.name); date:\(self.formattedDate)"
    }
}

struct ObjectView: View {

    let object: ObjectDTO

    @State
    private var isFirstShowed: Bool = false

    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?

    @Environment(\.isChange)
    private var isChange

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("This is Object")
                    if isChange.wrappedValue {
                        Text("changed")
                    } else {
                        Text("wait change")
                    }
                }
                Button("pop to First") {
                    navigationStorage?.popTo(FirstView.self)
                }
                Button("pop to Bool") {
                    navigationStorage?.popTo(BoolView.self)
                }
                Button("to First") {
                    isFirstShowed = true
                }
                Text(object.description)
                if let navigationStorage = navigationStorage {
                    Text("Path: \(navigationStorage.currentUrl)")
                }
            }
        }.navigationAction(isActive: $isFirstShowed) {
            FirstView(string: "Object")
        }
    }
}
