//
//  ContentView.swift
//  No Gank
//
//  Created by Alan Yan on 2020-08-21.
//

import SwiftUI

struct ConnectedView: View {
    @ObservedObject var viewModel = ConnectedViewModel()
    var body: some View {
        VStack {
            Text(viewModel.isSendable ? "Tracking" : "Instructions")
                .bold()
                .font(.system(size: 28, weight: .heavy, design: .default))
                .padding(.bottom, 20)
            if !viewModel.isSendable {

            
            VStack(alignment: .leading, spacing: 10) {
                (Text("1. ").bold() + Text("Secure your phone to the door")).font(.system(size: 18))
                
                (Text("2. ").bold() + Text("Close the door")).font(.system(size: 18))
                
                (Text("3. ").bold() + Text("Click \"Start Detecting\"")).font(.system(size: 18))
                
                (Text("4. ").bold() + Text("Use your computer as normal")).font(.system(size: 18))
            }
            .padding(.bottom, 30)
            }
            
            Text(viewModel.isSendable ? "Stop Detecting" : "Start Detecting")
                .bold()
                .font(.system(size: 16, weight: .semibold, design: .default))
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(!viewModel.isSendable ? Color.green : Color.red)
                .cornerRadius(8)
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    withAnimation(.easeInOut) {
                        viewModel.isSendable.toggle()
                    }
                })
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedView()
    }
}
