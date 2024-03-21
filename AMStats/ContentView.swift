//
//  ContentView.swift
//  Musie
//
//  Created by Arth Patel on 8/10/23.
//

import SwiftUI
import MusicKit


enum AppView  {
    case home
    case insight
    case recommendations
    
    
    var icon : String {
        switch self {
        case .home:
            return "music.note.house"
        case .insight:
            return "chart.bar"
        case .recommendations:
            return "square.stack"
        }
    }
}

struct CustomToolBar: View {
    @Binding var selection : AppView
    var options : [AppView] = [.home, .insight, .recommendations]
   
    var body: some View {
        HStack(alignment: .center) {
            ForEach(options, id: \.self) { item in
                
                Spacer()
                
                Button(action: {
                    selection = item
                }, label: {
                    Image(systemName: item.icon)
                        .font(.title2)
                })
                .padding(.top)
             
                Spacer()
            }
           
        }
        
        .background {
            ZStack {
                VStack {
                    
                }
                .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity

                    )
                .background(.thinMaterial)
                
                VStack{
                    
                }
                .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity

                    )
                .background(.black.opacity(0.5))
            }
            .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity

                )
        }
       
       
        
        
    }
    
}


struct ContentView: View {

    @State var expand = false

    @Namespace var namespace
    @State var selection : AppView = .home
@Environment(LibraryData.self) private var libraryData
    @Environment(MusicPlayer.self) private var musicPlayer
    
    
    var body: some View {
        
        
       
            TabView(selection: $selection) {
                  
                Group {
                    LibraryStatView()
                        .tag(AppView.home)
                        
                        
                    
                    InsightsView()
                        .tag(AppView.insight)
                    
                    RecommendationsView()
                        .tag(AppView.recommendations)
                    
                    
                }
              
           
            }
            
           
            
            .overlay(alignment: .bottom) {
               
                Group {
                    if expand, let song =  musicPlayer.currentlyPlayingSong {
                        CurrentlyPlayingExpandedView(expand: $expand, id: namespace, currentPlayingSong: song)
                    } else {
                        VStack(spacing: 0) {
                            if !expand, let song = musicPlayer.currentlyPlayingSong {
                                Spacer()
                                CurrentlyPlayingWidget(expand: $expand, id:  namespace, currentPlayingSong: song)
                                
                            }
                            CustomToolBar(selection: $selection)
                        }
                       
                    }
                    
                }
                .ignoresSafeArea(.keyboard)
                    
                        
                    
                    
             
                   
                
            }
            
}

}

enum Selection {
    case overview
    case top
}

struct BottomBar : View {
    
    @Binding var selection : Selection
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            Button {
                withAnimation(.spring) {
                    selection = .overview
                }
                
            } label: {
                Image(systemName: "music.note")
                    .font(.system(size: 20))
                    .padding()
                    .foregroundStyle(selection == .overview ? .pink : .secondary)
                
                    .scaleEffect(selection == .overview ? 1.2 : 1)
            }
            
            Spacer()
            
            Button {
                withAnimation(.spring) {
                    selection = .top
                }
                
            } label: {
                
                Image(systemName: "music.quarternote.3")
                    .font(.system(size: 20))
                    .padding()
                    .foregroundStyle(selection == .top ? .pink : .secondary)
                    .scaleEffect(selection == .top ? 1.2 : 1)
                
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.ultraThickMaterial)
        .cornerRadius(50)
    
}
    
}
