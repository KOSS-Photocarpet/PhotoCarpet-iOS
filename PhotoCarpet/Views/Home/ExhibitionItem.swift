//
//  ExhibitionItem.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/21.
//

import SwiftUI

struct ExhibitionItem: View {
    var exhibition: Response.Exhibition

    init(_ exhibition: Response.Exhibition) {
        self.exhibition = exhibition
    }

    var body: some View {
        ViewThatFits {
            ZStack {
                AsyncImage(url: URL(string: exhibition.thumbUrl!)) { phase in
                    if let image = phase.image {
                        image
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 150, height: 250)
                            .cornerRadius(5)
                    } else if phase.error != nil {
                        Image(systemName: "wifi.slash")
                            .onAppear {
                                debugPrint(phase.error)
                            }
                    } else {
                        ProgressView()
                    }
                }

                VStack {
                    Spacer()
                    ExhibitionInfo(exhibition)
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0))
                .frame(width: 150, height: 250, alignment: .leading)
            } // ZStack

            ZStack(alignment: .leading) {
                AsyncImage(url: URL(string: exhibition.thumbUrl!)) { phase in
                    if let image = phase.image {
                        image
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 150, height: 250)
                            .cornerRadius(5)
                    } else if phase.error != nil {
                        Image(systemName: "wifi.slash")
                    } else {
                        ProgressView()
                    }

                    VStack(alignment: .leading) {
                        Spacer()
                        ExhibitionInfo(exhibition)
                    }
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 0))
                    .frame(width: 120, height: 200, alignment: .leading)
                } // ZStack
            }
        }
    }
}

struct ExhibitionItem_Previews: PreviewProvider {
    static var previews: some View {
//        ExhibitionItem()
        EmptyView()
    }
}
