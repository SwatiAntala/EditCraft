//
//  CountdownTimer.swift
//  DualSpace
//
//  Created by swati on 11/08/24.
//

import Foundation
import UIKit

class CountdownTimer {
    private var timer: Timer?
    private var endDate: Date?
    private var timerInterval: TimeInterval = 1.0 // Update interval (1 second)
    private var daysLabel: UILabel?
    private var hoursLabel: UILabel?
    private var minutesLabel: UILabel?
    private var secondsLabel: UILabel?
    private var completion: (() -> Void)?
    
    static let shared = CountdownTimer()
    
    private init() {
        loadTimer()
    }
    
    // Set the labels to update
    func setLabels(daysLabel: UILabel,
                   hoursLabel: UILabel,
                   minutesLabel: UILabel,
                   secondsLabel: UILabel,
                   completion: @escaping () -> Void) {
        self.daysLabel = daysLabel
        self.hoursLabel = hoursLabel
        self.minutesLabel = minutesLabel
        self.secondsLabel = secondsLabel
        self.completion = completion
        updateLabels()
    }
    
    func setTime(time: String,
                 completion: @escaping () -> Void) {
        
        if time.isEmpty {
            return
        }
        // Split the string by the decimal point
           let timeComponents = time.split(separator: ".")
           
           // Extract hours and minutes
           var hours = Double(timeComponents[0]) ?? 0.0
           var minutes = Double(timeComponents.count > 1 ? timeComponents[1] : "0") ?? 0.0
           
           // Normalize the minutes (convert anything over 60 into hours)
           if minutes >= 60 {
               hours += floor(minutes / 60)
               minutes = minutes.truncatingRemainder(dividingBy: 60)
           }
           
           // Normalize the hours (convert anything over 24 into days)
           let days = floor(hours / 24)
           hours = hours.truncatingRemainder(dividingBy: 24)
        
        startTimer(days: days,
                   hours: hours,
                   minutes: minutes,
                   seconds: .zero,
                   completion: completion)
    }
    
    // Start the timer with a specified duration
    func startTimer(days: Double,
                    hours: Double,
                    minutes: Double,
                    seconds: Double,
                    completion: @escaping () -> Void) {
        let totalSeconds = (days * 86400) + (hours * 3600) + (minutes * 60) + seconds
        endDate = Date().addingTimeInterval(TimeInterval(totalSeconds))
        self.completion = completion
        saveTimer()
        startUpdating()
    }
    
    // Start updating the timer
    private func startUpdating() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // Update the timer every second
    @objc private func updateTimer() {
        guard let endDate = endDate else { return }
        
        let timeRemaining = endDate.timeIntervalSinceNow
        
        if timeRemaining <= 0 {
            timer?.invalidate()
            timer = nil
            // Timer has finished
            updateLabels()
            timerFinished()
        } else {
            // Update the labels with the remaining time
            updateLabels()
        }
    }
    
    // Update the labels with the remaining time
    private func updateLabels() {
        guard let daysLabel = daysLabel,
              let hoursLabel = hoursLabel,
              let minutesLabel = minutesLabel,
              let secondsLabel = secondsLabel else { return }
        
        let timeRemaining = endDate?.timeIntervalSinceNow ?? 0
        
        if timeRemaining <= 0 {
            daysLabel.text = "00"
            hoursLabel.text = "00"
            minutesLabel.text = "00"
            secondsLabel.text = "00"
        } else {
            let days = Int(timeRemaining) / 86400
            let hours = (Int(timeRemaining) % 86400) / 3600
            let minutes = (Int(timeRemaining) % 3600) / 60
            let seconds = Int(timeRemaining) % 60
            
            daysLabel.text = String(format: "%02d", days)
            hoursLabel.text = String(format: "%02d", hours)
            minutesLabel.text = String(format: "%02d", minutes)
            secondsLabel.text = String(format: "%02d", seconds)
        }
    }
    
    // Handle when the timer finishes
    private func timerFinished() {
        // Call the completion handler
        completion?()
    }
    
    // Save the timer state to UserDefaults
    func saveTimer() {
        if let endDate = endDate {
            UserDefaults.standard.set(endDate, forKey: "endDate")
        }
    }
    
    // Load the timer state from UserDefaults
    func loadTimer() {
        if let savedEndDate = UserDefaults.standard.object(forKey: "endDate") as? Date {
            endDate = savedEndDate
            startUpdating()
        }
    }
    
    // Reset the timer
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        endDate = nil
        UserDefaults.standard.removeObject(forKey: "endDate")
        updateLabels()
    }
}
