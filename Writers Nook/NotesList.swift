import SwiftUI

struct NotesList: View {
    
    @ObservedObject var fm: FolderModel
    @Binding var folder: Folder
    @State var folderIndex: Int
    @State var newNote = false
    
    var body: some View {
            ZStack {
                ColorDefinitions.background_2
                    .ignoresSafeArea()
                List {
                    ForEach(folder.notes.sorted { $0.date > $1.date }) { note in
                        NavigationLink(value: note) {
                            VStack(alignment: .leading) {
                                Text(note.note.preview(64))
                                    .font(.headline)
                                Text(note.date.formatted())
                                    .font(.subheadline)
                                    .foregroundStyle(ColorDefinitions.accent_2)
                            }
                        }
                        .listRowBackground(ColorDefinitions.background)
                        .foregroundColor(ColorDefinitions.foreground)
                    }
                    .onDelete { offsets in
                        fm.deleteNote(at: offsets, in: folderIndex)
                    }
                }
                .navigationDestination(for: Note.self) { note in
                    EditNote(folder: $fm.folders[folderIndex], note: note, words: note.note.numberOfWords)
                }
                .navigationTitle(folder.name)
                .toolbar {
                    Button(action: { newNote = true }) {
                        Image(systemName: "square.and.pencil")
                    }
                    .tint(ColorDefinitions.foreground)
                }
                .sheet(isPresented: $newNote) {
                    NewNote(fm: fm, folderIndex: folderIndex)
                }
                .scrollContentBackground(.hidden)
            }
            .accentColor(ColorDefinitions.color_3)
            .preferredColorScheme(.light)
        }
        
    
}

extension String {
    func preview(_ length: Int, trailing: String = "…") -> String {
        if let newlineIndex = self.firstIndex(of: "\n") {
            return String(self[..<newlineIndex])
        }
        if self.count <= length { return self }
        return String(self.prefix(length)) + trailing
    }
}
