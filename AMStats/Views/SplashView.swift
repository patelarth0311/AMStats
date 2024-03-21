//
//  SplashView.swift
//  Musie
//
//  Created by Arth Patel on 8/16/23.
//

import Foundation
import SwiftUI


struct SplashView : View {
@State var animationsRunning = false;
var body: some View {

    VStack(spacing: 20) {
        Text("AMStats")
            .font(.system(size: 55,weight: .semibold))
        Image(systemName: "waveform")
            .font(.system(size: 60,weight: .semibold))
            .symbolEffect(.variableColor.iterative.reversing, options: .repeating,value: animationsRunning)
            
            .task {
                withAnimation {
                    animationsRunning.toggle()
                }
            }
            .padding()
            
    }
   
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  
   
  
    .background(.pink)
    .clipShape(RoundedRectangle(cornerRadius: 30.0))
    .ignoresSafeArea(.all)
    .foregroundStyle(.white)



}
}



