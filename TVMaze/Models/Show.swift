//
//  Show.swift
//  TVMaze
//
//  Created by Youssef on 8/3/22.
//

import Foundation

struct Show: Codable {
    let showId: UInt
    let showURL: String
    let showName, showType, showLanguage: String?
    let showGenres: [String]
    let showStatus: String
    let showRuntime: Int?
    let showAverageRuntime: Int?
    let showPremiered: String?
    let showEnded: String?
    let showOfficialSite: String?
    let showWeight: Int
    let showSummary: String?
    let showUpdated: Int
    
    let showSchedule: Schedule?
    let showRating: Rating
    let showNetwork: Network?
    let showWebChannel: Channel?
    let showDVDCountry: Country?
    let showExternals: Externals
    let showImage: Image?
    let showLinks: Links?

    var showPremieredYear: String {
        if let showPremiered = showPremiered {
            let dateComponents = showPremiered.split(separator: "-")
            return String(dateComponents.first!)
        }
        
        return "Unknown"
    }
    
    enum CodingKeys: String, CodingKey {
        case showId = "id", showURL = "url", showName = "name",
             showType = "type", showLanguage = "language", showGenres = "genres",
             showStatus = "status", showRuntime = "runtime", showAverageRuntime = "averageRuntime",
             showPremiered = "premiered", showEnded = "ended", showOfficialSite = "officialSite",
             showSchedule = "schedule", showRating = "rating", showWeight = "weight",
             showNetwork = "network", showWebChannel = "webChannel", showDVDCountry = "dvdCountry",
             showExternals = "externals", showImage = "image", showSummary = "summary", showUpdated = "updated", showLinks = "_links"
    }
}

struct Schedule: Codable {
    let time: String
    let days: [String]
}

struct Rating: Codable {
    let average: Float?
}

struct Network: Codable {
    let id: UInt?
    let name: String?
    let country: Country?
    let officialSite: String?
}

struct Channel: Codable {
    let id: UInt?
    let name: String?
    let country: Country?
    let officialSite: String?
}

struct Country: Codable {
    let name, code, timezone: String?
}

struct Externals: Codable {
    let tvrage: UInt?
    let thetvdb: UInt?
    let imdb: String?
}

struct Image: Codable {
    let medium: String?
    let original: String?
}

struct Links: Codable {
    let selfLink: Link?
    let previousEpisodeLink: Link?

    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case previousEpisodeLink = "previousepisode"
    }
}

struct Link: Codable {
    let href: String?
}




