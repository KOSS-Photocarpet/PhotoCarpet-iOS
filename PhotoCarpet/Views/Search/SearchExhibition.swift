//
//  SearchExhibition.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/22.
//

import SwiftUI

struct SearchExhibition: View {
    @EnvironmentObject var exhibitionData: ExhibitionData

    var exhibitions: [Response.Exhibition]

    init(exhibitions: [Response.Exhibition]) {
        self.exhibitions = exhibitions
    }

    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(exhibitions.indices, id: \.self) { index in
                    NavigationLink {
                        // TODO: 
                        ExhibitionMainView()
                    } label: {
                        ExhibitionItem(thumbUrl: exhibitions[index].thumbUrl, nickName: exhibitions[index].user?.nickName, profileURL: exhibitions[index].user?.profilUrl, title: exhibitions[index].title)
                            .padding(.vertical, 10)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .scrollIndicators(.hidden)
    }
}

struct SearchExhibition_Previews: PreviewProvider {
    static var previews: some View {
        SearchExhibition(exhibitions: [])
            .environmentObject(ExhibitionData())
    }
}
