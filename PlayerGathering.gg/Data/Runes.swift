import Foundation

// MARK: - Perks
struct Perks: Codable {
    let id: Int
    let key, icon, name: String
    let slots: [Slots]
}

// MARK: - Slot
struct Slots: Codable {
    let runes: [Runes]
}

// MARK: - Rune
struct Runes: Codable {
    let id: Int
    let key, icon, name, shortDesc: String
    let longDesc: String
}