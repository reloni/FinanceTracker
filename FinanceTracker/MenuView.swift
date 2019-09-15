//
//  MenuView.swift
//  FinanceTracker
//
//  Created by Anton Efimenko on 13/09/2019.
//  Copyright © 2019 Anton Efimenko. All rights reserved.
//

import SwiftUI

struct GroupItem<Group: Hashable, Item: Hashable, NavigationView: View>: Identifiable, Hashable {
    static func == (lhs: GroupItem<Group, Item, NavigationView>, rhs: GroupItem<Group, Item, NavigationView>) -> Bool {
        return lhs.header == rhs.header && lhs.isExpanded == rhs.isExpanded && lhs.items == rhs.items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(header)
        hasher.combine(id)
        hasher.combine(items)
    }
    
    var id: Group {
        return header
    }
    
    var header: Group
    var items: [Item]
    var navigationView: AnyView
    var isExpanded: Bool = false
}

struct HeaderView: View {
    let headerText: String
    @Binding var isExpanded: Bool
    
    var body: some View {
        HStack {
            Text(headerText)
                .font(.headline)
            
            Spacer()
            
            Button(action: { self.isExpanded.toggle() }, label: {
                Image(systemName: "chevron.up")
                    .font(.headline)
                    .rotationEffect(.degrees(isExpanded ? 0 : 180))
                    .animation(.easeInOut)
            })
        }
    }
}

struct MenuView: View {
    @State var items: [GroupItem<String, String, AnyView>] = [
        GroupItem(header: "First", items: ["Accounts", "2", "3"], navigationView: AnyView(AccountsView()), isExpanded: true),
        GroupItem(header: "Second", items: ["1", "2", "3"], navigationView: AnyView(EmptyView())),
        GroupItem(header: "Third", items: ["1", "2", "3"], navigationView: AnyView(EmptyView()))
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items.indices, id: \.self) { index in
                    MenuSection(group: self.$items[index])
                }
                .padding(.top)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Menu", displayMode: .inline)
        }
    }
}

struct MenuSection<Group: StringProtocol, Item: Hashable & LosslessStringConvertible, NavigationView: View>: View {
    @Binding var group: GroupItem<Group, Item, NavigationView>
    
    var body: some View {
        Section(header: HeaderView(headerText: String(self.group.header), isExpanded: self.$group.isExpanded)) {
            if self.group.isExpanded {
                ForEach(self.group.items, id: \.self) { item in
                    NavigationLink(destination: self.group.navigationView, label: { Text(String(item)) })
                }
            }
        }
    }
}
