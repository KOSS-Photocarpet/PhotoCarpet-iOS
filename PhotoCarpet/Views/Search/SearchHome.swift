//
//  SearchHome.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/22.
//

import SwiftUI

struct SearchHome: View {
    @Environment(\.presentationMode) var presentation

    @StateObject private var searchVM = SearchViewModel()

    @State var searchWord: String = ""
    @State var searchType: SearchType = .artist // 전시회 검색인지 확인

    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            SearchBar(searchWord: $searchWord, searchType: $searchType)
                .environmentObject(searchVM)

            HStack {
                Button {
                    searchType = .artist
                } label: {
                    Text("Artists")
                        .fontWeight(searchType == .artist ? .bold : .regular)
                }

                Spacer()

                Button {
                    searchType = .exhibition
                } label: {
                    Text("Exhibitions")
                        .fontWeight(searchType == .exhibition ? .bold : .regular)
                }
            }
            .frame(width: 200)

            searchType == .exhibition ? AnyView(SearchExhibition().environmentObject(searchVM)) : AnyView(SearchArtist().environmentObject(searchVM))
        }
        .padding(.top, 20)

        .navigationBarTitle("검색", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.black)
                    .onTapGesture {
                        self.presentation.wrappedValue.dismiss()
                    }
            }
        })
        .tint(.black)
    }
}

struct SearchHome_Previews: PreviewProvider {
    static var previews: some View {
        SearchHome()
    }
}
