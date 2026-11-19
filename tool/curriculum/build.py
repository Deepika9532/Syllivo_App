"""Compile curriculum sources to assets/curriculum/**.json.

Usage (from the project root):  python3 tool/curriculum/build.py
"""
import json, os, sys
sys.path.insert(0, os.path.dirname(__file__))

import de_a, de_b, de_c, ko_a, ko_b

LEVELS = {
    "de": [de_a.a1, de_a.a2, de_b.b1, de_b.b2, de_c.c1, de_c.c2],
    "ko": [ko_a.l1, ko_a.l2, ko_a.l3, ko_b.l4, ko_b.l5, ko_b.l6],
}

# Picture questions appended to existing lessons (v3.0). Appending keeps the
# indices of earlier questions stable, so saved "resume" positions stay valid.
from dsl import image
PICTURES = {
    ("de_a1", "vocabulary"): [
        image("Which one is “the bed”?", ["das Haus", "der Tisch", "das Bett", "der Stuhl"],
              ["house", "table", "bed", "chair"], 2, "das Bett = the bed."),
        image("Which one is “the chair”?", ["die Küche", "der Stuhl", "das Bett", "das Haus"],
              ["kitchen", "chair", "bed", "house"], 1, "der Stuhl = the chair."),
    ],
    ("de_a1", "conversation"): [
        image("Which one is “the coffee”?", ["der Kaffee", "der Tee", "das Wasser", "das Brot"],
              ["coffee", "tea", "water", "bread"], 0, "der Kaffee = the coffee."),
    ],
    ("de_a2", "listening"): [
        image("Which one is “the train”?", ["der Zug", "der Bus", "das Flugzeug", "die Fahrkarte"],
              ["train", "bus", "airplane", "ticket"], 0, "der Zug = the train."),
    ],
    ("de_b1", "vocabulary"): [
        image("Which one is “the medicine”?", ["der Arzt", "das Medikament", "der Computer", "das Geld"],
              ["doctor", "medicine", "computer", "money"], 1, "das Medikament = the medicine; der Arzt = the doctor."),
    ],
    ("ko_l1", "vocabulary"): [
        image("Which one is “book”?", ["학교", "책", "집", "친구"], ["school", "book", "house", "friends"], 1, "책 = book."),
        image("Which one is “teacher”?", ["선생님", "학생", "집", "책"], ["teacher", "person", "house", "book"], 0, "선생님 = teacher."),
    ],
    ("ko_l2", "vocabulary"): [
        image("Which one is “water”?", ["물", "밥", "고기", "과일"], ["water", "rice", "meat", "fruit"], 0, "물 = water."),
    ],
    ("ko_l3", "vocabulary"): [
        image("Which one is “train”?", ["기차", "버스", "비행기", "표"], ["train", "bus", "airplane", "ticket"], 0, "기차 = train; 비행기 = airplane."),
    ],
}

def add_pictures(level):
    touched = False
    for m in level["modules"]:
        extra = PICTURES.get((level["id"], m["type"]))
        if not extra:
            continue
        lesson = m["lessons"][0]
        n = len(lesson["questions"])
        for i, q in enumerate(extra, 1):
            q = dict(q)
            q["id"] = f"{lesson['id']}_q{n + i}"
            lesson["questions"].append(q)
        touched = True
    if touched:
        level["version"] = level["version"] + 1
    return level

def check(level):
    errs = []
    def q_ok(q):
        t = q["type"]
        if t in ("mcq", "listening", "image"):
            if not (0 <= q["answer"] < len(q["options"])): errs.append(f"{q['id']}: answer out of range")
            if len(set(q["options"])) != len(q["options"]): errs.append(f"{q['id']}: duplicate options")
    for m in level["modules"]:
        for l in m["lessons"]:
            for q in l["questions"]: q_ok(q)
    for q in level["exam"]:
        q_ok(q)
        if q["type"] in ("speak", "pronounce", "write"): errs.append(f"{q['id']}: not auto-gradable")
    return errs

def main():
    root = os.path.join(os.path.dirname(__file__), "..", "..", "assets", "curriculum")
    index, errors, stats = {}, [], []
    for lang, fns in LEVELS.items():
        os.makedirs(os.path.join(root, lang), exist_ok=True)
        index[lang] = []
        for fn in fns:
            level = add_pictures(fn())
            errors += check(level)
            path = f"assets/curriculum/{lang}/{level['code'].lower()}.json"
            with open(os.path.join(root, lang, f"{level['code'].lower()}.json"), "w", encoding="utf-8") as f:
                json.dump(level, f, ensure_ascii=False, indent=1)
            index[lang].append(path)
            nq = sum(len(l["questions"]) for m in level["modules"] for l in m["lessons"])
            stats.append(f"{level['id']}: {len(level['modules'])} modules, {nq} practice questions, {len(level['exam'])} exam questions")
    with open(os.path.join(root, "index.json"), "w", encoding="utf-8") as f:
        json.dump(index, f, ensure_ascii=False, indent=1)
    print("\n".join(stats))
    if errors:
        print("ERRORS:\n" + "\n".join(errors)); sys.exit(1)

if __name__ == "__main__":
    main()
