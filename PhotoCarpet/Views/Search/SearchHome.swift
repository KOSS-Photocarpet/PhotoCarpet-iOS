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

    @State var searchType: SearchType = .artist

    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            SearchBar(searchType: $searchType)
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

            searchType == .exhibition ? AnyView(SearchExhibition(exhibitions: searchVM.exhibitions)) : AnyView(SearchArtist(artists: searchVM.artists))
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
