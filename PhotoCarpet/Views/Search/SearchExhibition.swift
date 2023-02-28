//
//  SearchExhibition.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/22.
//

import SwiftUI

struct SearchExhibition: View {
    @EnvironmentObject var searchVM: SearchViewModel
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    
    var body: some View {
        let exhibitions = searchVM.exhibitions
        return ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(exhibitions.indices, id: \.self) { index in
                    NavigationLink {
                        ExhibitionMainView()
                            .onAppear {
                                // TODO:
                            }
                    } label: {
                        ExhibitionItem()
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
        SearchExhibition()
            .environmentObject(ExhibitionData())
    }
}
