//
//  StatsView.swift
//  Musie
//
//  Created by Arth Patel on 8/10/23.
//

import SwiftUI
import MusicKit
import RealmSwift

struct LibraryStatView: View {

    @Environment(LibraryData.self) private var libraryData

    @Environment(MusicPlayer.self) private var musicPlayer

    @State var whichView : Int = 0

    var body: some View {
    
   
        
        
        NavigationView {
        
              
            ScrollView(.vertical) {
           
                    
                VStack(spacing: 20) {
                    
                        
                        
                            
                            
        
                                StatView(number: libraryData.totalMinutes, title: "Minutes Listened")
                                
                                
                      
                                
                                
                                StatView(number: libraryData.playCount, title: "Play Count")
                                
                            
                           
                            
                            
                            TopView()
                    
                            
                        
                    
                    }
                    
                    .padding(.bottom, musicPlayer.currentlyPlayingSong == nil ? 0 : 55)
                    
                    
                
            }
         
            .scrollIndicators(.hidden)
            
            .background(Color(red: 0.07, green: 0.07, blue: 0.07))
            .navigationTitle("Overview")
           
            .tint(.white)
            .navigationBarTitleDisplayMode(.large)
            
            .refreshable {
              
                self.libraryData.fetch { success in
                    self.libraryData.refresh.toggle()
                }
          

            }
        
    }
}
}


struct StatView : View  {
var number: Double
var title: String


var body: some View {
  
  
    HStack {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            
            Text("\(Int(number))")
                .font(.system(size: 60))
                .minimumScaleFactor(0.05)
                .lineLimit(1)
                .fontWeight(.bold)
            
        }
       
        .padding(.leading)
        Spacer()
    }
    
   
}
}




