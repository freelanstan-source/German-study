import Foundation

class DataManager: ObservableObject {
    @Published var grammarTopics: [GrammarTopic] = []
    @Published var vocabularyWords: [VocabularyWord] = []
    
    init() {
        loadGrammarTopics()
        loadVocabularyWords()
    }
    
    private func loadGrammarTopics() {
        grammarTopics = [
            // A1 Level
            GrammarTopic(
                title: "Артиклі (der, die, das)",
                explanation: "В німецькій мові існує три артиклі: der (чоловічий рід), die (жіночий рід), das (середній рід). Артиклі використовуються перед іменниками та вказують на їх рід.",
                examples: [
                    "der Mann (чоловік) - чоловічий рід",
                    "die Frau (жінка) - жіночий рід",
                    "das Kind (дитина) - середній рід"
                ],
                level: .a1
            ),
            GrammarTopic(
                title: "Дієслова в теперішньому часі",
                explanation: "Дієслова в німецькій мові змінюються за особами та числами. Основна форма дієслова закінчується на -en.",
                examples: [
                    "ich lerne (я вивчаю)",
                    "du lernst (ти вивчаєш)",
                    "er/sie/es lernt (він/вона/воно вивчає)"
                ],
                level: .a1
            ),
            GrammarTopic(
                title: "Прийменники",
                explanation: "Прийменники в німецькій мові використовуються для вираження просторових та часових відносин.",
                examples: [
                    "in der Schule (в школі)",
                    "auf dem Tisch (на столі)",
                    "um 8 Uhr (о 8 годині)"
                ],
                level: .a1
            ),
            
            // A2 Level
            GrammarTopic(
                title: "Минулий час (Perfekt)",
                explanation: "Perfekt - це складений минулий час, який утворюється за допомогою допоміжного дієслова haben або sein та дієприкметника минулого часу.",
                examples: [
                    "Ich habe gelernt (Я вивчив)",
                    "Er ist gegangen (Він пішов)",
                    "Wir haben gegessen (Ми поїли)"
                ],
                level: .a2
            ),
            GrammarTopic(
                title: "Прикметники",
                explanation: "Прикметники в німецькій мові змінюються за родом, числом та відмінком. Вони можуть стояти перед іменником або після дієслова.",
                examples: [
                    "ein großer Mann (великий чоловік)",
                    "eine schöne Frau (красива жінка)",
                    "Das Buch ist interessant (Книга цікава)"
                ],
                level: .a2
            ),
            
            // B1 Level
            GrammarTopic(
                title: "Умовний спосіб (Konjunktiv II)",
                explanation: "Konjunktiv II використовується для вираження нереальних або гіпотетичних ситуацій, побажань та вежливості.",
                examples: [
                    "Ich würde gerne reisen (Я б хотів подорожувати)",
                    "Wenn ich Zeit hätte... (Якби у мене був час...)",
                    "Könntest du mir helfen? (Чи міг би ти мені допомогти?)"
                ],
                level: .b1
            ),
            GrammarTopic(
                title: "Пасивний стан (Passiv)",
                explanation: "Пасивний стан утворюється за допомогою дієслова werden та дієприкметника минулого часу. Використовується, коли важливіше дія, ніж той, хто її виконує.",
                examples: [
                    "Das Buch wird gelesen (Книгу читають)",
                    "Das Haus wurde gebaut (Будинок було збудовано)",
                    "Der Brief ist geschrieben worden (Лист було написано)"
                ],
                level: .b1
            ),
            
            // B2 Level
            GrammarTopic(
                title: "Складні речення з підрядними",
                explanation: "В німецькій мові підрядні речення завжди починаються з сполучника або займенника, а дієслово ставиться в кінець речення.",
                examples: [
                    "Ich weiß, dass du kommst (Я знаю, що ти прийдеш)",
                    "Wenn es regnet, bleibe ich zu Hause (Якщо дощить, я залишаюся вдома)",
                    "Obwohl es spät ist, arbeite ich noch (Хоча пізно, я ще працюю)"
                ],
                level: .b2
            ),
            
            // C1 Level
            GrammarTopic(
                title: "Інфінітивні конструкції",
                explanation: "Інфінітивні конструкції використовуються для вираження мети, наміру або можливості. Часто використовуються з дієсловами lassen, helfen, lehren.",
                examples: [
                    "Ich helfe dir, das zu verstehen (Я допомагаю тобі це зрозуміти)",
                    "Es ist wichtig, regelmäßig zu üben (Важливо регулярно тренуватися)",
                    "Ich lasse das Auto reparieren (Я даю поремонтувати автомобіль)"
                ],
                level: .c1
            ),
            
            // C2 Level
            GrammarTopic(
                title: "Стилістичні особливості та ідіоми",
                explanation: "На найвищому рівні важливо розуміти стилістичні особливості, ідіоми та культурні контексти німецької мови.",
                examples: [
                    "Das ist nicht mein Bier (Це не моя справа)",
                    "Ich verstehe nur Bahnhof (Я нічого не розумію)",
                    "Das ist ein alter Hut (Це стара новина)"
                ],
                level: .c2
            )
        ]
    }
    
    private func loadVocabularyWords() {
        vocabularyWords = [
            // A1 Level - Basic words
            VocabularyWord(
                german: "Haus",
                ukrainian: "будинок",
                english: "house",
                level: .a1,
                partOfSpeech: "существительное",
                example: "Das ist mein Haus."
            ),
            VocabularyWord(
                german: "Buch",
                ukrainian: "книга",
                english: "book",
                level: .a1,
                partOfSpeech: "существительное",
                example: "Ich lese ein Buch."
            ),
            VocabularyWord(
                german: "lernen",
                ukrainian: "вивчати",
                english: "to learn",
                level: .a1,
                partOfSpeech: "глагол",
                example: "Ich lerne Deutsch."
            ),
            VocabularyWord(
                german: "groß",
                ukrainian: "великий",
                english: "big",
                level: .a1,
                partOfSpeech: "прилагательное",
                example: "Das ist ein großes Auto."
            ),
            VocabularyWord(
                german: "klein",
                ukrainian: "малий",
                english: "small",
                level: .a1,
                partOfSpeech: "прилагательное",
                example: "Das Kind ist klein."
            ),
            
            // A2 Level
            VocabularyWord(
                german: "Reise",
                ukrainian: "подорож",
                english: "journey",
                level: .a2,
                partOfSpeech: "существительное",
                example: "Ich plane eine Reise."
            ),
            VocabularyWord(
                german: "verstehen",
                ukrainian: "розуміти",
                english: "to understand",
                level: .a2,
                partOfSpeech: "глагол",
                example: "Ich verstehe dich."
            ),
            
            // B1 Level
            VocabularyWord(
                german: "Entscheidung",
                ukrainian: "рішення",
                english: "decision",
                level: .b1,
                partOfSpeech: "существительное",
                example: "Das ist eine wichtige Entscheidung."
            ),
            VocabularyWord(
                german: "verantwortlich",
                ukrainian: "відповідальний",
                english: "responsible",
                level: .b1,
                partOfSpeech: "прилагательное",
                example: "Er ist verantwortlich für das Projekt."
            ),
            
            // B2 Level
            VocabularyWord(
                german: "Herausforderung",
                ukrainian: "виклик",
                english: "challenge",
                level: .b2,
                partOfSpeech: "существительное",
                example: "Das ist eine große Herausforderung."
            ),
            VocabularyWord(
                german: "beeindruckend",
                ukrainian: "вражаючий",
                english: "impressive",
                level: .b2,
                partOfSpeech: "прилагательное",
                example: "Das war beeindruckend."
            ),
            
            // C1 Level
            VocabularyWord(
                german: "Selbstverständnis",
                ukrainian: "самоусвідомлення",
                english: "self-understanding",
                level: .c1,
                partOfSpeech: "существительное",
                example: "Das ist wichtig für das Selbstverständnis."
            ),
            VocabularyWord(
                german: "unverzichtbar",
                ukrainian: "незамінний",
                english: "indispensable",
                level: .c1,
                partOfSpeech: "прилагательное",
                example: "Das ist unverzichtbar."
            ),
            
            // C2 Level
            VocabularyWord(
                german: "Weltanschauung",
                ukrainian: "світогляд",
                english: "worldview",
                level: .c2,
                partOfSpeech: "существительное",
                example: "Das prägt seine Weltanschauung."
            ),
            VocabularyWord(
                german: "unvergleichlich",
                ukrainian: "непорівнянний",
                english: "incomparable",
                level: .c2,
                partOfSpeech: "прилагательное",
                example: "Das ist unvergleichlich schön."
            )
        ]
    }
    
    func getGrammarTopics(for level: LanguageLevel) -> [GrammarTopic] {
        return grammarTopics.filter { $0.level == level }
    }
    
    func getVocabularyWords(for level: LanguageLevel) -> [VocabularyWord] {
        return vocabularyWords.filter { $0.level == level }
    }
    
    func getDailyWords(for level: LanguageLevel, count: Int = 5) -> [VocabularyWord] {
        let levelWords = getVocabularyWords(for: level)
        return Array(levelWords.shuffled().prefix(count))
    }
    
    func getWordsForReview(for level: LanguageLevel) -> [VocabularyWord] {
        let levelWords = getVocabularyWords(for: level)
        return levelWords.filter { word in
            if let lastReviewed = word.lastReviewed {
                let calendar = Calendar.current
                let daysSinceReview = calendar.dateComponents([.day], from: lastReviewed, to: Date()).day ?? 0
                return daysSinceReview >= 1
            }
            return false
        }
    }
}