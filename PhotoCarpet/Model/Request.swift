//
//  Request.swift
//  PhotoCarpet
//
//  Created by 최정민 on 2023/02/26.
//

import Foundation
import SwiftUI

struct Request {
    static let baseURL = "http://localhost:8080"
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"

    struct Exhibition {
        let title: String
        let content: String
        let exhibitionDate: Date
        let userId: Int
        let customMoods: [String]
        let photo: UIImage
    }

    struct Photo {
        let exhibitionId: Int
        let soldOut: Bool
        let price: Int
        let photo: UIImage
    }
}
