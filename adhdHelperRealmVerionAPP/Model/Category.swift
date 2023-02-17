//
//  Category.swift
//  adhdHelperRealmVerionAPP
//
//  Created by Amel Sbaihi on 1/20/23.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var colorString : String = ""
    
    var items = List<Item>()
 
    
    
}
