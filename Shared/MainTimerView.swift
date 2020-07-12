//
//  MainTimerView.swift
//  Strowke
//
//  Created by quarticAIMBP2018 on 2020-07-12.
//

import SwiftUI

struct MainTimerView: View {
    
    @State private var strokeRate = 24
    @State private var recovery = 3
    @State private var looping = true
    private var ratioLabel = "Stroke ratio"
    private var rateLabel = "Stroke rate"
    
    var body: some View {
        VStack (spacing: 30){
            HStack {
                Spacer()
                Button(action: {}){Image(systemName: "gear").font(.title)}.buttonStyle(PlainButtonStyle())
            }
            Circle().stroke(lineWidth: 10.0).padding(.horizontal, 30)
            CDView(seconds: 60.0/Double(strokeRate))
            
            VStack(spacing:0){
                Toggle("Loop timer", isOn: $looping).labelsHidden()
                Text("loop timer".uppercased()).font(.caption).foregroundColor(.secondary)
            }
            HStack(alignment:.center){
                Spacer()
                VStack(alignment: .center){
                    Text(rateLabel.uppercased()).fontWeight(.bold)
                    Text("\(strokeRate)").font(.largeTitle).fontWeight(.bold)
                    Text("spm".uppercased()).font(.caption).fontWeight(.bold).foregroundColor(.secondary)
                    Stepper("Stroke rate", value: $strokeRate, in: 0...50).labelsHidden()
                }
                Spacer()
                Divider()
                Spacer()
                VStack(alignment:.center){
                    Text(ratioLabel.uppercased()).fontWeight(.bold)
                    Text("\(recovery):1").font(.largeTitle).fontWeight(.bold)
                    Text("recovery:drive".uppercased()).font(.caption).fontWeight(.bold).foregroundColor(.secondary)
                    Stepper("Stroke ratio", value: $recovery, in: 1...6).labelsHidden()
                }
                Spacer()
            }
        }.padding()
    }
    
}

struct MainTimerView_Previews: PreviewProvider {
    static var previews: some View {
        MainTimerView()
    }
}
