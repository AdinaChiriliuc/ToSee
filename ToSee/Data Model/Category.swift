//
//  Category.swift
//  ToSee
//
//  Created by Adina Chiriliuc on 15/07/2020.
//  Copyright © 2020 Adina Chiriliuc. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
    
}
