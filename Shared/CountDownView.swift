//
//  CountDownView.swift
//  Strowke
//
//  Created by quarticAIMBP2018 on 2020-07-12.
//

import SwiftUI

struct CountDownView: View {
    @State var currentDate = Date()
    @State var timeRemaining: TimeInterval = 60
    
    var formatter: DateComponentsFormatter {
        let frm = DateComponentsFormatter()
        frm.allowedUnits = [.hour, .minute, .second, .nanosecond]
        frm.allowsFractionalUnits = true
        frm.unitsStyle = .positional
        return frm
    }
    
    var intervalLabel: String {
        return formatter.string(from: timeRemaining) ?? "error"
    }
    
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    var body: some View {
        Text(intervalLabel)
            .onReceive(timer) { input in
                if timeRemaining == 0 { timeRemaining = 60 }
                self.timeRemaining -= 0.01
            }
    }
}

struct CountDownView_Previews: PreviewProvider {
    static var previews: some View {
        CountDownView()
    }
}
