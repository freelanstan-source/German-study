import Foundation

enum Level: String, CaseIterable, Codable, Identifiable {
    case A1, A2, B1, B2, C1, C2

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .A1: return "A1 — Початковий"
        case .A2: return "A2 — Базовий"
        case .B1: return "B1 — Середній"
        case .B2: return "B2 — Вище середнього"
        case .C1: return "C1 — Просунутий"
        case .C2: return "C2 — Вільне володіння"
        }
    }
}