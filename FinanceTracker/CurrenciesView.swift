//
//  CurrenciesView.swift
//  FinanceTracker
//
//  Created by Anton Efimenko on 21.11.2019.
//  Copyright © 2019 Anton Efimenko. All rights reserved.
//

import Foundation
import SwiftUI

final class FluentApi<Object> {
    let object: Object
    
    init(_ object: Object) {
        self.object = object
    }
    
    func set<T>(_ kp: WritableKeyPath<Object, T>, _ value: @autoclosure () -> T) -> FluentApi<Object> {
        var copy = object
        copy[keyPath: kp] = value()
        return FluentApi(copy)
    }
}

extension TestClass {
    var fluent: FluentApi<TestClass> { .init(self) }
}

class TestClass {
    var a = ""
    var b = ""
}

//extension CloudCurrency: FluentApi { }

extension CloudCurrency: Identifiable { }

struct CurrenciesView: View {
    @Environment(\.managedObjectContext) var context
    
    @State var isPushed = false

    @FetchRequest(fetchRequest: CloudCurrency.fetchRequest()) var currencies: FetchedResults<CloudCurrency>
    
    var body: some View {
        VStack {
            NavigationLink(destination: AccountView(.init()), isActive: self.$isPushed) { EmptyView() }.hidden()
            List {
                ForEach(currencies) { currency in
                    NavigationLink(destination: EmptyView()) {
                        VStack(alignment: .leading) {
                            Text(currency.code)
                        }
                    }
                }
            }
        }
        .navigationBarItems(trailing: Button(action: { self.isPushed.toggle() }) { Image(systemName: "plus").font(Font.title) })
        .navigationBarTitle("Currencies", displayMode: .inline)
    }
}
