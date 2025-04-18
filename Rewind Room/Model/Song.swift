//
//  Song.swift
//  Rewind Room
//
//  Created by John Taylor on 4/15/25.
//
import Foundation

struct Song: Decodable {
    let id: UUID
    let title: String
    let date: String?
    let public_domain: Bool?
    let source_url: String?
    let audio_url: String
    let art_url: String
}
