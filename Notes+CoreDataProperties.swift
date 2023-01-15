//
//  Notes+CoreDataProperties.swift
//  
//
//  Created by Sunil Developer on 13/01/23.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var date: String?
    @NSManaged public var descraption: String?
    @NSManaged public var id: Int32
    @NSManaged public var priority: String?
    @NSManaged public var status: String?
    @NSManaged public var title: String?

}
