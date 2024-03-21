    //
    //  DetailedStatView.swift
    //  Musie
    //
    //  Created by Arth Patel on 8/10/23.
    //

    import SwiftUI
    import MusicKit



struct DetailedStatView: View {

        @State var expand = false
    @Environment(LibraryData.self) private var libraryData

        var contentType: ContentType
        @Binding var optionChoose : SortOption 
        @State var sortToggled : Bool = false
        @State var engaged = false
          
        @State var  query : String = ""
        
        
        @State var songs = MusicItemCollection<MusicKit.Song>()
        @State var albums = MusicItemCollection<MusicKit.Album>()
        @State var artists = MusicItemCollection<MusicKit.Artist>()

       @State var toggle = false
    @State var viewingOption: ViewingOptions = .List
    @State var viewingToggled = false
        
        
        var body: some View {
        
            GeometryReader { reader in
                
            VStack {
              
                    
                    
                switch contentType {
                case .songs:
                    
                    if (viewingOption == .List) {
                        List {
                            ForEach(engaged ?  libraryData.querysongs : libraryData.songs) { song in
                                SongSpecView(song: song, specBG: .material, hideArrow: true, artworkWidth: 60 , showAsList: true)

                                   
                                
                            }
                        }
                    } else {
                        ScrollView {
                    
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: (reader.size.width / 4) ))],alignment: .center, spacing: 0) {
                                ForEach(engaged ?  libraryData.querysongs : libraryData.songs) { song in
                                   
                                    SongSpecView(song: song, specBG: .material, hideArrow: false, artworkWidth: ((reader.size.width) / 3) - 25 , showAsList: false)
                                    
                                       
                      
                                }
                            }
                        }
                    }
                 
                   
                  
                    
                   
                   
                    
                case .artists:
                    
                    if (viewingOption == .List) {
                        List {
                            ForEach(engaged ? libraryData.queryartists : libraryData.artists) { artist in
                                ArtistSpecView(artist: artist, specBG: .material,  hideArrow: true, artworkWidth: 60 , showAsList: true)

                                   
                                
                            }
                        }
                    } else {
                        ScrollView {
                    
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: (reader.size.width / 4) ))],alignment: .center, spacing: 0) {
                                ForEach(engaged ? libraryData.queryartists : libraryData.artists) { artist in
                                   
                                    ArtistSpecView(artist: artist, specBG: .material,  hideArrow: false, artworkWidth: ((reader.size.width) / 3) - 25 , showAsList: false)
                                    
                                       
                      
                                }
                            }
                        }
                    }
                    
                   
                   
                    
                case .albums:
                    if (viewingOption == .List) {
                        List {
                            ForEach(engaged ? libraryData.queryalbums : libraryData.albums) { album in
                                AlbumSpecView(album: album,  specBG: .material,  hideArrow: true, artworkWidth: 60 , showAsList: true)

                                   
                            }
                        }
                    } else {
                        ScrollView {
                    
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: (reader.size.width / 4) ))],alignment: .center, spacing: 0) {
                                ForEach(engaged ? libraryData.queryalbums : libraryData.albums) { album in
                                   
                                    AlbumSpecView(album: album,  specBG: .material,  hideArrow: false, artworkWidth: ((reader.size.width) / 3) - 25 , showAsList: false)
                                    
                                       
                      
                                }
                            }
                        }
                    }
                  
                   
                }
                
                
            }
                        .scrollContentBackground(.hidden)
                        .listStyle(PlainListStyle())
                       
                        .background(Color(red: 0.07, green: 0.07, blue: 0.07))
                        
                    
                 
                    .navigationTitle("\(contentType.rawValue)")
                    .navigationBarTitleDisplayMode(.large)
             
                    .searchable(text: $query, isPresented: $engaged, placement: .navigationBarDrawer(displayMode: .always))
                    .onChange(of: engaged, { oldValue, newValue in
                        if (engaged) {
                            switch contentType {
                            case .songs:
                               
                                libraryData.querysongs = libraryData.songs
                                
                            case .artists:
                               
                                
                                libraryData.queryartists = libraryData.artists
                             
                            case .albums:
                               
                                
                                libraryData.queryalbums = libraryData.albums
                            }
                        }
                    })
                    .onChange(of: query) { oldValue, newValue in
                      
                        Task {
                          
                            do {
                                switch contentType {
                                case .songs:
                                   
                                    let result = try await search(query: query, request: Song.self)
                                    guard let res = result else {
                                        return
                                    }
                                    libraryData.querysongs = res.items
                                    
                                case .artists:
                                    let result = try await search(query: query, request: Artist.self)
                                    
                                    guard let res = result else {
                                        return
                                    }
                                    
                                    libraryData.queryartists = res.items
                                 
                                case .albums:
                                    let result = try await search(query: query, request: Album.self)
                                    
                                    guard let res = result else {
                                        return
                                    }
                                    
                                    libraryData.queryalbums = res.items
                                }
                            } catch {
                                print(error)
                            }
                           
                           
                        }
                      
                    }
                  
              
                    
                   
                    .toolbar {
                       
                        ToolbarItem(placement: .topBarTrailing) {
                  
                            HStack {
                                Menu {
                                    ViewingOption(viewingOptionChoose: $viewingOption)
                                        .onChange(of: viewingOption) { oldValue, newValue in
                                        
                                           
                                            
                                            
                                               
                                            
                                            
                                            withAnimation {
                                                viewingToggled.toggle()
                                             
                                            }
                                            
                                        
                                           
                                        }
                                }
                            label: {
                                Image(systemName: viewingOption == .List ? "list.bullet" : "square.grid.2x2" )
                                   .font(.system(size: 20,weight: .medium))
                                   .symbolEffect(.bounce.byLayer, value: viewingToggled)
                                   .foregroundStyle(.pink)
                           }
                            .onTapGesture {
                               withAnimation {
                                   viewingToggled.toggle()
                               }
                           }
                                
                                Menu {
                                    SortOptionButton(contentType: contentType,  optionChoose: $optionChoose, granularity:  .generic, action:  { optionChoose in  libraryData.sort(contentType: contentType, optionChoose: optionChoose)})
                                        
                                        .onChange(of: optionChoose) { oldValue, newValue in
                                        
                                           
                                            
                                            
                                               
                                            
                                            
                                            withAnimation {
                                                sortToggled.toggle()
                                             
                                            }
                                            
                                        
                                           
                                        }
                                } label: {
                                    Image(systemName: "line.3.horizontal.decrease.circle")
                                        .font(.system(size: 20,weight: .medium))
                                        .symbolEffect(.bounce.byLayer, value: sortToggled)
                                        .foregroundStyle(.pink)
                                }
                               
                                .onTapGesture {
                                    withAnimation {
                                        sortToggled.toggle()
                                    }
                                }
                            }
                            
                            
                                
                            
                        }
                    }
                   
                .tint(.white)
                .background(Color(red: 0.07, green: 0.07, blue: 0.07))
            
        }
    }
}

enum ViewingOptions: String {
    case List
    case Grid
}

struct ViewingOption: View {
    @Binding var viewingOptionChoose : ViewingOptions
    var viewingOptions : [ViewingOptions] = [.List, .Grid]

    var body: some View {
        Picker(selection: $viewingOptionChoose) {
            ForEach(viewingOptions,id: \.self) { option in
                
                Text(option.rawValue)
                   
                }
        } label: {
           Text("")
        }
       
    }
}

func search<T : MusicLibraryRequestable>(query: String,  request: T.Type) async throws ->  MusicLibraryResponse<T>? {
        do {
           
            var request = MusicLibraryRequest<T>()
            request.filter(text: query)
            let results = try await request.response()
            return results
        } catch {
            print(error)
        }
        return nil
    }


