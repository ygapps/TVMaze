//
//  Episode.swift
//  TVMaze
//
//  Created by Youssef on 8/4/22.
//

import Foundation

struct Episode: Codable {
    let episodeId: UInt
    let episodeURL: String
    let episodeName: String
    let episodeSummary: String?
    let episodeSeason, episodeNumber: UInt
    
    let episodeType, episodeAirdate, episodeAirtime: String?
    let episodeAirstamp: String?
    
    let episodeRuntime: UInt?
    let episodeRating: Rating?
    let episodeImage: Image?
    let episodeLinks: Links?

    enum CodingKeys: String, CodingKey {
        case episodeId = "id", episodeURL = "url", episodeName = "name", episodeSeason = "season",
             episodeNumber = "number", episodeType = "type", episodeAirdate = "airdate",
             episodeAirtime = "airtime", episodeAirstamp = "airstamp", episodeRuntime = "runtime",
             episodeRating = "rating", episodeImage = "image", episodeSummary = "summary", episodeLinks = "_links"
    }
}


