//
//  BuyModal.swift
//  PhotoCarpet
//
//  Created by 최정민 on 2023/02/24.
//

import SwiftUI

struct BuyModal: View {
    @Binding var price: String
    
    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Text("구매 포인트")
                    .font(.custom("system", size: 12, relativeTo: .subheadline))
                    .bold()
                    .foregroundColor(Color(0x898EBC))
                Text(price + "P")
                    .font(.system(size: 25))
            }
            
            Button {
                
            } label: {
                Text("구매하기")
                    .foregroundColor(.white)
                    .padding()
                    .font(.system(size: 16, weight: .black))
            }
            .frame(width: UIScreen.main.bounds.size.width * 0.5)
            .background(.black)
            .cornerRadius(54)

        }
        .frame(width: UIScreen.main.bounds.size.width * 0.8)
        .padding()
        .background(.white)
        .cornerRadius(54)
        .background(
            Color(red: 0.761, green: 0.749, blue: 0.675, opacity: 0.6)
                .opacity(1)
                .shadow(color: .black, radius: 32, x: 0, y: 4)
                .blur(radius: 8, opaque: false)
        )
    }
}

struct BuyModal_Previews: PreviewProvider {
    static var previews: some View {
        BuyModal(
            price: .constant("300")
        )
    }
}
