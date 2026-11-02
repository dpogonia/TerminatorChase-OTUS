//
//  ContentViewModel.swift
//  TEscape
//
//  Created by user on 16.06.2025.
//

import Foundation
import SwiftUI

@Observable
final class ContentViewModel {
    enum GameState: String {
        case idle = "idle"
        case playing
        case paused
        case won
        case lost

        var localizedKey: LocalizedStringKey {
            switch self {
            case .idle:
                return LocalizedStringKey("starting")
            default:
                return LocalizedStringKey(self.rawValue)
            }
        }
    }
    
    var gameState: GameState
    var leftSeconds: Int
    
    static let t800MaxBulletCount: Int = 6
    static private let maxT1000SpeedKmH: Double = 15
    static private let startDistance: Int = 500
    static private let secondsForRecoverDamage: Int = 3
    static private let secondsForWin: Int = 30
    
    var t800bulletsCount: Int
    var t1000SpeedKmH: Double
    var t1000Distance: Int
    var t1000Damages: [Date]
    
    let t800SpeedKmH: Double
    var t800Distance: Int
    var distance: Int
    
    private var timer: Timer?
    
    init() {
        gameState = .idle
        leftSeconds = 0
        t800bulletsCount = Self.t800MaxBulletCount
        t1000SpeedKmH = Self.maxT1000SpeedKmH
        t1000Distance = 0
        
        t800SpeedKmH = 10
        t800Distance = Self.startDistance
        
        distance = Self.startDistance
        t1000Damages = [Date]()
    }
    
    func startGame() {
        gameState = .playing
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    func pauseGame() {
        gameState = .paused
        timer?.invalidate()
    }
    
    func stopGame() {
        gameState = .idle
        timer?.invalidate()
        reset()
    }
    
    private func lostGame() {
        gameState = .lost
        timer?.invalidate()
    }
    
    private func winGame() {
        gameState = .won
        timer?.invalidate()
    }
    
    func t800Shoot() {
        guard t800bulletsCount > 0 else {
            return
        }
        
        t800bulletsCount -= 1
        t1000Damages.append(.now)
    }
    
    func t800LoadGun() {
        guard t800bulletsCount < Self.t800MaxBulletCount else {
            return
        }
        t800bulletsCount += 1
    }
    
    private func reset() {
        gameState = .idle
        leftSeconds = 0
        t800bulletsCount = Self.t800MaxBulletCount
        t1000SpeedKmH = Self.maxT1000SpeedKmH
        t1000Distance = 0
        
        t800Distance = Self.startDistance
        
        distance = Self.startDistance
        t1000Damages = [Date]()
    }
    
    
    @objc func fireTimer() {
        leftSeconds += 1
        
        if leftSeconds >= Self.secondsForWin {
            winGame()
            return
        }
        
        t1000Damages = t1000Damages.filter { $0 >= (.now - TimeInterval(Self.secondsForRecoverDamage)) }
        
        t1000SpeedKmH = Self.maxT1000SpeedKmH * (1 - 0.1 * Double(t1000Damages.count))
        
        t800Distance += Int(t800SpeedKmH * 1000 / 3600) * leftSeconds
        t1000Distance += Int(t1000SpeedKmH * 1000 / 3600) * leftSeconds
        
        distance = max(t800Distance - t1000Distance, 0)
        
        if distance <= 0 {
            lostGame()
        }
    }
}

extension ContentViewModel {
    func formattedSpeed(_ speed: Double) -> String {
        let measurement = NSMeasurement(doubleValue: speed, unit: UnitSpeed.kilometersPerHour)
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.minimumFractionDigits = 1

        return formatter.string(from: measurement as Measurement)
    }

    func formattedDistance(_ meters: Int) -> String {
        let value = NSMeasurement(doubleValue: Double(meters), unit: UnitLength.meters)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = [.naturalScale]
        return formatter.string(from: value as Measurement<Unit>)
    }

    func formattedTime(_ seconds: Int) -> String {
        let value = NSMeasurement(doubleValue: Double(seconds), unit: UnitDuration.seconds)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long
        formatter.unitOptions = [.naturalScale]
        return formatter.string(from: value as Measurement<Unit>)
    }
}
