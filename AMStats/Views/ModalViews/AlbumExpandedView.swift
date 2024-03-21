//
//  MediaExpandedView.swift
//  Musie
//
//  Created by Arth Patel on 8/14/23.
//

import SwiftUI
import MusicKit
import UIKit




struct AlbumExpandedView: View {
@Binding var modal: AlbumModalData
@State private var playedCount: Double = 0.0
@State private var minutesListened: Double = 0.0

@Environment(LibraryData.self) private var libraryData
    @Environment(MusicPlayer.self) private var musicPlayer

@State var sortToggled = false
@Environment(\.dismiss) private var dismiss
@State var optionChoose : SortOption = .recentlyAdded

    
var body: some View {
    

        if let album = modal.album {
        
            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer()
                        if let artwork = album.artwork {
                            
                            ArtworkImage(artwork, width: UIScreen.main.bounds.size.width - 40)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: .black.opacity(0.25), radius: 20)
                            
                        }
                
                        
                        VStack(alignment: .leading, spacing: 2) {
                          
                            
                            ScrollView(.horizontal) {
                                Text(album.title)
                                    .font(.system(.title, weight: .bold))
                                    .minimumScaleFactor(0.005)
                                    .lineLimit(1)
                            }
                            .frame(width: UIScreen.main.bounds.size.width - 40, alignment: .leading)
                            .padding(.bottom)
                            .scrollIndicators(.hidden)
                            
                            
                            
                            ForEach(modal.artists) { artist in
                                
                                ArtistSpecView(artist: artist,  specBG: .material, hideArrow: false, artworkWidth: 60, showAsList: true)
                                
                                
                                
                            }
                        }
                       
                      
                       
                        
                  
                        
                        
                   
                            
                            
                               
                                
                            
                            
                    
                    DateView(recentlyListenDate: album.lastPlayedDate, addedDate: album.libraryAddedDate)
                    
                    

                    
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 0) {
                        
                        ForEach(modal.songs) { song in
                            
                            SongSpecView(song: song,  specBG: .material, hideArrow: false, artworkWidth: 60, showAsList: true)
                            
                        }
                        
                        
                        
                        
                        HStack {
                            
                            
                            Text("\(modal.songs.count) song\(modal.songs.count > 1 ? "s" : "")")
                            
                            
                        }
                        
                        
                        .font(.system(.subheadline,weight: .semibold))
                    }
                    
                   
                    
                    
                    
                    
                                VStack(spacing: 10) {
                                    Spacer()
                                    HStack(alignment: .top) {
                                        VStack {
                                            InsightView(title: "Play Count",  number: playedCount)
                                            InsightView(title: "Minutes Listened", number: minutesListened)
                                        }
                                        
                                        VStack {
                                            HStack {
                                                Text("Contribution %")
                                                    .font(.system(.title3,weight: .semibold))
                                                    .foregroundStyle(.secondary)
                                                Spacer()
                                            }
                                            VStack(alignment: .center, spacing: 10) {
                                                
                                                GaugeCircleView(value: playedCount / libraryData.playCount, color: album.artwork?.backgroundColor)
                                                Spacer()
                                                GaugeCircleView(value: minutesListened / libraryData.totalMinutes, color: album.artwork?.backgroundColor)
                                            }
                                            
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                    
                    
                               
                
                        Spacer()
                        }
                    .padding([.leading,.trailing])
                   
            .padding(.bottom, musicPlayer.currentlyPlayingSong == nil ? 0 : 55)
                    Spacer()
                   
                }
                .scrollIndicators(.hidden)
                
              
                .background(Color(red: 0.07, green: 0.07, blue: 0.07))
                
                .foregroundStyle(.white)
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
                
                
                
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                
                .toolbarRole(.editor)
                
                .toolbar {
                    
                    
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            SortOptionButton(contentType: .songs,  optionChoose: $optionChoose, granularity: .specifc, action:
                                                { optionChoose in     modal.sort(sortOption: optionChoose) }
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
                }
                
                
            }
            
            
            
            
            
            
            
    }
}


}











