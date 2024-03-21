//
//  SongExpandedView.swift
//  Musie
//
//  Created by Arth Patel on 8/22/23.
//

import SwiftUI
import MusicKit

import Charts

struct SongExpandedView: View {


@Environment(\.dismiss) private var dismiss
@State private var playedCount: Double = 0
@State private var minutesListened: Double = 0

    @Environment(MusicPlayer.self) private var musicPlayer
    @Environment(LibraryData.self) private var libraryData
    
    
@Binding var modal : SongModalData
var body: some View {
    
    
    if let song = modal.song {

            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    
                    if let artwork = song.artwork {
                        
                        ArtworkImage(artwork, width: UIScreen.main.bounds.size.width - 40)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: .black.opacity(0.25), radius: 20)
                           
                        
                    }
                    
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 2)  {
                            
                            ScrollView(.horizontal) {
                                Text(song.title)
                                    .font(.system(.title, weight: .bold))
                                    .minimumScaleFactor(0.005)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: UIScreen.main.bounds.size.width - 40, alignment: .center)
                            .padding(.bottom)
                            .scrollIndicators(.hidden)
                            
                            if let artists = song.artists {
                                VStack(alignment: .center) {
                                   
                                        
                                    ForEach(artists) { artist in
                                          
                                                ArtistSpecView(artist: artist,  specBG: .material,  hideArrow: false, artworkWidth: 60, showAsList: true)
                                            

                                            
                                        }
                                    
                                    
                                      
                                    
                                     
                                    
                                }
                               
                            }
                            
                            if let albums = song.albums {
                                VStack(alignment: .center) {
                                    ForEach(albums) { album in
                                        
                                        AlbumSpecView(album: album, specBG: .material, hideArrow: false, artworkWidth: 60, showAsList: true)
                                        
                                        
                                        
                                    }
                                }
                                
                            }
                          
                            
                        }
                       
                       
                    }
                   
                    
                    DateView(recentlyListenDate: song.lastPlayedDate, addedDate: song.libraryAddedDate)
                    
                 
                    
                    VStack(spacing: 10) {
                        Spacer()
                        HStack(alignment: .top) {
                            VStack {
                                InsightView(title: "Play Count",  number: playedCount)
                                InsightView(title: "Minutes Listened",  number: minutesListened)
                                Spacer()
                            }
                            
                            VStack {
                                HStack {
                                    Text("Contribution %")
                                        .font(.system(.title3,weight: .semibold))
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                }
                                VStack(alignment: .center, spacing: 10) {
                                    GaugeCircleView(value: playedCount / libraryData.playCount, color: song.artwork?.backgroundColor)
                                    Spacer()
                                    GaugeCircleView(value: minutesListened / libraryData.totalMinutes, color: song.artwork?.backgroundColor)
                                 
                                }
                               
                                
                                Spacer()
                             
                                
                            }
                        }
                       
                       
                     
                        
                        Spacer()
                        
                        
                      
                        
                        if let songEntry = libraryData.realm.objects(SongListened.self).filter(NSPredicate(format: "musicId == %@", song.id.rawValue )).first {
                            VStack(alignment: .leading) {
                               
                                Text("Totals Plays over Time")
                                    .font(.system(.title3,weight: .semibold))
                                    .foregroundStyle(.secondary)
                                    
                                Chart( songEntry.playsOverTime) { item in
                                    LineMark(x: .value("Time", item.date, unit: .day), y: .value("playCount", item.playCount))
                                       
                                        .foregroundStyle(Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
                                    
                                        .lineStyle(StrokeStyle(lineWidth: 2))
                                    
                                    AreaMark(
                                        x: .value("Time", item.date, unit: .day),
                                        yStart: .value("playStart", 0),
                                        // get the max close value or adjust to your use case
                                        
                                        yEnd: .value("playEnd", item.playCount)
                                    )
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient (
                                                colors: [
                                                    Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).opacity(0.5),
                                                    Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).opacity(0.2),
                                                    Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).opacity(0.05),
                                                ]
                                            ),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                }
                                .frame(minHeight: 300)
                                .chartYScale(domain: 0...song.playCount! + 100)
                              
                              
                                
                               
                            }
                            .padding()
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                          
                            VStack(alignment: .leading) {
                                Text("Total Minutes Listened over Time")
                                    .font(.system(.title3,weight: .semibold))
                                    .foregroundStyle(.secondary)
                                Chart( songEntry.playsOverTime) { item in
                                    LineMark(x: .value("Time", item.date, unit: .day), y: .value("playCount", item.minutesListened))
                                        
                                        .foregroundStyle(Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
                                    
                                        .lineStyle(StrokeStyle(lineWidth: 2))
                                    
                                    AreaMark(
                                        x: .value("Time", item.date, unit: .day),
                                        yStart: .value("playStart", 0),
                                        // get the max close value or adjust to your use case
                                        
                                        yEnd: .value("playEnd", item.minutesListened)
                                    )
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient (
                                                colors: [
                                                    Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).opacity(0.5),
                                                    Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).opacity(0.2),
                                                    Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).opacity(0.05),
                                                ]
                                            ),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                }
                                .frame(minHeight: 300)
                                .chartYScale(domain: 0...Int(  Double(song.playCount ?? 0) * ((song.duration ?? TimeInterval())/60.0)) + 100)
                                
                                
                               
                            
                               
                               
                            }
                            .padding()
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                       
                        
                      
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    Spacer()
                }
                
                .padding([.leading,.trailing])
                .padding(.bottom, musicPlayer.currentlyPlayingSong == nil ? 0 : 55)
                Spacer()
            }
       
            
            .scrollIndicators(.hidden)
           
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
         
        
          .background(Color(red: 0.07, green: 0.07, blue: 0.07))
          
            .foregroundStyle(.white)
          
          
            
          
          
            .onChange(of: modal.loaded, { _, _ in
                
                
                    withAnimation(.easeIn) {
                        playedCount = modal.getPlayCount()
                        minutesListened =  modal.getMinutesPlayed()
                       
                    }
                   
               
            })
          
            .task(priority: .high, {
              
                withAnimation(.easeIn) {
                   
                    playedCount = modal.getPlayCount()
                    minutesListened =  modal.getMinutesPlayed()
                  
                }
            })
            
            
            
           
          
            
 
        
    }
        
}

}


struct GaugeCircleView : View {

    var value : Double
    var color: CGColor?
    var body: some View {
        VStack {
            Circle()
                .stroke(lineWidth: 10)
            
                .frame(width: 100, height: 100)
                .foregroundStyle(.ultraThinMaterial)
                .overlay {
                    Circle()
                        .trim(from: 0, to: (value))
                        .stroke(Color(color ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)) , style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    HStack(spacing: 0) {
                        Spacer()
                        Text(String(format: "%.2f", value * 100.0))
                            .font(.system(size: 30, weight: .bold))
                            .minimumScaleFactor(0.05)
                            .lineLimit(1)
                        Spacer()
                        
                    }
                    
                    
                }
        }
    }
}


