//
//  FooterView.swift
//  Honeymoon
//
//  Created by Robin Ruf on 25.03.21.
//

import SwiftUI

struct FooterView: View {
    
    @Binding var showBookingAlert: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "xmark.circle")
                .font(.system(size: 42, weight: .light))
            
            Spacer()
            
            Button(action: {
                showBookingAlert.toggle()
            }, label: {
                Text("Book Destination".uppercased())
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.heavy)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .foregroundColor(.pink)
                    .background(
                        Capsule().stroke(Color.pink, lineWidth: 2)
                    )
            })
            
            
            Spacer()
            
            Image(systemName: "heart.circle")
                .font(.system(size: 42, weight: .light))
            
        }
        .padding()
    }
}

struct FooterView_Previews: PreviewProvider {
    
    @State static var showAlert: Bool = false
    
    static var previews: some View {
        FooterView(showBookingAlert: $showAlert)
            .previewLayout(.fixed(width: 375, height: 80))
    }
}
