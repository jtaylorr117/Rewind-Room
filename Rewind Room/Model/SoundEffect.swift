//
//  SoundEffect.swift
//  Rewind Room
//
//  Created by John Taylor on 4/15/25.
//

struct SoundEffect: Decodable{
    let id: Int
    let fileName: String
    let soundType: String
    let label: String
    let icon: String
    let audioFile: String
    let isPremiumSound: Bool
}
