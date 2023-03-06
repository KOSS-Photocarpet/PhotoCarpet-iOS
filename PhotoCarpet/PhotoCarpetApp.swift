//
//  PhotoCarpetApp.swift
//  PhotoCarpet
//
//  Created by 최정민 on 2023/02/18.
//

import SwiftUI

// FIXME: 좋아요 여부를 프론트에서 한번 더 확인하는 것이 아니라, 백엔드에서 전시회, 전시물 데이터를 전달할 때 데이터베이스에서 확인 후 전달 바람.
// FIXME: 태그가 수정시에 계속 생겨남, 중복 처리 필요.
// FIXME: 전시물 조회시 좋아요도 나오게끔 API 수정 필요.
// ---
// TODO: 전시물 좋아요 기능 추가

@main
struct PhotoCarpetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
