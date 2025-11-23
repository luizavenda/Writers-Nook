import SwiftUI
import UIKit

extension TextEditor {
    @ViewBuilder
    func hideBackground() -> some View {
        if #available(iOS 16, *) {
            self.scrollContentBackground(.hidden)
        } else {
            self.background(Color.clear)
        }
    }
}

struct EditNote: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var folder: Folder
    @State var note: Note
    @State var selection: TextSelection? = nil
    @State private var editing: Bool = false
    
    @State var words: Int;
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                if !editing {
                    ScrollView {
                        Text(.init(note.note))
                            .foregroundColor(ColorDefinitions.foreground)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                }
                else {
                    TextEditor(text: $note.note, selection: $selection)
                        .hideBackground()
                        .foregroundColor(ColorDefinitions.foreground)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
                }
            }
            .background(ColorDefinitions.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { editing.toggle() }) {
                        Text(editing ? "Done" : "Edit")
                    }
                    .foregroundColor(ColorDefinitions.foreground)
                }
            }
            .onChange(of: note.note) {_old, new in
                if let index = folder.notes.firstIndex(where: { $0.id == note.id }) {
                    folder.notes[index].note = new
                    folder.notes[index].date = Date()
                }
                words = note.note.numberOfWords
            }
            .onDisappear {
                if let index = folder.notes.firstIndex(where: { $0.id == note.id }) {
                    folder.notes[index].date = Date()
                }
            }
            HStack() {
                Spacer()
                Spacer()
                Text("Words: \(words)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(ColorDefinitions.background)
            .foregroundColor(ColorDefinitions.foreground)
        }
        .accentColor(ColorDefinitions.color_3)
        .preferredColorScheme(.light)
    }
}

extension String {
    var numberOfWords: Int {
        var count = 0
        let range = startIndex..<endIndex
        enumerateSubstrings(in: range, options: [.byWords, .substringNotRequired, .localized], { _, _, _, _ -> () in
            count += 1
        })
        return count
    }
}
