"""Tiny authoring DSL for Lingo curriculum content.

Content is written in de.py / ko.py and compiled to
assets/curriculum/<lang>/<level>.json by build.py. IDs are derived from the
level code and module type, so they stay stable between content updates.
Bump a level's `version` whenever its content changes.
"""

MODULE_ORDER = [
    "vocabulary", "grammar", "reading", "writing", "listening", "speaking",
    "pronunciation", "conversation", "exercises", "quiz",
]

# ---------- content blocks ----------

def txt(t): return {"type": "text", "text": t}
def head(t): return {"type": "heading", "text": t}
def tip(t): return {"type": "tip", "text": t}

def ex(target, en=None, pron=None, note=None):
    b = {"type": "example", "target": target}
    if en: b["en"] = en
    if pron: b["pron"] = pron
    if note: b["note"] = note
    return b

def voc(*items):
    """items: (target, en[, pron[, example]])"""
    out = []
    for it in items:
        d = {"target": it[0], "en": it[1]}
        if len(it) > 2 and it[2]: d["pron"] = it[2]
        if len(it) > 3 and it[3]: d["example"] = it[3]
        out.append(d)
    return {"type": "vocab", "items": out}

def tbl(header, *rows): return {"type": "table", "head": list(header), "rows": [list(r) for r in rows]}

def dlg(title, *lines):
    """lines: (speaker, target, en[, pron])"""
    out = []
    for l in lines:
        d = {"speaker": l[0], "target": l[1], "en": l[2]}
        if len(l) > 3 and l[3]: d["pron"] = l[3]
        out.append(d)
    return {"type": "dialogue", "title": title, "lines": out}

def psg(title, target, en): return {"type": "passage", "title": title, "target": target, "en": en}

# ---------- questions ----------

def _q(type_, **kw):
    q = {"type": type_}
    q.update({k: v for k, v in kw.items() if v is not None})
    return q

def _list(a): return [a] if isinstance(a, str) else list(a)

def mcq(prompt, options, answer, exp, skill=None, tr=None):
    return _q("mcq", prompt=prompt, options=options, answer=answer, explanation=exp, skill=skill, translation=tr)

def fill(prompt, answers, exp, skill=None, tr=None):
    return _q("fill", prompt=prompt, answers=_list(answers), explanation=exp, skill=skill, translation=tr)

def trans(prompt, answers, exp, skill="translation"):
    return _q("translate", prompt=prompt, answers=_list(answers), explanation=exp, skill=skill)

def match(pairs, exp=None, prompt="", skill=None):
    return _q("match", prompt=prompt, pairs=[list(p) for p in pairs], explanation=exp, skill=skill)

def order(sentence, exp=None, tr=None, prompt="", skill=None):
    words = sentence.split(" ") if isinstance(sentence, str) else list(sentence)
    merged = []
    for w in words:  # attach stray punctuation tokens to the previous word
        if merged and w and all(not c.isalnum() for c in w):
            merged[-1] += w
        elif w:
            merged.append(w)
    words = merged
    return _q("order", prompt=prompt, words=words, explanation=exp, translation=tr, skill=skill)

def listen(audio, prompt, options, answer, exp, skill="listening"):
    return _q("listening", audio=audio, prompt=prompt, options=options, answer=answer, explanation=exp, skill=skill)

def fix(sentence, answers, exp, skill="grammar"):
    return _q("correction", prompt=sentence, answers=_list(answers), explanation=exp, skill=skill)

def speak(text, tr, prompt="", skill="speaking"):
    return _q("speak", audio=text, translation=tr, prompt=prompt, skill=skill)

def pron(text, tr, prompt="", skill="pronunciation"):
    return _q("pronounce", audio=text, translation=tr, prompt=prompt, skill=skill)

def image(prompt, options, images, answer, exp, skill="vocabulary"):
    """Picture question: pick the illustration for a word (ids from
    lib/core/widgets/illustrations.dart)."""
    return _q("image", prompt=prompt, options=options, images=images, answer=answer,
              explanation=exp, skill=skill)

def write(prompt, min_words, keywords, sample, exp=None):
    return _q("write", prompt=prompt, minWords=min_words, keywords=keywords, sample=sample,
              explanation=exp, skill="writing")

# ---------- assembly ----------

def lesson(title, summary, blocks, questions):
    return {"title": title, "summary": summary, "blocks": blocks, "questions": questions}

def level(lang, code, order_, title, description, alignment, topics, modules, exam, version=1):
    lid = f"{lang}_{code.lower()}"
    mods = []
    for mtype in MODULE_ORDER:
        les = modules[mtype]
        mid = f"{lid}_{mtype}"
        lesson_id = f"{mid}_1"
        qs = []
        for i, q in enumerate(les["questions"], 1):
            q = dict(q)
            q["id"] = f"{lesson_id}_q{i}"
            q.setdefault("skill", mtype)
            qs.append(q)
        mods.append({
            "id": mid, "type": mtype, "title": les["title"],
            "lessons": [{"id": lesson_id, "title": les["title"], "summary": les["summary"],
                         "blocks": les["blocks"], "questions": qs}],
        })
    exam_qs = []
    for i, q in enumerate(exam, 1):
        q = dict(q)
        q["id"] = f"{lid}_exam_q{i}"
        exam_qs.append(q)
    return {
        "id": lid, "lang": lang, "code": code, "order": order_, "version": version,
        "title": title, "description": description, "alignment": alignment,
        "topics": topics, "modules": mods, "exam": exam_qs,
    }
