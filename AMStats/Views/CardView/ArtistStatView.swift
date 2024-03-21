    //
    //  ArtistStatView.swift
    //  Musie
    //
    //  Created by Arth Patel on 8/26/23.
    //

    import Foundation
    import MusicKit
    import SwiftUI

    struct ArtistStatView : View {
      
        @Environment(LibraryData.self) private var libraryData
        @Namespace var namespace
     
        var body: some View {
            VStack(alignment: .leading, spacing: 3) {
                
          
                if (libraryData.artists.count > 0) {
                    
               
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: Array(repeating: .init(.flexible()), count: min(libraryData.artists.count, 4)),spacing: 10) {
                                
                                
                                ForEach(Array(libraryData.artists.enumerated())[0...19], id: \.element) { index, artist in
                             
                                    ArtistRectangle(artist: artist, opacity: 0.25, radius: 20.0, width:  (Double(Int(UIScreen.main.bounds.width / 4))))
                                        
                                    
                                     
                                    
                                    
                                }
                                
                               
                                
                            }
                            
                           
                        }
                      
                       
                        
                    
                    
                   
                  
                    
                    
                }
                
            }
           
            
          
            
        }
            
    }


struct ArtistRectangle : View {
    var artist: Artist
    var opacity: Double
    var radius: Double
    var width: Double
    @Environment(LibraryData.self) private var libraryData
    @State var modal = ArtistModalData()
    var body: some View {
        
        if let artwork = artist.artwork {
            NavigationLink {
                ArtistExpandedView(modal: $modal)
            } label: {
                
                HStack {
                    ArtworkImage(artwork, width: width)
                        .clipShape(Circle())
                    
                    
                    
                    
                    
                    
                    Text(artist.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                        .lineLimit(1)
                     
                }
                
            }
            .padding(.leading)
            .frame(width :UIScreen.main.bounds.width, alignment: .leading  )
            .onChange(of: libraryData.artists, { oldValue, newValue in
                modal = ArtistModalData(artist: artist)
            })
            .task {
                modal  = ArtistModalData(artist: artist)
            }
           
            
        }
            
       
    }
}
