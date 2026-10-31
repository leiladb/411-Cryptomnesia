import Foundation

enum MediaType: String, CaseIterable {
    case movie = "Movie"
    case book = "Book"
    case music = "Music"
    case show = "Show"

    var symbolName: String {
        switch self {
        case .movie: return "film"
        case .book: return "book"
        case .music: return "music.note"
        case .show: return "tv"
        }
    }
}

struct MediaItem {
    var title: String
    var type: MediaType
    var rating: Int          // 1...5
    var notes: String
    var date: String
    var isShared: Bool
}

struct Friend {
    var name: String
    var recentActivity: String
}

// Hard-coded sample data for Milestone 1
enum SampleData {
    static var items: [MediaItem] = [
        MediaItem(title: "Dune: Part Two", type: .movie, rating: 5,
                  notes: "Incredible visuals and sound design.", date: "Oct 12, 2026", isShared: true),
        MediaItem(title: "Project Hail Mary", type: .book, rating: 5,
                  notes: "Couldn't put it down.", date: "Oct 3, 2026", isShared: true),
        MediaItem(title: "Currents - Tame Impala", type: .music, rating: 4,
                  notes: "Great for late night drives.", date: "Sep 28, 2026", isShared: false),
        MediaItem(title: "Arcane", type: .show, rating: 5,
                  notes: "Animation is unreal.", date: "Sep 15, 2026", isShared: true),
        MediaItem(title: "Everything Everywhere All at Once", type: .movie, rating: 4,
                  notes: "Chaotic in the best way.", date: "Aug 30, 2026", isShared: false)
    ]

    static let friends: [Friend] = [
        Friend(name: "Alex", recentActivity: "Finished Severance, Season 2"),
        Friend(name: "Jordan", recentActivity: "Listened to Blonde"),
        Friend(name: "Sam", recentActivity: "Read Piranesi"),
        Friend(name: "Taylor", recentActivity: "Watched Past Lives")
    ]
}
