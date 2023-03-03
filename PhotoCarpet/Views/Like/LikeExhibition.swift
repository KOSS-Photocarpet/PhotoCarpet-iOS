//
//  LikeExhibition.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/03/01.
//

import SwiftUI

struct LikeExhibition: View {
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
//                ForEach(exhibitions.indices, id: \.self) { index in
//                    NavigationLink {
//                        ExhibitionMainView()
//                            .onAppear {
//                                exhibitionData.setDummyData()
//                            }
//                    } label: {
//                        ExhibitionItem(thumbUrl: exhibitions[index].thumbUrl, nickName: exhibitions[index].user?.nickName, profileURL: exhibitions[index].user?.profilUrl, title: exhibitions[index].title)
//                            .padding(.vertical, 10)
//                    }
//                }
            }
        }
        .padding(.horizontal, 20)
        .scrollIndicators(.hidden)
    }
}

struct LikeExhibition_Previews: PreviewProvider {
    static var previews: some View {
        LikeExhibition()
    }
}
