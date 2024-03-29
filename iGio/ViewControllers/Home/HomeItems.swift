//
//  HomeCells.swift
//  MGS
//
//  Created by Dani Tox on 09/06/2019.
//  Copyright © 2019 Dani Tox. All rights reserved.
//

import UIKit

struct HomeItem {
    var idNumber: Int
    var name: String
    var image: UIImage?
    var color: UIColor
    var allowedAge: [ScuolaType]
    var allowedGenders: [UserGender]
}


let allHomeItems: [HomeItem] = [
    HomeItem(idNumber: 0, name: "Diario personale", image: #imageLiteral(resourceName: "diary"), color: .blue, allowedAge: ScuolaType.allCases, allowedGenders: UserGender.allCases), //✅
    HomeItem(idNumber: 2, name: "GioProNet", image: #imageLiteral(resourceName: "weightscale"), color: .red, allowedAge: ScuolaType.allCases, allowedGenders: UserGender.allCases),
    HomeItem(idNumber: 4, name: "Il mio percorso formativo", image: #imageLiteral(resourceName: "search"), color: .orange, allowedAge: [.medie, .biennio, .triennio], allowedGenders: UserGender.allCases),
    HomeItem(idNumber: 1, name: "TeenSTAR", image: #imageLiteral(resourceName: "star"), color: UIColor(red: 244/255, green: 0, blue: 261/255, alpha: 1), allowedAge: ScuolaType.allCases, allowedGenders: UserGender.allCases), //✅
    HomeItem(idNumber: 3, name: "Agenda dell'allegria e della santità", image: #imageLiteral(resourceName: "airplane"), color: .darkGreen, allowedAge: [.medie], allowedGenders: UserGender.allCases), //✅
    HomeItem(idNumber: 5, name: "Il progetto delle 3S", image: #imageLiteral(resourceName: "airplane"), color: .darkGreen, allowedAge: [.biennio], allowedGenders: UserGender.allCases), //✅
    HomeItem(idNumber: 6, name: "Regola di Vita", image: #imageLiteral(resourceName: "airplane"), color: .darkGreen, allowedAge: [.triennio], allowedGenders: UserGender.allCases), //✅
    HomeItem(idNumber: 7, name: "Angelo Custode",
             image: UIImage(named: "angel"),
             color: UIColor.yellow,
             allowedAge: ScuolaType.allCases, allowedGenders: UserGender.allCases)
]

