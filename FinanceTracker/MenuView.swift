//
//  MenuView.swift
//  FinanceTracker
//
//  Created by Anton Efimenko on 13/09/2019.
//  Copyright © 2019 Anton Efimenko. All rights reserved.
//

import SwiftUI

struct GroupItem<Group: Hashable, Item: Hashable>: Identifiable, Hashable {
    var id: Group {
        return header
    }
    
    var isExpanded: Bool = false
    var header: Group
    var items: [Item]
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
    @State var items = [
        GroupItem(header: "First", items: ["1", "2", "3"]),
        GroupItem(header: "Second", items: ["1", "2", "3"]),
        GroupItem(header: "Third", items: ["1", "2", "3"])
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items.indices, id: \.self) { index in
                    Section(header: HeaderView(headerText: self.items[index].header, isExpanded: self.$items[index].isExpanded)) {
                        if self.items[index].isExpanded {
                            ForEach(self.items[index].items, id: \.self) { item in
                                Text(item)
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Menu", displayMode: .inline)
        }
    }
}
