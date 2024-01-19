//
//  MatchInfo.swift
//  PlayerGathering.gg
//
//  Created by SDV Bordeaux on 18/01/2024.
//

import Foundation

struct Match: Codable {
    
    let metadata: [Metadata]
    
    struct Metadata: Codable {
        let matchID: String
        let participants: [String]
    }
    
    let info: [Info]
    
    struct Info: Codable {
        let gameCreation: CLong
        let gameDuration: CLong
        let gameEndTimeStamp: CLong
        let gameID: CLong
        let gameMode: String
        let gameStartTimeStamp: CLong
        let gameType: String
        let gameVersion: String
        let mapID: Int
        let participants: [Participants]
        
    }
    
    struct Participants: Codable {
        let assists: Int
        let champLevel: Int
        let championName: String
        let championTransform: Int
        let damageDealtToBuildings: Int
        let damageDealtToObjectives: Int
        let damageDealtToTurrets: Int
        let deaths: Int
        let item0: Int
        let item1: Int
        let item2: Int
        let item3: Int
        let item4: Int
        let item5: Int
        let item6: Int
        let kills: Int
        let lane: String
        let magicDamageDealt: Int
        let neutralMinionsKilles: Int
        let pentaKills: Int
        let perks: [Perks]
        let physicalDamageDealtToChampions: Int
        let puuid: String
        let riotIdName: String
        let riotIdTagline: String
        let teamID: Int
        let teamPosition: String
        let totalDamageDealtToChampions: Int
        let totalDamageShieldedToChampions: Int
        let totalDamageTaken: Int
        let totalHeal: Int
        let totalHealsOnTeammates: Int
        let totalMinionsKilled: Int
        let trueDamageDealtToChampions: Int
        let visionScore: Int
        let win: Bool
        
    }
    
    struct Perks: Codable {
        let styles: [Styles]
        
        struct Styles: Codable {
            let description: String
            let selections: [Selections]
            let style: Int
            
            struct Selections: Codable {
                let perk: Int
                let var1: Int
                let var2: Int
                let var3: Int
            }
        }
        
    }
}
