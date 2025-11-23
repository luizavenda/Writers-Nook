import Combine
import Foundation
import SwiftUI

struct Folder: Identifiable, Codable {
    var id = UUID()
    var name: String
    var notes: [Note] = []
    
    init(_ name: String) {
        self.name = name
    }
}

class FolderModel: ObservableObject {
    
    @Published var folders: [Folder] = [] {
        didSet {
            saveFolders()
        }
    }
    
    private let folderKey = "FoldersKey"
    
    init() {
        loadFolders()
    }
    
    private func loadFolders() {
        guard let data = UserDefaults.standard.data(forKey: folderKey) else { return }
        do {
            folders = try JSONDecoder().decode([Folder].self, from: data)
        }
        catch {
            print("Folders could not be loaded \(error)")
            folders = []
        }
    }
    
    func addFolder(_ name: String) {
        let new = Folder(name)
        folders.insert(new, at: 0)
    }
    
    func moveFolder(from source: IndexSet, to destination: Int) {
        folders.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteFolder(at offsets: IndexSet) {
        folders.remove(atOffsets: offsets)
    }
    
    private func saveFolders() {
        do {
            let encoded = try JSONEncoder().encode(folders)
            UserDefaults.standard.set(encoded, forKey: folderKey)
        }
        catch {
            print("Folder could not be encoded \(error)")
        }
    }
    
    func addNote(_ text: String, to folderIndex: Int) {
        let note = Note(text)
        folders[folderIndex].notes.insert(note, at: 0)
        folders[folderIndex].notes.sort { $0.date > $1.date }
    }
    
    func deleteNote(at offsets: IndexSet, in folderIndex: Int) {
        folders[folderIndex].notes.remove(atOffsets: offsets)
    }
    
}
