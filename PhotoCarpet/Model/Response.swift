//
//  Response.swift
//  PhotoCarpet
//
//  Created by 최정민 on 2023/02/26.
//

import Foundation

struct Response: Codable {
    struct Exhibition: Codable {
        struct User: Codable {
            let nickName: String?
            let profilUrl: String?
        }

        let exhibitId: Int
        let title: String?
        let content: String?
        let likeCount: Int?
        let exhibitionDate: Date?
        let thumbUrl: String?
        let user: User?
        let moodContents: [String]?
        var liked: Bool?
    }

    struct Artist: Codable {
        let userId: Int
        let nickName: String?
        let profileMessage: String?
        let profileUrl: String?
        let exhibitions: [Exhibition]?
    }

    struct SocialUser: Codable {
        let userId: Int
        let nickname: String?
        let email: String
        let profileUrl: String?
        let jwtToken: String
        let accessToken: String
        let profileMessage: String?
        let validate_check: Bool?
    }

    struct SearchResult<T: Codable>: Codable {
        let result: [T]
        let error: String?
    }

    struct Photo: Codable {
        let exhibitionId: Int
        let photoId: Int
        let artUrl: String
        let price: Int
        let soldOut: Bool
    }
}
