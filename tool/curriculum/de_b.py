"""German B1 and B2."""
from dsl import *

ALIGN = "Oriented to CEFR {0} descriptors. Practice content, not an official certification."


def b1():
    m = {}
    m["vocabulary"] = lesson("Work, education and health",
        "Vocabulary for applications, training and visiting the doctor.",
        [voc(("die Bewerbung", "job application"), ("das Vorstellungsgespräch", "job interview"),
             ("die Erfahrung", "experience"), ("die Ausbildung", "vocational training"),
             ("kündigen", "to resign / give notice"), ("die Krankenversicherung", "health insurance"),
             ("die Überweisung", "referral (medical) / bank transfer"), ("sich krankmelden", "to call in sick"),
             ("die Sprechstunde", "consultation hours"), ("verschreiben", "to prescribe"),
             ("die Weiterbildung", "further training"), ("das Zeugnis", "certificate / reference"))],
        [mcq("Ein „Vorstellungsgespräch“ ist:", ["a job interview", "a presentation", "a phone call"], 0, "sich vorstellen = to introduce oneself."),
         match([("die Bewerbung", "application"), ("kündigen", "to resign"), ("die Erfahrung", "experience"), ("verschreiben", "to prescribe")]),
         fill("Ich habe Fieber und muss mich heute ___. (call in sick)", ["krankmelden"], "sich krankmelden = to call in sick."),
         mcq("Der Arzt ___ mir ein Medikament.", ["verschreibt", "kündigt", "bewirbt"], 0, "verschreiben = to prescribe.")])

    m["grammar"] = lesson("Subordinate clauses, relative clauses, Präteritum and Konjunktiv II",
        "The structures that let you explain, connect and speculate.",
        [head("Subordinate clauses"),
         txt("After weil (because), dass (that), obwohl (although), wenn (if/when), ob (whether) the conjugated verb goes to the END."),
         ex("Ich lerne Deutsch, weil ich in Berlin arbeiten möchte.", "I'm learning German because I want to work in Berlin."),
         head("Relative clauses"),
         tbl(["", "masc.", "fem.", "neut.", "plural"], ["Nominative", "der", "die", "das", "die"],
             ["Accusative", "den", "die", "das", "die"], ["Dative", "dem", "der", "dem", "denen"]),
         ex("Das ist der Mann, den ich gestern gesehen habe.", "That's the man (whom) I saw yesterday."),
         head("Präteritum (simple past) — mainly in writing and for sein, haben, modals"),
         tbl(["Infinitive", "ich / er"], ["sein", "war"], ["haben", "hatte"], ["gehen", "ging"], ["kommen", "kam"], ["machen", "machte"], ["können", "konnte"]),
         head("Konjunktiv II — wishes, polite requests, hypotheses"),
         tbl(["Use", "Form", "Example"], ["most verbs", "würde + infinitive", "Ich würde gern reisen."],
             ["haben", "hätte", "Wenn ich Zeit hätte, …"], ["sein", "wäre", "Das wäre toll."], ["können", "könnte", "Könnten Sie mir helfen?"])],
        [order("Ich komme nicht, weil ich krank bin.", "After weil the verb goes to the end.", "I'm not coming because I'm ill."),
         mcq("Das ist der Mann, ___ ich gestern gesehen habe.", ["der", "den", "dem"], 1, "Object of sehen, masculine → den."),
         fill("Wenn ich Zeit ___, würde ich mehr reisen. (haben)", "hätte", "Konjunktiv II of haben: hätte."),
         fix("Ich weiß, dass er kommt morgen.", "Ich weiß, dass er morgen kommt.", "Verb at the end of the dass-clause."),
         fill("Als Kind ___ ich in Köln. (wohnen, Präteritum)", "wohnte", "Regular verbs: stem + -te.")])

    m["reading"] = lesson("Reading: working from home",
        "An article-style text with opinions and contrast.",
        [psg("Homeoffice – Fluch oder Segen?",
             "Seit einigen Jahren arbeiten viele Menschen in Deutschland teilweise im Homeoffice. Die meisten Beschäftigten schätzen die "
             "Flexibilität, weil sie keine Zeit im Verkehr verlieren. Andere vermissen jedoch den Kontakt zu ihren Kolleginnen und Kollegen. "
             "Viele Firmen bieten deshalb ein Modell an, bei dem man zwei oder drei Tage pro Woche ins Büro kommt. Fachleute meinen, dass "
             "dieses hybride Modell auch in Zukunft beliebt bleiben wird.",
             "For some years many people in Germany have worked partly from home. Most employees value the flexibility because they don't "
             "lose time in traffic. Others, however, miss contact with their colleagues. Many companies therefore offer a model in which you "
             "come to the office two or three days a week. Experts think this hybrid model will remain popular in the future."),
         tip("Signal words help you follow an argument: jedoch (however), deshalb (therefore), weil (because).")],
        [mcq("Warum mögen viele das Homeoffice?", ["Sie verlieren keine Zeit im Verkehr.", "Sie verdienen mehr Geld.", "Sie haben mehr Kollegen."], 0, "„weil sie keine Zeit im Verkehr verlieren“."),
         mcq("Was vermissen manche?", ["den Kontakt zu Kollegen", "das Mittagessen", "ihren Computer"], 0, "„vermissen … den Kontakt“."),
         mcq("Was ist das „hybride Modell“ im Text?", ["nur Homeoffice", "teils Büro, teils zu Hause", "nur Büro"], 1, "Two or three days a week in the office."),
         mcq("„jedoch“ shows:", ["a contrast", "a reason", "a time"], 0, "jedoch = however.")])

    m["writing"] = lesson("Writing: giving your opinion",
        "Structure a short opinion text with advantages and disadvantages.",
        [tbl(["Function", "Phrase"], ["Give an opinion", "Meiner Meinung nach … / Ich bin der Meinung, dass …"],
             ["Contrast", "Einerseits … andererseits …"], ["Advantage", "Ein Vorteil ist, dass …"],
             ["Disadvantage", "Ein Nachteil ist, dass …"], ["Conclude", "Insgesamt finde ich …"]),
         tip("After „Meiner Meinung nach“ the verb comes next (position 2): Meiner Meinung nach IST das praktisch.")],
        [write("Is working from home a good idea? Give your opinion with at least one advantage and one disadvantage (60+ words).", 60,
               ["meinung|finde|denke", "vorteil|einerseits", "nachteil|andererseits", "weil|dass"],
               "Meiner Meinung nach ist das Homeoffice eine gute Idee, aber nicht für jeden. Ein Vorteil ist, dass man keine Zeit im Verkehr "
               "verliert und flexibler arbeiten kann. Ein Nachteil ist, dass man die Kollegen seltener sieht. Andererseits kann man sich zu "
               "Hause oft besser konzentrieren. Insgesamt finde ich ein hybrides Modell am besten, weil es beide Vorteile verbindet."),
         fill("Meiner Meinung ___ ist das praktisch.", "nach", "Meiner Meinung nach = in my opinion."),
         mcq("Which phrase introduces a disadvantage?", ["Ein Nachteil ist, dass …", "Ein Vorteil ist, dass …", "Zum Beispiel …"], 0, "Nachteil = disadvantage.")])

    m["listening"] = lesson("Listening: at the doctor's",
        "Appointments, opening hours and instructions.",
        [dlg("In der Praxis",
             ("Ärztin", "Was fehlt Ihnen denn?", "What's the matter?"),
             ("Patient", "Ich habe seit drei Tagen Halsschmerzen und Fieber.", "I've had a sore throat and fever for three days."),
             ("Ärztin", "Ich verschreibe Ihnen ein Medikament. Bleiben Sie zwei Tage zu Hause.", "I'll prescribe you some medicine. Stay at home for two days."))],
        [listen("Die Praxis ist am Mittwochnachmittag geschlossen.", "When is the practice closed?",
                ["Wednesday afternoon", "Monday morning", "all day Wednesday"], 0, "Mittwochnachmittag = Wednesday afternoon."),
         listen("Nehmen Sie die Tabletten dreimal täglich nach dem Essen.", "How should the tablets be taken?",
                ["three times a day after meals", "twice a day before meals", "once a day"], 0, "dreimal täglich nach dem Essen."),
         listen("Ich hätte gern einen Termin für nächste Woche, am liebsten vormittags.", "What does the caller want?",
                ["an appointment next week, ideally in the morning", "an appointment today", "to cancel an appointment"], 0, "am liebsten vormittags = preferably in the morning.")])

    m["speaking"] = lesson("Speaking: appointments and opinions",
        "Polite requests and clear opinions.",
        [ex("Ich würde gern einen Termin vereinbaren.", "I'd like to make an appointment."),
         ex("Könnten Sie das bitte wiederholen?", "Could you repeat that, please?"),
         ex("Ich bin der Meinung, dass wir mehr Zeit brauchen.", "I think we need more time.")],
        [speak("Ich würde gern einen Termin vereinbaren.", "I'd like to make an appointment."),
         speak("Ich bin der Meinung, dass wir mehr Zeit brauchen.", "I think we need more time."),
         speak("Könnten Sie das bitte wiederholen?", "Could you repeat that, please?"),
         mcq("Which request is polite?", ["Könnten Sie mir helfen?", "Helfen Sie mir!", "Du hilfst mir."], 0, "Konjunktiv II (könnten) makes requests polite.")])

    m["pronunciation"] = lesson("Vowel length and final devoicing",
        "Long vs short vowels change meaning; final b, d, g sound like p, t, k.",
        [tbl(["Long vowel", "Short vowel"], ["der Staat (state)", "die Stadt (city)"], ["die Miete (rent)", "die Mitte (middle)"], ["der Ofen (oven)", "offen (open)"]),
         txt("A doubled consonant after a vowel usually means the vowel is short (Mitte). A vowel + h or a double vowel is long (Sohn, Staat)."),
         tbl(["Written", "Sounds like"], ["Hund", "Hunt"], ["Tag", "Tak"], ["gelb", "gelp"], ["wichtig", "wichtich"])],
        [pron("die Miete", "the rent"), pron("die Mitte", "the middle"), pron("Der Hund ist wichtig.", "The dog is important."),
         mcq("In „Tag“, the final g sounds like:", ["k", "g", "ch"], 0, "Final devoicing: g → k.")])

    m["conversation"] = lesson("Conversation: a job interview",
        "Typical questions and strong answers.",
        [dlg("Im Vorstellungsgespräch",
             ("Interviewer", "Erzählen Sie etwas über sich.", "Tell me about yourself."),
             ("Bewerberin", "Ich habe Informatik studiert und arbeite seit drei Jahren als Entwicklerin.", "I studied computer science and have worked as a developer for three years."),
             ("Interviewer", "Warum möchten Sie bei uns arbeiten?", "Why do you want to work for us?"),
             ("Bewerberin", "Weil Ihre Firma innovative Projekte macht und ich mich weiterentwickeln möchte.", "Because your company does innovative projects and I want to develop further."),
             ("Interviewer", "Was sind Ihre Stärken?", "What are your strengths?"),
             ("Bewerberin", "Ich bin zuverlässig und arbeite gern im Team.", "I'm reliable and like working in a team."))],
        [mcq("Best answer to „Warum möchten Sie bei uns arbeiten?“",
             ["Weil Ihre Projekte mich interessieren.", "Ich habe Hunger.", "Ich wohne in Berlin."], 0, "Give a reason related to the company."),
         order("Ich arbeite gern im Team.", tr="I like working in a team."),
         fill("Ich arbeite ___ drei Jahren als Entwicklerin. (for)", "seit", "seit + dative for a duration continuing now."),
         mcq("„zuverlässig“ means:", ["reliable", "creative", "ambitious"], 0, "zuverlässig = reliable.")])

    m["exercises"] = lesson("Mixed practice: B1 structures",
        "Clauses, relative pronouns and Konjunktiv II together.",
        [tip("Check three things: Is the verb at the end of the subordinate clause? Is the relative pronoun's case right? Is it a real or imagined situation?")],
        [fill("Ich weiß nicht, ___ er heute kommt. (whether)", "ob", "ob = whether (yes/no)."),
         fill("Das ist die Frau, ___ ich geholfen habe.", "der", "helfen takes the dative: der (feminine)."),
         trans("If I were rich, I would travel.", ["Wenn ich reich wäre, würde ich reisen."], "wäre + würde … reisen."),
         order("Obwohl es regnet, gehen wir spazieren.", "A subordinate clause first: the main verb follows the comma.", "Although it's raining, we're going for a walk."),
         fix("Gestern ich ging ins Kino.", "Gestern ging ich ins Kino.", "Verb in position 2 after Gestern.")])

    m["quiz"] = lesson("B1 quiz", "Five questions across B1.",
        [tip("Several answers may look possible — choose the one that is grammatically correct.")],
        [mcq("Ich bleibe zu Hause, ___ ich krank bin.", ["weil", "denn", "deshalb"], 0, "weil + verb at the end."),
         mcq("Die Kinder, ___ ich Geschenke gegeben habe, …", ["die", "denen", "den"], 1, "Dative plural: denen."),
         mcq("Präteritum of „gehen“ (er):", ["gehte", "ging", "gang"], 1, "gehen → ging."),
         mcq("„Das wäre schön“ expresses:", ["a hypothetical / wish", "a fact in the past", "an order"], 0, "Konjunktiv II."),
         mcq("„die Überweisung“ at the doctor's is:", ["a referral", "a bill", "a prescription"], 0, "A referral to a specialist.")])

    exam = [
        mcq("„die Ausbildung“ is:", ["vocational training", "a holiday", "a salary"], 0, "Ausbildung = vocational training.", skill="vocabulary"),
        mcq("Someone who „kündigt“:", ["resigns", "gets promoted", "applies"], 0, "kündigen = give notice.", skill="vocabulary"),
        mcq("Ich glaube, ___ das stimmt.", ["dass", "ob", "wenn"], 0, "glauben, dass …", skill="grammar"),
        mcq("Das Buch, ___ du mir geliehen hast, ist toll.", ["der", "das", "dem"], 1, "neuter accusative: das.", skill="grammar"),
        fill("Wenn ich du ___, würde ich das machen. (sein)", "wäre", "wenn ich du wäre = if I were you.", skill="grammar"),
        fix("Ich bin müde, weil ich habe schlecht geschlafen.", "Ich bin müde, weil ich schlecht geschlafen habe.", "Verb at the end after weil.", skill="grammar"),
        mcq("Read: „Obwohl die Firma Gewinn macht, werden 200 Stellen gestrichen.“ What happens?",
            ["200 jobs are cut despite profits", "200 people are hired", "the firm makes a loss"], 0, "obwohl = although; Stellen streichen = cut jobs.", skill="reading"),
        mcq("Read: „Bewerbungen bitte bis zum 15. März per E-Mail.“ How should you apply?",
            ["by email by 15 March", "by post after 15 March", "in person"], 0, "bis zum = by; per E-Mail.", skill="reading"),
        listen("Wegen Bauarbeiten fährt die Linie fünf heute nur bis zum Hauptbahnhof.", "What's different today?",
               ["line 5 only goes to the main station", "line 5 is free", "line 5 starts later"], 0, "nur bis zum Hauptbahnhof.", skill="listening"),
        listen("Könnten wir den Termin auf Donnerstag verschieben?", "What does the speaker want?",
               ["to move the appointment to Thursday", "to cancel it", "to make it longer"], 0, "verschieben = postpone/move.", skill="listening"),
        trans("I'm learning German because I want to study in Germany.",
              ["Ich lerne Deutsch, weil ich in Deutschland studieren möchte.", "Ich lerne Deutsch, weil ich in Deutschland studieren will."],
              "weil + verb at the end.", skill="writing"),
        mcq("In a meeting you didn't understand. You say:", ["Könnten Sie das bitte wiederholen?", "Was?", "Nein."], 0, "Polite Konjunktiv II request.", skill="conversation"),
    ]
    return level("de", "B1", 3, "Intermediate",
                 "Independent conversations about work, education, health and travel. Subordinate and relative clauses, Präteritum and Konjunktiv II.",
                 ALIGN.format("B1"),
                 ["Work & education", "Health & appointments", "Travel experiences", "Opinions & explanations", "Präteritum",
                  "Subordinate clauses", "Relative clauses", "Konjunktiv II"], m, exam)


def b2():
    m = {}
    m["vocabulary"] = lesson("News, society and the environment",
        "Vocabulary for current affairs and discussions.",
        [voc(("die Umfrage", "survey / poll"), ("die Regierung", "government"), ("die Maßnahme", "measure / step"),
             ("die Auswirkung", "effect / impact"), ("zunehmen", "to increase"), ("abnehmen", "to decrease"),
             ("der Klimawandel", "climate change"), ("die Nachhaltigkeit", "sustainability"),
             ("erneuerbare Energien", "renewable energy"), ("die Wirtschaft", "economy"),
             ("die Arbeitslosigkeit", "unemployment"), ("der Beschluss", "decision / resolution"))],
        [mcq("„die Nachhaltigkeit“ means:", ["sustainability", "night shift", "neighbourhood"], 0, "nachhaltig = sustainable."),
         match([("die Regierung", "government"), ("die Auswirkung", "impact"), ("die Umfrage", "survey"), ("der Beschluss", "decision")]),
         fill("Die Zahl der Elektroautos hat stark ___. (increased)", "zugenommen", "zunehmen → hat zugenommen."),
         mcq("Eine „Maßnahme“ ist:", ["a measure / step taken", "a measuring tape", "a meal"], 0, "Maßnahmen ergreifen = take measures.")])

    m["grammar"] = lesson("The passive voice and advanced connectors",
        "Focus on actions rather than people, and link complex ideas.",
        [tbl(["Tense", "Passive (werden + participle)"], ["Present", "Das Haus wird gebaut."], ["Präteritum", "Das Haus wurde gebaut."],
             ["Perfect", "Das Haus ist gebaut worden."], ["With modal", "Das Haus muss gebaut werden."], ["State (sein-passive)", "Das Haus ist gebaut."]),
         tip("In the perfect passive the participle of werden is „worden“ (not „geworden“)."),
         tbl(["Connector", "Meaning", "Example"], ["je … desto", "the … the", "Je mehr man liest, desto besser schreibt man."],
             ["indem", "by (doing)", "Man spart Energie, indem man das Licht ausmacht."], ["sodass", "so that (result)", "Es regnete, sodass das Spiel ausfiel."],
             ["(an)statt … zu", "instead of", "Statt zu lernen, schlief er."], ["während", "while / whereas", "Während sie arbeitet, kocht er."])],
        [fill("Die Brücke ___ 1990 gebaut. (Präteritum passive)", "wurde", "wurde + participle."),
         fill("Das Problem muss sofort gelöst ___.", "werden", "modal + participle + werden."),
         mcq("Je mehr man übt, ___ besser spricht man.", ["desto", "als", "wie"], 0, "je … desto."),
         fix("Das Haus wurde renoviert worden.", ["Das Haus ist renoviert worden.", "Das Haus wurde renoviert."], "Perfect passive: ist … worden; Präteritum passive: wurde …"),
         order("Man lernt am besten, indem man viel spricht.", tr="You learn best by speaking a lot.")])

    m["reading"] = lesson("Reading: the four-day week",
        "A news-style text with arguments for and against.",
        [psg("Kommt die Vier-Tage-Woche?",
             "In mehreren Unternehmen wird derzeit die Vier-Tage-Woche getestet. Die Beschäftigten arbeiten dabei weniger Stunden, erhalten aber "
             "das gleiche Gehalt. Befürworter argumentieren, dass ausgeruhte Mitarbeitende produktiver seien und seltener krank würden. Kritiker "
             "hingegen befürchten, dass nicht alle Branchen dieses Modell umsetzen können, etwa die Pflege oder der Einzelhandel. Ob sich die "
             "Vier-Tage-Woche durchsetzt, hängt vermutlich davon ab, wie die Ergebnisse der Pilotprojekte ausfallen.",
             "Several companies are currently testing the four-day week. Employees work fewer hours but receive the same salary. Supporters argue "
             "that rested staff are more productive and get ill less often. Critics, on the other hand, fear that not all sectors can implement "
             "this model, for example care or retail. Whether the four-day week catches on probably depends on the results of the pilot projects.")],
        [mcq("Was bleibt bei der Vier-Tage-Woche gleich?", ["das Gehalt", "die Arbeitszeit", "die Branche"], 0, "„erhalten aber das gleiche Gehalt“."),
         mcq("Welches Argument nennen die Befürworter?", ["Ausgeruhte Mitarbeitende sind produktiver.", "Firmen sparen Geld.", "Die Pflege profitiert besonders."], 0, "„produktiver seien“."),
         mcq("Warum sind Kritiker skeptisch?", ["Nicht alle Branchen können es umsetzen.", "Es ist zu teuer für Mitarbeitende.", "Niemand will weniger arbeiten."], 0, "Pflege, Einzelhandel."),
         mcq("„hingegen“ signals:", ["contrast", "cause", "time"], 0, "hingegen = on the other hand.")])

    m["writing"] = lesson("Writing: a formal complaint",
        "Formal register, clear structure, polite but firm requests.",
        [tbl(["Part", "Formal phrase"], ["Opening", "Sehr geehrte Damen und Herren,"], ["Reason", "ich wende mich an Sie, weil …"],
             ["Details", "Am 3. Mai habe ich … bestellt. Leider …"], ["Request", "Ich bitte Sie daher, … / Ich erwarte …"],
             ["Close", "Für eine baldige Antwort wäre ich Ihnen dankbar."], ["Sign-off", "Mit freundlichen Grüßen"]),
         tip("In formal letters use Sie/Ihnen (capitalised) and avoid contractions and slang.")],
        [write("Write a formal complaint (80+ words): an order you placed three weeks ago has not arrived. Ask for delivery or a refund.", 80,
               ["sehr geehrte", "bitte|bitten", "freundlichen grüßen"],
               "Sehr geehrte Damen und Herren, ich wende mich an Sie, weil meine Bestellung vom 3. Mai (Nr. 4581) bis heute nicht angekommen ist. "
               "Laut Ihrer Website sollte die Lieferung innerhalb von fünf Werktagen erfolgen. Leider habe ich auf meine E-Mail vom 15. Mai keine "
               "Antwort erhalten. Ich bitte Sie daher, mir die Ware bis Ende dieser Woche zu liefern oder mir den Kaufpreis zu erstatten. "
               "Für eine baldige Antwort wäre ich Ihnen dankbar. Mit freundlichen Grüßen, Priya Sharma"),
         mcq("Formal opening when you don't know the name:", ["Sehr geehrte Damen und Herren,", "Liebe Leute,", "Hallo zusammen,"], 0, "Standard formal opening."),
         fill("Mit ___ Grüßen", "freundlichen", "Mit freundlichen Grüßen.")])

    m["listening"] = lesson("Listening: radio news",
        "Short news items: strikes, weather and local decisions.",
        [voc(("der Streik", "strike"), ("ausfallen", "to be cancelled"), ("sperren", "to close (off)"), ("der Stadtrat", "city council"), ("steigen", "to rise"))],
        [listen("Wegen eines Streiks fallen morgen zahlreiche Flüge in Frankfurt und München aus.", "What is happening tomorrow?",
                ["many flights are cancelled due to a strike", "airports close because of weather", "trains are delayed"], 0, "ausfallen = be cancelled."),
         listen("Die Temperaturen steigen bis zum Wochenende auf über dreißig Grad.", "What's the forecast?",
                ["above 30 °C by the weekend", "rain at the weekend", "cooler by the weekend"], 0, "über dreißig Grad."),
         listen("Der Stadtrat hat beschlossen, die Innenstadt ab Januar für Autos zu sperren.", "What did the council decide?",
                ["to close the city centre to cars from January", "to build a car park", "to lower bus fares"], 0, "für Autos sperren = close to cars.")])

    m["speaking"] = lesson("Speaking: agreeing and disagreeing politely",
        "Discussion phrases at B2 level.",
        [tbl(["Function", "Phrase"], ["Agree", "Da stimme ich Ihnen völlig zu."], ["Partly agree", "Da haben Sie teilweise recht, aber …"],
             ["Disagree politely", "Das sehe ich etwas anders."], ["Contradict", "Da muss ich Ihnen widersprechen."], ["Summarise", "Lassen Sie mich das kurz zusammenfassen."])],
        [speak("Da muss ich Ihnen widersprechen.", "I have to disagree with you there."),
         speak("Das sehe ich etwas anders.", "I see that a little differently."),
         speak("Lassen Sie mich das kurz zusammenfassen.", "Let me summarise briefly."),
         mcq("The most diplomatic way to disagree:", ["Das sehe ich etwas anders.", "Das ist falsch.", "Unsinn!"], 0, "Softened disagreement.")])

    m["pronunciation"] = lesson("Sentence melody and the glottal stop",
        "Intonation and the small catch before vowels that makes German sound German.",
        [txt("Statements and W-questions fall at the end. Yes/no questions rise. A glottal stop (a tiny catch) comes before a word or syllable "
             "starting with a vowel: be|antworten, ver|eisen (to ice over) vs. verreisen (to go on a trip)."),
         tbl(["Type", "Melody", "Example"], ["Statement", "falls ↘", "Ich komme morgen."], ["W-question", "falls ↘", "Woher kommen Sie?"], ["Yes/no question", "rises ↗", "Haben Sie heute Zeit?"])],
        [pron("Haben Sie heute Zeit?", "Do you have time today?"), pron("Woher kommen Sie?", "Where are you from?"),
         pron("Wir verreisen morgen.", "We're going away tomorrow."),
         mcq("In a yes/no question the melody usually:", ["rises at the end", "falls at the end", "stays flat"], 0, "Yes/no questions rise.")])

    m["conversation"] = lesson("Conversation: debate on a car-free city centre",
        "Follow a moderated discussion and use discussion strategies.",
        [dlg("Diskussion: Autofreie Innenstadt?",
             ("Moderatorin", "Frau Yilmaz, was spricht für eine autofreie Innenstadt?", "Ms Yilmaz, what speaks for a car-free centre?"),
             ("Frau Yilmaz", "Die Luft wird sauberer, und die Straßen werden für Fußgänger attraktiver.", "The air becomes cleaner and streets more attractive for pedestrians."),
             ("Herr Bauer", "Das ist ein wichtiger Punkt, aber viele Geschäfte befürchten weniger Kunden.", "That's an important point, but many shops fear fewer customers."),
             ("Frau Yilmaz", "Studien aus anderen Städten zeigen eher das Gegenteil.", "Studies from other cities tend to show the opposite."),
             ("Herr Bauer", "Ich verstehe Ihren Standpunkt, trotzdem brauchen wir gute Alternativen.", "I understand your position; still, we need good alternatives."))],
        [mcq("Which phrase acknowledges before disagreeing?", ["Das ist ein wichtiger Punkt, aber …", "Nein.", "Ich weiß nicht."], 0, "Acknowledge, then contrast."),
         order("Ich verstehe Ihren Standpunkt.", tr="I understand your position."),
         mcq("What do shops fear, according to Herr Bauer?", ["fewer customers", "higher rent", "more noise"], 0, "„weniger Kunden“."),
         fill("Da stimme ich Ihnen ___ zu. (completely)", ["völlig", "vollkommen", "ganz"], "völlig/vollkommen zustimmen.")])

    m["exercises"] = lesson("Mixed practice: B2 structures",
        "Passive, connectors and register.",
        [tip("Remember: worden in the perfect passive; „statt … zu“ needs zu + infinitive.")],
        [trans("The letter was written yesterday.", ["Der Brief wurde gestern geschrieben."], "Präteritum passive."),
         fill("Es regnete stark, ___ das Konzert ausfiel. (so that)", "sodass", "sodass = so that (result)."),
         fix("Anstatt lernen, hat er gespielt.", "Anstatt zu lernen, hat er gespielt.", "anstatt … zu + infinitive."),
         order("Je früher wir anfangen, desto besser.", tr="The earlier we start, the better."),
         mcq("Formal register:", ["Ich würde Sie bitten, mir zu antworten.", "Schreib mir mal zurück.", "Antworte halt."], 0, "Konjunktiv II + Sie.")])

    m["quiz"] = lesson("B2 quiz", "Five questions across B2.",
        [tip("Read every option fully — differences are small at this level.")],
        [mcq("Perfect passive:", ["Das Auto ist repariert worden.", "Das Auto ist repariert geworden.", "Das Auto hat repariert worden."], 0, "ist … worden."),
         mcq("„indem“ expresses:", ["the means / how", "a time", "a contrast"], 0, "by doing …"),
         mcq("„die Arbeitslosigkeit“:", ["unemployment", "workload", "laziness"], 0, "arbeitslos = unemployed."),
         mcq("Formal letter sign-off:", ["Mit freundlichen Grüßen", "Bis bald!", "Tschüss"], 0, "Standard formal closing."),
         mcq("„befürchten“ means:", ["to fear", "to support", "to explain"], 0, "befürchten = to fear (that something will happen).")])

    exam = [
        mcq("„die Auswirkung“ is closest to:", ["effect", "exit", "exception"], 0, "Auswirkung = effect.", skill="vocabulary"),
        mcq("„abnehmen“ (numbers) means:", ["to decrease", "to pick up", "to accept"], 0, "Die Zahl nimmt ab.", skill="vocabulary"),
        fill("Der Vertrag ___ gestern unterschrieben. (Präteritum passive)", "wurde", "wurde unterschrieben.", skill="grammar"),
        mcq("Die Rechnung muss bis Freitag bezahlt ___.", ["werden", "worden", "geworden"], 0, "modal + participle + werden.", skill="grammar"),
        mcq("___ mehr ich darüber nachdenke, desto unsicherer werde ich.", ["Je", "Wie", "Als"], 0, "je … desto.", skill="grammar"),
        fix("Statt anrufen, schrieb sie eine E-Mail.", "Statt anzurufen, schrieb sie eine E-Mail.", "Separable verb: an-zu-rufen.", skill="grammar"),
        mcq("Read: „Trotz steigender Preise ist die Nachfrage stabil geblieben.“ What happened to demand?",
            ["it stayed stable", "it rose", "it fell"], 0, "stabil geblieben.", skill="reading"),
        mcq("Read: „Die Maßnahme ist umstritten: Während Umweltverbände sie begrüßen, lehnt die Industrie sie ab.“ Who opposes it?",
            ["industry", "environmental groups", "nobody"], 0, "lehnt … ab = rejects.", skill="reading"),
        listen("Aufgrund technischer Störungen verzögert sich der Abflug um etwa vierzig Minuten.", "What's the delay?",
               ["about 40 minutes", "about 14 minutes", "four hours"], 0, "vierzig Minuten.", skill="listening"),
        listen("Die Umfrage zeigt, dass zwei Drittel der Befragten mehr Radwege wollen.", "What do two thirds want?",
               ["more cycle paths", "more car parks", "cheaper tickets"], 0, "Radwege = cycle paths.", skill="listening"),
        trans("The museum is being renovated.", ["Das Museum wird renoviert.", "Das Museum wird gerade renoviert."], "Present passive.", skill="writing"),
        mcq("In a debate, to disagree politely you say:", ["Das sehe ich etwas anders.", "Sie haben keine Ahnung.", "Egal."], 0, "Diplomatic disagreement.", skill="conversation"),
    ]
    return level("de", "B2", 4, "Upper Intermediate",
                 "Complex grammar, the passive, professional and formal communication, news and debates, and longer texts.",
                 ALIGN.format("B2"),
                 ["Passive voice", "Advanced connectors", "Professional communication", "News & current affairs",
                  "Formal & informal writing", "Discussions & debates", "Longer listening", "Complex texts"], m, exam)
