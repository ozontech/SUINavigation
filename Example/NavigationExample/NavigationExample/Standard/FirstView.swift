//
//  FirstView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 28.09.2023.
//

import SwiftUI
import SUINavigation

struct FirstView: View {

    let string: String

    @State
    private var numberForSecond: Int? = nil

    @State
    private var isBoolShowed: Bool = false

    @State
    private var object: ObjectDTO? = nil
    @State
    private var objectDTO: ObjectDTO? = nil

    @Environment(\.isChange)
    private var isChange

    @Environment(\.presentationMode)
    private var presentationMode

    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?

    var body: some View {
        ZStack {
            if isChange.wrappedValue {
                Color.gray.ignoresSafeArea()
            } else {
                Color.pink.ignoresSafeArea()
            }
            VStack {
                Text("This is First")
                Text("with: \(string)")
                Button("to Bool") {
                    isBoolShowed = true
                }
                Button("to Second with 22") {
                    numberForSecond = 22
                }
                Button("to Object") {
                    object = .testValue1
                }
                Button("to Replace") {
                    navigationStorage?.replaceDestination(with: ReplaceValue.replace("www"))
                }
                Button("dismiss") {
                    presentationMode.wrappedValue.dismiss()
                }
                if isChange.wrappedValue {
                    Text("This screen is changed")
                } else {
                    Text("Waitting changes")
                }
            }
        }
        .padding()
        .navigation(isActive: $isBoolShowed){
            BoolView()
        }
        .navigationAction(item: $numberForSecond, paramName: "secondNumber", isRemovingParam: true) { numberValue in
            SecondView(number: numberValue, numberFromParent: $numberForSecond)
        }
        .navigationAction(item: $object, paramName: "object") { objectValue in
            ObjectView(object: objectValue)
        }
        .navigation(item: $objectDTO, id: "object") { objectValue in
            ObjectView(object: objectValue)
        }
        .navigateUrlParams("object") { path in
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

#Preview {
    FirstView(string: "test string")
}

#if DEBUG

extension FirstView {

    init(string: String, numberForSecond: State<Int?>) {
        self.string = string
        _numberForSecond = numberForSecond
    }

    init(string: String, isBoolShowed: State<Bool>) {
        self.string = string
        _isBoolShowed = isBoolShowed
    }
}

#endif
