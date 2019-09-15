//
//  AccountsView.swift
//  FinanceTracker
//
//  Created by Anton Efimenko on 13/09/2019.
//  Copyright © 2019 Anton Efimenko. All rights reserved.
//

import SwiftUI
import UIKit

struct Account: Identifiable {
    var id = UUID()
    var title: String
    var initialAmount: Int
    var currency: Currency
}

struct Currency {
    let code: String
    
    static let rub = Currency(code: "RUB")
    static let usd = Currency(code: "USD")
    static let eur = Currency(code: "EUR")
}

struct AccountsView: View {
    @State var accounts = [
        Account(title: "Cash", initialAmount: 10, currency: .rub),
        Account(title: "Card 1", initialAmount: 1000, currency: .eur),
        Account(title: "Card 2", initialAmount: 2400, currency: .usd)
    ]
    
    var body: some View {
        List(accounts) { account in
            NavigationLink(destination: AccountView()) {
                VStack {
                    Text(account.title)
                    Text("\(account.initialAmount)")
                }
            }
        }
            .navigationBarTitle("Accounts", displayMode: .inline)
    }
}

struct AccountView: View {
    @State var title = ""
    @State var initialAmount = ""
    @State var index = 0
    let currencies: [Currency] = [.eur, .rub, .usd]
    var body: some View {
        Form {
            TextField("Title", text: self.$title)
            TextField("Initial amount", text: self.$initialAmount)
                .keyboardType(.decimalPad)
            Picker(selection: self.$index, label: Text("Currency")) {
                ForEach(0..<currencies.count) {
                    Text(self.currencies[$0].code)
                }
            }
        }
        .navigationBarTitle("Account", displayMode: .inline)
    }
}

struct MultilineTextView: UIViewRepresentable {
    var placeholder: String = ""
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.font = UIFont.preferredFont(forTextStyle: .body)
//        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
        }
    }
}
