//
//  ExhibitionItem.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/21.
//

import SwiftUI

struct ExhibitionItem: View {
    var thumbUrl: String?
    var nickName: String?
    var profileURL: String?
    var title: String?

    init(thumbUrl: String?, nickName: String?, profileURL: String?, title: String?) {
        self.thumbUrl = thumbUrl
        self.nickName = nickName
        self.profileURL = profileURL
        self.title = title
    }

    var body: some View {
        ViewThatFits {
            ZStack {
                if let thumbUrl {
                    AsyncImage(url: URL(string: thumbUrl)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 150, height: 250)
                                .cornerRadius(5)
                        case .empty:
                            ProgressView()
                                .frame(width: 150, height: 250)
                                .cornerRadius(5)
                                .background(Color.gray)
                        case .failure:
                            Image(systemName: "wifi.slash")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 150, height: 250)
                                .cornerRadius(5)
                        @unknown default:
                            EmptyView()
                                .frame(width: 150, height: 250)
                                .cornerRadius(5)
                        }
                    }
                } else {
                    Image(systemName: "nosign")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 150, height: 250)
                        .cornerRadius(5)
                }

                VStack {
                    Spacer()
                    ExhibitionInfo(exhibitionTitle: title, profileUrl: profileURL, nickName: nickName)
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0))
                .frame(width: 150, height: 250, alignment: .leading)
            } // ZStack

            ZStack(alignment: .leading) {
                Image("Image")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 120, height: 200)
                    .cornerRadius(5)

                VStack(alignment: .leading) {
                    Spacer()
                    ExhibitionInfo(exhibitionTitle: title, profileUrl: profileURL, nickName: nickName)
                }
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 0))
                .frame(width: 120, height: 200, alignment: .leading)
            } // ZStack
        }
    }
}

struct ExhibitionItem_Previews: PreviewProvider {
    static var previews: some View {
        ExhibitionItem(thumbUrl: "https://photocarpet.s3.ap-northeast-2.amazonaws.com/4f66d408-1c1c-4608-8d6c-cc1e421ab73c-4572474%20bytes.jpeg", nickName: "tester1", profileURL: nil, title: "전시회")
    }
}
