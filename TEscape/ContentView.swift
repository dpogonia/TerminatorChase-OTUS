//
//  ContentView.swift
//  TEscape
//
//  Created by user on 16.06.2025.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel = ContentViewModel()
    
    @State private var showWonSheet = false
    @State private var showLostSheet = false
    
    var body: some View {
        ScrollView(.vertical) {

            VStack {
                Text("T-1000")
                    .font(.title2)
                
                HStack(spacing: 100) {
                    Image("t1000")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    VStack {
                        Text(viewModel.formattedSpeed(viewModel.t1000SpeedKmH))
                        Text(viewModel.formattedDistance(viewModel.t1000Distance))
                        Text("\(viewModel.t1000Damages.count) damages")
                    }
                }
            }
            
            Divider()
            
            VStack {
                Text("T-800")
                    .font(.title2)
                HStack(spacing: 100) {
                    Image("t800")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    VStack {
                        Text(viewModel.formattedSpeed(viewModel.t800SpeedKmH))
                        Text(viewModel.formattedDistance(viewModel.t800Distance + 700))
                    }
                }
                HStack {
                    Button("Shot") {
                        viewModel.t800Shoot()
                    }
                    
                    Spacer()
                    Text("\(viewModel.t800bulletsCount) bullets")
                    Spacer()
                    
                    Button("Load gun") {
                        viewModel.t800LoadGun()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            
            Divider()
            
            VStack {
                Text(viewModel.gameState.localizedKey)
                    .font(.title2)
                    .foregroundStyle(stateStyle)
                
                HStack {
                    Text(viewModel.formattedTime(viewModel.leftSeconds))
                    Spacer()
                    Text("\(viewModel.distance) meters")
                }
                
                HStack {
                    Spacer()
                    VStack {
                        Image("t1000")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                            .clipShape(Circle())
                        if !viewModel.t1000Damages.isEmpty {
                            Label("\(viewModel.t1000Damages.count)", systemImage: "heart.slash")
                                .imageScale(.small)
                                .font(.footnote)
                        } else {
                            Spacer()
                        }
                    }
                    Spacer()
                        .frame(width: max(CGFloat(viewModel.distance / 3),0))
                    VStack {
                        Image("john")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                            .clipShape(Circle())
                        Image("t800")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                            .clipShape(Circle())
                        Label("\(viewModel.t800bulletsCount)", systemImage: "record.circle")
                            .imageScale(.small)
                            .font(.footnote)
                    }
                }
                .padding()
                //.background(Color.gray.opacity(0.5))
            }
            .padding()
            
            Divider()
            
            HStack {                
                Button("Start") {
                    viewModel.startGame()
                }
                
                Spacer()
                
                Button("Pause") {
                    viewModel.pauseGame()
                }
                
                Spacer()
                
                Button("Stop") {
                    viewModel.stopGame()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .sheet(isPresented: $showWonSheet) {
            WonView()
        }
        .sheet(isPresented: $showLostSheet) {
            LostView()
        }
        .onChange(of: viewModel.gameState) { oldValue, newValue in
            switch newValue {
            case .lost:
                showLostSheet = true
            case .won:
                showWonSheet = true
            default:
                return
            }
        }
    }
    
    private var stateStyle: any ShapeStyle {
        switch viewModel.gameState {
        case .lost:
            return .red
        case .won:
            return .green
        default:
            return .primary
        }
    }
}

#Preview {
    ContentView()
}
