"""German C1 and C2."""
from dsl import *

ALIGN = "Oriented to CEFR {0} descriptors. Practice content, not an official certification."


def c1():
    m = {}
    m["vocabulary"] = lesson("Academic and professional vocabulary",
        "Words you meet in studies, reports and presentations.",
        [voc(("die Hypothese", "hypothesis"), ("die Untersuchung", "study / investigation"), ("belegen", "to prove / substantiate"),
             ("die Erkenntnis", "finding / insight"), ("erheblich", "considerable"), ("maßgeblich", "decisive / significant"),
             ("berücksichtigen", "to take into account"), ("die Voraussetzung", "prerequisite"), ("gewährleisten", "to guarantee / ensure"),
             ("in Frage stellen", "to call into question"), ("die Schlussfolgerung", "conclusion"), ("hinsichtlich (+ Gen.)", "with regard to")),
         tip("Many academic verbs pair with fixed nouns: eine These vertreten, einen Beitrag leisten, eine Frage aufwerfen, Kritik üben.")],
        [mcq("„erheblich“ means:", ["considerable", "obvious", "eligible"], 0, "ein erheblicher Unterschied = a considerable difference."),
         match([("belegen", "to substantiate"), ("gewährleisten", "to ensure"), ("berücksichtigen", "to take into account"), ("die Erkenntnis", "finding")]),
         fill("Die Ergebnisse stellen die bisherige Theorie in ___. (call into question)", "Frage", "in Frage stellen."),
         mcq("Which noun goes with „vertreten“?", ["eine These", "einen Tisch", "eine Reise"], 0, "eine These vertreten = to hold a position.")])

    m["grammar"] = lesson("Nominal style and indirect speech",
        "Academic German prefers nouns; reported speech uses Konjunktiv I.",
        [head("Nominal style"),
         tbl(["Verbal style", "Nominal style"], ["weil die Preise steigen", "aufgrund steigender Preise"],
             ["nachdem das Projekt abgeschlossen wurde", "nach Abschluss des Projekts"], ["wenn man das Gesetz ändert", "bei einer Änderung des Gesetzes"],
             ["obwohl es Kritik gab", "trotz der Kritik"]),
         head("Konjunktiv I (indirect speech)"),
         tbl(["Verb", "er / sie / es", "Note"], ["sein", "sei", "sie seien (plural)"], ["haben", "habe", "plural uses hätten (habe = indicative)"],
             ["können", "könne", ""], ["werden", "werde", "future in reported speech"], ["kommen", "komme", "stem + e"]),
         ex("Die Ministerin sagte, sie sei mit dem Ergebnis zufrieden.", "The minister said she was satisfied with the result."),
         tip("Konjunktiv I signals that the writer is reporting, not claiming. It is standard in news and academic texts.")],
        [fill("Der Minister sagte, er ___ zufrieden. (sein)", "sei", "Konjunktiv I of sein: sei."),
         mcq("aufgrund ___ Preise", ["steigender", "steigende", "steigenden"], 0, "Genitive plural without article: strong ending -er."),
         mcq("Nominal form of „nachdem das Projekt abgeschlossen wurde“:", ["nach Abschluss des Projekts", "nach dem Abschluss der Projekt", "nach den Abschluss des Projekts"], 0, "nach + dative; des Projekts (genitive)."),
         fix("Laut dem Bericht, die Zahl ist gestiegen.", "Laut dem Bericht ist die Zahl gestiegen.", "„Laut dem Bericht“ fills position 1; the verb follows directly, no comma."),
         fill("Sie behauptete, sie ___ keine Zeit gehabt. (haben)", "habe", "Konjunktiv I: sie habe.")])

    m["reading"] = lesson("Reading: a research abstract",
        "Academic register, hedging and reported findings.",
        [psg("Mehrsprachigkeit und kognitive Flexibilität",
             "Die vorliegende Untersuchung geht der Frage nach, inwiefern Mehrsprachigkeit die kognitive Flexibilität von Kindern beeinflusst. "
             "Hierzu wurden 120 Grundschulkinder mit unterschiedlichem sprachlichem Hintergrund getestet. Die Ergebnisse deuten darauf hin, dass "
             "mehrsprachige Kinder bei Aufgaben, die einen schnellen Wechsel zwischen Regeln erfordern, tendenziell besser abschneiden. Allerdings "
             "lassen sich aufgrund der geringen Stichprobengröße keine allgemeingültigen Schlussfolgerungen ziehen. Weitere Studien seien notwendig, "
             "so die Autorinnen.",
             "This study examines to what extent multilingualism influences children's cognitive flexibility. For this purpose, 120 primary school "
             "children with different language backgrounds were tested. The results suggest that multilingual children tend to perform better on "
             "tasks requiring a quick switch between rules. However, owing to the small sample size, no generally valid conclusions can be drawn. "
             "Further studies are necessary, according to the authors."),
         tip("Hedging language — deuten darauf hin, tendenziell, lassen sich keine … ziehen — shows how certain the authors are.")],
        [mcq("Was wird untersucht?", ["Einfluss von Mehrsprachigkeit auf kognitive Flexibilität", "Schulnoten mehrsprachiger Kinder", "Lehrmethoden in Grundschulen"], 0, "„geht der Frage nach, inwiefern …“."),
         mcq("Was schränkt die Aussagekraft ein?", ["die geringe Stichprobengröße", "das Alter der Autorinnen", "fehlende Ergebnisse"], 0, "„aufgrund der geringen Stichprobengröße“."),
         mcq("Warum steht „seien“ im Konjunktiv I?", ["Es ist indirekte Rede.", "Es ist eine Bitte.", "Es ist Vergangenheit."], 0, "The authors' view is reported."),
         mcq("„tendenziell“ means:", ["tending to / on the whole", "definitely", "never"], 0, "A hedge: a tendency, not a certainty.")])

    m["writing"] = lesson("Writing: summarising an academic text",
        "Neutral, concise summaries with reporting verbs.",
        [tbl(["Function", "Phrase"], ["Topic", "Der Text befasst sich mit … / Im Mittelpunkt steht …"],
             ["Author's position", "Die Autorin vertritt die These, dass …"], ["Method", "Hierzu wurden … untersucht."],
             ["Result", "Die Ergebnisse zeigen / deuten darauf hin, dass …"], ["Limitation", "Einschränkend ist anzumerken, dass …"],
             ["Conclusion", "Zusammenfassend lässt sich festhalten, dass …"]),
         tip("A summary reports — it does not judge. Use Konjunktiv I or reporting verbs, and keep your own opinion out.")],
        [write("Summarise the research abstract from the Reading module in 80+ words, in neutral academic German.", 80,
               ["befasst|untersucht|thema|mittelpunkt", "ergebnis", "zusammenfassend|insgesamt|einschränkend"],
               "Der Text befasst sich mit der Frage, ob Mehrsprachigkeit die kognitive Flexibilität von Kindern beeinflusst. Hierzu wurden 120 "
               "Grundschulkinder mit unterschiedlichem sprachlichem Hintergrund getestet. Die Ergebnisse deuten darauf hin, dass mehrsprachige Kinder "
               "bei Aufgaben mit Regelwechseln tendenziell besser abschneiden. Einschränkend ist anzumerken, dass die Stichprobe klein war. "
               "Zusammenfassend lässt sich festhalten, dass weitere Studien notwendig sind, um die Befunde zu bestätigen."),
         fill("Zusammenfassend lässt sich ___, dass … (state)", ["festhalten", "sagen", "feststellen"], "Zusammenfassend lässt sich festhalten …"),
         mcq("Which sentence is neutral?", ["Die Autorin vertritt die These, dass …", "Die Autorin hat völlig recht, dass …", "Leider glaubt die Autorin, dass …"], 0, "Report without evaluating.")])

    m["listening"] = lesson("Listening: lectures and seminars",
        "Signposting language in academic talks.",
        [tbl(["Signpost", "Meaning"], ["zunächst", "first of all"], ["im Gegensatz zu", "in contrast to"], ["darüber hinaus", "furthermore"], ["abschließend", "finally"])],
        [listen("Lassen Sie mich zunächst auf die methodischen Einschränkungen eingehen, bevor ich die Ergebnisse vorstelle.", "What will the speaker do first?",
                ["discuss methodological limitations", "present the results", "take questions"], 0, "zunächst … bevor …"),
         listen("Im Gegensatz zur ursprünglichen Annahme stieg die Nachfrage nicht, sondern sie blieb konstant.", "What happened to demand?",
                ["it stayed constant", "it rose as expected", "it fell"], 0, "nicht …, sondern … konstant."),
         listen("Die Frist für die Abgabe der Hausarbeit wurde um zwei Wochen verlängert.", "What changed?",
                ["the essay deadline was extended by two weeks", "the essay was cancelled", "the deadline was moved earlier"], 0, "verlängert = extended.")])

    m["speaking"] = lesson("Speaking: presentations",
        "Open, structure and close a presentation.",
        [tbl(["Stage", "Phrase"], ["Open", "Ich möchte Ihnen heute … vorstellen."], ["Structure", "Mein Vortrag gliedert sich in drei Teile."],
             ["Transition", "Damit komme ich zum nächsten Punkt."], ["Close", "Abschließend möchte ich festhalten, dass …"], ["Questions", "Gibt es dazu noch Fragen?"])],
        [speak("Ich möchte Ihnen heute die Ergebnisse unserer Studie vorstellen.", "Today I'd like to present the results of our study."),
         speak("Damit komme ich zum nächsten Punkt.", "That brings me to the next point."),
         speak("Gibt es dazu noch Fragen?", "Are there any questions about that?"),
         mcq("Which sentence announces the structure?", ["Mein Vortrag gliedert sich in drei Teile.", "Gibt es Fragen?", "Vielen Dank."], 0, "gliedern = to structure.")])

    m["pronunciation"] = lesson("Fluency: consonant clusters and compound stress",
        "Long words and dense consonants without hesitation.",
        [txt("Compounds stress the FIRST part: BAHNhof, KRANkenversicherung, HAUSaufgabe. Practise clusters slowly, then at normal speed: "
             "Herbst (autumn), du sprichst, der Strumpf (sock)."),
         tip("Break a long compound into its parts first: Kranken-ver-sicherung → then join them.")],
        [pron("Herbst", "autumn"), pron("du sprichst", "you speak"), pron("die Krankenversicherung", "health insurance"),
         mcq("Stress in „Hausaufgabe“:", ["HAUSaufgabe", "hausAUFgabe", "hausaufGAbe"], 0, "Compound: first element stressed.")])

    m["conversation"] = lesson("Conversation: negotiating in a meeting",
        "Diplomatic language for proposals, concerns and agreement.",
        [dlg("Projektbesprechung",
             ("Frau Klein", "Wir sollten die Frist realistisch ansetzen.", "We should set a realistic deadline."),
             ("Herr Roth", "Ich gebe zu bedenken, dass der Kunde bereits Druck macht.", "I'd point out that the client is already putting on pressure."),
             ("Frau Klein", "Könnten wir uns darauf einigen, die erste Phase bis Ende Mai abzuschließen?", "Could we agree to finish the first phase by the end of May?"),
             ("Herr Roth", "Damit wäre ich einverstanden, sofern wir zusätzliche Unterstützung bekommen.", "I'd agree to that, provided we get additional support."))],
        [mcq("„Ich gebe zu bedenken, dass …“ is used to:", ["raise a concern", "agree fully", "end the meeting"], 0, "zu bedenken geben = point out a concern."),
         order("Könnten wir uns darauf einigen?", tr="Could we agree on that?"),
         fill("Damit wäre ich ___, sofern … (in agreement)", "einverstanden", "einverstanden sein = agree."),
         mcq("„sofern“ means:", ["provided that", "although", "because"], 0, "A condition.")])

    m["exercises"] = lesson("Mixed practice: idioms and C1 grammar",
        "Idiomatic expressions in context, plus nominal style.",
        [tbl(["Idiom", "Meaning"], ["etwas auf die lange Bank schieben", "to put something off"], ["den Nagel auf den Kopf treffen", "to hit the nail on the head"],
             ["ins Fettnäpfchen treten", "to put your foot in it"], ["jemandem reinen Wein einschenken", "to tell someone the plain truth"],
             ["Tomaten auf den Augen haben", "to not see the obvious"])],
        [match([("auf die lange Bank schieben", "to put off"), ("den Nagel auf den Kopf treffen", "to be exactly right"),
                ("ins Fettnäpfchen treten", "to make a faux pas"), ("Tomaten auf den Augen haben", "to miss the obvious")]),
         fill("Wir dürfen die Entscheidung nicht auf die lange ___ schieben.", "Bank", "auf die lange Bank schieben."),
         trans("Due to the rain, the event was cancelled.", ["Aufgrund des Regens wurde die Veranstaltung abgesagt.", "Wegen des Regens wurde die Veranstaltung abgesagt."], "Nominal style with genitive."),
         mcq("Sie sagte, sie ___ morgen. (kommen, Konj. I)", ["komme", "kommt", "käme"], 0, "Konjunktiv I: sie komme."),
         order("Die Ergebnisse deuten darauf hin.", tr="The results suggest it.")])

    m["quiz"] = lesson("C1 quiz", "Five questions across C1.",
        [tip("Choose the most precise and register-appropriate option.")],
        [mcq("Nominal form of „weil es regnete“:", ["aufgrund des Regens", "aufgrund der Regen", "weil Regen"], 0, "aufgrund + genitive."),
         mcq("Indirect speech: Er sagt: „Ich bin krank.“ →", ["Er sagt, er sei krank.", "Er sagt, er ist krank sei.", "Er sagt, ich bin krank."], 0, "Konjunktiv I."),
         mcq("„maßgeblich“ means:", ["decisive / significant", "measurable", "moderate"], 0, "maßgeblich beteiligt = significantly involved."),
         mcq("„ins Fettnäpfchen treten“:", ["make a social blunder", "lose weight", "cook badly"], 0, "A faux pas."),
         mcq("Which is academic register?", ["Die Daten legen nahe, dass …", "Die Daten sagen halt, dass …", "Echt jetzt, die Daten …"], 0, "nahelegen = suggest.")])

    exam = [
        mcq("„die Voraussetzung“ is:", ["prerequisite", "forecast", "assumption"], 0, "Voraussetzung = prerequisite.", skill="vocabulary"),
        mcq("„gewährleisten“ means:", ["to ensure", "to allow", "to lend"], 0, "Sicherheit gewährleisten.", skill="vocabulary"),
        fill("Die Sprecherin erklärte, das Unternehmen ___ keine Fehler gemacht. (haben, Konj. I)", "habe", "das Unternehmen habe.", skill="grammar"),
        mcq("trotz ___ Kritik", ["der", "die", "den"], 0, "trotz + genitive: der Kritik.", skill="grammar"),
        mcq("Nominal: „wenn man die Regeln ändert“ →", ["bei einer Änderung der Regeln", "bei ändern der Regeln", "mit Änderung die Regeln"], 0, "bei + dative noun + genitive.", skill="grammar"),
        fix("Hinsichtlich dem Budget gibt es Fragen.", "Hinsichtlich des Budgets gibt es Fragen.", "hinsichtlich + genitive.", skill="grammar"),
        mcq("Read: „Die Befunde lassen allenfalls vorsichtige Rückschlüsse zu.“ How certain are the authors?",
            ["only cautiously certain", "completely certain", "they have no findings"], 0, "allenfalls vorsichtig = at most cautious.", skill="reading"),
        mcq("Read: „Während Studie A einen Zusammenhang belegt, konnte Studie B diesen nicht replizieren.“ What did Study B find?",
            ["it could not replicate the link", "it confirmed the link", "it found a stronger link"], 0, "nicht replizieren.", skill="reading"),
        listen("Darüber hinaus möchte ich auf einen Aspekt hinweisen, der bisher kaum beachtet wurde.", "What is the speaker doing?",
               ["adding an overlooked point", "concluding the talk", "repeating an earlier point"], 0, "darüber hinaus = furthermore; kaum beachtet = barely noticed.", skill="listening"),
        listen("Abschließend lässt sich sagen, dass die Maßnahmen nur teilweise wirksam waren.", "What's the conclusion?",
               ["the measures were only partly effective", "the measures failed completely", "the measures were fully effective"], 0, "nur teilweise wirksam.", skill="listening"),
        trans("The study calls the theory into question.", ["Die Studie stellt die Theorie in Frage.", "Die Untersuchung stellt die Theorie in Frage."], "in Frage stellen.", skill="writing"),
        mcq("To raise a concern diplomatically in a meeting:", ["Ich gebe zu bedenken, dass …", "Das ist Quatsch.", "Mir egal."], 0, "zu bedenken geben.", skill="conversation"),
    ]
    return level("de", "C1", 5, "Advanced",
                 "Academic and professional German: nominal style, reported speech, presentations, idioms and critical reading.",
                 ALIGN.format("C1"),
                 ["Academic German", "Professional presentations", "Advanced grammar", "Nuanced vocabulary", "Idiomatic expressions",
                  "Academic writing", "Critical reading", "Advanced listening", "Formal discussions"], m, exam)


def c2():
    m = {}
    m["vocabulary"] = lesson("Sophisticated vocabulary and regional variants",
        "Precise words, plus Austrian and Swiss alternatives you will hear.",
        [voc(("unabdingbar", "indispensable"), ("lapidar", "terse, matter-of-fact"), ("ambivalent", "ambivalent"),
             ("akribisch", "meticulous"), ("obsolet", "obsolete"), ("prekär", "precarious"),
             ("der Paradeiser (AT)", "tomato (Germany: die Tomate)"), ("der Erdapfel (AT)", "potato (die Kartoffel)"),
             ("die Jause (AT)", "snack, light meal"), ("das Velo (CH)", "bicycle (das Fahrrad)"),
             ("Grüß Gott (AT/S-DE)", "hello"), ("Grüezi (CH)", "hello")),
         tip("Regional words are standard in their region — not slang. Recognising them matters more than using them.")],
        [mcq("„akribisch“ means:", ["meticulous", "aggressive", "ironic"], 0, "akribisch genau = meticulously precise."),
         match([("der Paradeiser", "die Tomate"), ("der Erdapfel", "die Kartoffel"), ("das Velo", "das Fahrrad"), ("Grüezi", "Guten Tag")]),
         fill("Eine gute Vorbereitung ist ___. (indispensable)", "unabdingbar", "unabdingbar = indispensable."),
         mcq("A „lapidare“ answer is:", ["very brief and plain", "very emotional", "very long"], 0, "lapidar = terse.")])

    m["grammar"] = lesson("Extended participial attributes and modal particles",
        "Compress clauses into dense noun phrases; colour speech with particles.",
        [head("Extended participial attributes"),
         tbl(["Relative clause", "Participial attribute"], ["die Maßnahmen, die von der Regierung beschlossen wurden", "die von der Regierung beschlossenen Maßnahmen"],
             ["der Bedarf, der seit Jahren steigt", "der seit Jahren steigende Bedarf"], ["das Problem, das gelöst werden muss", "das zu lösende Problem"]),
         tip("Read from the article to the noun, then go back: everything in between describes the noun."),
         head("Modal particles"),
         tbl(["Particle", "Typical effect", "Example"], ["doch", "contradiction / urging", "Komm doch mit!"], ["ja", "shared knowledge / surprise", "Das ist ja interessant."],
             ["mal", "softens a request", "Schau mal."], ["eben / halt", "resignation: that's how it is", "Das ist halt so."], ["wohl", "assumption", "Er ist wohl krank."])],
        [mcq("Participial form of „die Gäste, die gestern angekommen sind“:", ["die gestern angekommenen Gäste", "die gestern ankommenden Gäste", "die angekommen gestern Gäste"], 0, "Past participle + adjective ending."),
         fill("das zu ___ Problem (lösen)", "lösende", "zu + present participle = must be …"),
         mcq("„Er ist wohl krank“ expresses:", ["an assumption", "certainty", "a wish"], 0, "wohl = probably."),
         fix("die gestern angekommenden Gäste", "die gestern angekommenen Gäste", "Use the past participle (angekommen) for a completed action."),
         order("Das ist halt so.", tr="That's just how it is.")])

    m["reading"] = lesson("Reading: an essay on language and thought",
        "Dense, nuanced argumentation with concessions.",
        [psg("Sprache und Denken",
             "Wer behauptet, Sprache sei bloß ein Werkzeug, unterschätzt, wie sehr sie unser Denken prägt. Freilich wäre es überzogen, mit der "
             "starken Form der Sapir-Whorf-Hypothese anzunehmen, wir könnten nur denken, was unsere Sprache zulässt. Gleichwohl zeigt bereits ein "
             "flüchtiger Blick auf Übersetzungen, dass manche Begriffe – man denke an „Heimat“ oder „Gemütlichkeit“ – sich einer exakten Entsprechung "
             "hartnäckig entziehen. Es ist ebendiese Widerständigkeit, die das Übersetzen zu einer Kunst und nicht zu einem bloßen Handwerk macht.",
             "Anyone who claims language is merely a tool underestimates how much it shapes our thinking. Admittedly, it would be excessive to assume, "
             "with the strong form of the Sapir–Whorf hypothesis, that we can only think what our language allows. Nevertheless, even a fleeting look "
             "at translations shows that some concepts – think of “Heimat” or “Gemütlichkeit” – stubbornly resist an exact equivalent. It is precisely "
             "this resistance that makes translation an art and not a mere craft."),
         tip("Concession pattern: Freilich … Gleichwohl … = Admittedly … Nevertheless … The author concedes a point, then returns to the main claim.")],
        [mcq("What is the author's position?", ["Language shapes thinking, but not absolutely.", "Language is only a tool.", "We can only think what language allows."], 0, "Rejects both extremes."),
         mcq("„Gleichwohl“ means:", ["nevertheless", "equally", "therefore"], 0, "A concessive connector."),
         mcq("What makes translation an art, according to the text?", ["Some concepts resist exact equivalents.", "Translators are poorly paid.", "Dictionaries are incomplete."], 0, "„ebendiese Widerständigkeit“."),
         mcq("„flüchtig“ in „ein flüchtiger Blick“ means:", ["brief, cursory", "escaped", "careful"], 0, "A quick glance.")])

    m["writing"] = lesson("Writing: an argumentative essay",
        "Thesis, concession, counter-argument and conclusion in elevated style.",
        [tbl(["Move", "Phrase"], ["Thesis", "Es lässt sich nicht von der Hand weisen, dass …"], ["Concession", "Zwar …, doch …"],
             ["Counter-argument", "Dem ist entgegenzuhalten, dass …"], ["Weighing", "Wägt man die Argumente ab, …"], ["Conclusion", "Letztlich …"]),
         tip("Vary sentence openings and use nominal style sparingly — C2 writing is precise, not merely complicated.")],
        [write("Should universities teach more in English instead of German? Write an argumentative essay (120+ words) with a concession and a conclusion.", 120,
               ["zwar|einerseits", "doch|jedoch|entgegen", "letztlich|abschließend|fazit"],
               "Es lässt sich nicht von der Hand weisen, dass englischsprachige Studiengänge internationale Studierende anziehen. Zwar erleichtert Englisch "
               "die Zusammenarbeit in der Forschung, doch droht das Deutsche als Wissenschaftssprache an Bedeutung zu verlieren. Dem ist entgegenzuhalten, "
               "dass Mehrsprachigkeit kein Nullsummenspiel ist: Wer auf Englisch publiziert, kann in der Lehre dennoch Deutsch verwenden. Wägt man die "
               "Argumente ab, erscheint ein ausgewogenes Modell sinnvoll, in dem Master-Programme auf Englisch und Grundlagenfächer auf Deutsch angeboten "
               "werden. Letztlich sollte die Sprache dem Lernziel dienen und nicht umgekehrt."),
         mcq("„Dem ist entgegenzuhalten, dass …“ introduces:", ["a counter-argument", "an example", "a summary"], 0, "entgegenhalten = to counter."),
         fill("Es lässt sich nicht von der ___ weisen, dass … (cannot be denied)", "Hand", "nicht von der Hand zu weisen.")])

    m["listening"] = lesson("Listening: irony, implication and regional speech",
        "Understand what is meant, not just what is said.",
        [tip("Irony often uses exaggerated praise for a bad situation: „Na, toll!“ usually means the opposite.")],
        [listen("Na, das hat ja wunderbar geklappt – jetzt dürfen wir alles noch einmal machen.", "What is the speaker's attitude?",
                ["ironic and annoyed", "genuinely delighted", "neutral"], 0, "Exaggerated praise + redoing everything = irony."),
         listen("Ich nehme eine Jause mit, falls wir später Hunger bekommen.", "What will the speaker take?",
                ["a snack", "a jacket", "a map"], 0, "Jause (Austrian) = snack."),
         listen("Das Vorhaben ist zwar ambitioniert, dürfte aber an der Finanzierung scheitern.", "What does the speaker expect?",
                ["the project will probably fail due to funding", "the project will succeed", "funding is secured"], 0, "dürfte … scheitern = will probably fail.")])

    m["speaking"] = lesson("Speaking: nuance and hedging",
        "Disagree, concede and qualify with precision.",
        [ex("Das mag auf den ersten Blick einleuchten, greift aber zu kurz.", "That may seem plausible at first glance, but it falls short."),
         ex("Ich will nicht ausschließen, dass Sie recht haben.", "I won't rule out that you're right."),
         ex("Darüber ließe sich trefflich streiten.", "That's very much open to debate.")],
        [speak("Das mag auf den ersten Blick einleuchten, greift aber zu kurz.", "That may seem plausible at first, but it falls short."),
         speak("Ich will nicht ausschließen, dass Sie recht haben.", "I won't rule out that you're right."),
         speak("Darüber ließe sich trefflich streiten.", "That's very much open to debate."),
         mcq("„greift zu kurz“ means an argument:", ["doesn't go far enough", "is too long", "is irrelevant"], 0, "zu kurz greifen = to fall short.")])

    m["pronunciation"] = lesson("Natural connected speech",
        "How fluent speakers reduce and link words, and long-sentence rhythm.",
        [tbl(["Careful", "Casual (common in speech)"], ["Hast du mal eine Minute?", "Haste mal 'ne Minute?"], ["Ist es so?", "Isses so?"], ["nicht", "nich"], ["haben wir", "ham wir"]),
         tip("Recognise reductions when listening; in formal speaking keep the careful forms.")],
        [pron("Die von der Kommission vorgeschlagenen Maßnahmen sind umstritten.", "The measures proposed by the commission are controversial."),
         pron("Eichhörnchen", "squirrel"), pron("Streichholzschächtelchen", "little matchbox"),
         mcq("„Haste mal 'ne Minute?“ is casual for:", ["Hast du mal eine Minute?", "Hast du keine Minute?", "Hattest du eine Minute?"], 0, "haste = hast du; 'ne = eine.")])

    m["conversation"] = lesson("Conversation: a high-level debate",
        "Follow and join a complex exchange of views.",
        [dlg("Podiumsdiskussion: Künstliche Intelligenz im Unterricht",
             ("Prof. Lang", "Es wäre fahrlässig, KI pauschal aus dem Unterricht zu verbannen.", "It would be negligent to ban AI from lessons across the board."),
             ("Dr. Seidel", "Zugegeben, aber wir dürfen die Urteilskraft der Lernenden nicht leichtfertig aufs Spiel setzen.", "Granted, but we mustn't carelessly risk learners' judgement."),
             ("Prof. Lang", "Gerade deshalb plädiere ich für einen reflektierten Einsatz statt eines Verbots.", "That's exactly why I argue for reflective use rather than a ban."),
             ("Dr. Seidel", "Darin sind wir uns einig – strittig bleibt, wie man das in der Praxis gewährleistet.", "We agree on that – what remains contentious is how to ensure it in practice."))],
        [mcq("What do both speakers agree on?", ["Reflective use is preferable to a ban.", "AI should be banned.", "Nothing at all."], 0, "„Darin sind wir uns einig“."),
         mcq("„plädieren für“ means:", ["to argue for", "to complain about", "to plead guilty"], 0, "plädieren für = advocate."),
         order("Darin sind wir uns einig.", tr="On that we agree."),
         fill("___, aber wir dürfen … nicht aufs Spiel setzen. (Granted)", "Zugegeben", "Zugegeben = granted / admittedly.")])

    m["exercises"] = lesson("Mixed practice: C2 precision",
        "Particles, participial attributes, regional words and idioms.",
        [tip("At C2, accuracy and register matter as much as meaning.")],
        [fill("Komm ___ mit! (urging)", "doch", "doch adds urging."),
         mcq("Rewrite „ein Argument, das nicht zu widerlegen ist“:", ["ein nicht zu widerlegendes Argument", "ein nicht widerlegtes Argument", "ein widerlegendes Argument"], 0, "zu + present participle."),
         trans("The decision, which was made hastily, was criticised.", ["Die übereilt getroffene Entscheidung wurde kritisiert.", "Die überstürzt getroffene Entscheidung wurde kritisiert."], "Participial attribute."),
         match([("Grüß Gott", "Austria / Bavaria"), ("Grüezi", "Switzerland"), ("Moin", "Northern Germany"), ("Servus", "Austria / Bavaria (informal)")]),
         mcq("„etwas aufs Spiel setzen“:", ["to put something at risk", "to play a game", "to bet on sports"], 0, "aufs Spiel setzen = jeopardise.")])

    m["quiz"] = lesson("C2 quiz", "Five questions across C2.",
        [tip("Several options may be grammatical — pick the most idiomatic.")],
        [mcq("„die zu erwartenden Kosten“ means:", ["the costs to be expected", "the expected-for costs", "the costs that expected"], 0, "zu + present participle."),
         mcq("„Das ist ja interessant!“ — „ja“ signals:", ["surprise", "agreement", "a question"], 0, "ja = surprise / emphasis."),
         mcq("„prekär“ means:", ["precarious", "precise", "premature"], 0, "eine prekäre Lage."),
         mcq("„Freilich …, gleichwohl …“ structures:", ["a concession and counterpoint", "a list", "a cause and effect"], 0, "Concessive."),
         mcq("Austrian „Erdapfel“ =", ["Kartoffel", "Apfel", "Erdbeere"], 0, "potato.")])

    exam = [
        mcq("„obsolet“ means:", ["obsolete", "obvious", "absolute"], 0, "obsolet = outdated.", skill="vocabulary"),
        mcq("Swiss „Velo“ is:", ["a bicycle", "a sail", "a hat"], 0, "das Velo = das Fahrrad.", skill="vocabulary"),
        mcq("„der seit Jahren ___ Bedarf“ (steigen)", ["steigende", "gestiegene", "steigenden"], 0, "Ongoing → present participle, nominative after der: -e.", skill="grammar"),
        fill("Das ist ___ so – da kann man nichts machen. (resignation)", ["halt", "eben"], "halt/eben express resignation.", skill="grammar"),
        mcq("Participial form of „die Studie, die 2020 veröffentlicht wurde“:", ["die 2020 veröffentlichte Studie", "die 2020 veröffentlichende Studie", "die veröffentlicht 2020 Studie"], 0, "Past participle + ending.", skill="grammar"),
        fix("Die Kosten sind ein nicht zu unterschätzender Faktor, die man beachten muss.", "Die Kosten sind ein nicht zu unterschätzender Faktor, den man beachten muss.", "The relative pronoun refers to „Faktor“ (masculine, accusative) → den.", skill="grammar"),
        mcq("Read: „Man mag dem Autor vieles vorwerfen – mangelnde Sorgfalt gehört nicht dazu.“ What does the writer think?",
            ["The author is careful, despite other faults.", "The author is careless.", "The author is faultless."], 0, "mangelnde Sorgfalt gehört nicht dazu.", skill="reading"),
        mcq("Read: „Das Ergebnis ist bestenfalls ein Achtungserfolg.“ How good is the result?",
            ["modest at best", "outstanding", "a disaster"], 0, "Achtungserfolg = a respectable but modest success.", skill="reading"),
        listen("Na, da hast du dir ja was Schönes eingebrockt.", "What does the speaker mean?",
               ["you've got yourself into trouble", "you've cooked something nice", "you've been lucky"], 0, "sich etwas einbrocken = get into a mess (ironic „Schönes“).", skill="listening"),
        listen("Die Entscheidung ist keineswegs so eindeutig, wie sie auf den ersten Blick erscheint.", "What does the speaker say?",
               ["the decision is less clear-cut than it seems", "the decision is obvious", "the decision has been reversed"], 0, "keineswegs so eindeutig.", skill="listening"),
        trans("That may seem plausible, but it falls short.", ["Das mag einleuchten, greift aber zu kurz.", "Das mag plausibel erscheinen, greift aber zu kurz."], "zu kurz greifen.", skill="writing"),
        mcq("To concede and then disagree at C2 level:", ["Zugegeben, doch …", "Ja, nein.", "Okay, egal."], 0, "Concession + counterpoint.", skill="conversation"),
    ]
    return level("de", "C2", 6, "Proficient",
                 "Near-native comprehension and expression: dense structures, regional variety, irony, nuance and high-level debate.",
                 ALIGN.format("C2"),
                 ["Near-native comprehension", "Sophisticated vocabulary", "Idioms & regional expressions", "Complex academic texts",
                  "Advanced professional writing", "Nuanced speaking", "Complex debates", "Natural fluent communication"], m, exam)
