//
//  Router.swift
//  TVMaze
//
//  Created by Youssef on 8/3/22.
//

import Foundation

enum Router {
    case shows(page: UInt)
    case search(searchQuery: String)
    case showsDetails(seriesId: UInt)
    case episodes(seriesId: UInt)
    case episodeDetails(episodeId: UInt)
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.tvmaze.com"
    }
    
    var path: String {
        switch self {
        case .shows:
            return "/shows"
        case .search:
            return "/search/shows"
        case .showsDetails(let seriesId):
            return "/shows/\(seriesId)"
        case .episodes(let seriesId):
            return "/shows/\(seriesId)/episodes"
        case .episodeDetails(let episodeId):
            return "/episodes/\(episodeId)"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .shows(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .search(let searchQuery):
            return [URLQueryItem(name: "q", value: searchQuery)]
        case .showsDetails:
            return []
        case .episodes:
            return []
        case .episodeDetails:
            return []
        }
    }
    
    var method: String {
        return "GET"
    }
}
