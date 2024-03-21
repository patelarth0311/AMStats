//
//  TopView.swift
//  Musie
//
//  Created by Arth Patel on 8/10/23.
//

import SwiftUI
import MusicKit

struct TopView: View {

    @State var toggle = false
    @Environment(LibraryData.self) private var libraryData
 
  
    @Namespace var namespace
    
    


    
    var body: some View {
      
        VStack(spacing: 15) {
                
                
                   
                    TopStatView(title: "Songs", contentType: .songs)
               
                            
                    TopStatView(title: "Albums",   contentType: .albums)
                           
                 
                    TopStatView(title: "Artists",    contentType: .artists)
               
            }
           
            .background(Color(red: 0.07, green: 0.07, blue: 0.07))
            
           
          
          
        
        
    
    }
}



struct TopStatView: View {
    var title: String
   
    @State var toggle = false
    @Environment(LibraryData.self) private var libraryData
   
    var contentType : ContentType
 
    @State var optionChoose : SortOption  = .title
    @State var sortToggled : Bool = false
  
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .bottom)  {
                
                switch contentType {
                case .songs:
                    StatView(number: Double(libraryData.songs.count), title: title)
                case .artists:
                    StatView(number: Double(libraryData.artists.count), title: title)
                case .albums:
                    StatView(number: Double(libraryData.albums.count), title: title)
                }
               
                Spacer()
                
                VStack(alignment: .center) {
                    Menu {
                        SortOptionButton(contentType: contentType, optionChoose: $optionChoose, granularity: .generic, action:
                                            { optionChoose in  libraryData.sort(contentType: contentType, optionChoose: optionChoose)}
                        
                        )
                            .onChange(of: optionChoose) { oldValue, newValue in
                                DispatchQueue.main.async {
                                    withAnimation {
                                        sortToggled.toggle()
                                        
                                    }
                                }
                              
                            }
                            .onChange(of: libraryData.refresh) { oldValue, newValue in
                                optionChoose = .title
                            }
                           
                    } label: {
                        
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 25,weight: .medium))
                            .symbolEffect(.bounce.byLayer, value: sortToggled)
                            .foregroundStyle(.pink)
                        
                    }
                    
                    Spacer()
                    NavigationLink {
                        DetailedStatView(  contentType: contentType, optionChoose: $optionChoose)
                           
                    } label: {
                        
                     
                        Image(systemName: "arrow.forward.circle")
                            .font(.system(size: 25,weight: .medium))
                            .foregroundStyle(.pink)
                          
                    }
                }
               
                
            }
            .padding(.trailing)
                        
                            
                                
                                switch contentType {
                                case .songs:
                                    
                                   SongStatView()
                               
                                  
                                    
                                case .artists:
                                    
                                    ArtistStatView()

                                    
                                   
                                  
                                case .albums:
                                    
                                   AlbumStatView()

                                    
                                }
                
        }
       
        .padding(.bottom, 30)
        
    
        
        
    }
}




struct SortOptionButton: View {
    var contentType : ContentType

    @Binding var optionChoose : SortOption
    var granularity: Granularity
    var action : (_ optionChoose : SortOption) -> Void
   
    var body: some View {
        
        Picker(selection: $optionChoose) {
            ForEach(contentType.filterOption(gran: granularity),id: \.self) { option in
                
                Text(option.rawValue)
                   
                }
        } label: {
           Text("")
        }
        .onChange(of: optionChoose) { oldValue, newValue in
            DispatchQueue.main.async {
                self.action(optionChoose)
                
               
            }
        }
       
        
    }
}




