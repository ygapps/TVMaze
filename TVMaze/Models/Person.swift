//
//  Person.swift
//  TVMaze
//
//  Created by Youssef on 8/5/22.
//

import Foundation

struct Person: Codable {
    let personId: UInt
    let personURL: String?
    let personName: String
    let personBirthday: String?
    let personDeathday: String?
    let personGender: String?
    let personUpdated: Int
    
    let personCountry: Country?
    let personImage: Image?
    let personLinks: Links?

    enum CodingKeys: String, CodingKey {
        case personId = "id", personURL = "url", personName = "name", personCountry = "country",
             personBirthday = "birthday", personDeathday = "deathday", personGender = "gender",
             personImage = "image", personUpdated = "updated", personLinks = "_links"
    }
}
