//
//  SearchExhibition.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/22.
//

import SwiftUI

struct SearchExhibition: View {
    @State private var offset: Int = 0
    @State private var limit: Int = 9

    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(0 ... (offset + 1) * 10, id: \.self) { index in
                    NavigationLink {
//                        ExhibitionMainView()
                    } label: {
//                        ExhibitionItem()
//                            .onAppear {
//                                if index % (limit + 1) == limit {
//                                    offset += 1
//                                }
//                            }
//                            .padding(.vertical, 10)
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
        SearchExhibition()
    }
}
