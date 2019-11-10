//
//  MenuView.swift
//  FinanceTracker
//
//  Created by Anton Efimenko on 13/09/2019.
//  Copyright © 2019 Anton Efimenko. All rights reserved.
//

import SwiftUI

struct GroupItem<Group: Hashable, Item: Hashable>: Identifiable, Hashable {
    struct GroupElement: Equatable {
        let label: String
        let navigationView: AnyView
        
        init<T: View>(_ label: String, _ navigationView: T) {
            self.label = label
            self.navigationView = AnyView(navigationView)
        }
        
        static func == (lhs: GroupElement, rhs: GroupElement) -> Bool {
            return lhs.label == rhs.label
        }
    }
    
    static func == (lhs: GroupItem<Group, Item>, rhs: GroupItem<Group, Item>) -> Bool {
        return lhs.header == rhs.header && lhs.isExpanded == rhs.isExpanded && lhs.items == rhs.items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(header)
        hasher.combine(id)
        hasher.combine(items.map { $0.label })
    }
    
    var id: Group {
        return header
    }
    
    var header: Group
    var items: [GroupElement]
//    var navigationView: AnyView
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
                Image(systemName: "chevron.down")
                    .font(.headline)
                    .rotationEffect(.degrees(isExpanded ? 0 : -90))
                    .animation(.easeInOut)
            })
        }
    }
}

struct MenuView: View {
    @State var items: [GroupItem<String, String>] = [
        GroupItem(header: "First",
                  items: [.init("Accounts", AccountsView()), .init("2", EmptyView()), .init("3", EmptyView())],
                  isExpanded: true),
        GroupItem(header: "Second", items: [.init("1", EmptyView()), .init("2", EmptyView())]),
        GroupItem(header: "Third", items: [.init("1", EmptyView()), .init("2", EmptyView())])
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items.indices, id: \.self) { index in
                    MenuSection(group: self.$items[index])
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Menu", displayMode: .inline)
        }
    }
}

struct MenuSection<Group: StringProtocol, Item: Hashable & LosslessStringConvertible>: View {
    @Binding var group: GroupItem<Group, Item>
    
    var body: some View {
        Section(header: HeaderView(headerText: String(self.group.header), isExpanded: self.$group.isExpanded)) {
            if self.group.isExpanded {
                ForEach(self.group.items, id: \.label) { item in
                    NavigationLink(destination: item.navigationView, label: { Text(String(item.label)) })
                }
            }
        }
    }
}
