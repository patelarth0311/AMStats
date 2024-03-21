//
//  SpecView.swift
//  Musie
//
//  Created by Arth Patel on 8/10/23.
//

import SwiftUI
import MusicKit
import UIKit

enum SpecBG {
case avgColor
case material
}
import MediaPlayer


func conditionalStack<Content: View>(isHorizontal: Bool, @ViewBuilder content: () -> Content) -> some View {
    Group {
        if isHorizontal {
            HStack(alignment: .center, content: content)
        } else {
            VStack(alignment: .leading, content: content)
        }
    }
}

struct SongSpecView: View {


var song: MusicKit.Song
    

    @Environment(LibraryData.self) private var libraryDataa
var specBG : SpecBG
    @State var modal = SongModalData()

var hideArrow : Bool
    var artworkWidth: CGFloat
    var showAsList: Bool

var body: some View {

    ZStack {
        
        if hideArrow {
            HStack(alignment: .center) {
                if let artwork = song.artwork {
                    
                    ArtworkImage(artwork, width:  artworkWidth)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                       
                       
                        .shadow(color: .black.opacity(0.3), radius: 7)
                    
                    
                    
                }
                VStack(alignment: .leading)  {
                   
                        Text(song.title)
                            .font(.system(size:  14,weight: .bold))
                    
                    Group {
                        Text(song.artistName)
                            .font(.system(size:  12,weight: .medium))
                        Spacer()
                        
                        HStack(alignment: .bottom, spacing: 3) {
                            Text("\(song.playCount ?? 0)")
                                .font(.system(size:  13,weight: .semibold))
                            Text("plays")
                                .font(.system(size: 11,weight: .regular))
                        }
                    }
                    .foregroundStyle(.secondary)
                }
                .lineLimit(1)
                .truncationMode(.tail)
               
                
                
                Spacer()
                
            }
            NavigationLink("", destination: SongExpandedView( modal: $modal)).opacity(0)
        } else {
            NavigationLink {
                SongExpandedView( modal: $modal)
            } label: {
                
                conditionalStack(isHorizontal: showAsList) {
                    if let artwork = song.artwork {
                        
                        ArtworkImage(artwork, width: artworkWidth)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                           
                           
                            .shadow(color: .black.opacity(0.3), radius: 7)
                           
                        
                        
                    }
                    
                    VStack(alignment: .leading)  {
                       
                            Text(song.title)
                                .font(.system(size:  14,weight: .bold))
                        
                        Group {
                           
                            Spacer()
                            
                            HStack(alignment: .bottom, spacing: 3) {
                                Text("\(song.playCount ?? 0)")
                                    .font(.system(size:  13,weight: .semibold))
                                Text("plays")
                                    .font(.system(size: 11,weight: .regular))
                            }
                        }
                        .foregroundStyle(.secondary)
                    }
                    .if(showAsList == false, transform: { view in
                        view
                         .frame(width: artworkWidth, alignment: .leading)
                    })
                    .lineLimit(1)
                    .truncationMode(.tail)
                    Spacer()
                }

            }

        }
      
    }
    
    
        .musicItemCardStyle(specBG: specBG, color: Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
        
        .task {
            modal = SongModalData(song: song)
        }
    }

}

struct ArtistSpecView: View {
    
var artist: MusicKit.Artist


var specBG : SpecBG
    @Environment(LibraryData.self) private var libraryData
    @State var modal = ArtistModalData()
    var hideArrow : Bool
    var artworkWidth: CGFloat
    var showAsList: Bool
var body: some View {
    ZStack {
        
        if hideArrow {
            HStack {
                if let artwork = artist.artwork {
                    ArtworkImage(artwork, width:  artworkWidth)
                        .clipShape(Circle())
                    
                    
                    
                        .shadow(color: .black.opacity(0.3), radius: 7)
                       
                }
                VStack(alignment: .leading)  {
                    Text(artist.name)
                        .font(.system(size: 14,weight: .bold))
                    
                }
                .lineLimit(1)
                .truncationMode(.tail)
                Spacer()
                
            }
            NavigationLink("", destination: ArtistExpandedView(modal: $modal)).opacity(0)
            
        } else {
            NavigationLink {
                ArtistExpandedView(modal: $modal)
            } label: {
                conditionalStack(isHorizontal: showAsList) {
                    if let artwork = artist.artwork {
                        ArtworkImage(artwork, width:  artworkWidth)
                            .clipShape(Circle())
                        
                        
                        
                            .shadow(color: .black.opacity(0.3), radius: 7)
                            
                    }
                    VStack(alignment: .leading)  {
                        Text(artist.name)
                            .font(.system(size: 15,weight: .bold))
                        
                    }
                    .if(showAsList == false, transform: { view in
                        view
                         .frame(width: artworkWidth, alignment: .leading)
                    })
                    .lineLimit(1)
                    .truncationMode(.tail)
                    Spacer()
                }
            }

        }
    
    }
    
    .musicItemCardStyle(specBG: specBG, color: Color(artist.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
    .task {
    modal = ArtistModalData(artist: artist)
       
    }
    

    }


}

struct AlbumSpecView: View {
var album: MusicKit.Album

var specBG : SpecBG
    @Environment(LibraryData.self) private var libraryData
@State var modal = AlbumModalData()
    var hideArrow : Bool
    var artworkWidth: CGFloat
    var showAsList: Bool
var body: some View {
    
    ZStack {
        if hideArrow {
            HStack {
                if let artwork = album.artwork {
                    ArtworkImage(artwork, width:  artworkWidth)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                      
                        
                        .shadow(color: .black.opacity(0.3), radius: 7)
                       
                }
                VStack(alignment: .leading)  {
                    Text(album.title)
                    .font(.system(size: 14,weight: .bold))
                    Group {
                        Text(album.artistName)
                            .font(.system(size: 12,weight: .semibold))
                        Spacer()
                        HStack(alignment: .bottom, spacing: 3) {
                            Text("\(album.trackCount)")
                                .font(.system(size: 13,weight: .medium))
                            Text("songs")
                                .font(.system(size: 11,weight: .regular))
                        }
                    }
                    .foregroundStyle(.secondary)
                  
                }  
               
                .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer()
               
       
            }
            NavigationLink("", destination: AlbumExpandedView(modal: $modal)).opacity(0)
        } else {
            NavigationLink {
                AlbumExpandedView(modal: $modal)
            } label: {
                conditionalStack(isHorizontal: showAsList) {
                    if let artwork = album.artwork {
                        ArtworkImage(artwork, width:  artworkWidth)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                          
                            
                            .shadow(color: .black.opacity(0.3), radius: 7)
                            
                    }
                    VStack(alignment: .leading)  {
                        Text(album.title)
                        .font(.system(size: 14,weight: .bold))
                        Group {
                            Spacer()
                            HStack(alignment: .bottom, spacing: 3) {
                                Text("\(album.trackCount)")
                                    .font(.system(size: 13,weight: .medium))
                                Text("songs")
                                    .font(.system(size: 11,weight: .regular))
                            }
                        }
                        .foregroundStyle(.secondary)
                      
                    }
                    .if(showAsList == false, transform: { view in
                        view
                         .frame(width: artworkWidth, alignment: .leading)
                    })
                    .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                }
                
            }

        }
      
        
    }

        .musicItemCardStyle(specBG: specBG, color: Color(album.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
      
        .task {
            modal = AlbumModalData(album: album)
           
        }
     
    }


    

}

