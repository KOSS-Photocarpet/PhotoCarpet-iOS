//
//  User.swift
//  PhotoCarpet
//
//  Created by 최정민 on 2023/02/23.
//

import Foundation
import SwiftUI

final class User {
    static let shared: User = .init()
//    private init() {}
    public init() {}

    let userId: Int = 2
    let nickName: String = "tester2"
    var point: Int = 1500
    var profileurl: String?
    var email: String?
}
