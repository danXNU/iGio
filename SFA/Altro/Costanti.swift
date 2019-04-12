//
//  Costanti.swift
//  SFA
//
//  Created by Dani Tox on 14/11/2018.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

let IS_FIRST_LAUNCH = "is_first_launch"
let NOTIFICHE_DA_RICEVERE = "notifiche_da_ricevere"
let THEME_KEY = "theme"
let GENDER_KEY = "gender"
let GRADOSCUOLA_KEY = "gradoScuola"


var isAlreadyLaunched : Bool {
    get {
        return UserDefaults.standard.bool(forKey: IS_FIRST_LAUNCH)
    } set {
        UserDefaults.standard.set(newValue, forKey: IS_FIRST_LAUNCH)
    }
}

var notificheDaRicevere : [String] {
    get {
        if let nots = UserDefaults.standard.array(forKey: NOTIFICHE_DA_RICEVERE) as? [String] {
            return nots
        } else {
            return []
        }
    } set {
        UserDefaults.standard.set(newValue, forKey: NOTIFICHE_DA_RICEVERE)
    }
}

class RegolaFile : Codable {
    var scuolaType: ScuolaType
    var categories : [RegolaCategoryFile] = []
    init(scuolaType: ScuolaType) { self.scuolaType = scuolaType }
}
class RegolaCategoryFile : Codable {
    var id : Int
    var name : String
    var domande : [RegolaDomandaFile]
}
class RegolaDomandaFile : Codable {
    var idDomanda: Int
    var domanda : String
    var rispsota : String?
}

enum LocalDBError: Error {
    case foundNil(String)
    case inconsistency(String)
    case warning(String)
    case fatal(String)
}

enum ToxException : Error {
    case generic
    case noteRelated(String)
    case regola(String)
}

let genderArray : [String] = ["Maschio", "Femmina"]
let EMOZIONI : [String] = ["Fiducia", "Collera", "Paura", "Tristezza", "Gioia", "Equilibrio"]

let TEENSTAR_INDICES : [String] = ["Sentimento prevalente alle ore 8:00:",
                                   "Sentimento prevalente alle ore 14:00:",
                                   "Sentimento prevalente alle ore 20:00:",
                                   "Ciclo: seleziona il tipo di colore o simbolo:"]



let CICLO_COLORS : [String] = ["rosso",
                               "verde",
                               "giallo",
                               "bianco",
                               "croce"]

let COLORS_DESCRIPTIONS : [CicloColor : String] = [
    .rosso : "Presenza di sangue nei genitali sia che provenga dalla mestruazione o da perdite intermestruali",
    .verde : "Giorni senza muco o con sensazione di secchezza",
    .giallo : "Giorni con presenza di muco appiccicoso e opaco, o una mucosità spessa senza variazioni",
    .bianco : "Giorni di muco cervicale trasparente, elastico, vulva bagnata o sensazione di umidità",
    .croce : "Giorno in cui è avvenuta la mestruazione"
]

var theme : String {
    get {
        return UserDefaults.standard.string(forKey: THEME_KEY) ?? "light"
    } set {
        UserDefaults.standard.set(newValue, forKey: THEME_KEY)
    }
}
