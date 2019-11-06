//
//  AccountsView.swift
//  FinanceTracker
//
//  Created by Anton Efimenko on 13/09/2019.
//  Copyright © 2019 Anton Efimenko. All rights reserved.
//

import SwiftUI
import UIKit
import CoreData

struct Account: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var initialAmount: Int
    var currency: Currency
}

extension CloudAccount: Identifiable {
    
}

extension CloudAccount {
    static func allItems() -> NSFetchRequest<CloudAccount> {
        let request: NSFetchRequest<CloudAccount> = CloudAccount.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return request
    }
    
    static func fetchRequest2() -> FetchRequest<CloudAccount> {
        return FetchRequest<CloudAccount>(
                     sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)],
                     animation: .easeInOut(duration: 3))
    }
}

struct AppState {
    var accounts: [Account] = [
        Account(title: "Cash", initialAmount: 10, currency: .rub),
        Account(title: "Card 1", initialAmount: 1000, currency: .eur),
        Account(title: "Card 2", initialAmount: 2400, currency: .usd)
    ]
}

struct Currency: Equatable {
    let code: String
    
    static let rub = Currency(code: "RUB")
    static let usd = Currency(code: "USD")
    static let eur = Currency(code: "EUR")
}

struct AccountsView: View {
    @EnvironmentObject var store: Store<AppState, Void>
    @Environment(\.managedObjectContext) var context
    
    let request = CloudAccount.fetchRequest2()
    var accounts: FetchedResults<CloudAccount> { return request.wrappedValue }
//    @FetchRequest(fetchRequest: CloudAccount.allItems()) var accounts: FetchedResults<CloudAccount>
//    @FetchRequest(fetchRequest: CloudAccount.allItems(), animation: .spring(response: 5, dampingFraction: 6, blendDuration: 1)) var accounts: FetchedResults<CloudAccount>
    
    var body: some View {
        List {
            ForEach(accounts) { account in
                VStack(alignment: .leading) {
                    Text(account.title ?? "")
                    Text("\(account.initialAmount)")
                }
            }
            .onDelete { set in
                print(set)
                self.context.delete(self.accounts[set.first!])
//                try! self.context.save()
            }
            .onTapGesture {
                let newAccount = CloudAccount(entity: CloudAccount.entity(), insertInto: self.context)
                newAccount.title = UUID().uuidString
                newAccount.initialAmount = Int64.random(in: 0...1000)
//                try! self.context.save()
            }

//            NavigationLink(destination: AccountView(account) ) {
//                VStack(alignment: .leading) {
//                    Text(account.title)
//                    Text("\(account.initialAmount)")
//                    Text("\(account.currency.code)")
//                }
//            }
        }
            .navigationBarTitle("Accounts", displayMode: .inline)
    }
}

struct AccountView: View {
    class AccountModel: ObservableObject {
        let original: Account
        var editing: Account

        var index: Int {
            didSet {
                editing.currency = currencies[index]
            }
        }
        let currencies: [Currency] = [.eur, .rub, .usd]
        
        var amount: String {
            get { return "\(editing.initialAmount)" }
            set { editing.initialAmount = Int(newValue) ?? 0 }
        }
        
        init(_ account: Account) {
            self.original = account
            self.editing = account
            index = currencies.firstIndex(where: { $0 == account.currency })!
        }
        
        func reset() {
            editing = original
        }
    }
    
    @ObservedObject var model: AccountModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: Store<AppState, Void>
    
    init(_ account: Account) {
        self.model = AccountModel(account)
    }
    
    var body: some View {
        Form {
            TextField("Title", text: self.$model.editing.title)
            
            TextField("Initial amount", text: self.$model.amount)
                .keyboardType(.decimalPad)
            Picker(selection: self.$model.index, label: Text("Currency")) {
                ForEach(0..<self.model.currencies.count) {
                    Text(self.model.currencies[$0].code)
                }
            }
        }
        .navigationBarItems(leading: Button(action: { self.dismiss() }) { Image(systemName: "chevron.left").font(Font.title.weight(.semibold)) },
                            trailing: Button(action: { self.save() }) { Text("Save") })
        .navigationBarTitle("Account", displayMode: .inline)
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
        model.reset()
    }
    
    func save() {
        presentationMode.wrappedValue.dismiss()
        if let index = store.state.accounts.firstIndex(where: { $0 == model.original }) {
            store.state.accounts[index] = model.editing
        }
    }
}
