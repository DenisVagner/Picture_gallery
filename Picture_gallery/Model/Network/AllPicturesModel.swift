//
//  AllPictures.swift
//  Picture_gallery
//
//  Created by Денис Вагнер on 16.02.2022.
//

import Foundation

struct AllPicturesModel: Decodable {
    let total, totalHits: Int?
    var hits: [Hit]
   }

   // MARK: - Hit
   struct Hit: Decodable {
       let id: Int?
       let pageURL: String?
       let type: TypeEnum?
       let tags: String?
       let previewURL: String?
       let previewWidth, previewHeight: Int?
       let webformatURL: String?
       let webformatWidth, webformatHeight: Int?
       let largeImageURL: String?
       let imageWidth, imageHeight, imageSize, views: Int?
       let downloads, collections, likes, comments: Int?
       let userID: Int?
       let user: String?
       let userImageURL: String?

       enum CodingKeys: String, CodingKey {
           case id, pageURL, type, tags, previewURL, previewWidth, previewHeight, webformatURL, webformatWidth, webformatHeight, largeImageURL, imageWidth, imageHeight, imageSize, views, downloads, collections, likes, comments
           case userID = "user_id"
           case user, userImageURL
       }
   }

   enum TypeEnum: String, Codable {
       case photo = "photo"
   }
