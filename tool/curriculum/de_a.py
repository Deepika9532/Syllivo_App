"""German A1 and A2."""
from dsl import *

ALIGN = "Oriented to CEFR {0} descriptors. Practice content, not an official certification."


def a1():
    m = {}
    m["vocabulary"] = lesson("At home & describing things",
        "Rooms, furniture, colours and size adjectives. Always learn a noun with its article.",
        [tip("German nouns are always capitalised and have a gender: der (masculine), die (feminine) or das (neuter). Learn them as a pair: der Tisch, not just Tisch."),
         voc(("das Haus", "house", "hows"), ("die Wohnung", "flat / apartment", "VOH-nung"),
             ("das Zimmer", "room", "TSIM-mer"), ("die Küche", "kitchen", "KÜ-khe"),
             ("der Tisch", "table", "tish"), ("der Stuhl", "chair", "shtool"),
             ("das Bett", "bed", "bet"), ("rot", "red", "roht"), ("blau", "blue", "blow"),
             ("grün", "green", "grün"), ("groß", "big, tall", "grohs"), ("klein", "small", "kline", "Die Küche ist klein."))],
        [mcq("Was bedeutet „die Küche“?", ["bedroom", "kitchen", "bathroom"], 1, "die Küche = the kitchen."),
         match([("der Tisch", "table"), ("der Stuhl", "chair"), ("das Bett", "bed"), ("das Zimmer", "room")]),
         fill("Das Haus ist ___. (big)", ["groß", "gross"], "groß = big. ß can be written ss when you have no ß key."),
         mcq("Which article? ___ Zimmer", ["der", "die", "das"], 2, "Zimmer is neuter: das Zimmer."),
         mcq("What colour is grass?", ["rot", "blau", "grün"], 2, "Gras ist grün.")])

    m["grammar"] = lesson("Articles, pronouns and the present tense",
        "der/die/das, ein/eine, personal pronouns, and regular verbs plus sein in the present tense.",
        [txt("Every noun has a gender. The definite article (the) is der, die or das; the indefinite article (a) is ein (masculine/neuter) or eine (feminine)."),
         tbl(["Gender", "the", "a"], ["masculine", "der Tisch", "ein Tisch"], ["feminine", "die Küche", "eine Küche"],
             ["neuter", "das Bett", "ein Bett"], ["plural", "die Tische", "– (no article)"]),
         txt("Regular verbs drop -en and add an ending for each person. sein (to be) is irregular and must be memorised."),
         tbl(["Pronoun", "wohnen (to live)", "kommen (to come)", "sein (to be)"],
             ["ich (I)", "wohne", "komme", "bin"], ["du (you, informal)", "wohnst", "kommst", "bist"],
             ["er / sie / es", "wohnt", "kommt", "ist"], ["wir (we)", "wohnen", "kommen", "sind"],
             ["ihr (you all)", "wohnt", "kommt", "seid"], ["sie / Sie (they / you formal)", "wohnen", "kommen", "sind"]),
         tip("In a statement the verb is always the second element: Ich wohne in Berlin. / In Berlin wohne ich."),
         ex("Woher kommst du?", "Where are you from?"), ex("Ich komme aus Indien.", "I come from India.")],
        [fill("Ich ___ in Berlin. (wohnen)", "wohne", "ich → -e: ich wohne."),
         fill("Du ___ sehr nett. (sein)", "bist", "du bist = you are."),
         mcq("Wir ___ aus Spanien.", ["kommt", "kommen", "komme"], 1, "wir → -en: wir kommen."),
         fix("Er kommen aus Indien.", "Er kommt aus Indien.", "er/sie/es takes -t: er kommt."),
         order("Woher kommst du ?", "Question words come first, then the verb.", "Where are you from?")])

    m["reading"] = lesson("Reading: Lena introduces herself",
        "A short personal profile. Read it, then answer the questions.",
        [psg("Lena stellt sich vor",
             "Hallo! Ich heiße Lena und ich bin 25 Jahre alt. Ich komme aus Hamburg, aber ich wohne jetzt in München. "
             "Ich bin Lehrerin. Meine Wohnung ist klein, aber schön. Am Wochenende spiele ich gern Tennis.",
             "Hello! My name is Lena and I am 25 years old. I come from Hamburg, but I live in Munich now. "
             "I am a teacher. My flat is small but nice. At the weekend I like playing tennis."),
         tip("„gern“ after a verb means you like doing it: Ich spiele gern Tennis = I like playing tennis.")],
        [mcq("Woher kommt Lena?", ["München", "Hamburg", "Berlin"], 1, "„Ich komme aus Hamburg“."),
         mcq("Was ist Lena von Beruf?", ["Ärztin", "Lehrerin", "Studentin"], 1, "„Ich bin Lehrerin“ = I am a (female) teacher."),
         mcq("Wie ist ihre Wohnung?", ["groß und alt", "klein, aber schön", "sehr teuer"], 1, "„Meine Wohnung ist klein, aber schön.“"),
         fill("Lena ist ___ Jahre alt.", ["25", "fünfundzwanzig"], "She says „ich bin 25 Jahre alt“.")])

    m["writing"] = lesson("Writing: introduce yourself",
        "Build a short self-introduction from fixed sentence patterns.",
        [txt("Use these patterns and replace the words in brackets."),
         ex("Ich heiße [Name].", "My name is …"), ex("Ich komme aus [Land].", "I come from …"),
         ex("Ich wohne in [Stadt].", "I live in …"), ex("Ich bin Student / Studentin.", "I am a student (m / f)."),
         ex("In meiner Freizeit spiele ich gern [Hobby].", "In my free time I like playing …"),
         tip("Jobs have a masculine and feminine form: Lehrer / Lehrerin, Arzt / Ärztin. No article: Ich bin Lehrer.")],
        [write("Write 3–5 sentences about yourself: your name, where you come from, where you live and a hobby.", 15,
               ["ich", "heiße|bin", "komme|wohne"],
               "Ich heiße Ravi. Ich komme aus Indien und wohne in Hyderabad. Ich bin Student. In meiner Freizeit spiele ich gern Cricket."),
         fill("Ich ___ aus Indien. (kommen)", "komme", "ich komme."),
         order("Ich wohne in Hyderabad .", "Subject – verb – place.", "I live in Hyderabad."),
         mcq("A female doctor says:", ["Ich bin ein Arzt.", "Ich bin Ärztin.", "Ich bin die Ärztin."], 1, "No article with professions, and the female form ends in -in.")])

    m["listening"] = lesson("Listening: time, prices and orders",
        "Listen for numbers and key words. Tap play as often as you like.",
        [ex("Es ist drei Uhr.", "It is 3:00."),
         ex("Es ist halb vier.", "It is 3:30.", note="halb vier = half (way) to four"),
         ex("Das kostet zwölf Euro.", "That costs 12 euros."),
         tip("Careful: „halb drei“ is 2:30, not 3:30. German counts toward the next hour."),
         voc(("dreizehn", "13"), ("vierzehn", "14"), ("fünfzehn", "15"), ("sechzehn", "16"),
             ("siebzehn", "17"), ("achtzehn", "18"), ("neunzehn", "19"), ("zwanzig", "20"))],
        [listen("Es ist halb drei.", "Wie spät ist es?", ["3:30", "2:30", "3:00"], 1, "halb drei = half to three = 2:30."),
         listen("Das kostet achtzehn Euro.", "Wie viel kostet das?", ["8 €", "18 €", "80 €"], 1, "achtzehn = 18."),
         listen("Ich möchte einen Kaffee und ein Wasser, bitte.", "What does the person order?",
                ["coffee and water", "tea and water", "coffee and juice"], 0, "einen Kaffee und ein Wasser."),
         listen("Meine Telefonnummer ist null eins fünf sieben.", "Which digits do you hear?", ["0157", "0175", "0517"], 0,
                "null – eins – fünf – sieben.")])

    m["speaking"] = lesson("Speaking: everyday phrases",
        "Say useful sentences aloud. Listen first, then record yourself.",
        [dlg("Formal and informal greetings",
             ("A", "Guten Tag, Frau Weber! Wie geht es Ihnen?", "Good afternoon, Ms Weber! How are you? (formal)"),
             ("B", "Danke, gut. Und Ihnen?", "Fine, thanks. And you?"),
             ("C", "Hi Tim, wie geht's dir?", "Hi Tim, how are you? (informal)"),
             ("D", "Super, danke!", "Great, thanks!")),
         tip("Use Sie (formal) with strangers, officials and at work; du with friends, family and children.")],
        [speak("Ich komme aus Indien.", "I come from India."),
         speak("Wie geht es Ihnen?", "How are you? (formal)"),
         speak("Ich möchte ein Wasser, bitte.", "I would like a water, please."),
         mcq("Which is the formal “How are you?”", ["Wie geht's dir?", "Wie geht es Ihnen?", "Wie heißt du?"], 1,
             "Ihnen is the formal form; dir is informal.")])

    m["pronunciation"] = lesson("German sounds: umlauts, ch, ß, ei and ie",
        "The sounds English speakers find hardest, with a reliable rule for each.",
        [tbl(["Spelling", "How to say it", "Example"],
             ["ä", "like e in “bed”", "Mädchen (girl)"], ["ö", "say “e” with rounded lips", "schön (beautiful)"],
             ["ü", "say “ee” with rounded lips", "Brücke (bridge)"], ["ch after e, i", "soft hiss, like a whispered “h”", "ich (I)"],
             ["ch after a, o, u", "from the throat, like Scottish “loch”", "Buch (book)"], ["ß / ss", "a sharp s", "Straße (street)"],
             ["ei", "like “eye”", "Wein (wine)"], ["ie", "like “ee”", "Wien (Vienna)"],
             ["w", "like English v", "Wasser (water)"], ["v", "usually like f", "Vater (father)"], ["z", "ts", "Zeit (time)"]),
         tip("Trick for ei / ie: say the SECOND letter’s English name. ei → “eye” (i), ie → “ee” (e).")],
        [pron("schön", "beautiful"), pron("Brücke", "bridge"), pron("ich", "I"),
         pron("Wein", "wine"), pron("Wien", "Vienna"),
         mcq("How is „ei“ in „Wein“ pronounced?", ["like “ee” in see", "like “eye”", "like “ay” in day"], 1,
             "ei sounds like the English word “eye”."),
         mcq("Which word has the throat „ch“ sound?", ["ich", "Buch", "nicht"], 1, "After a, o, u: Buch, Bach, noch.")])

    m["conversation"] = lesson("Conversation: at the café",
        "Order, ask for the bill and pay.",
        [dlg("Im Café",
             ("Kellner", "Guten Tag! Was möchten Sie?", "Hello! What would you like?"),
             ("Gast", "Ich möchte einen Kaffee, bitte.", "I'd like a coffee, please."),
             ("Kellner", "Mit Milch?", "With milk?"),
             ("Gast", "Ja, gern. Und ein Stück Kuchen.", "Yes, please. And a piece of cake."),
             ("Kellner", "Das macht sechs Euro fünfzig.", "That comes to €6.50."),
             ("Gast", "Hier, bitte. Stimmt so.", "Here you are. Keep the change.")),
         tip("„Stimmt so“ = keep the change. Tipping 5–10 % is common in German cafés.")],
        [mcq("The waiter asks „Mit Milch?“ Best reply:", ["Ja, gern.", "Ich heiße Paul.", "Es ist drei Uhr."], 0, "Ja, gern = yes, please."),
         order("Ich möchte einen Kaffee , bitte .", tr="I'd like a coffee, please."),
         mcq("„Das macht sechs Euro fünfzig“ means:", ["That's €6.50", "It's 6:50", "Six coffees"], 0, "Das macht … = that comes to …"),
         fill("Ich ___ einen Kuchen, bitte. (would like)", "möchte", "ich möchte = I would like.")])

    m["exercises"] = lesson("Mixed practice: A1 foundations",
        "Pronouns, sein, articles and simple questions together.",
        [tip("Review before you start: verb in position 2, sein is irregular (bin, bist, ist, sind, seid, sind), and nouns carry an article."),
         tbl(["Question word", "Meaning"], ["Wer?", "Who?"], ["Was?", "What?"], ["Wo?", "Where?"], ["Woher?", "Where from?"], ["Wie?", "How?"], ["Wann?", "When?"])],
        [match([("ich", "bin"), ("du", "bist"), ("er", "ist"), ("wir", "sind")], "The forms of sein."),
         trans("I am tired.", ["Ich bin müde."], "müde = tired."),
         trans("Where do you live?", ["Wo wohnst du?", "Wo wohnen Sie?"], "Wo = where; wohnen = to live."),
         fill("___ Frau heißt Maria. (The)", "Die", "Frau is feminine: die Frau."),
         order("Wie heißt du ?", tr="What's your name?")])

    m["quiz"] = lesson("A1 quiz",
        "Five quick questions across the level.",
        [tip("Answer from memory first, then read the explanation for anything you missed.")],
        [mcq("Which article? ___ Tisch", ["der", "die", "das"], 0, "der Tisch (masculine)."),
         mcq("„Entschuldigung“ means:", ["Thank you", "Excuse me / sorry", "Goodbye"], 1, "Use it to get attention or apologise."),
         mcq("Plural of „das Kind“:", ["die Kinds", "die Kinder", "die Kinden"], 1, "das Kind → die Kinder."),
         mcq("„Es ist halb zehn“ is:", ["10:30", "9:30", "10:00"], 1, "halb zehn = half to ten = 9:30."),
         mcq("Which question is correct?", ["Woher kommst du?", "Woher du kommst?", "Du woher kommst?"], 0, "Question word + verb + subject.")])

    exam = [
        mcq("Which article? ___ Wohnung", ["der", "die", "das"], 1, "die Wohnung.", skill="vocabulary"),
        mcq("„klein“ is the opposite of:", ["groß", "rot", "neu"], 0, "klein ↔ groß.", skill="vocabulary"),
        fill("Ihr ___ aus Kanada. (sein)", "seid", "ihr seid.", skill="grammar"),
        fill("Sie ___ in Köln. (she lives: wohnen)", "wohnt", "sie (she) → wohnt.", skill="grammar"),
        fix("Ich bist Student.", "Ich bin Student.", "ich bin.", skill="grammar"),
        mcq("Read: „Tom ist 30. Er kommt aus Dublin und arbeitet als Koch in Wien.“ Where does Tom work?",
            ["Dublin", "Wien", "Köln"], 1, "„arbeitet … in Wien“.", skill="reading"),
        mcq("Read: „Tom ist 30. Er kommt aus Dublin und arbeitet als Koch in Wien.“ What is his job?",
            ["cook", "teacher", "doctor"], 0, "Koch = cook.", skill="reading"),
        listen("Es ist Viertel nach acht.", "Wie spät ist es?", ["8:15", "7:45", "8:45"], 0, "Viertel nach acht = quarter past eight.", skill="listening"),
        listen("Ein Tee kostet zwei Euro vierzig.", "How much is the tea?", ["€2.40", "€4.20", "€2.14"], 0, "zwei Euro vierzig.", skill="listening"),
        trans("My name is Anna.", ["Ich heiße Anna.", "Mein Name ist Anna."], "Ich heiße … / Mein Name ist …", skill="writing"),
        order("Wo wohnst du ?", "Question word – verb – subject.", "Where do you live?", skill="writing"),
        mcq("In a shop, how do you ask the price?", ["Wie viel kostet das?", "Wie heißt das?", "Wo ist das?"], 0, "Wie viel kostet das?", skill="conversation"),
    ]
    return level("de", "A1", 1, "Beginner",
                 "Greetings, introductions, numbers and time, home and food. Articles, pronouns and the present tense.",
                 ALIGN.format("A1"),
                 ["Alphabet & pronunciation", "Greetings & introductions", "Numbers, dates & time", "Family", "Food & drinks",
                  "Articles der/die/das", "Personal pronouns", "Present tense", "Questions & answers"], m, exam)


def a2():
    m = {}
    m["vocabulary"] = lesson("Daily routine & shopping",
        "Words for your day, appointments and buying things.",
        [voc(("aufstehen", "to get up (separable)", "OWF-shtay-en", "Ich stehe um 7 Uhr auf."),
             ("frühstücken", "to have breakfast"), ("einkaufen", "to go shopping (separable)"),
             ("die Kasse", "checkout / till"), ("das Angebot", "special offer"),
             ("billig", "cheap"), ("teuer", "expensive", "TOY-er"), ("der Termin", "appointment"),
             ("pünktlich", "on time"), ("anprobieren", "to try on (clothes)"), ("die Größe", "size"),
             ("umtauschen", "to exchange (an item)")),
         tip("Separable verbs split in the present tense: aufstehen → Ich stehe … auf. The prefix goes to the end.")],
        [mcq("„teuer“ is the opposite of:", ["billig", "groß", "pünktlich"], 0, "teuer (expensive) ↔ billig (cheap)."),
         match([("die Kasse", "checkout"), ("der Termin", "appointment"), ("die Größe", "size"), ("das Angebot", "special offer")]),
         fill("Ich stehe um sieben Uhr ___. (aufstehen)", "auf", "The separable prefix auf goes to the end."),
         mcq("Wo bezahlt man im Supermarkt?", ["an der Kasse", "im Angebot", "in der Größe"], 0, "an der Kasse = at the checkout.")])

    m["grammar"] = lesson("Modal verbs, accusative and dative",
        "Say what you can, must and want to do, and choose the right case.",
        [tbl(["", "können (can)", "müssen (must)", "wollen (want)", "dürfen (may)"],
             ["ich", "kann", "muss", "will", "darf"], ["du", "kannst", "musst", "willst", "darfst"],
             ["er/sie/es", "kann", "muss", "will", "darf"], ["wir/sie/Sie", "können", "müssen", "wollen", "dürfen"]),
         txt("A modal verb stands in position 2; the main verb goes to the END in the infinitive: Ich muss heute arbeiten."),
         tbl(["Case", "masc.", "fem.", "neut.", "plural"], ["Nominative (subject)", "der", "die", "das", "die"],
             ["Accusative (direct object)", "den", "die", "das", "die"], ["Dative (indirect object)", "dem", "der", "dem", "den (+n)"]),
         tip("Always dative after: aus, bei, mit, nach, seit, von, zu. Always accusative after: durch, für, gegen, ohne, um.")],
        [fill("Ich ___ heute nicht kommen. (können)", "kann", "ich kann; the infinitive kommen goes to the end."),
         mcq("Ich sehe ___ Mann.", ["der", "den", "dem"], 1, "sehen takes a direct object → accusative den."),
         mcq("Ich fahre mit ___ Bus.", ["der", "den", "dem"], 2, "mit + dative: dem Bus."),
         fix("Ich muss morgen arbeite.", "Ich muss morgen arbeiten.", "After a modal verb: infinitive (arbeiten) at the end."),
         order("Kannst du mir helfen ?", tr="Can you help me?")])

    m["reading"] = lesson("Reading: an email from Vienna",
        "An informal email about a trip, using the perfect tense and comparisons.",
        [psg("E-Mail von Jonas",
             "Liebe Sara, wie geht es dir? Letzte Woche bin ich nach Wien gefahren. Die Stadt ist schöner als Berlin, finde ich! "
             "Am Samstag habe ich das Schloss Schönbrunn besucht und am Abend haben wir in einem Restaurant gegessen. "
             "Das Essen war sehr lecker, aber teurer als in Berlin. Nächsten Monat möchte ich dich besuchen. Hast du Zeit? Viele Grüße, Jonas",
             "Dear Sara, how are you? Last week I went to Vienna. The city is more beautiful than Berlin, I think! On Saturday I visited "
             "Schönbrunn Palace and in the evening we ate in a restaurant. The food was very tasty but more expensive than in Berlin. "
             "Next month I'd like to visit you. Do you have time? Best wishes, Jonas")],
        [mcq("Wohin ist Jonas gefahren?", ["Berlin", "Wien", "Salzburg"], 1, "„bin ich nach Wien gefahren“."),
         mcq("Was hat er am Samstag besucht?", ["ein Museum", "das Schloss Schönbrunn", "einen Freund"], 1, "„habe ich das Schloss Schönbrunn besucht“."),
         mcq("Wie war das Essen?", ["billig und schlecht", "lecker, aber teurer als in Berlin", "nicht lecker"], 1, "„sehr lecker, aber teurer als in Berlin“."),
         mcq("Was möchte Jonas nächsten Monat machen?", ["Sara besuchen", "nach Wien fahren", "arbeiten"], 0, "„möchte ich dich besuchen“.")])

    m["writing"] = lesson("Writing: an informal email",
        "Greeting, past events in the perfect tense, a question and a closing.",
        [tbl(["Part", "Informal email"], ["Greeting", "Liebe Sara, / Lieber Tom, / Hallo Max,"],
             ["Opening", "Wie geht es dir?"], ["Past events", "Am Wochenende bin ich … gegangen / habe ich … gemacht."],
             ["Question", "Was hast du gemacht?"], ["Closing", "Viele Grüße / Liebe Grüße, [Name]"]),
         tip("Perfect tense = haben/sein + past participle at the end. Verbs of movement (gehen, fahren) use sein.")],
        [write("Write an email (5–7 sentences) to a friend about your last weekend. Use the perfect tense.", 35,
               ["liebe|lieber|hallo", "habe|bin", "grüße"],
               "Lieber Tom, wie geht es dir? Am Wochenende bin ich mit meiner Schwester ins Kino gegangen. Danach haben wir Pizza gegessen. "
               "Am Sonntag habe ich lange geschlafen und dann für die Prüfung gelernt. Was hast du gemacht? Liebe Grüße, Anna"),
         fill("Am Sonntag ___ ich lange geschlafen. (haben)", "habe", "schlafen takes haben: ich habe geschlafen."),
         mcq("Which closing is informal?", ["Mit freundlichen Grüßen", "Liebe Grüße", "Sehr geehrte Damen und Herren"], 1, "Liebe Grüße is for friends.")])

    m["listening"] = lesson("Listening: directions and announcements",
        "Understand directions in the street and announcements at the station.",
        [voc(("geradeaus", "straight ahead"), ("links abbiegen", "turn left"), ("rechts", "right"),
             ("die Ampel", "traffic lights"), ("die Kreuzung", "crossroads"), ("gegenüber", "opposite"), ("das Gleis", "platform / track")),
         ex("Gehen Sie geradeaus und dann die zweite Straße links.", "Go straight on and then take the second street on the left.")],
        [listen("Gehen Sie geradeaus bis zur Ampel und dann rechts.", "Where do you turn right?",
                ["at the traffic lights", "at the church", "at the station"], 0, "bis zur Ampel = as far as the traffic lights."),
         listen("Der Zug nach Köln fährt heute von Gleis sieben ab.", "Which platform?", ["1", "7", "11"], 1, "Gleis sieben."),
         listen("Die Apotheke ist gegenüber vom Bahnhof.", "Where is the pharmacy?",
                ["next to the station", "opposite the station", "behind the station"], 1, "gegenüber = opposite."),
         listen("Ich bin um acht Uhr aufgestanden und habe gefrühstückt.", "What did the speaker do?",
                ["got up at 8 and had breakfast", "went to work at 8", "had dinner at 8"], 0, "aufgestanden = got up; gefrühstückt = had breakfast.")])

    m["speaking"] = lesson("Speaking: shopping and asking for help",
        "Phrases for shops and the street.",
        [ex("Kann ich das anprobieren?", "Can I try this on?"), ex("Haben Sie das eine Nummer größer?", "Do you have this one size bigger?"),
         ex("Kann ich mit Karte zahlen?", "Can I pay by card?"), ex("Wie komme ich zum Bahnhof?", "How do I get to the station?")],
        [speak("Kann ich das anprobieren?", "Can I try this on?"),
         speak("Haben Sie das eine Nummer größer?", "Do you have this one size bigger?"),
         speak("Wie komme ich zum Bahnhof?", "How do I get to the station?"),
         mcq("You want to pay by card. You ask:", ["Kann ich mit Karte zahlen?", "Ich habe Karte.", "Wo ist die Karte?"], 0, "mit Karte zahlen = pay by card.")])

    m["pronunciation"] = lesson("Word stress and separable verbs",
        "Where the stress falls changes how natural you sound.",
        [txt("Most German words stress the first syllable: ARbeit, MORgen. Separable prefixes are stressed: ANrufen, AUFstehen, EINkaufen. "
             "Inseparable prefixes (be-, ver-, er-, ge-, ent-) are never stressed: beSUchen, verSTEhen."),
         tbl(["Separable (stressed prefix)", "Inseparable (unstressed prefix)"], ["ANrufen", "beSUchen"], ["AUFstehen", "verSTEhen"], ["EINkaufen", "erZÄHlen"])],
        [pron("anrufen", "to call"), pron("verstehen", "to understand"), pron("Ich stehe um sieben Uhr auf.", "I get up at seven."),
         mcq("Where is the stress in „einkaufen“?", ["EIN-kaufen", "ein-KAU-fen", "einkau-FEN"], 0, "Separable prefixes carry the stress.")])

    m["conversation"] = lesson("Conversation: ordering and paying in a restaurant",
        "A complete restaurant visit.",
        [dlg("Im Restaurant",
             ("Kellnerin", "Haben Sie schon gewählt?", "Have you decided?"),
             ("Gast", "Ja, ich nehme die Tomatensuppe und danach das Schnitzel.", "Yes, I'll have the tomato soup and then the schnitzel."),
             ("Kellnerin", "Und zu trinken?", "And to drink?"),
             ("Gast", "Eine Apfelschorle, bitte.", "An apple spritzer, please."),
             ("Gast", "Die Rechnung, bitte.", "The bill, please."),
             ("Kellnerin", "Zusammen oder getrennt?", "Together or separately?"),
             ("Gast", "Getrennt, bitte.", "Separately, please."))],
        [mcq("„Zusammen oder getrennt?“ asks whether you want to:", ["pay together or separately", "sit inside or outside", "eat now or later"], 0, "Common question when paying in groups."),
         order("Ich nehme die Tomatensuppe .", tr="I'll have the tomato soup."),
         mcq("Best reply to „Haben Sie schon gewählt?“", ["Ja, ich nehme das Schnitzel.", "Nein, ich bin müde.", "Ja, ich wähle Berlin."], 0, "nehmen = to have/take (when ordering)."),
         fill("Die ___, bitte. (bill)", "Rechnung", "die Rechnung = the bill.")])

    m["exercises"] = lesson("Mixed practice: perfect tense and comparison",
        "Talk about the past and compare things.",
        [tbl(["Infinitive", "Perfect"], ["machen", "hat gemacht"], ["spielen", "hat gespielt"], ["essen", "hat gegessen"],
             ["gehen", "ist gegangen"], ["fahren", "ist gefahren"], ["kommen", "ist gekommen"]),
         tbl(["Base", "Comparative", "Superlative"], ["gut", "besser", "am besten"], ["groß", "größer", "am größten"],
             ["viel", "mehr", "am meisten"], ["gern", "lieber", "am liebsten"]),
         tip("Comparison: größer als = bigger than; so groß wie = as big as.")],
        [fill("Gestern ___ ich nach Hause gefahren. (sein)", "bin", "fahren uses sein."),
         fill("Berlin ist ___ als Bonn. (groß)", ["größer", "groesser"], "groß → größer (with umlaut)."),
         mcq("Perfect of „essen“:", ["hat gegessen", "ist gegessen", "hat geessen"], 0, "essen → hat gegessen."),
         trans("I prefer tea to coffee.", ["Ich trinke lieber Tee als Kaffee.", "Ich mag Tee lieber als Kaffee."], "lieber … als = rather … than."),
         order("Ich habe gestern Fußball gespielt .", tr="I played football yesterday.")])

    m["quiz"] = lesson("A2 quiz", "Five questions across A2.",
        [tip("Watch for case endings and the position of the verb.")],
        [mcq("Ich gebe ___ Frau das Buch.", ["die", "der", "den"], 1, "Indirect object → dative: der Frau."),
         mcq("Perfect of „gehen“:", ["hat gegangen", "ist gegangen", "ist gegeht"], 1, "Movement → sein; irregular participle gegangen."),
         mcq("Du ___ hier nicht rauchen. (not allowed)", ["darfst", "musst", "kannst"], 0, "nicht dürfen = not allowed."),
         mcq("Comparative of „gut“:", ["guter", "besser", "am besten"], 1, "gut – besser – am besten."),
         mcq("Separable verb: „Ich ___ dich morgen ___.“ (anrufen)", ["rufe … an", "anrufe … –", "rufe … auf"], 0, "Ich rufe dich morgen an.")])

    exam = [
        mcq("„pünktlich“ means:", ["on time", "cheap", "tired"], 0, "pünktlich = punctual/on time.", skill="vocabulary"),
        mcq("Where do you try on clothes?", ["in der Umkleidekabine", "an der Kasse", "am Gleis"], 0, "die Umkleidekabine = fitting room.", skill="vocabulary"),
        mcq("Ich gehe ohne ___ Freund.", ["mein", "meinen", "meinem"], 1, "ohne + accusative: meinen.", skill="grammar"),
        mcq("Ich wohne bei ___ Eltern.", ["meine", "meinen", "meiner"], 1, "bei + dative plural: meinen Eltern.", skill="grammar"),
        fill("Wir ___ am Montag arbeiten. (müssen)", "müssen", "wir müssen.", skill="grammar"),
        fix("Ich habe nach Hamburg gefahren.", "Ich bin nach Hamburg gefahren.", "fahren (movement) uses sein.", skill="grammar"),
        mcq("Read: „Der Laden öffnet um 9 Uhr, aber am Samstag erst um 10 Uhr.“ When does it open on Saturday?",
            ["9:00", "10:00", "it is closed"], 1, "erst um 10 Uhr = not until 10.", skill="reading"),
        mcq("Read: „Die Jacke kostet 80 Euro. Heute gibt es 20 % Rabatt.“ What is special today?",
            ["a 20% discount", "a free jacket", "the shop is closed"], 0, "Rabatt = discount.", skill="reading"),
        listen("Der Bus Nummer zwölf fährt alle zehn Minuten.", "How often does bus 12 run?", ["every 10 minutes", "every 12 minutes", "at 10 o'clock"], 0, "alle zehn Minuten = every ten minutes.", skill="listening"),
        listen("Biegen Sie an der Kreuzung links ab.", "What should you do at the crossroads?", ["turn left", "turn right", "go straight on"], 0, "links abbiegen = turn left.", skill="listening"),
        trans("I have to work today.", ["Ich muss heute arbeiten.", "Heute muss ich arbeiten."], "Modal in position 2, infinitive at the end.", skill="writing"),
        mcq("At the end of a meal you say:", ["Die Rechnung, bitte.", "Guten Appetit!", "Haben Sie gewählt?"], 0, "Ask for the bill.", skill="conversation"),
    ]
    return level("de", "A2", 2, "Elementary",
                 "Daily routines, shopping, restaurants and directions. Modal and separable verbs, accusative and dative, perfect tense and comparisons.",
                 ALIGN.format("A2"),
                 ["Daily routines", "Shopping & restaurants", "Travel & directions", "Modal verbs", "Accusative & dative",
                  "Separable verbs", "Perfect tense", "Comparative & superlative"], m, exam)
