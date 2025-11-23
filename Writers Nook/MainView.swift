import SwiftUI

struct MainView: View {
    
    @StateObject var fm = FolderModel()
    @State var newFolder = false
    
    @State var newTitle = ""
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(ColorDefinitions.foreground_2)
        ]
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(ColorDefinitions.foreground)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor(ColorDefinitions.background)
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                ColorDefinitions.background_2
                    .ignoresSafeArea()
                List {
                    ForEach(fm.folders.indices, id: \.self) { index in
                        NavigationLink(value: index) {
                            Text(fm.folders[index].name)
                        }
                        .listRowBackground(ColorDefinitions.background)
                        .foregroundColor(ColorDefinitions.foreground)
                    }
                    .onDelete(perform: fm.deleteFolder)
                    .onMove(perform: fm.moveFolder)
                }
                .scrollContentBackground(.hidden)
                .navigationDestination(for: Int.self) { folderIndex in
                    NotesList(fm: fm, folder: $fm.folders[folderIndex], folderIndex: folderIndex)
                }
                .navigationTitle("Projects")
                .toolbar {
                    HStack {
                        EditButton()
                            .foregroundColor(ColorDefinitions.foreground)
                            .tint(ColorDefinitions.color_3)
                        Button(action: { newFolder = true }) {
                            Image(systemName: "square.and.pencil")
                        }
                        .alert("New Folder", isPresented: $newFolder) {
                            TextField("Folder Name", text: $newTitle)
                            Button("OK", role: .confirm) {
                                fm.addFolder(newTitle)
                                newTitle = ""
                            }
                            Button("Cancel", role: .cancel) {
                                newTitle = ""
                            }
                        }
                        .tint(ColorDefinitions.foreground)
                    }
                }
            }
        }
        .accentColor(ColorDefinitions.color_3)
        .preferredColorScheme(.light)
    }
    
}
