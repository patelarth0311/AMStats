//
//  RecommendationsView.swift
//  Musie
//
//  Created by Arth Patel on 9/15/23.
//

import SwiftUI
import MusicKit

extension ApplicationMusicPlayer.Queue.Entry {
    var song : Song? {
        switch self.item {
        case .song(let song):
            return song
        default:
            return nil
        }
    }
}

extension MusicItemCollection<MusicPersonalRecommendation.Item>  {
    
    var itemsArray :  [MusicPersonalRecommendation.Item] {
        return self.map { item in
            return item
        }
    }
    
}

extension MusicPersonalRecommendation.Item {
    
    func getPlayableItem() -> PlayableMusicItem {
        
        switch self {
        case .album(let album):
            return album
        case .playlist(let playlist):
            return playlist
        case .station(let station):
            return station
        }
        
    }
    
}



struct AlbumRecommendationCard : View {
    
    var album: Album
    @State var offset = CGSize.zero
    var index: Int
    @Environment(LibraryData.self) private var libraryData
    var parentIndex: Int
    
    @Binding var recommendation : Recommendation
   
    
    
    
    
    var body: some View {
        
      
            VStack {
                if let artwork =  album.artwork {
                    
                    ArtworkImage(artwork, width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.width - 100)
                } else {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.width - 100)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
           
            .shadow(color: .black.opacity(0.2), radius: 20)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        withAnimation(.smooth) {
                            self.offset = gesture.translation
                        }
                    }
                    .onEnded { _ in
                        
                        if offset.width < -100 {
                            withAnimation(.bouncy) {
                                
                                self.recommendation.items.move(fromOffsets: IndexSet(integer: 0), toOffset:        self.recommendation.items.count )
                                offset = .zero
                            }
                            
                            
                        } else if (offset.width > 100) {
                            withAnimation(.bouncy) {
                                
                                self.recommendation.items.move(fromOffsets: IndexSet(integer: self.recommendation.items.count  - 1), toOffset:        0 )
                                offset = .zero
                            }
                        } else {
                            withAnimation(.bouncy) {
                                offset = .zero
                            }
                        }
                    }
            )
          
            
            .offset(x: abs(offset.width) > 100 ? offset.width : 0.0 , y: Double(index) * 40.0)
            
            .scaleEffect(1.0 -  (Double(index) * 0.1) )
            .zIndex(Double(index * -1))
            
            
            
            
            .transition(.identity)
        
        
        
        
    }
    
}
struct PlaylistRecommendationCard : View {
   
    var playlist : Playlist
    @State var offset = CGSize.zero
    var index: Int
    @Environment(LibraryData.self) private var libraryData
   
    var parentIndex: Int
    @Binding var recommendation : Recommendation
    var body: some View {
      
          
        VStack {
            if let artwork = playlist.artwork {
                ArtworkImage(artwork, width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.width - 100)
            } else {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.width - 100)
            }
        }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            
                    .shadow(color: .black.opacity(0.2), radius: 20)
                    
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                withAnimation(.smooth) {
                                    self.offset = gesture.translation
                                }
                            }
                            .onEnded { _ in
                                
                                if offset.width < -100 {
                                    withAnimation(.bouncy) {
                                        
                                        self.recommendation.items.move(fromOffsets: IndexSet(integer: 0), toOffset:        self.recommendation.items.count )
                                        offset = .zero
                                    }
                                    
                                    
                                } else if (offset.width > 100) {
                                    withAnimation(.bouncy) {
                                        
                                        self.recommendation.items.move(fromOffsets: IndexSet(integer: self.recommendation.items.count  - 1), toOffset:        0 )
                                        offset = .zero
                                    }
                                } else {
                                    withAnimation(.bouncy) {
                                        offset = .zero
                                    }
                                }
                            }
                    )
                    
                    .offset(x: abs(offset.width) > 100 ? offset.width : 0.0 , y: Double(index) * 40.0)
                  
                    .scaleEffect(1.0 -  (Double(index) * 0.1) )
                    .zIndex(Double(index * -1))
            
           
        
      
      
        
      
    }
}

struct StationRecommendationCard : View {
   
    var station: Station
    @State var offset = CGSize.zero
    var index: Int
    @Environment(LibraryData.self) private var libraryData
    var parentIndex: Int
    @Binding var recommendation : Recommendation
    var body: some View {
        
          
        VStack {
            if let artwork = station.artwork {
                ArtworkImage(artwork, width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.width - 100)
                
                
            } else {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.width - 100)
            }
        }
            .clipShape(RoundedRectangle(cornerRadius: 20))
           
            .shadow(color: .black.opacity(0.2), radius: 20)
            .gesture(
                
                DragGesture()
                    .onChanged { gesture in
                        withAnimation(.smooth) {
                            self.offset = gesture.translation
                        }
                    }
                    .onEnded { _ in
                        
                        if offset.width < -100 {
                            withAnimation(.bouncy) {
                                
                                self.recommendation.items.move(fromOffsets: IndexSet(integer: 0), toOffset:        self.recommendation.items.count )
                                offset = .zero
                            }
                            
                            
                        } else if (offset.width > 100) {
                            withAnimation(.bouncy) {
                                
                                self.recommendation.items.move(fromOffsets: IndexSet(integer: self.recommendation.items.count  - 1), toOffset:        0 )
                                offset = .zero
                            }
                        } else {
                            withAnimation(.bouncy) {
                                offset = .zero
                            }
                        }
                    }
            )
            
            .offset(x: abs(offset.width) > 100 ? offset.width : 0.0 , y: Double(index) * 40.0)
          
            .scaleEffect(1.0 -  (Double(index) * 0.1) )
            .zIndex(Double(index * -1))
            
      
       
   
        
      
    }
}

struct ZView : View {
    @State var recommendation : Recommendation
    @Environment(LibraryData.self) private var libraryData
    @Environment(MusicPlayer.self) private var musicPlayer
    init(recommendation: Recommendation) {
        _recommendation = State(initialValue: recommendation)
    }
    @State var bounce = false
    var body: some View {
        ZStack {
            
            
            ForEach(Array(recommendation.items.enumerated()), id: \.element) { index, item in
               
                
                switch item {
                case .album(let album):
                   
                    AlbumRecommendationCard(album: album, index: index, parentIndex: 0, recommendation: $recommendation)
                                
                                
                                
                              
                        
                case .playlist(let playlist):
                    PlaylistRecommendationCard(playlist: playlist, index: index, parentIndex: 0, recommendation: $recommendation)
                       
                        
                
                case .station(let station):
                    StationRecommendationCard(station: station, index: index, parentIndex: 0, recommendation: $recommendation)
                       
                
                }
            }
            
           
            
            
        }
       
        Spacer()
            .padding(.bottom)
        HStack {
            VStack(alignment: .leading) {
                switch recommendation.items[0] {
                case .album(let album):
                    
                    
                    Text(album.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.05)
                    
                        .lineLimit(1)
                    
                    Text(album.artistName)
                        .font(.headline)
                        .minimumScaleFactor(0.05)
                        .lineLimit(1)
                        .fontWeight(.bold)
                    
                    
                    
                case .playlist(let playlist):
                    
                    Text(playlist.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.05)
                    
                        .lineLimit(1)
                    
                    Text(playlist.curatorName ?? "")
                        .font(.headline)
                        .minimumScaleFactor(0.05)
                        .lineLimit(1)
                        .fontWeight(.bold)
                    
                    
                    
                case .station(let station):
                    
                    
                    Text(station.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.05)
                    
                        .lineLimit(1)
                    
                    
                    
                    
                }
            }
            Spacer()
            
            Button(action: {
               
                      
                Task {
                    
                   
                    setNowPlaying(recommendation.items[0].getPlayableItem()) { data in
                        
                        musicPlayer.currentlyPlayingSong = SystemMusicPlayer.shared.queue.currentEntry?.song
                        
                    }
                    
                }
                
                withAnimation(.bouncy) {
                    bounce.toggle()
                }
                
                
            }, label: {
                
               
                   
                    Image(systemName: "play.fill")
                        .font(.title)
                        .symbolEffect(.bounce, value: bounce)
                
                
            })
        }
        .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
    }
}

struct RecommendationsView: View {
    
    @Environment(LibraryData.self) private var libraryData
    @Environment(MusicPlayer.self) private var musicPlayer
    var body: some View {
        
        NavigationStack {
            ScrollView {
                
                VStack(spacing: 30) {
                    Spacer()
                        
                            
                    ForEach(Array(libraryData.recommendations.enumerated()), id: \.element) { parentIndex, recommendation in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(recommendation.recommendation.title ?? "" )
                                    .font(.system(.title,weight: .semibold))
                                Spacer()
                                VStack(spacing: 25) {
                                    
                              ZView(recommendation: recommendation)
                                        
                                }
                                
                                
                            }
                            .padding()
                            .background(.regularMaterial)
                            .transition(.scale)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                           
                           
                        }
                        
                        
                        
                    
                   
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, musicPlayer.currentlyPlayingSong == nil ? 0 : 55)
            }
           
            .background(Color(red: 0.07, green: 0.07, blue: 0.07))
               
                .navigationTitle("Recommendations")
        }
        .scrollIndicators(.hidden)
    }
}

