//
//  PictureInfo+CoreDataProperties.swift
//  
//
//  Created by Денис Вагнер on 16.02.2022.
//
//

import Foundation
import CoreData


extension PictureInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PictureInfo> {
        return NSFetchRequest<PictureInfo>(entityName: "PictureInfo")
    }

    @NSManaged public var id: Int
    @NSManaged public var views: Int
    @NSManaged public var largeImageURL: String?
    @NSManaged public var previewURL: String?
    @NSManaged public var imageWidth: Int
    @NSManaged public var imageHeight: Int
    @NSManaged public var smallIMG: Data?
    @NSManaged public var largeIMG: Data?
    @NSManaged public var savingDate: String

}
