import SwiftUI

struct NewNote: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var fm: FolderModel
    @State var note: String = ""
    @State var folderIndex: Int
    
    var body: some View {
        NavigationView {
            Form {
                TextEditor(text: $note)
                    .frame(minHeight: 450, maxHeight: .infinity)
                    .listRowBackground(ColorDefinitions.background)
                    .foregroundColor(ColorDefinitions.foreground)
            }
            .navigationTitle("Edit Note")
            .toolbar {
                Button("Done") {
                    fm.addNote(note, to: folderIndex)
                    dismiss()
                }
                .tint(ColorDefinitions.foreground)
            }
            .background(ColorDefinitions.background_2)
            .scrollContentBackground(.hidden)
        }
        .accentColor(ColorDefinitions.color_3)
        .preferredColorScheme(.light)
    }
    
}
