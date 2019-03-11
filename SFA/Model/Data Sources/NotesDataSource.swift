//
//  NotesDataSource.swift
//  SFA
//
//  Created by Dani Tox on 10/03/19.
//  Copyright © 2019 Dani Tox. All rights reserved.
//

import UIKit
import RealmSwift

class NotesDataSource : NSObject, UITableViewDataSource {
    
    private var noteModel : NoteModel = NoteModel()
    
    public var errorHandler : ((Error) -> Void)? {
        didSet {
            noteModel.errorHandler = errorHandler
        }
    }
    public var dataLoaded : (() -> Void)?
    private var notificationToken : NotificationToken?
    
    override init() {
        super.init()
        let realm = try! Realm()
        self.notificationToken = realm.observe { (notification, realm) in
            self.updateData()
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func updateData() {
        noteModel.fullFetch()
        dataLoaded?()
    }
    
    func getNewNote() -> Note {
        return noteModel.createNewNote()
    }
    
    func getNoteAt(indexPath: IndexPath) -> Note {
        return noteModel.notesStorage[indexPath.section].notes[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return noteModel.notesStorage.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let storage = noteModel.notesStorage[section]
        return storage.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BoldCell
        let note = noteModel.notesStorage[indexPath.section].notes[indexPath.row]
        
        let attributedBody : NSAttributedString = note.getBody()
        let stringValue : String = attributedBody.string
        
        let count = stringValue.wordsCount
        
        cell.rightBottomLabel.text = "\(count) parole"
        cell.mainLabel.text = note.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFocued = noteModel.notesStorage[section].date
        if dateFocued.isToday() {
            return "Oggi"
        } else if dateFocued.isYesterday() {
            return "Ieri"
        } else {
            return "\(dateFocued.dayOfWeek()) - \(dateFocued.stringValue)"
        }
        
    }
    
    
    
}
