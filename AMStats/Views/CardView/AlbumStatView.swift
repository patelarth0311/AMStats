import Foundation
import SwiftUI
import MusicKit

struct AlbumStatView : View {

    @Environment(LibraryData.self) private var libraryData
    @Namespace var namespace
 
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 25) {
                    
                    ForEach(Array(libraryData.albums.enumerated())[0...5], id: \.element) { index, album in
                        VStack(spacing: 13) {
                            
                            ZStack(alignment: .trailing) {
                                
                                AlbumRectangle(album: album, opacity: 0.25, radius: 15.0, width: UIScreen.main.bounds.width / 1.5)
                                ForEach(1...3, id: \.self) { item in
                                    if let artwork = album.artwork {
                                        ArtworkImage(artwork, width: UIScreen.main.bounds.width / 1.5)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                        
                                        
                                            .shadow(color: .black.opacity(0.1), radius: 15)
                                        
                                            .overlay {
                                                Color.black.opacity(1.0 - (1.0 - (Double(item) / 3.0)))
                                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                            }
                                        
                                            .offset(x:  Double(item) * 25.0 , y: Double(item) * 25.0)
                                        
                                            .scaleEffect(1.0 -  (Double(item) * 0.1) )
                                            .zIndex(Double(item * -1))
                                        
                                    }
                                    
                                }
                                
                                
                                
                            }
                            Spacer()
                            HStack(alignment: .bottom) {
                                VStack(alignment: .leading) {
                                    Text(album.title)
                                        .font(.title2)
                                    .fontWeight(.bold)
                                 
                                
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    
                                    Text(album.artistName)
                                        .font(.title2)
                                        .minimumScaleFactor(0.05)
                                        .lineLimit(1)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.secondary)
                                }
                              
                         Spacer()
                            }
                            
                        }
                        
                        .frame(width :UIScreen.main.bounds.width / 1.5 )
                        
                        
                    }
                }
                .padding(.trailing, 20)
                .padding(.leading)
                    
                }
          
               
            }
        }
}

struct AlbumRectangle : View {
    var  album: Album
    var opacity: Double
    var radius: Double
    var width: Double
    @Environment(LibraryData.self) private var libraryData
    @State var modal = AlbumModalData()
    var body: some View {
        
        if let artwork = album.artwork {
            NavigationLink {
                AlbumExpandedView(modal: $modal)
            } label: {
                ArtworkImage(artwork, width: width)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                
                    .shadow(color: .black.opacity(opacity), radius: radius)
                   
                
                
                
                
            }
            .onChange(of: libraryData.albums, { oldValue, newValue in
                modal = AlbumModalData(album: album)
            })
            .task {
                modal = AlbumModalData(album: album)
            }
           
            
        }
            
       
    }
}
