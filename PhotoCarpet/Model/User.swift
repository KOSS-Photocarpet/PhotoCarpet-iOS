//
//  User.swift
//  PhotoCarpet
//
//  Created by 최정민 on 2023/02/23.
//

import Foundation

final class User {
    static let shared: User = .init()
    private init() {}

    let userId: Int = 2
    var point: Int = 1500
    let jwtToken: String = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJudWxsIiwiaXNzIjoiZGVtbyBhcHAiLCJpYXQiOjE2Nzc0MDM4MDksImV4cCI6MTY3NzQ5MDIwOSwiYWNjZXNzX3Rva2VuIjoia2FrYW8ifQ.a8y6NfwoTFXDZhZeihdm5cceOC8mUcKAxJNbqiQ1e1yH7D6BI2i8Qq2m7nMLTtf-nEsTwv_cBiUf_CXrcmoJTw"
    let nickName: String = "ljh"
}
