//
//  TimerView.swift
//  Test1PK
//
//  Created by Luigi Cirillo on 13/12/23.
//

import SwiftUI

struct TimerView: View {
    var body: some View {
        VStack{
            Text("Set your timer")
                .font(.title2)
                .bold()
                .foregroundStyle(.black)
            
            GeometryReader{ proxy in
                VStack{
                    ZStack{
                        Circle()
                            .fill(.black.opacity(0.05))
                            .padding(-20)
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 80)
                        
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                        Circle()
                            .trim(from: 0, to: 0.5)
                            .stroke(Color.orange, lineWidth: 10)
                            .opacity(0.8)
                        
                        
                        GeometryReader{ proxy in
                            let size = proxy.size
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                }
                                .frame(width: size.width, height: size.height, alignment: .center)
                                .offset(x: size.height/2)
                        }
                        .shadow(radius: 1)
                    }
                    .padding()
                    .frame(height: proxy.size.width)
                    .rotationEffect(.degrees(-90))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .padding()
    }
}

#Preview {
    TimerView()
        .environment(PomodoroModel())
}
