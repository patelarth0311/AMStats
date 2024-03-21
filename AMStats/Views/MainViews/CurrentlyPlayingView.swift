//
//  CurrentlyPlayingView.swift
//  Musie
//
//  Created by Arth Patel on 9/18/23.
//

import SwiftUI
import MusicKit
import Combine

struct CurrentlyPlayingWidget: View {
    @Binding var expand : Bool
    var id: Namespace.ID
    @Environment(LibraryData.self) private var libraryData
    var currentPlayingSong : Song
    @Environment(MusicPlayer.self) private var musicPlayer
    var body: some View {
        HStack(alignment: .center ){
            if let artwork = currentPlayingSong.artwork {
                
                ArtworkImage(artwork, width: 45)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                   
                   
                    .shadow(color: .black.opacity(0.3), radius: 7)
                    .padding( 5)
                    .matchedGeometryEffect(id: "player", in: id)
                   
                
            }
               
                
            Text(currentPlayingSong.title)
                .fontWeight(.bold)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer()
            Button(action: {
               
                if (   self.musicPlayer.timerSubscription != nil) {
                    self.musicPlayer.pause()
                } else {
                    
                    self.musicPlayer.play()
                   
                    
                }
                   
                    
                
                
            }, label: {
                Image(systemName: self.musicPlayer.timerSubscription == nil ? "play.fill" : "pause.fill")
                    .symbolEffect(.bounce, value: expand)
                    .font(.title2)
                
            })
            .padding(.horizontal,15)
            
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      
        .padding(.horizontal,6)
        
        .matchedGeometryEffect(id: "bg", in: id)
      

        .onTapGesture {
            withAnimation(.smooth) {
                expand.toggle()
            }
           
        }
    }
}


struct PlayerButtonView: View {
    var action : () -> Void
    var imageName: String
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: imageName)
        })
    }
}

struct PlayerBackground : ViewModifier {
    var id: Namespace.ID

    @Environment(MusicPlayer.self) private var musicPlayer
    
    var currentPlayingSong : Song
    
   
    func adjustBgAttributes(width: CGFloat) -> Void {
        DispatchQueue.main.async {
            self.musicPlayer.width = width
            self.musicPlayer.total = width -  UIScreen.main.bounds.width
            self.musicPlayer.interval = SystemMusicPlayer.shared.playbackTime
            if let song = musicPlayer.currentlyPlayingSong {
                
                if let duration = song.duration {
                    
                    self.musicPlayer.offsetX = (self.musicPlayer.total / (duration)) * SystemMusicPlayer.shared.playbackTime
                  
                }
                
            }
        }
    }
    
    
    func adjustProgressBar() -> Void {
        DispatchQueue.main.async {
            
            if let song = musicPlayer.currentlyPlayingSong {
                
                if let duration = song.duration {
                    
                    self.musicPlayer.interval = SystemMusicPlayer.shared.playbackTime
                  
                    
                    self.musicPlayer.offsetX = (self.musicPlayer.total / (duration)) * SystemMusicPlayer.shared.playbackTime
                    
                }
            }
            
        }
    }
    
  
    
    func body(content: Content) -> some View {
       
            return content
                .background(
                 
                        ScrollView(.horizontal) {
                            HStack {
                                
                                if let artwork = currentPlayingSong.artwork {
                                    
                                    
                                    ArtworkImage(artwork, height: UIScreen.main.bounds.height )
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                        
                                        .offset(x:  musicPlayer.offsetX * -1)
                                        .animation(.easeInOut(duration: 0.5),  value: self.musicPlayer.offsetX)
                                    
                                    
                                }
                                
                                
                                
                                
                            }
                            .background( GeometryReader { proxy in
                                
                                VStack {
                                    
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.regularMaterial)
                                
                                .task {
                                    
                                    adjustBgAttributes(width: proxy.size.width)
                                    
                                    
                                    
                                }
                                .onChange(of: SystemMusicPlayer.shared.queue.currentEntry, { oldValue, newValue in
                                 
                                    adjustBgAttributes(width: proxy.size.width)
                                })
                            })
                            
                            .onReceive(self.musicPlayer.timer, perform: { input in
                               adjustProgressBar()
                            })
                        }
                        .scrollIndicators(.hidden)
                        
                        .scrollDisabled(true)
                        
                        
                )
        
       
      
    }
    
    
}

extension View {
    func playerBg(id: Namespace.ID, currentPlayingSong: Song) -> some View {
        modifier(PlayerBackground(id: id, currentPlayingSong: currentPlayingSong))
          
    }
}


struct CurrentlyPlayingExpandedView : View {
    @Binding var expand : Bool
    var id: Namespace.ID

    @Environment(LibraryData.self) private var libraryData
    
    @Environment(MusicPlayer.self) private var musicPlayer
    @State var offset = CGSize.zero
    
 

    
    
    var currentPlayingSong : Song
    var formatter : DateComponentsFormatter  {
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
         
        return formatter
    }
    
    var time : String {
        let formattedTime =   formatter.string(from: self.musicPlayer.interval )
        return formattedTime!.hasPrefix("0") ? String(formattedTime!.dropFirst()) : formattedTime!
    }
    
    var timeRemaining : String {
  
        if let song = musicPlayer.currentlyPlayingSong {
            let formattedTime =   formatter.string(from: (song.duration! - self.musicPlayer.interval  ))
            return formattedTime!.hasPrefix("0") ? String(formattedTime!.dropFirst()) : formattedTime!
        }
            return ""
    }
    
    
   
    
    var body: some View {
        GeometryReader { reader in
            
            
            ZStack(alignment: .bottom) {
                
            
                    Button {
                        withAnimation(.smooth) {
                            expand = false
                        }
                      
                    } label: {
                        Image(systemName: "arrow.down.circle.fill")
                           
                            .font(.largeTitle)
                    }
                    .foregroundStyle(.ultraThinMaterial)
        
                .offset(y: reader.safeAreaInsets.top)
               
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
               
                
                
                VStack(alignment: .leading, spacing: 11) {
                    
                
                    
                    VStack(spacing: 11) {
                       
                        
                        HStack(spacing: 16) {
                            if let artwork = currentPlayingSong.artwork {
                                
                                ArtworkImage(artwork, width: 65 )
                                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                   
                                    .shadow(color: .black.opacity(0.32), radius: 7)
                                
                                    .matchedGeometryEffect(id: "player", in: id)
                                
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 1)  {
                                
                                
                                ScrollView(.horizontal) {
                                    Text(currentPlayingSong.title)
                                        .font(.system(size: 15,weight: .bold))
                                        .minimumScaleFactor(0.005)
                                        .lineLimit(1)
                                }
                               
                                .scrollIndicators(.hidden)
                              
                                
                                
                                Text(currentPlayingSong.artistName)
                                    .font(.system(size: 15,weight: .medium))
                                    .foregroundStyle(.secondary)
                                    .minimumScaleFactor(0.005)
                                    .lineLimit(1)
                                
                                    
                            }
                           
                            
                        }
                      
                      
                        
                       
                       
                       
                        HStack(alignment: .center,spacing: 5) {
                           
                            Text(time)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            ProgressView(value:  self.musicPlayer.interval , total:  currentPlayingSong.duration ?? TimeInterval())
                            .animation(.easeInOut,  value: self.musicPlayer.interval)
                            .tint(.primary)
                            .animation(.smooth(duration: 0.5), value: self.musicPlayer.interval)
                            
                            Text("-\(timeRemaining)")
                            
                            .font(.headline)
                            .foregroundStyle(.primary)
                        }
                     
                       
                      
                        
                           
                        
                        HStack(alignment: .center, spacing: 5) {
                            Spacer()
                            PlayerButtonView(action: {
                                self.musicPlayer.backward()
                                
                            }, imageName: "backward.fill")
                            .font(.system(size: 25,weight: .bold))
                            Spacer()
                            PlayerButtonView(action: {
                                
                                        if (   self.musicPlayer.timerSubscription != nil) {
                                            self.musicPlayer.pause()
                                        } else {
                                            
                                            self.musicPlayer.play()
                                           
                                            
                                        }
                                    
                                   
                                
                                
                                
                            }, imageName:  self.musicPlayer.timerSubscription == nil ? "play.fill" : "pause.fill")
                            .font(.system(size: 33,weight: .bold))
                            .contentTransition(.symbolEffect(.replace.downUp))
                           
                            Spacer()
                            PlayerButtonView(action: {
                                
                                self.musicPlayer.skip()
                                
                            }, imageName: "forward.fill")
                            .font(.system(size: 25,weight: .bold))
                            Spacer()
                        }
                        .padding(.bottom,5)
                        
                        .foregroundStyle(.primary)
                        
                        .fixedSize()
                        
                    }
                    
                }
                .padding(20)
                
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 44,style: .continuous))
                .matchedGeometryEffect(id: "bg", in:  id)
              
                
            }
            .padding(.bottom, 55)
            .padding(.horizontal)
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .playerBg(id: self.id, currentPlayingSong:  currentPlayingSong )
            .environment(musicPlayer)
                        
            
            .clipShape(RoundedRectangle(cornerRadius: 40))
           
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        DispatchQueue.main.async {
                            withAnimation(.smooth) {
                                
                                
                                if (offset.height) < 200 && (offset.height) >= 0  {
                                    self.offset = gesture.translation
                                } else if (offset.height) > 200 {
                                    
                                    expand = false
                                    offset = .zero
                                    
                                    
                                    
                                    
                                } else {
                                    
                                    offset = .zero
                                }
                            }
                        }
                    }
                
                    .onEnded { _ in
                        DispatchQueue.main.async {
                            withAnimation(.smooth) {
                                if (self.offset.height) > 200 {
                                    
                                    self.expand = false
                                    self.offset = .zero
                                    
                                    
                                    
                                    
                                } else {
                                    
                                    self.offset = .zero
                                }
                                
                            }
                        }
                        
                    }
            )
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            .offset(y: (self.offset.height) < 200 && (self.offset.height) >= 0 ? self.offset.height : 0.0)
            
        }
       
   
    }
}

