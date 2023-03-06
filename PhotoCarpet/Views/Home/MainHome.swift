//
//  MainHome.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/21.
//

import SwiftUI

struct MainHome: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CustomNavBarView()

                VStack(spacing: 10) {
                    ExhibitionRow(categoryName: "Trend")
                        .listRowInsets(EdgeInsets())

                    ExhibitionRow(categoryName: "Recent")
                        .padding(.vertical, 10)
                        .listRowInsets(EdgeInsets())

                    NavigationLink {
                        EnrollView(isEdit: false)
                            .environmentObject(ExhibitionInputData())
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                    }
                } // VStack
                .padding(.top, 20)
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .frame(maxHeight: .infinity)
            }
            .toolbar(.hidden, for: .navigationBar)
            .background(Gradient(colors: [.black, .white]))
        } // NavView
        .navigationViewStyle(.stack)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
