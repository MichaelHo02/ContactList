//
//  ContentView.swift
//  ContactList
//
//  Created by Ho Le Minh Thach on 3/8/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @State private var path = NavigationPath()
    @State private var presentedView: PresentedView?

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(items) { item in
                    NavigationLink(value: PushedView.detailPage(item: item)) {
                        ItemRow(item: item)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .listRowSpacing(8)
            .navigationTitle(navigationTitle) 
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label(labelAddItem, systemSymbol: .plus)
                    }
                }
            }
            .navigationDestination(for: PushedView.self) { pushedView in
                switch pushedView {
                case .detailPage(let item):
                    ContactDetailView(item: item)
                }
            }
            .sheet(item: $presentedView) { presentedView in
                switch presentedView {
                case .createContact:
                    ContactCreationView()
                }
            }
        }
    }

    private func addItem() {
        presentedView = .createContact
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

// MARK: - Attributes

private extension ContentView {

    var navigationTitle: LocalizedStringKey {
        "Contact List"
    }

    var labelAddItem: LocalizedStringKey {
        "Add Item"
    }

}

extension ContentView {

    enum PushedView: Hashable {
        case detailPage(item: Item)
    }

    enum PresentedView: Int, Identifiable {
        var id: Int { self.rawValue }

        case createContact
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
