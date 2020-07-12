//
//  CDView.swift
//  Strowke
//
//  Created by Ерохин Ярослав Игоревич on 01.12.2019.
//  Copyright © 2019 HCFB. All rights reserved.
//

import Combine
import SwiftUI

struct CDView: View {
    
    init(seconds: Double){
        self.timer = CountDownTimer(seconds: seconds)
    }
    
    private let timer: CountDownTimer
    private let buttonWidth: CGFloat = 90
    private let buttonHeight: CGFloat = 25
    
    @State private var timerSubscription: Cancellable?
    @State private var counting = false
    @State private var time = 0.0
    
    private var minutesText: Int {Int(time/60)}
    private var secondsText: Int {Int(time)}
    private var millisecondsText: String {return "Boo"}
    var buttonText: String { counting ? "Cancel" : "Start" }
//    var timeText: String { counting ? "\(time.minutesInterval):\(time.secondsInterval):\(time.millisecondsInterval)": "00:00:00" }
    var timeText: String { time.timerDisplay }
    var buttonAction: () -> Void { counting ? cancel : start }
    
    var body: some View {
        
//        ZStack {
            
//            Color(.white).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                Text(timeText)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.black)
                
                HStack {
                    Button(action: buttonAction) {
                        Text(buttonText)
                            .font(.body)
                            .fontWeight(.black)
                            .foregroundColor(.black)
                    }.frame(width: buttonWidth, height: buttonHeight)
                    .padding(15)
                    //.background(Color.black.opacity(0.2))
                    .cornerRadius(10)
                    
                    Button(action: buttonAction) {
                        Text("Pause")
                            .font(.body)
                            .fontWeight(.black)
                            .foregroundColor(counting ? .black:.gray)
                    }.frame(width: buttonWidth, height: buttonHeight)
                    .padding(15)
//                    .background(Color.black.opacity(0.2))
                    .cornerRadius(10)
                    .disabled(!counting)
                }
            }
//        }
    }
    
    private func start() {
        counting = true
        timerSubscription = timer
            .start()
            .sink(receiveCompletion: { _ in self.counting = false },
                  receiveValue: { self.time = $0 })
    }
    
    private func cancel() {
        timerSubscription?.cancel()
        counting = false
    }
}

class CountDownTimer {
    
    var seconds: Double
    
    init(seconds: Double){
        self.seconds = seconds
    }
    
    func start() -> TimerPublisher {
        TimerPublisher(seconds: seconds)
    }
}

struct TimerPublisher: Publisher {
    
    let seconds: Double
    
    typealias Output = Double
    typealias Failure = Never
    
    func receive<Downstream>(subscriber: Downstream) where
        Downstream : Subscriber,
        Failure == Downstream.Failure,
        Output == Downstream.Input {
            
            let subscription = TimerSubscription(subscriber: subscriber,
                                                 seconds: seconds)
            subscriber.receive(subscription: subscription)
            subscription.run()
    }
}

class TimerSubscription<Downstream>: Subscription
where Downstream: Subscriber, Downstream.Input == Double {
    
    let seconds: Double
    var timer: Timer!
    
    private let interval = 0.1
    private var subscriber: Downstream?
    private var secondsLeft: Double
    
    init(subscriber: Downstream, seconds: Double) {
        self.seconds = seconds
        self.secondsLeft = seconds
        self.subscriber = subscriber
    }
    
    func run() {
        timer = Timer.scheduledTimer(withTimeInterval: interval,
                                     repeats: true,
                                     block: tick)
        timer.fire()
    }
    
    func request(_ demand: Subscribers.Demand) {
        // no op
    }
    
    func cancel() {
        subscriber = nil
    }
    
    private func tick(_ timer: Timer) {
        guard let subscriber = subscriber else { return }
        
        _ = subscriber.receive(secondsLeft)
        secondsLeft -= interval
        
        if secondsLeft < 0 {
            timer.invalidate()
            subscriber.receive(completion: .finished)
        }
    }
}


struct CDView_Previews: PreviewProvider {
    
    static var previews: some View {
        CDView(seconds: 76)
    }
}

extension Double {
    
    var pretty: Double {
        Double(Foundation.round(1000 * self) / 1000)
    }
    var minutesInterval: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? "00"
    }
    var secondsInterval: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self.truncatingRemainder(dividingBy: 60)) ?? "00"
    }
    
    var millisecondsInterval: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.nanosecond]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? "00"
    }
    
    var timerDisplay: String {
        return  "\(self.minutesInterval):\(self.secondsInterval):\(self.millisecondsInterval)"
    }
}
