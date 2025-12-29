import Foundation

enum SampleData {
    static var words: [Word] = [
        Word(german: "Hallo", translation: "Hello", partOfSpeech: "interjection"),
        Word(german: "Danke", translation: "Thank you", partOfSpeech: "interjection"),
        Word(german: "Haus", translation: "House", partOfSpeech: "noun"),
        Word(german: "laufen", translation: "to walk/run", partOfSpeech: "verb"),
        Word(german: "Buch", translation: "Book", partOfSpeech: "noun", isFavorite: true)
    ]
}
