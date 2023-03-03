//
//  Request.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/26.
//

import Foundation

struct Request: Codable {
    static let baseURL = "http://localhost:8080"
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"

    static let decoder: JSONDecoder = {
        let formatter = DateFormatter()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            formatter.dateFormat = Self.dateFormat
            if let date = formatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        }
        return decoder
    }()
}
