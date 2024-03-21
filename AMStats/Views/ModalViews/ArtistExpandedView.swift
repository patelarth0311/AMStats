//
//  ArtistExpandedView.swift
//  Musie
//
//  Created by Arth Patel on 8/22/23.
//

import SwiftUI
import MusicKit

struct ArtistAlbums : View {
    let rows = [GridItem(.flexible(minimum: 0)), GridItem(.flexible(minimum: 0)),GridItem(.flexible(minimum: 0)),GridItem(.flexible(minimum: 0))]
    @Binding var modal: ArtistModalData
    @State var sortToggled = false
    @State var optionChoose : SortOption = .recentlyAdded
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("Albums")
                        .font(.system(.title, weight: .bold))
                    Spacer()
                    Menu {
                        
                        
                        SortOptionButton(contentType: .albums,  optionChoose: $optionChoose, granularity: .specifc, action:
                                            { optionChoose in   modal.sort(sortOption: optionChoose, catalog: .albums)}
                        )
                        .onChange(of: optionChoose) { oldValue, newValue in
                            DispatchQueue.main.async {
                                withAnimation {
                                    sortToggled.toggle()
                                    
                                }
                            }
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                    } label: {
                        
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 20,weight: .medium))
                            .symbolEffect(.bounce.byLayer, value: sortToggled)
                            .foregroundStyle(.pink)
                    }
                }
             
                .padding([.trailing,.leading])
            ScrollView( .horizontal) {
                LazyHGrid(rows: Array(repeating: .init(.flexible()), count: min(modal.albums.count, 4))) {
                    ForEach(modal.albums) { album in
                        
                        
                        AlbumSpecView(album: album,   specBG: .material, hideArrow: false, artworkWidth: 60, showAsList: true)
                            .frame(width: UIScreen.main.bounds.width - 10)
                    }
                    
                }
                .padding(.leading)
            }
        }
            
            HStack {
                
                
                Text("\(modal.albums.count) album\(modal.albums.count > 1 ? "s" : "")")
                
                
            }
            
            
            .font(.system(.subheadline,weight: .semibold))
        }
     
    }
}

struct ArtistSongs : View {
    let rows = [GridItem(.flexible(minimum: 0)), GridItem(.flexible(minimum: 0)),GridItem(.flexible(minimum: 0)),GridItem(.flexible(minimum: 0))]
    @Binding var modal: ArtistModalData
    @State var sortToggled = false

    @State var optionChoose : SortOption = .lastPlayed
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Songs")
                        .font(.system(.title, weight: .bold))
                    Spacer()
                    Menu {
                        
                        
                        SortOptionButton(contentType: .songs,  optionChoose: $optionChoose, granularity: .specifc, action:
                                            { optionChoose in   modal.sort(sortOption: optionChoose, catalog: .songs)}
                        )
                        .onChange(of: optionChoose) { oldValue, newValue in
                            DispatchQueue.main.async {
                                withAnimation {
                                    sortToggled.toggle()
                                    
                                }
                            }
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                    } label: {
                        
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 20,weight: .medium))
                            .symbolEffect(.bounce.byLayer, value: sortToggled)
                            .foregroundStyle(.pink)
                    }
                }
             
                .padding([.trailing,.leading])
                ScrollView( .horizontal) {
                    LazyHGrid(rows: Array(repeating: .init(.flexible()), count: min(modal.songs.count, 4))) {
                        ForEach(modal.songs) { song in
                            
                            SongSpecView(song: song,specBG: .material, hideArrow: false, artworkWidth: 60, showAsList: true)
                                    .frame(width: UIScreen.main.bounds.width - 10)
                            
                            
                            
                       
                        }
                        
                        
                    }
                    
                    .padding(.leading)
                }
        }
         
            HStack {
                
                
                Text("\(modal.songs.count) song\(modal.songs.count > 1 ? "s" : "")")
                
                
            }
            
            
            .font(.system(.subheadline,weight: .semibold))
        }
    }
}



struct ArtistExpandedView: View {


@Binding var modal: ArtistModalData

    @Environment(LibraryData.self) private var libraryData
@State private var playedCount: Double = 0
@State private var minutesListened: Double = 0
@State private var recentlyListened: Date = Date()

@State var sortToggled = false
@Environment(\.dismiss) private var dismiss
@State var selection : ContentType = .songs
var options : [ContentType ] = [.songs, .albums]

@State var optionChoose : SortOption = .recentlyAdded
    @Environment(MusicPlayer.self) private var musicPlayer
    
    
    
var body: some View {
    
    
    if let artist = modal.artist {

        GeometryReader { proxy in
            
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    
                    if let artwork = artist.artwork{
                        
                        ArtworkImage(artwork, width: UIScreen.main.bounds.size.width)
                            .overlay(alignment: .bottomLeading) {
                                ScrollView(.horizontal) {
                                    Text(artist.name)
                                        .font(.system(.largeTitle, weight: .bold))
                                        .minimumScaleFactor(0.005)
                                        .lineLimit(1)
                                    
                                }
                                .frame(width: UIScreen.main.bounds.size.width - 10, alignment: .leading)
                                .padding([.bottom, .leading],5)
                                .foregroundStyle(.white)
                                .scrollIndicators(.hidden)
                            }
                           
                           
                        
                        
                        
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        
                        
                        
                        
                      
                          ArtistSongs(modal: $modal)
                      
                           ArtistAlbums(modal: $modal)
                            
                        
                        
                        
                    }
                   
                    Spacer()
                    
                    VStack {
                        
                        DateView(recentlyListenDate: modal.lastListened, addedDate: artist.libraryAddedDate)
                        
                        
                        
                        VStack(spacing: 10) {
                            
                            Spacer()
                            HStack(alignment: .top) {
                                VStack {
                                    InsightView(title: "Play Count",  number: playedCount)
                                    InsightView(title: "Minutes Listened",  number: minutesListened)
                                }
                                
                                VStack {
                                    HStack {
                                        Text("Contribution %")
                                            .font(.system(.title3,weight: .semibold))
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                    }
                                    VStack(alignment: .center, spacing: 10) {
                                        GaugeCircleView(value: playedCount / libraryData.playCount, color: artist.artwork?.backgroundColor )
                                        
                                        Spacer()
                                        GaugeCircleView(value: minutesListened / libraryData.totalMinutes, color: artist.artwork?.backgroundColor )
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                }
                            }
                            
                        }
                   
                        
                      
                        
                        
                        
                    }
                    .padding([.leading,.trailing])
                    
                    
                   
                }
                .offset(y: proxy.safeAreaInsets.top * -1.0)
                Spacer()
            }
           
            .scrollIndicators(.hidden)
          
            
            .background(Color(red: 0.07, green: 0.07, blue: 0.07))
            
            
            .foregroundStyle(.white)
            
            
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbarRole(.editor)
            
            
            
            
            .onChange(of: modal.loaded, { _, _ in
                
                
                withAnimation(.easeIn) {
                    playedCount = modal.getPlayCount()
                    
                    minutesListened = modal.getMinutesPlayed()
                    
                }
                
                
            })
            
            .task(priority: .high, {
                
                
                
                withAnimation(.easeIn) {
                    playedCount = modal.getPlayCount()
                    
                    minutesListened = modal.getMinutesPlayed()
                    
                }
            })
            
        }
      
       
    }
        
}

}



