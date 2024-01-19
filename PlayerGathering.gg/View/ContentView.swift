//
//  ContentView.swift
//  PlayerGathering.gg
//
//  Created by SDV Bordeaux on 18/01/2024.
//

import SwiftUI

struct ContentView: View {
    //MARK: PROPERTIES
    @StateObject var lastMatchesModel = LastMatchesModel()
    @StateObject var matchModel = MatchModel()
    
    var body: some View {
        //MARK: BODY
        NavigationStack {
            VStack {
                Image("ahri")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 30)
                    .clipShape(Circle())
                Text("Akariiinnn")
                    .font(.largeTitle)
            }//:VStack
            
            List{
                ForEach(lastMatchesModel.matches, id: \.self) { match in
                    HStack {
                        VStack {
                            Image("MonkeyKing_0")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .aspectRatio(contentMode: .fit)
                                .shadow(radius: 30)
                                .clipShape(Circle())
                            HStack {
                                Image("flash")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .aspectRatio(contentMode: .fit)
                                Image("ignite")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        VStack {
                            Image("Conqueror")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fit)
                                .shadow(radius: 30)
                                .clipShape(Circle())
                            Image("inspiration")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fit)
                                .shadow(radius: 30)
                                .clipShape(Circle())
                        }//:VStack
                        VStack {
                            Text("15/0/12")
                            Text("Perfect KDA")
                            Text("25 Vision")
                            Text(match)
                        }
                        
                    }//:HStack
                    .task{
                        await matchModel.fetchData(matchID: match)
                    }

                }
            }
        }//:NavigationStack
        .task {
            await lastMatchesModel.fetchData(riotpuuid: "EbJAzr1Nxzqh_Z5DeiJMuUxcsZrJlbd7uzgdnCfPbyEJA82jUyVQqewSfahV1uM8bdNSLf9hB1XbBw")
        }
        
    }
}

#Preview {
    ContentView()
}
