//
//  TimerView.swift
//  Test1PK
//
//  Created by Luigi Cirillo on 13/12/23.
//

import SwiftUI

struct TimerView: View {
    @Environment (PomodoroModel.self) var pomodoroModel : PomodoroModel
    let timerTip = startTimer()
    
    var body: some View {
        VStack{
            Text("Set your timer")
                .font(.title2)
                .bold()
                .foregroundStyle(.black)
                .padding()
            
            GeometryReader{ proxy in
                VStack{
                    ZStack{
                        Circle()
                            .fill(.black.opacity(0.05))
                            .padding(-20)
                        
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(.white.opacity(0.05), lineWidth: 80)
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 80)
                        
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(Color.orange, lineWidth: 10)
                            .opacity(0.8)
                        
                        
                        GeometryReader{ proxy in
                            let size = proxy.size
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                }
                                .frame(width: size.width, height: size.height, alignment: .center)
                                .offset(x: size.height/2)
                                .rotationEffect(.degrees(pomodoroModel.progress *  360))
                        }
                        .shadow(radius: 1)
                        .onTapGesture {
                            pomodoroModel.progress = 0.5
                        }
                        
                        Text(pomodoroModel.timerStringValue)
                            .font(.title)
                            .fontWeight(.light)
                            .rotationEffect(.degrees(90))
                            .animation(.none, value: pomodoroModel.progress)
                        
                    }
                    .padding()
                    .frame(height: proxy.size.width)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: pomodoroModel.progress )
                    VStack{
                        
                        Button(action: {
                            if pomodoroModel.isStarted {
                                pomodoroModel.stopTimer()
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            } else {
                                pomodoroModel.addNewTimer = true
                            }
                        }, label: {
                            Image(systemName: pomodoroModel.isStarted ? "pause" : "timer" )
                                .font(.title.bold())
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.black)
                                .background{
                                    Circle()
                                        .fill(.accent)
                                }
                        })
                        .disabled(pomodoroModel.isStarted ? false : true)
                        .popoverTip(timerTip)
                        
                        Spacer()
                        
                        HStack{
                            Text("\(pomodoroModel.hour) hr")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black.opacity(0.5))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background{
                                    Capsule()
                                        .fill(.black.opacity(0.05))
                                }
                                .contextMenu{
                                    contextMenuOptions(max: 12, hint: "hr") { value in
                                        pomodoroModel.hour = value
                                    }
                                }
                            
                            Text("\(pomodoroModel.minutes) min")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black.opacity(0.5))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background{
                                    Capsule()
                                        .fill(.black.opacity(0.05))
                                }
                                .contextMenu{
                                    contextMenuOptions(max: 12, hint: "min") { value in
                                        pomodoroModel.minutes = value
                                    }
                                }
                                
                            
                            Text("\(pomodoroModel.seconds) sec")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black.opacity(0.5))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background{
                                    Capsule()
                                        .fill(.black.opacity(0.05))
                                }
                                .contextMenu{
                                    contextMenuOptions(max: 12, hint: "sec") { value in
                                        pomodoroModel.seconds = value
                                    }
                                }
                        }
                        HStack{
                            if !pomodoroModel.isStarted {
                                Button(action: {
                                    pomodoroModel.startTimer()
                                    timerTip.invalidate(reason: .actionPerformed)
                                }, label: {
                                    Text("Start")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.black)
                                        .padding(.vertical)
                                        .padding(.horizontal, 100)
                                        .background{
                                            Capsule()
                                                .fill(.accent)
                                        }
                                })
                                    .disabled(pomodoroModel.seconds + pomodoroModel.hour + pomodoroModel.minutes == 0)
                                    .disabled(pomodoroModel.isStarted ? true : false)
                                    .opacity(pomodoroModel.seconds + pomodoroModel.hour + pomodoroModel.minutes == 0 ? 0.5 : 1)
                        }
                    }
                        if pomodoroModel.isStarted {
                            Button(action: {
                                pomodoroModel.resetTimer()
                            }, label: {
                                Text("Reset")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                    .padding(.vertical)
                                    .padding(.horizontal, 100)
                                    .background {
                                        Capsule()
                                            .fill(.accent)
                                    }
                            })
                            .disabled(!pomodoroModel.isStarted)
                            .opacity(pomodoroModel.isStarted ? 1 : 0.5)
                            
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .padding()
        .onReceive(Timer.publish(every: 1 , on: .main, in: .common).autoconnect(), perform: { _ in
            if pomodoroModel.isStarted {
                pomodoroModel.updateTimer()
            } else {
                
            }
        })
    }
    
    @ViewBuilder
    func contextMenuOptions(max: Int, hint: String, onClick:@escaping (Int)->())->some View{
        ForEach(0...max, id: \.self){ value in
            Button("\(value) \(hint)") {
                onClick(value)
            }
            
        }
    }
}

#Preview {
    TimerView()
        .environment(PomodoroModel())
}
