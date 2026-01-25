## I28 — Users Docs Simplification + Cookbook + README (v1.5)

### Goal

Make the first impression **Flutter-friendly** and fast:

- no DDD/SOLID/spec language in user-facing docs,
- copy-paste ready examples only,
- a 3-minute happy path (Material preset + one component),
- clear troubleshooting with debug vs release behavior.

All engineering details stay in `docs/implementation` and `docs/contributors`.

---

### Non-goals

- No API changes in this iteration.
- No new components.
- No architecture/spec rewrites.

---

### Success metrics

- A new user can render a button and a dropdown in under 5 minutes.
- User docs contain **zero** DDD/SOLID terminology.
- Every example is minimal and copy-paste ready.

---

### Deliverables (what + where)

#### 1) Root README (first impression)

File: `README.md`

Required sections:
1) What it is (2–3 bullets, plain language).
2) Quick start (Material preset, copy-paste).
3) Quick start (Cupertino preset, copy-paste).
4) Where to go next (Users Guide + Example app).
5) When Headless is overkill (3–4 bullets).

Rules:
- No spec/architecture links here (move those to contributor docs).
- Avoid deep terminology (capability/contracts/state resolution/etc).
- Keep it short (fits on one screen).

#### 2) English entrypoint docs

File: `docs/en/README.md`

Update to:
- link to `docs/users/README.md`,
- link to `docs/users/COOKBOOK.md`,
- link to `apps/example`,
- keep “canonical references” in a separate “References” block at the bottom (optional),
  so the main flow stays user-oriented.

#### 3) Users Guide (lightweight)

File: `docs/users/README.md`

Required structure:
1) Quick start (preset)
2) Quick start (custom theme)
3) Most common recipes (links to cookbook)
4) Troubleshooting
5) Where to go next

Rules:
- No DDD/SOLID/spec terminology.
- Avoid “capability/contracts” wording; use simple vocabulary:
  “preset”, “renderer”, “style”, “overrides”.
- Keep sections short and actionable.

#### 4) Users Cookbook (copy-paste recipes)

New file: `docs/users/COOKBOOK.md`

Mandatory recipes:
- Button: `RTextButton` with `style`
- Dropdown: `RDropdownButton<T>` with `itemAdapter`
- TextField: controlled vs controller-driven
- Autocomplete: `optionsBuilder` + `itemAdapter`
- Scoped overrides: `HeadlessButtonScope` / `HeadlessDropdownScope` / `HeadlessTextFieldScope`
- Theme defaults (Material): `MaterialHeadlessDefaults`

Each recipe must include:
- 1–2 sentence intent
- minimal code snippet (copy-paste ready)
- a short “why” line (optional)

#### 5) Troubleshooting (explicit behavior)

File: `docs/users/README.md` (section)

Include a compact table:
- MissingOverlayHostException → fix: wrap with `AnchoredOverlayEngineHost` (or use `HeadlessMaterialApp`).
- MissingThemeException → **debug only** (release renders diagnostic placeholder).
- MissingCapabilityException → **debug only** (release renders diagnostic placeholder).
- Release behavior: `FlutterError.reportError` + diagnostic placeholder.

---

### Content rules (must)

- No DDD/SOLID/spec terms in Users docs.
- Keep sentences short (no long paragraphs).
- Every code block should compile in isolation (include imports when needed).
- Prefer Material preset in examples unless the section is explicitly Cupertino.
- Mention that select-like behavior is `RDropdownButton<T>` (no separate Select component).

---

### Work order

1) Rewrite `README.md` (short, friendly, no jargon).
2) Update `docs/en/README.md` to point to Users Guide + Cookbook.
3) Rewrite `docs/users/README.md` with new structure and troubleshooting.
4) Create `docs/users/COOKBOOK.md` with recipes.
5) Cross-link README → Users → Cookbook → Example app.

---

### Definition of Done

- Root README is < ~120 lines and copy-paste ready.
- Users Guide is short and does not reference spec/architecture.
- Users Cookbook has 6+ recipes with minimal code.
- Troubleshooting section explicitly documents debug vs release behavior.


