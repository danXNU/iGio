//
//  TeenStarEditEntryVC.swift
//  SFA
//
//  Created by Dani Tox on 03/01/19.
//  Copyright © 2019 Dani Tox. All rights reserved.
//

import UIKit

let BASIC_CELL_ID = "cell"
let EMOZIONE_CELL_ID = "emozioneCell"
let CICLO_CELL_ID = "ciclocell"

let BASIC_ROW_HEIGHT : CGFloat = 50
let EMOZIONE_ROW_HEIGHT : CGFloat = 200
let CICLO_ROW_HEIGHT : CGFloat = 500 //350

let TSBOY_SECTIONS = 4
let TSGIRL_SECTIONS = 5

func GET_INDEX(_ index: Int) -> Int { return index - 1 }

class TeenStarEditEntryVC: UIViewController, HasCustomView {
    typealias CustomView = TeenStarEditEntryView
    override func loadView() {
        super.loadView()
        view = CustomView()
    }
    
    var genderType : UserGender? = .boy
    var entry : TeenStarTable?
    
    var currentEntryMemory : [Int : Int16] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        rootView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: BASIC_CELL_ID)
        rootView.tableView.register(EmozioneTableViewCell.self, forCellReuseIdentifier: EMOZIONE_CELL_ID)
        rootView.tableView.register(CicloTableViewCell.self, forCellReuseIdentifier: CICLO_CELL_ID)
        
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveTeenStarEntry()
    }
    
    private func saveTeenStarEntry() {
        guard let thisEntry = self.entry else { return }
        guard self.currentEntryMemory.indices.count > 0 else { return }
        if let emozione8 = self.currentEntryMemory[1] {
            thisEntry.sentimento8h = emozione8
        }
        if let emozione14 = self.currentEntryMemory[2] {
            thisEntry.sentimento14h = emozione14
        }
        if let emozione20 = self.currentEntryMemory[3] {
            thisEntry.sentimento20h = emozione20
        }
        if let cicloColor = self.currentEntryMemory[4] {
            thisEntry.ciclo = cicloColor
        }
        let context = thisEntry.managedObjectContext
        do {
            try context?.save()
        } catch {
            print("Errore a salvare CoreData TeenStar: \(error)")
        }
    }
    
}
extension TeenStarEditEntryVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: BASIC_CELL_ID)
            cell?.textLabel?.text = "Data: \(Date().dayOfWeek()) - \(Date().stringValue)"
            return cell!
        case 1, 2, 3, 4:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: BASIC_CELL_ID)
                let str = TEENSTAR_INDICES[GET_INDEX(indexPath.section)]
                cell?.textLabel?.text = "\(str)"
                return cell!
            }
            if indexPath.section == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CICLO_CELL_ID) as? CicloTableViewCell
                cell?.newValueSelected = { [weak self] newValue in
                    self?.currentEntryMemory[indexPath.section] = newValue.rawValue
                }
                return cell!
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: EMOZIONE_CELL_ID) as? EmozioneTableViewCell
            cell?.newValueSelected = { [weak self] (newValue) in
                self?.currentEntryMemory[indexPath.section] = newValue.rawValue
            }
            return cell!
        default:
            fatalError("Section inesistente")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (genderType == .boy) ? TSBOY_SECTIONS : TSGIRL_SECTIONS
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0, 1, 2, 3:
            if indexPath.row == 0 { return BASIC_ROW_HEIGHT }
            else { return EMOZIONE_ROW_HEIGHT }
        case 4:
            if indexPath.row == 0 { return BASIC_ROW_HEIGHT }
            else { return CICLO_ROW_HEIGHT }
        default:
            return 0
        }
    }
}
