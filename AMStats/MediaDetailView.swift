//
//  MediaDetailView.swift
//  Musie
//
//  Created by Arth Patel on 8/13/23.
//

import SwiftUI
import Charts

enum Selections {
    case overview
    case top
}


struct Card : View {
   
    var song: SongInfo
    @State var offset = CGSize.zero
    var index: Int
    @Environment(MusicCard.self) private var musicCard
    
    var body: some View {
        VStack(alignment: .leading) {
          
                Image(song.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                   
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(alignment: .bottomLeading) {
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(song.albumName)
                                .font(.title)
                                .fontWeight(.bold)
                                .minimumScaleFactor(0.05)
                                .getContrastText(backgroundColor: Color(UIImage(named: song.image)!.averageColor!.cgColor))
                                .lineLimit(1)
                            
                            Text(song.artistName)
                                .font(.headline)
                                .minimumScaleFactor(0.05)
                                .lineLimit(1)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                        }
                        
                        .padding(30)
                    }
          
        }
      
        .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.width - 50, alignment: .leading)
        .background(.thickMaterial)
       
       
        .clipShape(RoundedRectangle(cornerRadius: 50))
        .shadow(color: .black.opacity(0.2), radius: 10)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    withAnimation(.smooth) {
                        self.offset = gesture.translation
                    }
                }
                .onEnded { _ in
                 
                    if (offset.width) < -200 {
                        withAnimation(.bouncy) {
                            self.musicCard.albums.move(fromOffsets: IndexSet(integer: 0), toOffset:    self.musicCard.albums.count )
                            offset = .zero
                        }
                        
                       
                    } else {
                        withAnimation(.bouncy) {
                            offset = .zero
                        }
                    }
                }
        )
      
        .offset(x: (offset.width) < -200 ? offset.width : 0.0 , y: Double(index) * 40.0)
      
        .scaleEffect(1.0 -  (Double(index) * 0.1) )
        .zIndex(Double(index * -1))
        
      
    }
}

struct SongInfo : Identifiable, Hashable {
    var id = UUID()
    var albumName: String
    var artistName: String
    var image: String
}


@Observable  class MusicCard  {
    
    var albums = [SongInfo(albumName: "Utopia1", artistName: "SZA-SOSis Scott", image: "SZA-SOS"), SongInfo(albumName: "SOS2", artistName: "SZA-SOSis Scott", image: "SZA-SOS"), SongInfo(albumName: "SOS3", artistName: "SZA-SOSis Scott", image: "SZA-SOS"), SongInfo(albumName: "Utopia4", artistName: "SZA-SOSis Scott", image: "SZA-SOS")]
    
    init() {
        
    }
    
    
}

struct Idk : View {
   
    var musicCard = MusicCard()
    @State var papa = "sdsds"
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    VStack {
                        ZStack {
                            ForEach(Array(musicCard.albums.enumerated()), id: \.element) { index, item in
                                Card(song: item, index: index)
                                    .environment(musicCard)
                                
                                
                                
                            }
                            
                            
                        }
                        .padding(.bottom, 30)
                        Spacer()
                        HStack {
                            Text(musicCard.albums[0].artistName)
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding()
                        
                    }
                    .padding()
                    .background(.regularMaterial)
                    .transition(.scale)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                   
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
               
            }   .background(Color(red: 0.07, green: 0.07, blue: 0.07))
               
                .navigationTitle("Top")
        }
        .scrollIndicators(.hidden)
        .overlay(alignment: .bottom) {
            MusicPlayerView()
        }
    }
    
}

struct ToolBar: View {
    @Binding var selection : Int
    var body: some View {
        HStack(alignment: .center) {
            ForEach(0...2, id: \.self) { item in
                
                Spacer()
                
                Button(action: {
                    selection = item
                }, label: {
                  Image(systemName: "waveform")
                        .font(.title2)
                })
                .frame(height: 55, alignment: .center)
                Spacer()
            }
        }
       
       
        
        
    }
}

struct MusicPlayerView : View {
    @State var expand = true

    @State var offset = CGSize.zero
    @Namespace var namespace
    @State var width : CGFloat = UIScreen.main.bounds.width * 2.0
    @State var offsetps: CGFloat = 0.0
    @State var offsetX: CGFloat = 0.0
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var total = 0.0
    @State var loaded = false
    var array = [0,1,2]
    @State var selection : Int = 0
    @State var t = TimeInterval()
    var formatter : DateComponentsFormatter  {
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
         
        return formatter
    }
    
    var time : String {
        let formattedTime =   formatter.string(from: t)
        return formattedTime!.hasPrefix("0") ? String(formattedTime!.dropFirst()) : formattedTime!
    }
    
    var timeRemaining : String {
        let formattedTime =   formatter.string(from: (60.0 - t ))
        return formattedTime!.hasPrefix("0") ? String(formattedTime!.dropFirst()) : formattedTime!
    }
   

    var body: some View {
        
        TabView(selection: $selection) {
            VStack {
                Text("as")
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            .background(.white)
            .tag(array[0])
            
        }
        .overlay(alignment: .bottom) {
          
            VStack(spacing: 0) {
               Spacer()
               
                if (expand) {
                    ZStack(alignment: .bottom) {
                  
                        HStack {
                           
                            HStack {
                                
                                Image("kickback")
                                    .resizable()
                                
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                   
                                    .matchedGeometryEffect(id: "player", in: namespace)
                                
                                    .frame(width: 55, height: 55)
                                
                             
                                
                                VStack(alignment: .leading, spacing: 5)  {
                                    
                                    
                                    ScrollView(.horizontal) {
                                        Text("Modern Jam")
                                            .font(.system(size: 15,weight: .bold))
                                            .minimumScaleFactor(0.005)
                                            .lineLimit(1)
                                            
                                    }
                                    .frame(maxWidth: UIScreen.main.bounds.width / 3)
                                   
                                    .scrollIndicators(.hidden)
                                    
                                
                                    Text("Travis Scott")
                                        .font(.system(size: 15,weight: .medium))
                                        .foregroundStyle(.secondary)
                                        .minimumScaleFactor(0.005)
                                        .lineLimit(1)
                                    
                                    
                                }
                               
                               
                                   
                                    
                            }
                            .frame(maxWidth: UIScreen.main.bounds.width / 2)
                            
                            .matchedGeometryEffect(id: "bg", in: namespace)
                            .padding(5)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15,style: .continuous))
                           
                            Spacer()
                            HStack {
                                
                             
                               
                                Button {
                                    withAnimation(.smooth) {
                                        expand = false
                                    }
                                  
                                } label: {
                                    Image(systemName: "arrow.down.circle.fill")
                                        
                                        .font(.largeTitle)
                                }
                                .foregroundStyle(.regularMaterial)
                               
                            }
                          
                            
                            
                        }
                        .offset(y: 80)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                         
                             
                          
                        VStack(alignment: .leading, spacing: 11) {
                       
                        
                             
                          
                           
                            HStack(spacing: 11) {
                             
                              
                              
                              
                            
                              
                                 
                                    Circle()
                                        
                                        .stroke(lineWidth: 5)
                                        .foregroundStyle(.regularMaterial)
                                        
                                        .overlay {
                                            Circle()
                                                .trim(from: 0, to: 0.5)
                                                .stroke(.white, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                        }
                                  
                                    Button(action: {
                                        print("a")
                                    }, label: {
                                        Image(systemName: "backward.fill")
                                    })
                                   
                                    Button(action: {
                                        print("a")
                                    }, label: {
                                        Image(systemName: "play.fill")
                                    })
                                  
                                    Button(action: {
                                        print("a")
                                    }, label: {
                                        Image(systemName: "forward.fill")
                                    })
                                  
                                    
                                  
                                   
                                }
                             
                             
                                
                                
                                
                            
                           
                      }
                        .frame(width: 40)
                        .foregroundStyle(.white)
                       
                       
                                                
                    } 
                   
                   
                  
                    .background(
                    
                            ScrollView(.horizontal) {
                                HStack {
                                  
                                  
                                    Image("kickback")
                                    .resizable()
                                   
                                    .aspectRatio(contentMode: .fill)
                                   
                                    
                                    .clipShape(RoundedRectangle(cornerRadius: 20,style: .continuous))
                                   
                                   
                                    .offset(x:  self.offsetX * -1)
                                    .animation(.bouncy(duration: 2), value: offsetX)
                                    
                                    .background( GeometryReader { proxy in
                                        
                                        VStack {
                                           
                                        }
                                        
                                        .background(.red)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        
                                       
                                        
                                        .task {
                                            
                                        
                                            self.total = proxy.size.width -  UIScreen.main.bounds.width
                                            self.offsetps =  (total / 60.0)
                                        }
                                       
                                       
                                      
                                        
                                    })
                                    
                              
                                  /*
                                   .onReceive(timer, perform: { input in
                                       withAnimation(.smooth) {
                                           self.t = self.t + 1
                                       }
                                      
                                       withAnimation(.smooth(duration: 2)) {
                                           self.offsetX = (self.offsetX + self.offsetps)
                                          
                                           if (self.t == 60.0) {
                                               timer.upstream.connect().cancel()
                                           }
                                       }
                                      
                                   })
                                   */
                                   
                                }
                                .overlay {
                                    VStack {
                                       
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                          
                                    
                                   
                                }
                                
                        }
                                .scrollIndicators(.hidden)
                               
                                .scrollDisabled(true)
                                
                  
                    
                    )
                   
                 
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                   
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                withAnimation(.smooth) {
                                   
                                    
                                     if (offset.height) < 200 && (offset.height) >= 0  {
                                         self.offset = gesture.translation
                                     } else if (offset.height) > 200 {
                                         withAnimation(.smooth) {
                                             expand = false
                                             offset = .zero
                                             
                                         }
                                         
                                        
                                     } else {
                                         offset = .zero
                                     }
                                 }
                                }
                            
                            .onEnded { _ in
                             
                                if (offset.height) > 200 {
                                    withAnimation(.smooth) {
                                        expand = false
                                        offset = .zero
                                        
                                    }
                                    
                                   
                                } else {
                                    withAnimation(.smooth) {
                                        offset = .zero
                                    }
                                }
                            }
                    )
                   
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(.all)
                    .offset(y: (offset.height) < 200 && (offset.height) >= 0 ? offset.height : 0.0)
                 
                   
               
                    
                } else {
                    
                    VStack(spacing: 0) {
                        
                        if (!expand) {
                            HStack(alignment: .center ){
                                Image("SZA-SOS")
                                    .resizable()
                                
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
                                    .padding(5)
                                    .matchedGeometryEffect(id: "player", in: namespace)
                                
                                    .frame(width: 60, height: 60)
                                
                                
                                Text("SOS")
                                    .font(.headline)
                                
                                Spacer()
                                Button(action: {
                                    expand.toggle()
                                }, label: {
                                    Image(systemName: "play.fill")
                                        .symbolEffect(.bounce, value: expand)
                                        .font(.title2)
                                    
                                })
                                .padding(.trailing,20)
                            }
                            
                            .background(.regularMaterial)
                            
                            .clipShape(RoundedRectangle(cornerRadius: 15,style: .continuous))
                           
                            .padding(.horizontal,5)
                            .matchedGeometryEffect(id: "bg", in: namespace)
                            
                            
                           
                            .onTapGesture {
                                withAnimation(.smooth) {
                                    expand.toggle()
                                }
                                
                            }
                        }
                        ToolBar(selection: $selection)
                            .background(.ultraThickMaterial)
                           
                    }
                    
                   
                    
                    
                    
                    
                }
            }
            
            
        }
        
        .ignoresSafeArea(.all)

        
    }
}


struct TopViews : View {
    
    
    
    
    var body: some View {
        ScrollViewReader { reader in
            VStack {
                
                
               
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0...5, id: \.self) { item in
                            HStack {
                                Image("SZA-SOS")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                    .frame(width: 150)
                                    .id(item)
                            }
                            
                            .scrollTransition(.animated.threshold(.visible(0.3))) { content, phase in
                             
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.85)
                                    .scaleEffect(phase.isIdentity ? 2.0 : 0.80)
                             
                                   
                             
                            }
                        }
                    }
                    .padding(.leading, 25)
                }
                .scrollIndicators(.hidden)
                .task {
                    withAnimation {
                      
                    }
                }
                    
                
                    
                    
                    
                
                
                
                
                
            }
        }

    }
}



struct HomeView : View {
    var body: some View {
        NavigationStack {
            List {
                Group {
                    HStack {
                       
                            InsightView(title: "Minutes Listened", number: 132005.0)
                        
                        
                        Spacer()
                        
                        
                            InsightView(title: "Play Count", number: 1335.0)
                        
                    }
                    
                    
                    Section {
                        HStack {
                            StatView(number: Double(1000), title: "Song")
                        }
                        VStack(spacing: 5) {
                            ForEach(0...4, id: \.self)  { item in
                                HStack {
                                    HStack(alignment: .center ){
                                        Image("SZA-SOS")
                                            .resizable()
                                        
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
                                            .padding(5)
                                        
                                        
                                            .frame(width: 60, height: 60)
                                        
                                        
                                        Text("SOS")
                                            .font(.headline)
                                        
                                        Spacer()
                                        Button(action: {
                                            
                                        }, label: {
                                            Image(systemName: "play.fill")
                                            
                                                .font(.title2)
                                            
                                        })
                                        .padding(.trailing,20)
                                    }
                                    
                                    .background(.regularMaterial)
                                    
                                    .clipShape(RoundedRectangle(cornerRadius: 15,style: .continuous))
                                    
                                    .padding(.horizontal,5)
                                    
                                }
                            }
                        }
                    }
                }
                .listRowBackground(Color(red: 0.07, green: 0.07, blue: 0.07))
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
            
            .navigationTitle("Overview")
            .padding()
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .background(Color(red: 0.07, green: 0.07, blue: 0.07))
            .listStyle(.plain)
        }
    }
}


struct HomePage : View {
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        
                        VStack {
                            Image("goat")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .overlay(alignment: .bottomLeading) {
                            Text("Travis Scott")
                                .font(.system(.largeTitle, weight: .bold))
                                .padding([.bottom, .leading],5)
                                .foregroundStyle(.white)
                        }
                       
                        .frame(width:  UIScreen.main.bounds.size.width)
                      
                       
                           
                
                     
                       
                       
                        
                    }
                    .frame(width:  UIScreen.main.bounds.size.width)
                    .ignoresSafeArea(.all)
                   
                 
                    .offset(y: proxy.safeAreaInsets.top * -1.0)
                    
                       
                }
                .scrollIndicators(.hidden)
              
            }
        }
    }
}

struct CardView : View {
    
    var names : [String] = ["SZA-SOS","SZA-SOS", "goat"]
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 25){
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading) {
                        Text("Total Minutes Listened")
                            .font(.headline)
                        
                        Text("123,000")
                            .font(.system(size: 60))
                            .minimumScaleFactor(0.05)
                            .lineLimit(1)
                            
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text("Total Songs Played")
                            .font(.headline)
                        Text("123,000")
                            .font(.system(size: 60))
                            .minimumScaleFactor(0.05)
                            .lineLimit(1)
                    }
                    
                }
                .fontWeight(.bold)
                .padding(.leading)
             
               
                Text("Songs")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                ScrollView(.horizontal){
                    
                    HStack(spacing: 25) {
                        ForEach(0...5, id: \.self) { item in
                            VStack {
                                ZStack(alignment: .trailing) {
                                    ForEach(0...5, id: \.self) { item in
                                        Image("goat")
                                            .resizable()
                                        
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 200)
                                            .overlay {
                                                Color.black.opacity(1.0 -  (1.0 - (Double(item) * 0.4)))
                                                
                                            }
                                        
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                            .shadow(color: .black.opacity(0.1), radius: 20)
                                            .offset(x:  Double(item) * 20.0 , y: Double(item) * 20.0)
                                        
                                            .scaleEffect(1.0 -  (Double(item) * 0.1) )
                                            .zIndex(Double(item * -1))
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                                HStack(alignment: .bottom) {
                                    VStack(alignment: .leading) {
                                        Text("SOS")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .minimumScaleFactor(0.05)
                                        
                                            .lineLimit(1)
                                        
                                        Text("SZA")
                                            .font(.title2)
                                            .minimumScaleFactor(0.05)
                                            .lineLimit(1)
                                            .fontWeight(.bold)
                                    }
                                    Spacer()
                                    
                                }
                                
                            }
                            .frame(width: 200)
                            
                            
                            
                            .scrollTransition { content, phase in
                                
                                content
                                
                                    .scaleEffect(phase.isIdentity ? 1.0 : 1.0)
                                
                                
                            }
                            
                            
                        }
                    }
                    .padding(.leading)
                }
               
                Text("Songs")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                ScrollView(.horizontal){
                    HStack(spacing: 25) {
                        ForEach(0...5, id: \.self) { item in
                            VStack {
                                
                                
                                Image("goat")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(color: .black.opacity(0.1), radius: 20)
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                HStack(alignment: .bottom) {
                                    VStack(alignment: .leading) {
                                        Text("SOS")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .minimumScaleFactor(0.05)
                                        
                                            .lineLimit(1)
                                        
                                        Text("SZA")
                                            .font(.title2)
                                            .minimumScaleFactor(0.05)
                                            .lineLimit(1)
                                            .fontWeight(.bold)
                                    }
                                    Spacer()
                                    HStack(alignment: .bottom, spacing: 3) {
                                        Text("235")
                                            .font(.title)
                                            .minimumScaleFactor(0.05)
                                            .lineLimit(1)
                                            .fontWeight(.bold)
                                        
                                        Text("plays")
                                            .font(.body)
                                            .minimumScaleFactor(0.05)
                                            .lineLimit(1)
                                            .fontWeight(.bold)
                                        
                                    }
                                }
                                
                            }
                            .frame(width: 200)
                            
                            
                            
                            .scrollTransition { content, phase in
                                
                                content
                                
                                    .scaleEffect(phase.isIdentity ? 1.0 : 1.0)
                                
                                
                            }
                            
                            
                        }
                    }
                    .padding(.leading)
                }
                
                
                Spacer()
            }
            
            
           
        }
        .background(Color(red: 0.07, green: 0.07, blue: 0.07))
    
}
    
        
}

struct ArtistView : View {
    let rows = [GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    var body: some View {
        GeometryReader { reader in
           ScrollView {
           
                VStack(spacing: 0) {
                    
                    Image("goat")
                        .resizable()
                    
                        .aspectRatio(contentMode: .fill)
                    
                        .frame(width: UIScreen.main.bounds.width)
                        .overlay(alignment: .bottomLeading) {
                            Text("Travis Scott")
                                .font(.system(.largeTitle, weight: .bold))
                                .minimumScaleFactor(0.005)
                                .lineLimit(1)
                                .foregroundStyle(.white)
                                .padding([.leading, .bottom],5)
                            
                        }
                    
                    
                    
                    
                    
                    VStack(alignment: .leading) {
                        
                        
                        Text("Songs")
                            .font(.system(.title, weight: .bold))
                            .padding([.leading, .bottom],5)
                            .padding(.top)
                        ScrollView( .horizontal) {
                            LazyHGrid(rows: rows, spacing: UIScreen.main.bounds.width / 4) {
                                ForEach(0...10, id: \.self) { item in
                                    ArtistSongss()
                                }
                            }
                           
                            .padding([.leading, .bottom],5)
                            
                        }
                        
                        .scrollIndicators(.hidden)
                    }
                    
                    
                    
                    VStack(alignment: .leading) {
                        Text("Albums")
                            .font(.system(.title, weight: .bold))
                            .padding([.leading, .bottom],5)
                            .padding(.top)
                        ScrollView( .horizontal) {
                            LazyHGrid(rows: rows, spacing: UIScreen.main.bounds.width / 4) {
                                ForEach(0...10, id: \.self) { item in
                                    ArtistSongss()
                                }
                            }
                            .padding([.leading, .bottom],5)
                            
                        }
                        
                        .scrollIndicators(.hidden)
                    }
                   
                  
                    
                }
                .offset(y: reader.safeAreaInsets.top * -1.0)
                
               
         
            }
           
           
        }
    
    }
}

struct ArtistSongss: View {
    var body: some View {
        ScrollView {
            SongCard()
        }
    }
}

struct SongCard : View {
    @State var bounce = false
    var body: some View {
        
        HStack {
           Image("trav")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: .black.opacity(0.3), radius: 7)
                .scaleEffect(bounce ? 1.0 : 0)
                .animation(.bouncy, value: bounce)
                .onAppear {
                    bounce = true
                }
               
               
                
                
            
            
            VStack(alignment: .leading)  {
               
                    Text("Meltdown")
                        .font(.system(size:  14,weight: .bold))
                       
                
                Group {
                   
                    Spacer()
                    
                    HStack(alignment: .bottom, spacing: 3) {
                        Text("20")
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
        
        
    }
}

