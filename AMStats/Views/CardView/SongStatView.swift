//
//  SongStatView.swift
//  Musie
//
//  Created by Arth Patel on 8/26/23.
//

import Foundation
import SwiftUI
import MusicKit

struct SongStatView : View {
 
    @Environment(LibraryData.self) private var libraryData
  
    @Namespace var namespace
  
  
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            
      
            if (libraryData.songs.count > 0) {
                
           
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: Array(repeating: .init(.flexible()), count: min(libraryData.songs.count, 4)),spacing: 10) {
                            
                        
                            ForEach(Array(libraryData.songs.enumerated())[0...19], id: \.element) { index, song in
                               
                                    SongRectangle(song: song, opacity: 0.25, radius: 15.0, width: (Double(Int(UIScreen.main.bounds.width / 4))))
                                
                                
                               
                                
                                
                            }
                       
                            
                           
                            
                        }
                        
                       
                       
                    }
                  
                   
                    
                
                
               
              
                
                
            }
            
        }
       
        
      
        
    }
        
}


struct SongRectangle : View {
     var song: Song
    var opacity: Double
    var radius: Double
    var width: Double
    @Environment(LibraryData.self) private var libraryData
    @State var modal = SongModalData()
    var body: some View {
        
        if let artwork = song.artwork {
            NavigationLink {
                SongExpandedView( modal: $modal)
            } label: {
                HStack {
                ArtworkImage(artwork, width: width)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                
                    .shadow(color: .black.opacity(opacity), radius: radius)
                   
                
                
           
                    VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        
                      
                            Text(song.title)
                                .font(.title2)
                            .fontWeight(.bold)
                         
                        
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                       
                        
                        
                        Text(song.artistName)
                            .font(.title3)
                            
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.trailing)
                    Spacer()
                    HStack(alignment: .bottom, spacing: 3) {
                        Text("\(song.playCount ?? 0)")
                            .font(.title)
                            .minimumScaleFactor(0.05)
                            .lineLimit(1)
                            .fontWeight(.semibold)
                        
                        Text("plays")
                            .font(.body)
                            .minimumScaleFactor(0.05)
                            .lineLimit(1)
                            .fontWeight(.regular)
                        
                    }
                    .foregroundStyle(.secondary)
                }
               
            }
                
            
           
                
                
            }
            .padding(.leading)
            .frame(width :UIScreen.main.bounds.width , alignment: .leading  )
            
            
            .onChange(of: libraryData.songs, { oldValue, newValue in
                
                modal  = SongModalData(song: song)
            })
            .task {
                modal = SongModalData(song: song)
            }
           
            
        }
            
       
    }
}
