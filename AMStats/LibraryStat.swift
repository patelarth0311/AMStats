//
//  StatsView.swift
//  Musie
//
//  Created by Arth Patel on 8/10/23.
//

import SwiftUI

struct StatsView: View {
    
    var gridItemLayout = [GridItem(.flexible())]
    var body: some View {
       
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 2) {
  
                  
                    StatView(title: "Songs",stat:  "30,508")
                        .cardStyle()
                    StatView(title: "Total minutes",stat:  "100,508")
                        .cardStyle()

                
            }
                

            
        }
    }
}



struct StatView : View {
    var title: String
    var stat: String
    var body: some View {
        VStack(alignment: .leading) {
        
            Text(title)
                .font(.system(size: 25,weight: .bold))
            Spacer()
            Text(stat)
                .font(.system(size: 40,weight: .bold))
        }
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
            .background(.pink)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(2)
    }
}

    extension View {
        func cardStyle() -> some View {
            modifier(CardStyle())
        }
    }
    
