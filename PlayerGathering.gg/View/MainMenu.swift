//
//  MainMenu.swift
//  PlayerGathering.gg
//
//  Created by SDV Bordeaux on 19/01/2024.
//

import SwiftUI

struct MainMenu: View {
    @State private var username = ""
    @State private var tag = ""
    
    @State private var puuid = ""
    @State private var isSheetOn = false
    
    @StateObject var playerModel = PlayerModel()
    
    var body: some View {
        VStack {
            Image("summonersrift")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            Text("PlayerGathering.gg")
                .font(.largeTitle)
                .bold()
            VStack {
                HStack {
                    TextField("Username", text: $username)
                        .padding(7)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 275)
                        .autocorrectionDisabled()
                    
                    TextField("TAG", text: $tag)
                        .padding(7)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .autocorrectionDisabled()
                }
                .padding()
                Button(action: {
                    Task {
                        await playerModel.fetchData(tagLine: tag, gameName: username)
                        if playerModel.statusCode == 200 {
                            print(playerModel.player)
                            print("\(username)#\(tag)")
                            isSheetOn.toggle()
                        }else {
                            print("Error")
                        }
                    }
                    
                }, label: {
                    Text("Search")
                })
                .padding(7)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 150)
                .sheet(isPresented: $isSheetOn, content: {
                    ProfileView(playerPuuid: playerModel.player, playerName: playerModel.playerName)
                })
                Spacer()
            }
        }
        
    }
}


#Preview {
    MainMenu()
}
