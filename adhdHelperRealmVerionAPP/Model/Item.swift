//
//  Item.swift
//  adhdHelperRealmVerionAPP
//
//  Created by Amel Sbaihi on 1/20/23.
//

import Foundation
import  RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    //@objc dynamic var dateCreate : Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}


