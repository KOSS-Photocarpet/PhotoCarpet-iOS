//
//  CustomNavBarView.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/21.
//

import SwiftUI

struct CustomNavBarView: View {
    var body: some View {
        HStack {
            Text("PhotoCarpet")
                .fontWeight(.semibold)

            Spacer()

            NavigationLink {
                SearchHome()
            } label: {
                Image(systemName: "magnifyingglass")
            }

            NavigationLink {
                UserProfile()
            } label: {
                Image(systemName: "person.fill")
            }

            NavigationLink {
                LikeHome()
            } label: {
                Image(systemName: "ellipsis")
            }
        }
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
        .font(.title2)
        .foregroundColor(.white)
        .background(Color.black)
    }
}

struct CustomNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomNavBarView()
            Spacer()
        }
    }
}
