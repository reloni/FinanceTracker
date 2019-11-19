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
    var title: String = ""
    var initialAmount: Int64 = 0
    var currency: Currency = .rub
    var managedObjectId: NSManagedObjectID? = nil
}

extension Account {
    init(_ cloud: CloudAccount) {
        self.id = cloud.uuid
        self.initialAmount = cloud.initialAmount
        self.title = cloud.title
        self.currency = .eur
        self.managedObjectId = cloud.objectID
    }
}

extension CloudAccount: Identifiable { }

extension CloudAccount {
    static func allItems() -> NSFetchRequest<CloudAccount> {
        let request: NSFetchRequest<CloudAccount> = CloudAccount.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        request.shouldRefreshRefetchedObjects = true
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
    
    @State var isPushed = false
    
    let request = CloudAccount.fetchRequest2()
    var accounts: FetchedResults<CloudAccount> { return request.wrappedValue }
    //    @FetchRequest(fetchRequest: CloudAccount.allItems()) var accounts: FetchedResults<CloudAccount>
    //    @FetchRequest(fetchRequest: CloudAccount.allItems(), animation: .spring(response: 5, dampingFraction: 6, blendDuration: 1)) var accounts: FetchedResults<CloudAccount>
    
    var body: some View {
        VStack {
            NavigationLink(destination: AccountView(.init()), isActive: self.$isPushed) { EmptyView() }.hidden()
            List {
                
                ForEach(accounts) { account in
                    NavigationLink(destination: AccountView(Account(account))) {
                        VStack(alignment: .leading) {
                            Text(account.title)
                            Text("\(account.initialAmount)")
                        }
                    }
                }
                .onDelete { set in
                    print(set)
                    //                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
                    //                let obj = context.object(with: self.accounts[set.first!].objectID)
                    //                context.delete(obj)
                    //                try! context.save()
                    //                    .delete(self.accounts[set.first!])
                    self.context.delete(self.accounts[set.first!])
                    try! self.context.save()
                }
                //            .onTapGesture {
                //                let newAccount = CloudAccount(entity: CloudAccount.entity(), insertInto: self.context)
                //                newAccount.uuid = UUID()
                //                newAccount.title = UUID().uuidString
                //                newAccount.initialAmount = Int64.random(in: 0...1000)
                //                try! self.context.save()
                //            }
            }
        }
        .navigationBarItems(trailing: Button(action: { self.isPushed.toggle() }) { Image(systemName: "plus").font(Font.title.weight(.semibold)) })
        .navigationBarTitle("Accounts", displayMode: .inline)
    }
}

struct AccountView: View {
    @State var account: Account
    var amount: Binding<String> { Binding<String>(
        get: { "\(self.account.initialAmount)" },
        set: { self.account.initialAmount = Int64($0) ?? 0 }
        )
    }
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: Store<AppState, Void>
    @Environment(\.managedObjectContext) var context
    
    init(_ account: Account) {
        _account = State(initialValue: account)
    }
    
    var body: some View {
        Form {
            TextField("Title", text: self.$account.title)
                        
            TextField("Initial amount", text: self.amount)
                .keyboardType(.decimalPad)
            
            Text("Currency: \(account.currency.code)")
//            Picker(selection: self.$model.index, label: Text("Currency")) {
//                ForEach(0..<self.model.currencies.count) {
//                    Text(self.model.currencies[$0].code)
//                }
//            }
        }
        .navigationBarItems(leading: Button(action: { self.dismiss() }) { Image(systemName: "chevron.left").font(Font.title) },
                            trailing: Button(action: { self.save() }) { Text("Save") })
        .navigationBarTitle("Account", displayMode: .inline)
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func save() {
        presentationMode.wrappedValue.dismiss()
        let background = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
        
        let cloud: CloudAccount = {
            if let id = account.managedObjectId {
                return background.object(with: id) as! CloudAccount
            } else {
                let c = CloudAccount(entity: CloudAccount.entity(), insertInto: background)
                c.uuid = UUID()
                return c
            }
        }()
        
        cloud.initialAmount = account.initialAmount
        cloud.title = account.title
        
        try! background.save()
    }
}
