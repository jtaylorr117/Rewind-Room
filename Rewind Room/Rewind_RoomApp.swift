//
//  Rewind_RoomApp.swift
//  Rewind Room
//
//  Created by John Taylor on 4/14/25.
//

import SwiftUI
import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://todrsnszvxvwmrdushjj.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRvZHJzbnN6dnh2d21yZHVzaGpqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ3NDM5NzAsImV4cCI6MjA2MDMxOTk3MH0.0tKY25kxrFxdkuCH9lDN-PzzL1AdBTokzfu1XNoSvYU"
)

@main
struct Rewind_RoomApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
