//
//  ExhibitionInfo.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/23.
//

import SwiftUI

struct ExhibitionInfo: View {
    var exhibitionTitle: String?
    var profileUrl: String?
    var nickName: String?

    init(exhibitionTitle: String?, profileUrl: String?, nickName: String?) {
        self.exhibitionTitle = exhibitionTitle
        self.profileUrl = profileUrl
        self.nickName = nickName
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(exhibitionTitle ?? "전시회1")
                .foregroundColor(.white)
                .font(.system(size: 15, weight: .bold))

            ArtistInfo(artistProfileUrl: profileUrl, artistName: nickName)
        } // VStack
    }
}

struct ExhibitionInfo_Previews: PreviewProvider {
    static var previews: some View {
        ExhibitionInfo(exhibitionTitle: "전시회1", profileUrl: nil, nickName: "아티스트 이름")
    }
}
