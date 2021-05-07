//
//  HeaderView.swift
//  Honeymoon
//
//  Created by Robin Ruf on 25.03.21.
//

import SwiftUI

struct HeaderView: View {
    
    @Binding var showGuideView: Bool
    @Binding var showInfoView: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                showInfoView.toggle()
            }, label: {
                Image(systemName: "info.circle")
                    .font(.system(size: 24, weight: .regular))
            })
            .foregroundColor(.primary)
            .sheet(isPresented: $showInfoView, content: {
                InfoView()
            })
            
            Spacer()
            
            Image("logo-honeymoon-pink")
                .resizable()
                .scaledToFit()
                .frame(height: 28)
            
            Spacer()
            
            Button(action: {
                showGuideView.toggle()
            }, label: {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 24, weight: .regular))
            })
            .foregroundColor(.primary)
            .sheet(isPresented: $showGuideView, content: {
                GuideView()
            })
        }
        .padding()
    }
}

struct HeaderView_Previews: PreviewProvider {
    
    @State static var showGuideView: Bool = false
    @State static var showInfoView: Bool = false
    
    static var previews: some View {
        HeaderView(showGuideView: $showGuideView, showInfoView: $showInfoView)
            .previewLayout(.fixed(width: 375, height: 80))
    }
}
