"""Korean Levels 1–3."""
from dsl import *

TOPIK_NOTE = ("Content aligned with TOPIK {0}. TOPIK tests reading and listening{1}; it does not test speaking, "
              "so this level's speaking and pronunciation modules go beyond exam preparation. Not an official TOPIK result.")


def l1():
    m = {}
    m["vocabulary"] = lesson("People, places and things",
        "First nouns for introducing yourself. Read the Hangul first; romanization is only a guide.",
        [tip("Try to read each word in Hangul before looking at the romanization. You can hide romanization in Settings."),
         voc(("학교", "school", "hak-gyo"), ("학생", "student", "hak-saeng"), ("선생님", "teacher", "seon-saeng-nim"),
             ("친구", "friend", "chin-gu"), ("집", "house, home", "jip"), ("책", "book", "chaek"),
             ("사람", "person", "sa-ram"), ("이름", "name", "i-reum"), ("나라", "country", "na-ra"),
             ("한국", "Korea", "han-guk"), ("인도", "India", "in-do"), ("회사원", "office worker", "hoe-sa-won"))],
        [mcq("„선생님“ means:", ["student", "teacher", "friend"], 1, "선생님 = teacher (님 is an honorific)."),
         match([("학교", "school"), ("친구", "friend"), ("책", "book"), ("집", "home")]),
         mcq("Which word means “name”?", ["이름", "나라", "사람"], 0, "이름 = name."),
         fill("인도 ___ (Indian person: India + person)", "사람", "Nationality = country + 사람: 인도 사람.")])

    m["grammar"] = lesson("Syllable blocks and N이에요/예요",
        "How Hangul letters combine, and how to say “I am …”.",
        [head("Building syllables"),
         txt("Every syllable block has an initial consonant and a vowel, and may have a final consonant (batchim). A syllable that starts "
             "with a vowel sound uses the silent ㅇ."),
         tbl(["Parts", "Block", "Sound"], ["ㄱ + ㅏ", "가", "ga"], ["ㅇ + ㅗ", "오", "o"], ["ㅎ + ㅏ + ㄴ", "한", "han"],
             ["ㄱ + ㅡ + ㄹ", "글", "geul"], ["ㅂ + ㅏ + ㅂ", "밥", "bap"]),
         head("N이에요 / N예요 — “(it) is N”"),
         tbl(["Noun ends in", "Ending", "Example"], ["a consonant", "이에요", "학생이에요 (I'm a student)"], ["a vowel", "예요", "의사예요 (I'm a doctor)"]),
         ex("저는 학생이에요.", "I am a student.", "jeo-neun hak-saeng-i-e-yo"),
         tip("저 = I (polite). 는 marks the topic: “as for me”.")],
        [mcq("ㅎ + ㅏ + ㄴ =", ["한", "학", "하"], 0, "ㅎ+ㅏ = 하, add final ㄴ → 한."),
         mcq("저는 학생___.", ["이에요", "예요"], 0, "학생 ends in a consonant (ㅇ) → 이에요."),
         fill("저는 의사___. (I am a doctor)", "예요", "의사 ends in a vowel → 예요."),
         order("저는 인도 사람이에요.", "Topic – noun – 이에요.", "I am Indian."),
         match([("ㅂ + ㅏ + ㅂ", "밥"), ("ㄱ + ㅡ + ㄹ", "글"), ("ㅇ + ㅗ", "오"), ("ㄱ + ㅏ", "가")])])

    m["reading"] = lesson("Reading: Minsu introduces himself",
        "A first short text in Hangul.",
        [psg("자기소개",
             "안녕하세요? 저는 민수예요. 한국 사람이에요. 저는 대학생이에요. 제 친구는 마리아예요. 마리아는 스페인 사람이에요. 마리아도 학생이에요.",
             "Hello! I'm Minsu. I'm Korean. I'm a university student. My friend is Maria. Maria is Spanish. Maria is a student too."),
         voc(("대학생", "university student", "dae-hak-saeng"), ("제", "my (polite)", "je"), ("스페인", "Spain", "seu-pe-in"), ("-도", "also, too", "do"))],
        [mcq("민수는 어느 나라 사람이에요?", ["한국 사람", "스페인 사람", "인도 사람"], 0, "„한국 사람이에요“."),
         mcq("마리아는 누구예요?", ["Minsu's friend", "Minsu's teacher", "Minsu's sister"], 0, "„제 친구는 마리아예요“."),
         mcq("What does „마리아도 학생이에요“ tell you?", ["Maria is also a student.", "Maria is a teacher.", "Maria is not a student."], 0, "도 = also."),
         mcq("민수는 ___이에요.", ["대학생", "선생님", "회사원"], 0, "„저는 대학생이에요“.")])

    m["writing"] = lesson("Writing: a self-introduction in Hangul",
        "Write four short sentences using fixed patterns.",
        [ex("안녕하세요. 저는 [이름]이에요/예요.", "Hello. I'm [name]."), ex("[나라] 사람이에요.", "I'm from [country]."),
         ex("[직업]이에요/예요.", "I'm a [job]."), ex("만나서 반갑습니다.", "Nice to meet you."),
         tip("Choose 이에요 after a consonant and 예요 after a vowel: 라비예요, 민준이에요.")],
        [write("Introduce yourself in Hangul: greeting, name, nationality and job (at least 5 words).", 5,
               ["저는", "이에요|예요"], "안녕하세요. 저는 라비예요. 인도 사람이에요. 학생이에요. 만나서 반갑습니다."),
         fill("저는 미국 ___이에요. (American: America + person)", "사람", "미국 사람 = American."),
         mcq("Which is correct for the name 라비?", ["라비예요", "라비이에요"], 0, "Ends in a vowel → 예요.")])

    m["listening"] = lesson("Listening: names, jobs and prices",
        "Sino-Korean numbers are used for money: 천 = 1,000, 만 = 10,000.",
        [voc(("천", "1,000", "cheon"), ("만", "10,000", "man"), ("원", "won (currency)", "won"), ("얼마예요?", "How much is it?", "eol-ma-ye-yo")),
         ex("이 책은 삼천 원이에요.", "This book is 3,000 won.", "i chae-geun sam-cheon wo-ni-e-yo")],
        [listen("안녕하세요. 저는 지민이에요.", "What's the speaker's name?", ["지민", "지수", "민지"], 0, "저는 지민이에요."),
         listen("이 책은 삼천 원이에요.", "How much is the book?", ["3,000 won", "300 won", "30,000 won"], 0, "삼천 = 3 × 1,000."),
         listen("저는 회사원이에요.", "What is the speaker's job?", ["office worker", "student", "teacher"], 0, "회사원 = office worker."),
         listen("감사합니다.", "What did the speaker say?", ["Thank you", "Sorry", "Goodbye"], 0, "감사합니다 = thank you.")])

    m["speaking"] = lesson("Speaking: greetings and introductions",
        "Say your first Korean sentences.",
        [dlg("첫 만남 (First meeting)",
             ("A", "안녕하세요. 저는 민수예요.", "Hello. I'm Minsu.", "an-nyeong-ha-se-yo. jeo-neun min-su-ye-yo"),
             ("B", "안녕하세요. 저는 라비예요.", "Hello. I'm Ravi.", "an-nyeong-ha-se-yo. jeo-neun ra-bi-ye-yo"),
             ("A", "만나서 반갑습니다.", "Nice to meet you.", "man-na-seo ban-gap-seum-ni-da"))],
        [speak("안녕하세요. 저는 학생이에요.", "Hello. I'm a student."),
         speak("만나서 반갑습니다.", "Nice to meet you."),
         speak("이름이 뭐예요?", "What's your name?"),
         mcq("You meet someone for the first time. You say:", ["만나서 반갑습니다.", "안녕히 계세요.", "괜찮아요."], 0, "Nice to meet you.")])

    m["pronunciation"] = lesson("Batchim basics and sound linking",
        "Final consonants reduce to seven sounds, and they slide onto a following vowel.",
        [tbl(["Final letter(s)", "Sounds like", "Example"], ["ㄱ ㅋ ㄲ", "[k]", "책 [chaek]"], ["ㄴ", "[n]", "산 [san]"],
             ["ㄷ ㅅ ㅆ ㅈ ㅊ ㅌ ㅎ", "[t]", "옷 [ot]"], ["ㄹ", "[l]", "물 [mul]"], ["ㅁ", "[m]", "밤 [bam]"], ["ㅂ ㅍ", "[p]", "밥 [bap]"], ["ㅇ", "[ng]", "강 [gang]"]),
         txt("Linking (연음): when a syllable with a final consonant is followed by one starting with ㅇ, the consonant moves across: "
             "한국어 → [한구거], 음악 → [으막], 옷이 → [오시]."),
         tip("Write it as spelled, say it as linked. Spelling stays the same.")],
        [pron("한국어", "Korean language", "Say it linked: [한구거]"), pron("음악", "music", "Linked: [으막]"), pron("옷", "clothes", "Final ㅅ sounds like [t]"),
         mcq("„옷“ on its own is pronounced:", ["ot", "os", "oj"], 0, "Final ㅅ → [t]."),
         mcq("How is „음악“ pronounced?", ["[으막]", "[음악] with a pause", "[으망]"], 0, "ㅁ links onto the next vowel.")])

    m["conversation"] = lesson("Conversation: meeting someone new",
        "Ask and answer name and nationality.",
        [dlg("어느 나라 사람이에요?",
             ("민수", "안녕하세요. 저는 민수예요.", "Hello, I'm Minsu.", "an-nyeong-ha-se-yo. jeo-neun min-su-ye-yo"),
             ("라비", "안녕하세요. 저는 라비예요.", "Hello, I'm Ravi.", "an-nyeong-ha-se-yo. jeo-neun ra-bi-ye-yo"),
             ("민수", "라비 씨는 어느 나라 사람이에요?", "Which country are you from, Ravi?", "ra-bi ssi-neun eo-neu na-ra sa-ra-mi-e-yo"),
             ("라비", "인도 사람이에요.", "I'm Indian.", "in-do sa-ra-mi-e-yo"),
             ("민수", "만나서 반가워요.", "Nice to meet you.", "man-na-seo ban-ga-wo-yo"),
             ("라비", "저도 반가워요.", "Nice to meet you too.", "jeo-do ban-ga-wo-yo")),
         tip("씨 after a name is polite (like Mr/Ms). Never use 씨 with your own name.")],
        [mcq("„어느 나라 사람이에요?“ asks about:", ["nationality", "age", "job"], 0, "어느 나라 = which country."),
         order("저는 인도 사람이에요.", tr="I'm Indian."),
         fill("저___ 반가워요. (me too)", "도", "저도 = me too."),
         mcq("Polite way to address Ravi:", ["라비 씨", "라비 님 저", "라비야"], 0, "Name + 씨.")])

    m["exercises"] = lesson("Mixed practice: reading Hangul",
        "Vowels, consonants, batchim and your first sentences.",
        [tbl(["Vowel", "Sound"], ["ㅏ", "a"], ["ㅓ", "eo"], ["ㅗ", "o"], ["ㅜ", "u"], ["ㅡ", "eu"], ["ㅣ", "i"]),
         tip("ㅓ (eo) is like the u in “up”; ㅗ (o) is like the o in “go”. These two are the ones most often confused.")],
        [mcq("Which vowel sounds like “eo” (u in “up”)?", ["ㅓ", "ㅗ", "ㅜ"], 0, "ㅓ = eo."),
         match([("나무", "tree"), ("바다", "sea"), ("우유", "milk"), ("사과", "apple")]),
         mcq("Which word has a batchim?", ["학교", "나라", "바다"], 0, "학 has final ㄱ."),
         fill("저는 회사원___. (I'm an office worker)", "이에요", "회사원 ends in ㄴ → 이에요."),
         order("이름이 뭐예요?", tr="What's your name?")])

    m["quiz"] = lesson("Level 1 quiz", "Five questions across Level 1.",
        [tip("Read the Hangul in each option before deciding.")],
        [mcq("ㅁ + ㅜ + ㄹ =", ["물", "문", "몰"], 0, "무 + ㄹ = 물 (water)."),
         mcq("„감사합니다“ means:", ["Thank you", "Hello", "Sorry"], 0, "Formal thank you."),
         mcq("Final ㅂ sounds like:", ["[p]", "[b]", "[m]"], 0, "ㅂ/ㅍ at the end → [p]."),
         mcq("Correct sentence:", ["저는 선생님이에요.", "저는 선생님예요.", "저는 이에요 선생님."], 0, "Consonant ending → 이에요."),
         mcq("„안녕히 가세요“ is said to someone who is:", ["leaving", "staying", "arriving"], 0, "Go in peace.")])

    exam = [
        mcq("„친구“ means:", ["friend", "teacher", "family"], 0, "친구 = friend.", skill="vocabulary"),
        mcq("Which means “Korea”?", ["한국", "인도", "미국"], 0, "한국.", skill="vocabulary"),
        mcq("ㅅ + ㅏ + ㄴ =", ["산", "삼", "상"], 0, "사 + ㄴ = 산 (mountain).", skill="reading"),
        mcq("저는 의사___.", ["예요", "이에요"], 0, "의사 ends in a vowel.", skill="grammar"),
        mcq("저는 학생___.", ["이에요", "예요"], 0, "학생 ends in a consonant.", skill="grammar"),
        fill("저는 회사원___. (I am an office worker)", "이에요", "Consonant ending → 이에요.", skill="grammar"),
        mcq("Read: „저는 지수예요. 중국 사람이에요.“ Where is Jisu from?", ["China", "Korea", "Japan"], 0, "중국 = China.", skill="reading"),
        mcq("How is „음악“ pronounced?", ["[으막]", "[음아크]", "[음낙]"], 0, "Linking.", skill="pronunciation"),
        listen("오천 원이에요.", "How much?", ["5,000 won", "500 won", "50,000 won"], 0, "오천 = 5,000.", skill="listening"),
        listen("저는 선생님이에요.", "The speaker is a…", ["teacher", "student", "doctor"], 0, "선생님.", skill="listening"),
        trans("I am a student.", ["저는 학생이에요.", "학생이에요."], "저는 학생이에요.", skill="writing"),
        mcq("Reply to „만나서 반가워요“:", ["저도 반가워요.", "안녕히 계세요.", "얼마예요?"], 0, "Me too.", skill="conversation"),
    ]
    return level("ko", "L1", 1, "Absolute Beginner",
                 "Hangul vowels and consonants, syllable blocks, batchim, pronunciation, greetings, self-introduction and numbers.",
                 TOPIK_NOTE.format("I, level 1 (entry)", ""),
                 ["Hangul vowels", "Hangul consonants", "Syllable formation", "Batchim fundamentals", "Pronunciation",
                  "Greetings", "Self-introduction", "Numbers", "Essential vocabulary"], m, exam)


def l2():
    m = {}
    m["vocabulary"] = lesson("Family, food and shopping",
        "Everyday nouns and verbs for daily life.",
        [voc(("가족", "family", "ga-jok"), ("어머니", "mother", "eo-meo-ni"), ("아버지", "father", "a-beo-ji"),
             ("동생", "younger sibling", "dong-saeng"), ("음식", "food", "eum-sik"), ("물", "water", "mul"),
             ("사다", "to buy", "sa-da"), ("먹다", "to eat", "meok-da"), ("마시다", "to drink", "ma-si-da"),
             ("가다", "to go", "ga-da"), ("가게", "shop", "ga-ge"), ("비싸다", "to be expensive", "bi-ssa-da"))],
        [mcq("„먹다“ means:", ["to eat", "to drink", "to go"], 0, "먹다 = eat."),
         match([("어머니", "mother"), ("동생", "younger sibling"), ("가게", "shop"), ("물", "water")]),
         mcq("Opposite of „비싸다“:", ["싸다", "크다", "작다"], 0, "싸다 = cheap."),
         fill("물을 ___. (drink: dictionary form)", "마시다", "마시다 = to drink.")])

    m["grammar"] = lesson("Particles and tenses (polite style)",
        "은/는, 이/가, 을/를, 에/에서 and -아요/어요, -았/었어요, -(으)ㄹ 거예요.",
        [head("Particles"),
         tbl(["Particle", "After consonant / vowel", "Function", "Example"], ["topic", "은 / 는", "as for …", "저는 학생이에요."],
             ["subject", "이 / 가", "new info / who does it", "동생이 와요."], ["object", "을 / 를", "what is acted on", "밥을 먹어요."],
             ["place (destination/time)", "에", "to / at (time)", "학교에 가요."], ["place (action)", "에서", "at (where it happens)", "집에서 공부해요."]),
         head("Polite present -아요/어요"),
         tbl(["Rule", "Dictionary form", "Polite present"], ["last vowel ㅏ/ㅗ → 아요", "가다", "가요"], ["other vowels → 어요", "먹다", "먹어요"], ["하다 → 해요", "공부하다", "공부해요"]),
         head("Past and future"),
         tbl(["Tense", "Form", "Example"], ["Past", "-았/었어요, 했어요", "먹었어요 (ate)"], ["Future / plan", "-(으)ㄹ 거예요", "갈 거예요 (will go)"])],
        [mcq("저___ 커피를 마셔요.", ["는", "은"], 0, "저 ends in a vowel → 는."),
         mcq("밥___ 먹어요.", ["을", "를"], 0, "밥 ends in a consonant → 을."),
         mcq("I study at home: 집___ 공부해요.", ["에서", "에"], 0, "Action location → 에서."),
         fill("어제 영화를 ___. (보다, past)", ["봤어요", "보았어요"], "보다 → 봤어요."),
         order("내일 친구를 만날 거예요.", "Future: -(으)ㄹ 거예요.", "I'll meet a friend tomorrow.")])

    m["reading"] = lesson("Reading: Jiyu's weekend",
        "A short diary using past and future tenses.",
        [psg("주말",
             "지난 주말에 저는 가족하고 시장에 갔어요. 시장에서 과일하고 생선을 샀어요. 과일이 아주 싸고 맛있었어요. 저녁에 집에서 어머니하고 "
             "요리했어요. 다음 주말에는 친구하고 영화를 볼 거예요.",
             "Last weekend I went to the market with my family. At the market we bought fruit and fish. The fruit was very cheap and tasty. "
             "In the evening I cooked at home with my mother. Next weekend I'm going to watch a film with a friend."),
         voc(("시장", "market", "si-jang"), ("과일", "fruit", "gwa-il"), ("생선", "fish (food)", "saeng-seon"), ("-하고", "and / with", "ha-go"))],
        [mcq("Where did they go last weekend?", ["a market", "a cinema", "a school"], 0, "시장에 갔어요."),
         mcq("What did they buy?", ["fruit and fish", "meat and rice", "clothes"], 0, "과일하고 생선."),
         mcq("What will the writer do next weekend?", ["watch a film with a friend", "cook with mother", "go to the market"], 0, "영화를 볼 거예요."),
         mcq("How was the fruit?", ["cheap and tasty", "expensive", "not fresh"], 0, "싸고 맛있었어요.")])

    m["writing"] = lesson("Writing: my day",
        "Describe your day with times, places and particles.",
        [ex("저는 일곱 시에 일어나요.", "I get up at seven.", "jeo-neun il-gop si-e i-reo-na-yo"),
         ex("회사에서 일해요.", "I work at the company."), ex("저녁에 친구하고 밥을 먹었어요.", "In the evening I ate with a friend."),
         tip("Hours use native Korean numbers (한 시, 두 시, 세 시 …); minutes use Sino-Korean (십 분, 삼십 분).")],
        [write("Write 4–5 sentences about what you did yesterday. Use -았/었어요 and at least two particles.", 12,
               ["을|를", "에|에서", "었어요|았어요|했어요"],
               "어제 저는 아침 여덟 시에 일어났어요. 회사에서 일했어요. 점심에 동료하고 비빔밥을 먹었어요. 저녁에는 집에서 한국어를 공부했어요."),
         fill("저는 아홉 시___ 학교에 가요. (at nine)", "에", "Time + 에."),
         mcq("“I worked at the company”:", ["회사에서 일했어요.", "회사에 일했어요.", "회사를 일했어요."], 0, "Place of action → 에서.")])

    m["listening"] = lesson("Listening: shopping and plans",
        "Native numbers for counting things; Sino-Korean for prices.",
        [tbl(["Native number", "Counting things (개)"], ["하나", "한 개"], ["둘", "두 개"], ["셋", "세 개"], ["넷", "네 개"], ["다섯", "다섯 개"]),
         ex("사과 세 개 주세요.", "Three apples, please.")],
        [listen("사과 세 개 주세요.", "How many apples?", ["3", "2", "4"], 0, "세 개 = three items."),
         listen("이 가방은 만 오천 원이에요.", "How much is the bag?", ["15,000 won", "50,000 won", "1,500 won"], 0, "만 오천 = 15,000."),
         listen("내일 친구하고 도서관에 갈 거예요.", "What will the speaker do tomorrow?", ["go to the library with a friend", "go shopping alone", "stay home"], 0, "도서관 = library."),
         listen("어제 비가 와서 집에 있었어요.", "What did the speaker do yesterday?", ["stayed at home", "went out", "went to work"], 0, "집에 있었어요.")])

    m["speaking"] = lesson("Speaking: in a shop and a restaurant",
        "Ask, order and pay politely.",
        [ex("이거 얼마예요?", "How much is this?"), ex("비빔밥 하나 주세요.", "One bibimbap, please."), ex("카드로 계산할게요.", "I'll pay by card.")],
        [speak("이거 얼마예요?", "How much is this?"), speak("비빔밥 하나 주세요.", "One bibimbap, please."),
         speak("카드로 계산할게요.", "I'll pay by card."),
         mcq("To ask for something politely you add:", ["주세요", "있어요", "가요"], 0, "N + 주세요 = please give me N.")])

    m["pronunciation"] = lesson("Plain, tense and aspirated consonants",
        "ㄱ/ㄲ/ㅋ, ㄷ/ㄸ/ㅌ, ㅂ/ㅃ/ㅍ, ㅈ/ㅉ/ㅊ, ㅅ/ㅆ — the hardest contrast for learners.",
        [tbl(["Plain (soft)", "Tense (tight, no breath)", "Aspirated (strong breath)"], ["가 (ga)", "까 (kka)", "카 (ka)"], ["다 (da)", "따 (tta)", "타 (ta)"],
             ["바 (ba)", "빠 (ppa)", "파 (pa)"], ["자 (ja)", "짜 (jja)", "차 (cha)"], ["사 (sa)", "싸 (ssa)", "—"]),
         tip("Hold a tissue in front of your mouth: it should move a lot for 카, a little for 가, and not at all for 까.")],
        [pron("불", "fire"), pron("뿔", "horn"), pron("풀", "grass"),
         mcq("Which syllable is aspirated?", ["타", "다", "따"], 0, "ㅌ is aspirated."),
         mcq("„싸다“ (cheap) vs „사다“ (buy): the difference is:", ["tense ㅆ vs plain ㅅ", "vowel length", "tone"], 0, "ㅆ is tense.")])

    m["conversation"] = lesson("Conversation: ordering food",
        "A complete restaurant exchange in polite style.",
        [dlg("식당에서",
             ("직원", "어서 오세요. 몇 분이세요?", "Welcome. How many people?", "eo-seo o-se-yo. myeot bun-i-se-yo"),
             ("손님", "두 명이에요.", "Two people.", "du myeong-i-e-yo"),
             ("직원", "뭐 드릴까요?", "What can I get you?", "mwo deu-ril-kka-yo"),
             ("손님", "김치찌개 하나하고 불고기 하나 주세요.", "One kimchi stew and one bulgogi, please.", "gim-chi-jji-gae ha-na-ha-go bul-go-gi ha-na ju-se-yo"),
             ("손님", "여기 계산해 주세요.", "The bill, please.", "yeo-gi gye-san-hae ju-se-yo"))],
        [mcq("„몇 분이세요?“ asks:", ["how many people", "what time", "what you want"], 0, "몇 분 = how many people (honorific)."),
         order("불고기 하나 주세요.", tr="One bulgogi, please."),
         mcq("To ask for the bill:", ["계산해 주세요.", "어서 오세요.", "맛있게 드세요."], 0, "계산 = paying the bill."),
         fill("두 ___이에요. (people, counter)", "명", "명 counts people.")])

    m["exercises"] = lesson("Mixed practice: particles and tenses",
        "Choose the right particle and tense.",
        [tip("Ask: Is it the topic (은/는)? the doer (이/가)? the object (을/를)? a destination (에) or where the action happens (에서)?")],
        [mcq("동생___ 학교에 가요. (new information: my sibling)", ["이", "가"], 0, "동생 ends in ㅇ → 이."),
         fill("커피___ 마셔요.", "를", "커피 ends in a vowel → 를."),
         trans("I went to the market.", ["시장에 갔어요.", "저는 시장에 갔어요."], "가다 → 갔어요."),
         fix("어제 친구를 만날 거예요.", ["어제 친구를 만났어요."], "어제 (yesterday) needs past tense."),
         order("저는 도서관에서 공부해요.", tr="I study at the library.")])

    m["quiz"] = lesson("Level 2 quiz", "Five questions across Level 2.",
        [tip("Check consonant/vowel endings before choosing a particle.")],
        [mcq("물___ 마셔요.", ["을", "를"], 0, "물 ends in ㄹ → 을."),
         mcq("Polite present of „먹다“:", ["먹어요", "먹아요", "먹해요"], 0, "ㅓ vowel → 어요."),
         mcq("Future of „가다“:", ["갈 거예요", "갔어요", "가요"], 0, "-(으)ㄹ 거예요."),
         mcq("Counter for people:", ["명", "개", "권"], 0, "명."),
         mcq("„주세요“ means:", ["please give me", "it is", "goodbye"], 0, "Request.")])

    exam = [
        mcq("„아버지“ means:", ["father", "mother", "brother"], 0, "아버지 = father.", skill="vocabulary"),
        mcq("„사다“ means:", ["to buy", "to live", "to go"], 0, "사다 = buy.", skill="vocabulary"),
        mcq("학교___ 가요. (to school)", ["에", "에서", "를"], 0, "Destination → 에.", skill="grammar"),
        mcq("식당___ 밥을 먹어요. (at the restaurant)", ["에서", "에", "이"], 0, "Action location → 에서.", skill="grammar"),
        fill("어제 책을 ___. (읽다, past)", "읽었어요", "읽다 → 읽었어요.", skill="grammar"),
        fix("저는 사과를 먹아요.", "저는 사과를 먹어요.", "먹다 → 먹어요.", skill="grammar"),
        mcq("Read: „오늘은 바빠요. 내일 전화할 거예요.“ When will the writer call?", ["tomorrow", "today", "yesterday"], 0, "내일.", skill="reading"),
        mcq("Read: „이 식당은 싸고 맛있어요.“ The restaurant is…", ["cheap and tasty", "expensive", "closed"], 0, "싸고 맛있어요.", skill="reading"),
        listen("커피 두 잔 주세요.", "How many coffees?", ["2", "1", "3"], 0, "두 잔 = two cups.", skill="listening"),
        listen("어제 집에서 쉬었어요.", "What did the speaker do yesterday?", ["rested at home", "worked", "travelled"], 0, "쉬었어요 = rested.", skill="listening"),
        trans("I eat rice.", ["밥을 먹어요.", "저는 밥을 먹어요."], "Object particle 을.", skill="writing"),
        mcq("At a restaurant, to order bulgogi:", ["불고기 주세요.", "불고기예요.", "불고기 있어요?"], 0, "N 주세요.", skill="conversation"),
    ]
    return level("ko", "L2", 2, "Beginner",
                 "Everyday conversations, particles, basic sentence structure, present/past/future, polite speech, family, food and shopping.",
                 TOPIK_NOTE.format("I, levels 1–2", ""),
                 ["Everyday conversations", "Particles", "Subject & object markers", "Sentence structure", "Present, past & future",
                  "Polite speech", "Family, food & shopping", "Basic listening & reading"], m, exam)


def l3():
    m = {}
    m["vocabulary"] = lesson("Travel and descriptions",
        "Words for trips, weather and describing places.",
        [voc(("여행", "trip, travel", "yeo-haeng"), ("기차", "train", "gi-cha"), ("표", "ticket", "pyo"), ("예약하다", "to reserve", "ye-yak-ha-da"),
             ("날씨", "weather", "nal-ssi"), ("덥다", "to be hot (weather)", "deop-da"), ("춥다", "to be cold (weather)", "chup-da"),
             ("조용하다", "to be quiet", "jo-yong-ha-da"), ("유명하다", "to be famous", "yu-myeong-ha-da"), ("경치", "scenery", "gyeong-chi"),
             ("숙소", "accommodation", "suk-so"), ("관광지", "tourist spot", "gwan-gwang-ji"))],
        [mcq("„예약하다“ means:", ["to reserve", "to travel", "to arrive"], 0, "예약 = reservation."),
         match([("기차", "train"), ("날씨", "weather"), ("경치", "scenery"), ("숙소", "accommodation")]),
         mcq("Opposite of „덥다“:", ["춥다", "조용하다", "유명하다"], 0, "hot ↔ cold."),
         fill("제주도는 ___ 관광지예요. (famous: 유명하다 + -(으)ㄴ)", "유명한", "Adjective before noun: 유명한.")])

    m["grammar"] = lesson("Connectors and describing nouns",
        "-고, -지만, -아서/어서, -(으)니까, -(으)면 and adjective + -(으)ㄴ.",
        [tbl(["Connector", "Meaning", "Example"], ["-고", "and (then)", "밥을 먹고 공부해요."], ["-지만", "but", "비싸지만 좋아요."],
             ["-아서/어서", "because / so (not with commands)", "피곤해서 일찍 잤어요."], ["-(으)니까", "because (OK with commands/suggestions)", "비가 오니까 우산을 가져가세요."],
             ["-(으)면", "if / when", "시간이 있으면 같이 가요."]),
         tbl(["Describing a noun", "Form", "Example"], ["adjective (present)", "-(으)ㄴ", "조용한 카페 (a quiet café)"], ["verb (present)", "-는", "제가 읽는 책 (the book I'm reading)"]),
         tip("-아서/어서 never takes a past tense marker: 피곤했어서 ✗ → 피곤해서 ✓.")],
        [mcq("비가 와서 ___.", ["집에 있었어요", "우산을 가져가세요", "같이 가요"], 0, "-아서 cannot be followed by a command or suggestion."),
         fill("한국어는 어렵___ 재미있어요. (but)", "지만", "-지만 = but."),
         mcq("“a quiet café”:", ["조용한 카페", "조용하는 카페", "조용하고 카페"], 0, "Adjective → -(으)ㄴ."),
         fix("어제 피곤했어서 일찍 잤어요.", "어제 피곤해서 일찍 잤어요.", "No past tense before -아서/어서."),
         order("시간이 있으면 같이 가요.", tr="If you have time, let's go together.")])

    m["reading"] = lesson("Reading: a trip to Gyeongju",
        "A travel blog with connectors and descriptions.",
        [psg("경주 여행",
             "지난달에 친구하고 경주에 갔어요. 서울에서 기차를 타고 두 시간쯤 걸렸어요. 경주는 오래된 도시라서 유명한 관광지가 많아요. "
             "불국사는 경치가 아름답고 조용했지만 사람이 조금 많았어요. 날씨가 더워서 오후에는 숙소에서 쉬었어요. 다음에는 가을에 가고 싶어요.",
             "Last month I went to Gyeongju with a friend. We took the train from Seoul and it took about two hours. Gyeongju is an old city, so there "
             "are many famous sights. Bulguksa had beautiful scenery and was peaceful, but there were quite a few people. Because the weather was hot, "
             "we rested at our accommodation in the afternoon. Next time I want to go in autumn."),
         voc(("오래되다", "to be old (not new)", "o-rae-doe-da"), ("걸리다", "to take (time)", "geol-li-da"), ("-고 싶다", "want to", "go sip-da"))],
        [mcq("How did they travel?", ["by train", "by plane", "by bus"], 0, "기차를 타고."),
         mcq("Why are there many sights in Gyeongju?", ["It's an old city.", "It's the capital.", "It's by the sea."], 0, "오래된 도시라서."),
         mcq("Why did they rest in the afternoon?", ["It was hot.", "It rained.", "They were ill."], 0, "날씨가 더워서."),
         mcq("When does the writer want to go next time?", ["autumn", "summer", "winter"], 0, "가을.")])

    m["writing"] = lesson("Writing: describing a place",
        "Use adjectives and connectors to describe somewhere you know.",
        [ex("제 고향은 조용하고 아름다운 도시예요.", "My hometown is a quiet and beautiful city."),
         ex("음식이 맛있지만 조금 비싸요.", "The food is tasty but a bit expensive."),
         tip("Aim for variety: one -고, one -지만 and one -아서/어서 in your paragraph.")],
        [write("Describe your hometown or a favourite place in 4–6 sentences. Use -고, -지만 and -아서/어서.", 20,
               ["고", "지만", "서"],
               "제 고향은 하이데라바드예요. 하이데라바드는 크고 역사가 오래된 도시예요. 음식이 맵지만 정말 맛있어요. 여름에는 날씨가 더워서 "
               "저녁에 산책해요. 유명한 관광지도 많아서 여행객이 많이 와요."),
         fill("날씨가 좋___ 공원에 갔어요. (because)", "아서", "좋다 → 좋아서."),
         mcq("“a famous restaurant”:", ["유명한 식당", "유명하는 식당", "유명해서 식당"], 0, "-(으)ㄴ.")])

    m["listening"] = lesson("Listening: stations and reservations",
        "Announcements and phone calls when travelling.",
        [voc(("출발", "departure"), ("도착", "arrival"), ("번 출구", "exit number"), ("갈아타다", "to transfer (lines)"))],
        [listen("이번 역은 시청역입니다. 1호선으로 갈아타실 분은 이번 역에서 내리십시오.", "What should you do to transfer to Line 1?",
                ["get off at this station", "stay on the train", "go to exit 1"], 0, "이번 역에서 내리십시오."),
         listen("부산행 기차는 오후 세 시 반에 출발합니다.", "When does the train to Busan leave?", ["3:30 pm", "3:00 pm", "1:30 pm"], 0, "세 시 반."),
         listen("이번 주 토요일에 두 명 예약하고 싶어요.", "What does the caller want?", ["a reservation for two this Saturday", "to cancel on Saturday", "a table for one today"], 0, "두 명 예약.")])

    m["speaking"] = lesson("Speaking: travel situations",
        "Buy tickets, ask the way and make requests.",
        [ex("부산 가는 표 한 장 주세요.", "One ticket to Busan, please."), ex("이 근처에 화장실이 어디에 있어요?", "Where is a restroom near here?"),
         ex("사진 좀 찍어 주시겠어요?", "Could you take a photo for me?")],
        [speak("부산 가는 표 한 장 주세요.", "One ticket to Busan, please."),
         speak("이 근처에 화장실이 어디에 있어요?", "Is there a restroom near here?"),
         speak("사진 좀 찍어 주시겠어요?", "Could you take a photo for me?"),
         mcq("Counter for tickets:", ["장", "명", "개"], 0, "장 counts flat things like tickets and paper.")])

    m["pronunciation"] = lesson("Sound changes: nasalisation",
        "Why 감사합니다 sounds like [감사함니다].",
        [txt("When ㄱ, ㄷ, ㅂ sounds meet ㄴ or ㅁ, they become nasal: ㅂ→ㅁ, ㄷ→ㄴ, ㄱ→ㅇ."),
         tbl(["Spelling", "Pronounced", "Rule"], ["합니다", "[함니다]", "ㅂ + ㄴ → ㅁ + ㄴ"], ["거짓말", "[거진말]", "ㄷ-sound + ㅁ → ㄴ"], ["한국말", "[한궁말]", "ㄱ + ㅁ → ㅇ + ㅁ"])],
        [pron("감사합니다", "thank you", "Say [감사함니다]"), pron("한국말", "Korean language", "Say [한궁말]"), pron("입니다", "it is (formal)", "Say [임니다]"),
         mcq("„합니다“ is pronounced:", ["[함니다]", "[합니다] with a clear p", "[하니다]"], 0, "Nasalisation."),
         mcq("„한국말“ is pronounced:", ["[한궁말]", "[한국말]", "[항국말]"], 0, "ㄱ before ㅁ → ㅇ.")])

    m["conversation"] = lesson("Conversation: checking in",
        "At a guesthouse front desk.",
        [dlg("숙소에서",
             ("직원", "어서 오세요. 예약하셨어요?", "Welcome. Do you have a reservation?"),
             ("손님", "네, 라비 이름으로 2박 예약했어요.", "Yes, I booked two nights under the name Ravi."),
             ("직원", "여권 좀 보여 주시겠어요?", "Could you show me your passport?"),
             ("손님", "여기 있어요. 아침 식사는 몇 시부터예요?", "Here it is. From what time is breakfast?"),
             ("직원", "일곱 시부터 아홉 시까지예요.", "From seven to nine."))],
        [mcq("„2박“ means:", ["two nights", "two people", "two rooms"], 0, "박 counts nights."),
         order("여권 좀 보여 주시겠어요?", tr="Could you show me your passport?"),
         mcq("Breakfast is served:", ["7–9", "6–8", "8–10"], 0, "일곱 시부터 아홉 시까지."),
         fill("일곱 시___ 아홉 시까지 (from)", "부터", "-부터 … -까지 = from … to.")])

    m["exercises"] = lesson("Mixed practice: Level 3",
        "Connectors and descriptive forms.",
        [tip("If the second clause is a command or suggestion, use -(으)니까, not -아서/어서.")],
        [mcq("늦었___ 택시를 타세요. (because; command follows)", ["으니까", "어서"], 0, "Command → -(으)니까."),
         fill("밥을 먹___ 커피를 마셨어요. (and then)", "고", "-고."),
         trans("It's expensive but good.", ["비싸지만 좋아요."], "-지만."),
         order("제가 좋아하는 음식은 김치찌개예요.", tr="The food I like is kimchi stew."),
         fix("어제 바빠서 전화하세요.", ["어제 바빠서 전화 못 했어요.", "어제 바빠서 전화를 못 했어요."], "-아서 can't be followed by a command.")])

    m["quiz"] = lesson("Level 3 quiz", "Five questions across Level 3.",
        [tip("Watch the restrictions on -아서/어서.")],
        [mcq("“If it rains, I'll stay home.”", ["비가 오면 집에 있을 거예요.", "비가 와서 집에 있을 거예요.", "비가 오고 집에 있을 거예요."], 0, "-(으)면 = if."),
         mcq("“a person who works hard”:", ["열심히 일하는 사람", "열심히 일한 사람이에요", "열심히 일해서 사람"], 0, "Verb → -는."),
         mcq("„경치“ means:", ["scenery", "price", "luggage"], 0, "경치 = scenery."),
         mcq("Pronunciation of „입니다“:", ["[임니다]", "[입니다]", "[이니다]"], 0, "Nasalisation."),
         mcq("-지만 means:", ["but", "and", "if"], 0, "Contrast.")])

    exam = [
        mcq("„도착“ means:", ["arrival", "departure", "transfer"], 0, "도착 = arrival.", skill="vocabulary"),
        mcq("„조용하다“ means:", ["to be quiet", "to be famous", "to be cold"], 0, "quiet.", skill="vocabulary"),
        mcq("배가 고파___ 밥을 먹었어요.", ["서", "지만", "면"], 0, "Reason → -아서/어서.", skill="grammar"),
        mcq("시간이 없___ 내일 만나요. (suggestion follows)", ["으니까", "어서"], 0, "Suggestion → -(으)니까.", skill="grammar"),
        fill("이 옷은 예쁘___ 비싸요. (but)", "지만", "-지만.", skill="grammar"),
        fix("친절하는 사람", "친절한 사람", "Adjective → -(으)ㄴ.", skill="grammar"),
        mcq("Read: „주말이라서 사람이 많았지만 경치가 정말 좋았어요.“ What was good?", ["the scenery", "the crowd", "the weather"], 0, "경치가 좋았어요.", skill="reading"),
        mcq("Read: „표가 매진돼서 다음 기차를 탔어요.“ Why did they take the next train?", ["tickets sold out", "they were late", "the train broke"], 0, "매진 = sold out.", skill="reading"),
        listen("서울역에서 출발하는 기차는 오전 열 시에 도착합니다.", "When does the train arrive?", ["10 am", "10 pm", "2 am"], 0, "오전 열 시.", skill="listening"),
        listen("2번 출구로 나가서 오른쪽으로 가세요.", "Which exit?", ["2", "3", "12"], 0, "2번 출구.", skill="listening"),
        trans("If you have time, let's go together.", ["시간이 있으면 같이 가요.", "시간 있으면 같이 가요."], "-(으)면.", skill="writing"),
        mcq("At the hotel desk, “I have a reservation”:", ["예약했어요.", "예약해요?", "예약할 거예요?"], 0, "Past: I reserved.", skill="conversation"),
    ]
    return level("ko", "L3", 3, "Lower Intermediate",
                 "Expanded vocabulary, grammar patterns and connectors, descriptive sentences, travel situations, and intermediate reading and listening.",
                 TOPIK_NOTE.format("I, level 2 → TOPIK II, level 3 bridge", ""),
                 ["Expanded vocabulary", "Grammar patterns", "Daily-life conversations", "Connectors", "Descriptive sentences",
                  "Travel situations", "Intermediate reading", "Listening comprehension"], m, exam)
