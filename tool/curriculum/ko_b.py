"""Korean Levels 4–6."""
from dsl import *
from ko_a import TOPIK_NOTE

WRITING = ", plus writing in TOPIK II"


def l4():
    m = {}
    m["vocabulary"] = lesson("Feelings, opinions and honorific words",
        "Express emotions and use respectful vocabulary.",
        [voc(("기쁘다", "to be glad", "gi-ppeu-da"), ("슬프다", "to be sad"), ("걱정되다", "to be worried"), ("실망하다", "to be disappointed"),
             ("의견", "opinion"), ("찬성하다", "to agree / be in favour"), ("반대하다", "to oppose")),
         tbl(["Plain", "Honorific", "Meaning"], ["집", "댁", "home"], ["나이", "연세", "age"], ["밥", "진지", "meal"], ["있다", "계시다", "to be (somewhere)"],
             ["먹다", "드시다 / 잡수시다", "to eat"], ["자다", "주무시다", "to sleep"], ["말", "말씀", "words / speech"]),
         tip("Use honorific words when talking ABOUT someone older or senior — and never about yourself.")],
        [mcq("Honorific of „나이“:", ["연세", "댁", "진지"], 0, "연세 = age (honorific)."),
         match([("기쁘다", "glad"), ("슬프다", "sad"), ("걱정되다", "worried"), ("찬성하다", "to agree")]),
         mcq("Talking about your grandfather sleeping:", ["할아버지께서 주무세요.", "할아버지가 자요.", "할아버지께서 자요."], 0, "주무시다 + 께서."),
         fill("할머니 ___에 가요. (to grandmother's home, honorific)", "댁", "댁 = home (honorific).")])

    m["grammar"] = lesson("Honorifics, speech levels and giving opinions",
        "-(으)시-, 께서/께, three speech levels, -는 것 같다 and -다고 생각하다.",
        [head("Subject honorific -(으)시-"),
         tbl(["Plain", "Honorific", "Example"], ["가요", "가세요", "선생님께서 학교에 가세요."], ["읽어요", "읽으세요", "아버지께서 신문을 읽으세요."], ["이/가", "께서", "subject particle"], ["에게", "께", "to (someone senior)"]),
         head("Speech levels"),
         tbl(["Level", "Use", "Example"], ["합니다체 (formal polite)", "presentations, news, first business contact", "감사합니다. 시작하겠습니다."],
             ["해요체 (informal polite)", "most everyday polite talk", "고마워요. 시작할게요."], ["반말 (plain/informal)", "close friends, younger people", "고마워. 시작할게."]),
         head("Opinions and impressions"),
         tbl(["Pattern", "Meaning", "Example"], ["-는 것 같아요", "it seems / I think (soft)", "비가 올 것 같아요."], ["-다고 생각해요", "I think that …", "이 계획이 좋다고 생각해요."]),
         tip("Switching to 반말 without being invited can sound rude. Wait for “말 놓으세요” (please speak casually).")],
        [mcq("Honorific of „가요“:", ["가세요", "가요세", "가시요"], 0, "-(으)세요."),
         mcq("Formal polite style:", ["감사합니다.", "고마워요.", "고마워."], 0, "합니다체."),
         fill("내일 비가 올 것 ___. (it seems)", "같아요", "-(으)ㄹ 것 같아요."),
         fix("선생님이 지금 자요.", ["선생님께서 지금 주무세요.", "선생님이 지금 주무세요."], "Use 주무시다 (and ideally 께서) for a teacher."),
         order("저는 이 계획이 좋다고 생각해요.", tr="I think this plan is good.")])

    m["reading"] = lesson("Reading: an opinion column",
        "Arguments for and against a four-day school week.",
        [psg("주 4일 수업, 어떻게 생각하세요?",
             "요즘 일부 학교에서 주 4일 수업을 시범적으로 운영하고 있다. 찬성하는 사람들은 학생들이 충분히 쉬면 집중력이 높아진다고 말한다. "
             "반면에 반대하는 사람들은 수업 시간이 줄어들어 학습량이 부족해질 것 같다고 걱정한다. 또한 부모가 일하는 가정은 아이를 돌보기가 "
             "어려워질 수 있다. 결국 중요한 것은 학생들에게 실제로 도움이 되는지 확인하는 것이다.",
             "Recently some schools have been trialling a four-day school week. Supporters say that if students rest enough, their concentration improves. "
             "On the other hand, opponents worry that with fewer class hours students may not learn enough. Also, families where parents work may find "
             "childcare harder. In the end, what matters is checking whether it actually helps students."),
         tip("Written Korean often uses the plain -다 style (운영하고 있다, 말한다) instead of -아요/어요.")],
        [mcq("What do supporters say?", ["Rest improves concentration.", "Students learn more hours.", "Parents prefer it."], 0, "집중력이 높아진다."),
         mcq("What do opponents worry about?", ["less learning time", "too much homework", "expensive buses"], 0, "학습량이 부족해질 것 같다."),
         mcq("„반면에“ signals:", ["contrast", "result", "example"], 0, "반면에 = on the other hand."),
         mcq("Which families may struggle?", ["those where parents work", "those with many children", "those far from school"], 0, "부모가 일하는 가정.")])

    m["writing"] = lesson("Writing: a short opinion paragraph",
        "Practical writing in the plain written style.",
        [tbl(["Function", "Expression"], ["Opinion", "나는 …다고 생각한다."], ["Reason", "왜냐하면 …기 때문이다."], ["Contrast", "반면에 …"], ["Conclusion", "따라서 …"]),
         tip("TOPIK II writing tasks expect the plain written style (-다), not -아요/어요.")],
        [write("In 5–7 sentences of plain written style (-다), give your opinion on the four-day school week with a reason and a contrast.", 30,
               ["생각한다|생각합니다", "때문", "반면|하지만|그러나"],
               "나는 주 4일 수업에 찬성한다고 생각한다. 왜냐하면 학생들이 충분히 쉬면 공부에 더 집중할 수 있기 때문이다. 또한 주말에 가족과 "
               "보내는 시간이 늘어난다. 반면에 수업 시간이 줄어드는 문제가 있다. 따라서 학교는 수업 내용을 효율적으로 바꿔야 한다."),
         fill("늦게 일어났기 ___에 지각했다. (because)", "때문", "-기 때문에."),
         mcq("Plain written form of „가요“:", ["간다", "가요다", "갑니다요"], 0, "Verb with vowel stem → -ㄴ다.")])

    m["listening"] = lesson("Listening: feelings and opinions",
        "Recognise tone and opinion in conversation.",
        [tip("Listen for -는 것 같아요 (softened opinion) and -네요 (surprise / realisation).")],
        [listen("시험을 잘 못 봐서 너무 속상해요.", "How does the speaker feel?", ["upset", "excited", "relaxed"], 0, "속상하다 = upset."),
         listen("저는 그 의견에 반대해요. 비용이 너무 많이 드는 것 같아요.", "Why does the speaker disagree?", ["it seems too costly", "it takes too long", "it is unsafe"], 0, "비용이 많이 들다."),
         listen("할머니께서 다음 주에 저희 집에 오세요.", "Who is coming next week?", ["grandmother", "a friend", "a teacher"], 0, "할머니께서 오세요."),
         listen("발표는 다음 주 월요일 오전 열 시에 시작하겠습니다.", "When does the presentation start?", ["next Monday 10 am", "this Monday 10 am", "next Monday 10 pm"], 0, "다음 주 월요일 오전 열 시.")])

    m["speaking"] = lesson("Speaking: polite opinions and feelings",
        "Speak about feelings and views respectfully.",
        [ex("제 생각에는 그 방법이 더 좋은 것 같아요.", "In my view, that method seems better."), ex("말씀 잘 들었습니다.", "Thank you for your words. (formal)"),
         ex("걱정하지 마세요.", "Don't worry.")],
        [speak("제 생각에는 그 방법이 더 좋은 것 같아요.", "In my view, that method seems better."),
         speak("말씀 잘 들었습니다.", "I listened carefully to what you said."),
         speak("걱정하지 마세요.", "Don't worry."),
         mcq("To speak to your boss in a meeting, use:", ["합니다체 / 해요체 with honorifics", "반말", "plain -다 style"], 0, "Respectful levels.")])

    m["pronunciation"] = lesson("Sound changes: tensification and ㅎ",
        "Hidden tense consonants and the weakened ㅎ.",
        [tbl(["Spelling", "Pronounced", "Note"], ["학교", "[학꾜]", "ㄱ final + ㄱ → ㄲ"], ["식당", "[식땅]", "ㄱ + ㄷ → ㄸ"], ["좋아요", "[조아요]", "ㅎ disappears before a vowel"],
             ["축하해요", "[추카해요]", "ㄱ + ㅎ → ㅋ"], ["입학", "[이팍]", "ㅂ + ㅎ → ㅍ"])],
        [pron("학교", "school", "Say [학꾜]"), pron("좋아요", "good", "Say [조아요]"), pron("축하해요", "congratulations", "Say [추카해요]"),
         mcq("„식당“ is pronounced:", ["[식땅]", "[식당] soft", "[시당]"], 0, "Tensification."),
         mcq("„좋아요“ is pronounced:", ["[조아요]", "[좋하요]", "[조타요]"], 0, "ㅎ drops before a vowel.")])

    m["conversation"] = lesson("Conversation: talking with a senior colleague",
        "Mixing honorifics naturally at work.",
        [dlg("회사에서",
             ("민지", "부장님, 주말 잘 보내셨어요?", "Did you have a good weekend, sir?"),
             ("부장", "네, 가족들하고 바다에 다녀왔어요. 민지 씨는요?", "Yes, I went to the seaside with my family. And you, Minji?"),
             ("민지", "저는 집에서 쉬었어요. 그런데 내일 회의 자료는 언제까지 드리면 될까요?", "I rested at home. By when should I give you the materials for tomorrow's meeting?"),
             ("부장", "오늘 오후 다섯 시까지 보내 주세요.", "Please send them by 5 pm today."))],
        [mcq("Why does Minji use „드리다“?", ["She is giving something to a senior.", "It is the future tense.", "It is a question marker."], 0, "드리다 = humble 'give'."),
         order("주말 잘 보내셨어요?", tr="Did you have a good weekend? (honorific)"),
         mcq("Deadline for the materials:", ["5 pm today", "tomorrow morning", "this weekend"], 0, "오늘 오후 다섯 시까지."),
         fill("언제까지 ___면 될까요? (give, humble)", "드리", "드리다 → 드리면.")])

    m["exercises"] = lesson("Mixed practice: Level 4",
        "Honorifics, speech levels and opinion patterns.",
        [tip("Check who you are talking about (subject honorifics) and who you are talking to (speech level).")],
        [mcq("어머니께서 저녁을 ___.", ["드세요", "먹어요", "먹으세요"], 0, "먹다 → 드시다 for elders."),
         fill("선생님께 선물을 ___. (gave, humble, past polite)", ["드렸어요", "드렸습니다"], "드리다 → 드렸어요."),
         trans("I think it will be hard.", ["어려울 것 같아요.", "어려울 거라고 생각해요."], "-(으)ㄹ 것 같아요."),
         match([("합니다체", "formal polite"), ("해요체", "informal polite"), ("반말", "casual"), ("-(으)시-", "subject honorific")]),
         order("할아버지께서 신문을 읽으세요.", tr="Grandfather is reading the newspaper.")])

    m["quiz"] = lesson("Level 4 quiz", "Five questions across Level 4.",
        [tip("Decide the relationship first, then the form.")],
        [mcq("Honorific of „있다“ (person):", ["계시다", "있으시다", "드시다"], 0, "계시다."),
         mcq("Subject particle for elders:", ["께서", "이/가", "께"], 0, "께서."),
         mcq("„-는 것 같아요“ makes a statement:", ["softer / less certain", "stronger", "past"], 0, "Hedging."),
         mcq("„실망하다“ means:", ["to be disappointed", "to be relieved", "to be proud"], 0, "disappointed."),
         mcq("„학교“ is pronounced:", ["[학꾜]", "[하교]", "[학교] soft"], 0, "Tensification.")])

    exam = [
        mcq("„말씀“ is the honorific of:", ["말", "밥", "집"], 0, "말 → 말씀.", skill="vocabulary"),
        mcq("„반대하다“ means:", ["to oppose", "to agree", "to repeat"], 0, "oppose.", skill="vocabulary"),
        mcq("사장님께서 회의실에 ___.", ["계세요", "있어요", "있으세요요"], 0, "계시다 → 계세요.", skill="grammar"),
        mcq("Formal style for a presentation:", ["시작하겠습니다.", "시작할게.", "시작해."], 0, "합니다체.", skill="grammar"),
        fill("이 영화가 재미있을 것 ___. (seems)", "같아요", "-(으)ㄹ 것 같아요.", skill="grammar"),
        fix("할머니가 밥을 먹어요.", ["할머니께서 진지를 드세요.", "할머니께서 진지를 잡수세요."], "Use honorific particle, noun and verb.", skill="grammar"),
        mcq("Read: „찬성하는 의견도 있지만 반대하는 사람이 더 많다.“", ["More people oppose it.", "More people support it.", "Nobody has an opinion."], 0, "반대하는 사람이 더 많다.", skill="reading"),
        mcq("Read: „비용 문제 때문에 계획이 연기되었다.“ Why was the plan postponed?", ["cost", "weather", "staff"], 0, "비용 = cost.", skill="reading"),
        listen("요즘 일이 많아서 좀 피곤한 것 같아요.", "How does the speaker seem?", ["a bit tired", "very happy", "angry"], 0, "피곤한 것 같아요.", skill="listening"),
        listen("교수님께서 내일 연구실에 안 계십니다.", "Where won't the professor be tomorrow?", ["in the office/lab", "at home", "in class"], 0, "연구실 = office/lab.", skill="listening"),
        trans("I think this plan is good.", ["이 계획이 좋다고 생각해요.", "저는 이 계획이 좋다고 생각해요.", "이 계획이 좋은 것 같아요."], "-다고 생각해요.", skill="writing"),
        mcq("To a senior: “Please have some food.”", ["많이 드세요.", "많이 먹어.", "많이 먹어라."], 0, "드시다.", skill="conversation"),
    ]
    return level("ko", "L4", 4, "Intermediate",
                 "Complex sentences, honorifics and speech levels, opinions and feelings, longer conversations and practical writing.",
                 TOPIK_NOTE.format("II, levels 3–4", WRITING),
                 ["Complex sentences", "Honorifics", "Speech levels", "Giving opinions", "Expressing feelings",
                  "Longer conversations", "Practical writing", "Intermediate TOPIK preparation"], m, exam)


def l5():
    m = {}
    m["vocabulary"] = lesson("News, economy and academic vocabulary",
        "Sino-Korean vocabulary used in news and formal writing.",
        [voc(("경제", "economy"), ("정부", "government"), ("정책", "policy"), ("증가하다", "to increase"), ("감소하다", "to decrease"),
             ("영향", "influence, impact"), ("원인", "cause"), ("결과", "result"), ("조사", "survey, investigation"),
             ("발표하다", "to announce / present"), ("해결하다", "to solve"), ("대책", "countermeasure"))],
        [mcq("„감소하다“ means:", ["to decrease", "to increase", "to announce"], 0, "감소 = decrease."),
         match([("원인", "cause"), ("결과", "result"), ("정책", "policy"), ("영향", "impact")]),
         fill("인구가 계속 ___하고 있다. (decrease)", "감소", "감소하다."),
         mcq("„대책을 마련하다“ means:", ["to prepare countermeasures", "to cancel a policy", "to hold an election"], 0, "대책 = countermeasure.")])

    m["grammar"] = lesson("Formal written grammar",
        "-에 따르면, nominalisers -(으)ㅁ/-기, -는 반면(에), -(으)ㄹ 뿐만 아니라, -에 비해.",
        [tbl(["Pattern", "Meaning", "Example"], ["-에 따르면", "according to", "조사에 따르면 …"], ["-(으)ㅁ", "nominaliser (written, notices)", "회의가 연기됨."],
             ["-기", "nominaliser (habits, goals)", "운동하기가 어렵다."], ["-는 반면(에)", "whereas", "가격은 오른 반면 품질은 그대로다."],
             ["-(으)ㄹ 뿐만 아니라", "not only … but also", "싸 뿐만 아니라 → 쌀 뿐만 아니라 품질도 좋다."], ["-에 비해(서)", "compared with", "작년에 비해 증가했다."]),
         tip("News headlines often end in nouns: „물가 상승… 정부 대책 발표“ = prices rise… government announces measures.")],
        [fill("조사___ 따르면 응답자의 60%가 찬성했다.", "에", "-에 따르면."),
         mcq("작년___ 비해 수출이 늘었다.", ["에", "을", "이"], 0, "-에 비해."),
         mcq("“not only cheap but also good”:", ["쌀 뿐만 아니라 좋다", "싸는 반면 좋다", "싸기 때문에 좋다"], 0, "-(으)ㄹ 뿐만 아니라."),
         fix("도시는 편리하는 반면 시끄럽다.", "도시는 편리한 반면 시끄럽다.", "Adjectives take -(으)ㄴ 반면."),
         order("정부는 새로운 대책을 발표했다.", tr="The government announced new measures.")])

    m["reading"] = lesson("Reading: a news article",
        "A news report in formal written style.",
        [psg("1인 가구 증가",
             "통계청 조사에 따르면 지난해 1인 가구가 전체 가구의 30%를 넘은 것으로 나타났다. 이는 10년 전에 비해 크게 증가한 수치이다. "
             "전문가들은 결혼 연령이 높아지고 고령 인구가 늘어난 것을 주요 원인으로 꼽았다. 1인 가구가 늘어난 반면 이들을 위한 주거 정책은 "
             "아직 부족하다는 지적이 나온다. 정부는 소형 주택 공급을 확대하는 대책을 검토하고 있다.",
             "According to a Statistics Korea survey, single-person households exceeded 30% of all households last year. This is a large increase "
             "compared with ten years ago. Experts named rising marriage age and a growing elderly population as the main causes. While single-person "
             "households have grown, there is criticism that housing policy for them is still insufficient. The government is reviewing measures to "
             "expand the supply of small homes."),
         tip("This is a practice text; check current figures in real news sources.")],
        [mcq("What exceeded 30%?", ["single-person households", "elderly population", "small homes"], 0, "1인 가구."),
         mcq("Main causes given:", ["later marriage and an ageing population", "high rent and low wages", "migration abroad"], 0, "결혼 연령, 고령 인구."),
         mcq("What criticism is mentioned?", ["housing policy is insufficient", "too many houses", "taxes are too high"], 0, "주거 정책이 부족하다."),
         mcq("What is the government doing?", ["reviewing more small-home supply", "banning single households", "cutting housing"], 0, "소형 주택 공급 확대.")])

    m["writing"] = lesson("Writing: describing data (TOPIK II style)",
        "Describe trends in a graph in 200–300 characters of written style.",
        [tbl(["Function", "Expression"], ["Introduce", "…에 대해 조사한 결과 …"], ["Increase", "…에서 …로 증가했다"], ["Decrease", "…로 감소했다"], ["Reason", "그 원인은 …(으)로 보인다"], ["Forecast", "앞으로 …(으)ㄹ 것으로 예상된다"]),
         tip("Use the plain -다 style and connect sentences logically. Numbers make the description precise.")],
        [write("Describe this trend in written style (40+ words): smartphone use by people over 60 rose from 30% in 2015 to 75% in 2025. "
               "Give a possible reason and a forecast.", 40,
               ["증가", "원인|때문", "예상"],
               "60세 이상 노인의 스마트폰 사용률에 대해 조사한 결과, 2015년 30%에서 2025년 75%로 크게 증가한 것으로 나타났다. 그 원인은 "
               "스마트폰 사용법이 쉬워지고 은행이나 병원 예약 등 생활 서비스가 모바일로 바뀌었기 때문으로 보인다. 앞으로도 사용률은 계속 "
               "증가할 것으로 예상된다."),
         fill("앞으로 계속 증가할 것으로 ___. (is expected)", "예상된다", "-(으)ㄹ 것으로 예상된다."),
         mcq("Written-style ending:", ["증가했다", "증가했어요", "증가했어"], 0, "Plain -다 style.")])

    m["listening"] = lesson("Listening: news and lectures",
        "Formal announcements and broadcast style.",
        [tip("News uses -습니다 and many Sino-Korean nouns. Catch the topic noun, then the verb at the end.")],
        [listen("오늘 서울의 낮 최고 기온은 영하 오 도로 예상됩니다.", "What is today's high in Seoul?", ["minus 5 °C", "plus 5 °C", "minus 15 °C"], 0, "영하 = below zero."),
         listen("정부는 청년 일자리를 늘리기 위한 새로운 정책을 발표했습니다.", "What was announced?", ["a policy to increase youth jobs", "a new tax", "a holiday"], 0, "청년 일자리."),
         listen("이번 연구는 수면 시간이 기억력에 미치는 영향을 분석했습니다.", "What did the study analyse?", ["the effect of sleep on memory", "the cost of sleep", "memory in animals"], 0, "수면 → 기억력."),
         listen("교통사고는 작년에 비해 십 퍼센트 감소했습니다.", "What happened to traffic accidents?", ["down 10% on last year", "up 10%", "no change"], 0, "감소.")])

    m["speaking"] = lesson("Speaking: formal presentations",
        "Open, structure and close a formal talk.",
        [ex("지금부터 발표를 시작하겠습니다.", "I will now begin the presentation."), ex("다음으로 조사 결과를 말씀드리겠습니다.", "Next, I'll tell you the survey results."),
         ex("이상으로 발표를 마치겠습니다. 감사합니다.", "That concludes my presentation. Thank you.")],
        [speak("지금부터 발표를 시작하겠습니다.", "I will now begin the presentation."),
         speak("다음으로 조사 결과를 말씀드리겠습니다.", "Next, I'll present the survey results."),
         speak("이상으로 발표를 마치겠습니다.", "That concludes my presentation."),
         mcq("„말씀드리겠습니다“ is:", ["humble formal 'I will tell you'", "a question", "casual speech"], 0, "말씀드리다 (humble).")])

    m["pronunciation"] = lesson("Pronunciation: liquidisation and formal reading",
        "ㄴ next to ㄹ becomes ㄹ; reading formal text fluently.",
        [tbl(["Spelling", "Pronounced"], ["신라", "[실라]"], ["연락", "[열락]"], ["설날", "[설랄]"], ["관련", "[괄련]"]),
         tip("Read news sentences aloud in chunks: noun phrase | verb phrase. Pause at commas, not inside nouns.")],
        [pron("연락", "contact", "Say [열락]"), pron("관련", "relation", "Say [괄련]"),
         pron("정부는 새로운 정책을 발표했습니다.", "The government announced a new policy."),
         mcq("„설날“ is pronounced:", ["[설랄]", "[선날]", "[설날] with n"], 0, "ㄹ + ㄴ → ㄹㄹ.")])

    m["conversation"] = lesson("Conversation: a formal discussion",
        "Discuss a policy using formal expressions.",
        [dlg("토론: 대중교통 무료화",
             ("사회자", "대중교통 무료화에 대해 어떻게 생각하십니까?", "What do you think about free public transport?"),
             ("김 교수", "환경 측면에서는 긍정적인 효과가 있을 것으로 보입니다.", "From an environmental standpoint, it appears to have positive effects."),
             ("이 연구원", "하지만 재정 부담이 크다는 점도 고려해야 합니다.", "But we must also consider the large financial burden."),
             ("김 교수", "그 점에는 동의합니다. 단계적으로 시행하는 방안을 제안합니다.", "I agree with that. I propose implementing it in stages."))],
        [mcq("What concern does 이 연구원 raise?", ["financial burden", "safety", "pollution"], 0, "재정 부담."),
         mcq("What does 김 교수 propose?", ["a phased introduction", "cancelling it", "raising fares"], 0, "단계적으로 시행."),
         order("그 점에는 동의합니다.", tr="I agree on that point."),
         fill("재정 부담이 크다는 점도 ___해야 합니다. (consider)", "고려", "고려하다 = consider.")])

    m["exercises"] = lesson("Mixed practice: Level 5",
        "Written grammar and vocabulary.",
        [tip("Written Korean prefers Sino-Korean nouns + 하다/되다 over everyday verbs.")],
        [mcq("“compared with last year”:", ["작년에 비해", "작년에 따르면", "작년 반면"], 0, "-에 비해."),
         fill("가격은 오른 ___ 품질은 그대로다. (whereas)", "반면", "-(으)ㄴ 반면."),
         trans("According to the survey, the number increased.", ["조사에 따르면 수가 증가했다.", "조사에 따르면 숫자가 증가했다."], "-에 따르면."),
         match([("증가", "increase"), ("감소", "decrease"), ("원인", "cause"), ("대책", "countermeasure")]),
         order("이는 작년에 비해 크게 증가한 수치이다.", tr="This is a large increase compared with last year.")])

    m["quiz"] = lesson("Level 5 quiz", "Five questions across Level 5.",
        [tip("Think in written style.")],
        [mcq("„영향을 미치다“ means:", ["to have an influence", "to measure", "to decrease"], 0, "influence."),
         mcq("Nominaliser used in notices:", ["-(으)ㅁ", "-아서", "-고"], 0, "e.g. 휴업함."),
         mcq("„-(으)ㄹ 뿐만 아니라“ =", ["not only … but also", "because", "although"], 0, "Addition."),
         mcq("„연락“ is pronounced:", ["[열락]", "[연낙]", "[연락]"], 0, "Liquidisation."),
         mcq("Formal closing of a talk:", ["이상으로 발표를 마치겠습니다.", "끝!", "그럼 안녕."], 0, "Formal.")])

    exam = [
        mcq("„정책“ means:", ["policy", "politics", "election"], 0, "policy.", skill="vocabulary"),
        mcq("„해결하다“ means:", ["to solve", "to announce", "to cause"], 0, "solve.", skill="vocabulary"),
        mcq("전문가의 의견___ 따르면 …", ["에", "을", "과"], 0, "-에 따르면.", skill="grammar"),
        mcq("“Exercising is hard.”", ["운동하기가 어렵다.", "운동함이 어렵다.", "운동해서 어렵다."], 0, "-기 for activities.", skill="grammar"),
        fill("서울은 교통이 편리한 ___ 집값이 비싸다. (whereas)", "반면", "-(으)ㄴ 반면.", skill="grammar"),
        fix("작년에 비하면서 증가했다.", "작년에 비해 증가했다.", "-에 비해(서).", skill="grammar"),
        mcq("Read: „청년 실업률이 하락한 반면 고용의 질은 개선되지 않았다.“ What did NOT improve?", ["job quality", "youth unemployment", "wages"], 0, "고용의 질.", skill="reading"),
        mcq("Read: headline „물가 상승… 정부 긴급 대책 발표“", ["Prices rise; government announces urgent measures.", "Prices fall; government resigns.", "Government raises taxes."], 0, "상승 = rise.", skill="reading"),
        listen("내일은 전국에 비가 내리겠으며 기온이 다소 떨어지겠습니다.", "Tomorrow's weather?", ["rain nationwide and slightly cooler", "sunny and hot", "snow in the north"], 0, "비 + 기온 하락.", skill="listening"),
        listen("이번 조사 결과는 다음 주 학회에서 발표될 예정입니다.", "When will results be presented?", ["at next week's conference", "today", "next year"], 0, "다음 주 학회.", skill="listening"),
        trans("The population decreased compared with last year.", ["작년에 비해 인구가 감소했다.", "인구가 작년에 비해 감소했다."], "-에 비해 + 감소하다.", skill="writing"),
        mcq("To politely disagree in a formal debate:", ["그 점에 대해서는 생각이 조금 다릅니다.", "틀렸어.", "말도 안 돼."], 0, "Formal disagreement.", skill="conversation"),
    ]
    return level("ko", "L5", 5, "Advanced",
                 "Formal Korean, professional and academic vocabulary, news comprehension, advanced grammar, extended writing and complex listening.",
                 TOPIK_NOTE.format("II, level 5", WRITING),
                 ["Formal Korean", "Professional vocabulary", "Advanced grammar", "News comprehension", "Academic expressions",
                  "Advanced reading", "Extended writing", "Complex listening"], m, exam)


def l6():
    m = {}
    m["vocabulary"] = lesson("Idioms and proverbs",
        "Common idioms (관용어) and proverbs (속담) native speakers use.",
        [tip("Idioms are fixed: change a word and the meaning is lost. The literal meaning is shown under each one."),
         voc(("발이 넓다", "to know many people", None, "literally: feet are wide"),
             ("눈이 높다", "to have high standards", None, "literally: eyes are high"),
             ("미역국을 먹다", "to fail an exam", None, "literally: to eat seaweed soup"),
             ("식은 죽 먹기", "a piece of cake (very easy)", None, "literally: eating cold porridge"),
             ("손이 크다", "to be generous (with portions)", None, "literally: hands are big"),
             ("가는 말이 고와야 오는 말이 곱다", "treat others as you want to be treated", None, "literally: kind words out, kind words back"),
             ("원숭이도 나무에서 떨어진다", "anyone can make mistakes", None, "literally: even monkeys fall from trees"))],
        [mcq("„발이 넓다“ means:", ["to know many people", "to walk fast", "to have big feet"], 0, "Wide network."),
         match([("눈이 높다", "high standards"), ("식은 죽 먹기", "very easy"), ("미역국을 먹다", "to fail an exam"), ("손이 크다", "generous")]),
         mcq("Someone made a rare mistake. You say:", ["원숭이도 나무에서 떨어진다.", "가는 말이 고와야 오는 말이 곱다.", "식은 죽 먹기다."], 0, "Even experts slip."),
         fill("그 시험은 식은 죽 ___였어요. (a piece of cake)", "먹기", "식은 죽 먹기.")])

    m["grammar"] = lesson("Advanced honorifics and nuanced endings",
        "Humble verbs and endings that add feeling: -더라고요, -잖아요, -거든요, -네요.",
        [tbl(["Plain", "Humble / honorific", "Use"], ["주다", "드리다", "give to a senior"], ["묻다", "여쭙다 / 여쭈다", "ask a senior"], ["보다 (meet)", "뵙다", "meet a senior"],
             ["말하다", "말씀드리다", "speak to a senior"], ["데리고 가다", "모시고 가다", "take/escort a senior"]),
         tbl(["Ending", "Nuance", "Example"], ["-더라고요", "reporting what you personally saw/felt", "그 식당 정말 맛있더라고요."],
             ["-잖아요", "“you know …” (shared knowledge)", "내일 시험이잖아요."], ["-거든요", "giving background / reason", "오늘 바쁘거든요."], ["-네요", "realisation / surprise", "한국어 잘하시네요!"])],
        [mcq("Humble form of „묻다“ (ask a professor):", ["여쭙다", "물으시다", "말씀하다"], 0, "여쭙다."),
         mcq("“I'll see you (a senior) tomorrow”:", ["내일 뵙겠습니다.", "내일 보겠어.", "내일 보세요."], 0, "뵙다."),
         fill("어제 가 봤는데 정말 좋___. (personal observation)", "더라고요", "-더라고요."),
         mcq("“Because I'm busy today, you see…” (background):", ["오늘 바쁘거든요.", "오늘 바쁘네요.", "오늘 바쁘더라고요."], 0, "-거든요 gives a reason."),
         fix("교수님께 질문을 물어봤어요.", ["교수님께 질문을 여쭤봤어요.", "교수님께 여쭤봤어요."], "Use 여쭙다 for a professor.")])

    m["reading"] = lesson("Reading: an essay on honorific culture",
        "Nuanced argumentation about language and society.",
        [psg("높임말, 거리인가 존중인가",
             "높임말은 흔히 상대를 존중하는 장치로 여겨진다. 그러나 지나친 높임말은 오히려 사람 사이에 보이지 않는 벽을 쌓기도 한다. "
             "실제로 일부 기업에서는 직급 대신 '님'이나 영어 이름을 쓰도록 해 수평적인 소통을 꾀하고 있다. 물론 이러한 변화가 위계 자체를 "
             "없애지는 못한다는 비판도 만만치 않다. 결국 언어 형식보다 중요한 것은 그 말에 담긴 태도일 것이다.",
             "Honorifics are often regarded as a device for respecting others. However, excessive honorifics can actually build invisible walls between "
             "people. In fact, some companies have people use '님' or English names instead of titles to encourage horizontal communication. Of course, "
             "criticism that such changes cannot remove hierarchy itself is considerable. In the end, what matters more than linguistic form is probably "
             "the attitude contained in the words."),
         tip("만만치 않다 = considerable, not to be underestimated. -기도 하다 = can also / sometimes.")],
        [mcq("What can excessive honorifics do, according to the text?", ["build invisible walls", "remove hierarchy", "improve grammar"], 0, "보이지 않는 벽."),
         mcq("Why do some companies use '님' or English names?", ["to encourage horizontal communication", "to save time", "to follow the law"], 0, "수평적인 소통."),
         mcq("The author's conclusion:", ["attitude matters more than form", "honorifics should be banned", "titles are best"], 0, "언어 형식보다 … 태도."),
         mcq("„비판도 만만치 않다“ means criticism is:", ["considerable", "weak", "unfair"], 0, "Not to be underestimated.")])

    m["writing"] = lesson("Writing: an argumentative essay (TOPIK II Q54 style)",
        "A structured essay of 600–700 characters on a social issue.",
        [tbl(["Part", "Expression"], ["Introduction", "최근 …이/가 사회적 문제로 떠오르고 있다."], ["Argument", "첫째, … 둘째, …"], ["Counter-view", "물론 …다는 의견도 있다. 그러나 …"],
             ["Conclusion", "따라서 …아/어야 할 것이다."]),
         tip("TOPIK II essays are marked on content, structure and language. Use plain -다 style throughout.")],
        [write("Write an argumentative essay (80+ words) on: “Should children under 13 be allowed smartphones?” Include a counter-view and a conclusion.", 80,
               ["첫째|먼저", "물론|반면", "따라서|결론적으로"],
               "최근 어린이의 스마트폰 사용이 사회적 문제로 떠오르고 있다. 나는 13세 미만 어린이의 스마트폰 사용을 제한해야 한다고 생각한다. "
               "첫째, 지나친 사용은 수면과 집중력에 나쁜 영향을 미칠 수 있다. 둘째, 어린이는 유해한 정보로부터 스스로를 보호하기 어렵다. "
               "물론 안전을 위해 연락 수단이 필요하다는 의견도 있다. 그러나 이는 기본 기능만 있는 휴대폰으로도 충분히 해결할 수 있다. "
               "따라서 부모와 학교가 함께 올바른 사용 습관을 길러 주어야 할 것이다."),
         mcq("Which phrase introduces a counter-view?", ["물론 …다는 의견도 있다.", "따라서 …", "첫째, …"], 0, "Concession."),
         fill("따라서 우리는 대책을 마련해야 할 ___이다. (we should)", "것", "-아/어야 할 것이다.")])

    m["listening"] = lesson("Listening: nuance and implication",
        "Understand indirect refusals, irony and attitude.",
        [tip("Korean often refuses indirectly: „생각해 볼게요“ (I'll think about it) frequently means no.")],
        [listen("그 제안은 좋은데요, 이번에는 좀 어려울 것 같아요.", "What is the speaker doing?", ["politely declining", "accepting", "asking a question"], 0, "Soft refusal."),
         listen("역시 김 대리는 발이 넓네요. 모르는 사람이 없어요.", "What does the speaker mean about 김 대리?", ["he knows many people", "he walks a lot", "he is tall"], 0, "발이 넓다."),
         listen("말씀하신 내용은 충분히 이해합니다만, 현실적으로 실행이 쉽지 않아 보입니다.", "The speaker thinks the idea is…", ["understood but hard to implement", "excellent and easy", "unclear"], 0, "-습니다만 = but (formal)."),
         listen("그렇게 쉬운 문제였으면 벌써 누군가 해결했겠죠.", "Speaker's attitude?", ["sceptical: it's not that easy", "enthusiastic", "confused"], 0, "Counterfactual + 겠죠.")])

    m["speaking"] = lesson("Speaking: debate and diplomacy",
        "High-level discussion phrases.",
        [ex("말씀하신 부분에 일리가 있다고 생각합니다.", "I think what you said makes sense."),
         ex("다만 한 가지 짚고 넘어가고 싶은 점이 있습니다.", "However, there's one point I'd like to address."),
         ex("그 문제는 좀 더 다각도로 검토할 필요가 있습니다.", "That issue needs to be examined from more angles.")],
        [speak("말씀하신 부분에 일리가 있다고 생각합니다.", "I think what you said makes sense."),
         speak("다만 한 가지 짚고 넘어가고 싶은 점이 있습니다.", "However, there's one point I'd like to address."),
         speak("그 문제는 좀 더 다각도로 검토할 필요가 있습니다.", "That issue needs to be examined from more angles."),
         mcq("„일리가 있다“ means:", ["to make sense / have a point", "to be one mile away", "to be wrong"], 0, "Has a point.")])

    m["pronunciation"] = lesson("Natural intonation and ㄴ-insertion",
        "Compound words that add a ㄴ sound, and sentence-final intonation.",
        [tbl(["Spelling", "Pronounced", "Note"], ["색연필", "[생년필]", "ㄴ inserted, then nasalisation"], ["한여름", "[한녀름]", "ㄴ inserted"], ["물약", "[물략]", "inserted ㄴ → ㄹ"], ["서울역", "[서울력]", "inserted ㄴ → ㄹ"]),
         tip("-네요 rises slightly in surprise; -잖아요 often falls; -거든요 rises at the end when giving background.")],
        [pron("색연필", "coloured pencil", "Say [생년필]"), pron("서울역", "Seoul Station", "Say [서울력]"), pron("한국어 정말 잘하시네요!", "Your Korean is really good!"),
         mcq("„한여름“ is pronounced:", ["[한녀름]", "[하녀름]", "[한여름]"], 0, "ㄴ-insertion.")])

    m["conversation"] = lesson("Conversation: a nuanced workplace discussion",
        "Disagree and negotiate while preserving relationships.",
        [dlg("기획 회의",
             ("팀장", "이번 프로젝트 일정은 다음 달 말까지로 하는 게 어떨까요?", "How about setting the project schedule to the end of next month?"),
             ("서연", "팀장님 말씀도 일리가 있지만, 인력을 고려하면 조금 빠듯할 것 같습니다.", "You have a point, but considering staffing, it seems a bit tight."),
             ("팀장", "그럼 우선순위를 다시 정해 볼까요?", "Then shall we re-prioritise?"),
             ("서연", "네, 그렇게 하면 일정을 맞출 수 있을 것 같습니다. 자료는 제가 정리해서 드리겠습니다.", "Yes, then we can probably meet the schedule. I'll organise the materials for you."))],
        [mcq("Seoyeon's concern:", ["the schedule is tight given staffing", "the budget is too high", "the client is unhappy"], 0, "빠듯하다 = tight."),
         mcq("How does Seoyeon disagree?", ["acknowledges, then gives a reason", "refuses directly", "changes the topic"], 0, "일리가 있지만 …"),
         order("자료는 제가 정리해서 드리겠습니다.", tr="I'll organise the materials and give them to you."),
         fill("우선순위를 다시 정해 ___? (shall we)", "볼까요", "-아/어 볼까요?")])

    m["exercises"] = lesson("Mixed practice: Level 6",
        "Idioms, humble forms and nuance.",
        [tip("Nuance endings change attitude, not meaning. Choose the one that fits the situation.")],
        [mcq("“You know, tomorrow's a holiday.”", ["내일 휴일이잖아요.", "내일 휴일이더라고요.", "내일 휴일이네요."], 0, "-잖아요."),
         fill("교수님을 내일 ___겠습니다. (meet, humble)", "뵙", "뵙다."),
         trans("Your Korean is really good!", ["한국어 정말 잘하시네요!", "한국어를 정말 잘하시네요!"], "-시네요."),
         match([("발이 넓다", "well-connected"), ("눈이 높다", "picky"), ("식은 죽 먹기", "very easy"), ("원숭이도 나무에서 떨어진다", "anyone can err")]),
         fix("할아버지를 데리고 갔어요.", "할아버지를 모시고 갔어요.", "Use 모시다 for elders.")])

    m["quiz"] = lesson("Level 6 quiz", "Five questions across Level 6.",
        [tip("Several answers may be grammatical; choose the most natural.")],
        [mcq("„미역국을 먹었어요“ after an exam means:", ["I failed", "I celebrated", "I was hungry"], 0, "Idiom."),
         mcq("Humble form of „주다“:", ["드리다", "주시다", "올리시다"], 0, "드리다."),
         mcq("„-더라고요“ reports:", ["something you personally experienced", "a future plan", "a command"], 0, "Personal observation."),
         mcq("„서울역“ is pronounced:", ["[서울력]", "[서우력]", "[서울역]"], 0, "ㄴ-insertion → ㄹ."),
         mcq("„생각해 볼게요“ in a negotiation often means:", ["a polite no", "a definite yes", "I'm confused"], 0, "Indirect refusal.")])

    exam = [
        mcq("„눈이 높다“ means:", ["to have high standards", "to be tall", "to have good eyesight"], 0, "Idiom.", skill="vocabulary"),
        mcq("„손이 크다“ describes someone who:", ["is generous with portions", "is a thief", "is strong"], 0, "Idiom.", skill="vocabulary"),
        mcq("To ask a professor (humble):", ["교수님께 여쭤보겠습니다.", "교수님한테 물어볼게.", "교수님이 물어봐요."], 0, "여쭙다.", skill="grammar"),
        mcq("Background reason ending:", ["-거든요", "-네요", "-세요"], 0, "-거든요.", skill="grammar"),
        fill("사장님을 공항까지 ___고 갔어요. (escort, humble)", "모시", "모시다.", skill="grammar"),
        fix("부모님께 선물을 줬어요.", "부모님께 선물을 드렸어요.", "드리다 for parents.", skill="grammar"),
        mcq("Read: „그의 제안은 참신하지만 현실성이 떨어진다는 평가를 받았다.“", ["original but unrealistic", "realistic but boring", "rejected for cost"], 0, "참신 vs 현실성.", skill="reading"),
        mcq("Read: „이번 결정은 신중을 기했다기보다는 시간에 쫓긴 결과로 보인다.“ The decision seems…", ["rushed", "carefully considered", "postponed"], 0, "시간에 쫓긴 결과.", skill="reading"),
        listen("좋은 말씀 감사합니다만, 저희 입장에서는 수용하기 어렵습니다.", "What is the speaker doing?", ["politely rejecting", "accepting", "apologising"], 0, "수용하기 어렵다.", skill="listening"),
        listen("그 사람 정말 손이 크더라고요. 음식을 열 명분이나 준비했어요.", "What does the speaker say?", ["the person prepared lots of food", "the person has big hands", "the person was late"], 0, "손이 크다.", skill="listening"),
        trans("Anyone can make mistakes.", ["원숭이도 나무에서 떨어진다.", "누구나 실수할 수 있다.", "누구나 실수할 수 있어요."], "Proverb or plain statement.", skill="writing"),
        mcq("To acknowledge before disagreeing, formally:", ["말씀하신 부분에 일리가 있지만 …", "아니요, 틀렸어요.", "몰라요."], 0, "Diplomatic.", skill="conversation"),
    ]
    return level("ko", "L6", 6, "Advanced Proficiency",
                 "Nuanced expression, advanced honorifics, idioms, natural conversation, academic and professional Korean, debate and advanced writing.",
                 TOPIK_NOTE.format("II, level 6", WRITING),
                 ["Nuanced expression", "Advanced honorifics", "Idiomatic expressions", "Natural conversation",
                  "Academic & professional Korean", "Complex debates", "Advanced writing", "TOPIK II advanced preparation"], m, exam)
