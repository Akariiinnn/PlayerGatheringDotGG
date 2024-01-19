//
//  MatchInfo.swift
//  PlayerGathering.gg
//
//  Created by SDV Bordeaux on 18/01/2024.
//

import Foundation

struct Metadata: Codable {
    let matchId: String
    let participants: [String]
}

struct Info: Codable {
    let gameCreation: CLong
    let gameDuration: CLong
    let gameEndTimestamp: CLong
    let gameId: CLong
    let gameMode: String
    let gameStartTimestamp: CLong
    let gameType: String
    let gameVersion: String
    let mapId: Int
    let participants: [Participants]
    
    struct Participants: Codable {
        let assists: Int
        let champLevel: Int
        let championName: String
        let championId: Int
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
        let neutralMinionsKilled: Int
        let pentaKills: Int
        let perks: Perks
        let physicalDamageDealtToChampions: Int
        let puuid: String
        let profileIcon: Int
        let riotIdGameName: String
        let riotIdTagline: String
        let teamId: Int
        let teamPosition: String
        let totalDamageDealtToChampions: Int
        let totalDamageShieldedOnTeammates: Int
        let totalDamageTaken: Int
        let totalHeal: Int
        let totalHealsOnTeammates: Int
        let totalMinionsKilled: Int
        let trueDamageDealtToChampions: Int
        let visionScore: Int
        let win: Bool
        
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
}

struct MatchResponse : Codable {
    let metadata: Metadata
    let info: Info
}
