# Project log

Working notes, decisions and open questions. Decisions are marked "Decision:".
Changed decisions get a new entry; old ones are not deleted.

---

## 3 Nov 2026

### Question
- Main question: What are the observable trends for female ICT graduates in Europe?
- Started with ICT only; other STEM fields and "all fields" to be added later.

### Data source
- Eurostat, `educ_uoe_grad02` – Graduates by education level, programme
  orientation, sex and field of education.
- Data last updated by Eurostat: 6 Oct 2026. Years available: 2015–2024.

### Classification and time range
- Two classification changes:
  - ISCED 2011 (education levels) from reference year 2013.
  - ISCED-F 2013 (fields of education) from school year 2014/2015.
    Before that (ISCED 1997), computing was a subfield of
    "Science, mathematics and computing"; ICT became its own broad field in 2013,
    with redrawn boundaries.
- Source: Eurostat UOE metadata, section 3.2 Classification system.
- First planned to start from 2013, but field data is only comparable from 2015.
- Decision: time range 2015–2024.

### Field of education
- ICT has subfields: computer use, database and network design,
  software and applications development, interdisciplinary ICT,
  n.e.c. (not elsewhere classified), n.f.d. (not further defined).
- Decision: use broad field "Information and Communication Technologies" (06),
  incl. all subfields – standard EU figure, comparable across countries,
  fewer gaps.
- Note: "Journalism and information" is a different field, not included.

### Level and other filters
- Decision: Bachelor's or equivalent level (ISCED 6), incl. academic and
  professional orientation. Master's may be added later.
- Decision: sex = total, female, male – calculate female share myself;
  check female + male = total.
- Decision: unit = number of graduates; all countries downloaded.

### Download
- Selected view, SDMX-CSV 1.0, all dimensions, incl. non-available data,
  uncompressed. Saved in `data/raw/`.

### First look at the data
- Columns: DATAFLOW, LAST UPDATE, freq, unit, isced11, iscedf13, sex, geo,
  TIME_PERIOD, OBS_VALUE, OBS_FLAG, CONF_STATUS.
- Needed: isced11, iscedf13, sex, geo, TIME_PERIOD, OBS_VALUE, OBS_FLAG.
  Others are the same in every row.
- Missing values are empty cells (e.g. Albania until 2020).
- Flags seen so far: Belgium 2015 = "d" (definition differs).
- Includes non-EU countries (e.g. Albania, Bosnia and Herzegovina).

### Data quality (proposed, may change)
- Decision: scope = EU27 countries; EU27 aggregate as benchmark, not in rankings.
- Decision: missing values excluded from calculations; large gaps noted.
- Decision: flagged values (d, u, e, p, b) included but marked.
- Small countries: percentages volatile due to low numbers.

### Historical data (idea for later)
- No EU-level data for the 1980s/90s.
- Germany: Destatis publications with graduates by field and sex 1973–2000
  (West Germany until ~1992, then all of Germany) → possible deep dive,
  incl. East vs West Germany comparison.
- West Germany: ~18% women in computer science (late 1970s), under 12%
  (mid-1990s), ~19% (2018) – Tagesspiegel.

### Tools
- GitHub for storage and documentation; local work in DB Browser for SQLite.
- Installed DB Browser via Homebrew.

### Open questions
- Include non-EU countries later?
- Which flags appear, and how often?

### Import into DB Browser
- Created database `women_in_tech.db`; imported CSV as table `raw_graduates`
- Note: DB Browser only saves after "Write Changes".
- Queries saved in `01_explore.sql`.

### Profiling (raw_graduates)
- Rows: 1230 (= 41 geo × 10 years × 3 sexes – complete, no duplicates).
- Sex values: Females, Males, Total.
- 41 geo entries: 27 EU + 12 non-EU + 2 aggregates.
  - Non-EU: Albania, Bosnia and Herzegovina, Georgia, Iceland, Liechtenstein,
    Montenegro, North Macedonia, Norway, Serbia, Switzerland, Türkiye, United Kingdom.
  - Aggregates: EU27 (from 2020), EU28 (2013–2020).
- Decision: use EU27 aggregate as benchmark (consistent over time); not EU28
  (includes UK, ends 2020).
- Decision: keep all countries in the clean table with a group column
  (EU27 / Non-EU / Aggregate); scope chosen per visualisation.

### Flags
- d (definition differs) = 51 rows, p (provisional) = 3 rows, no flag = 1176.
- Flags count 3× per year (females, males, total). Years affected:
  Ireland d (7), Montenegro d (4), Germany d (2), Belgium/France/Hungary d (1),
  Italy p (1), EU28 d (1).
- Decision: flagged values kept and marked in the dashboard. Female share is
  less sensitive to coverage differences than absolute numbers.

### Ireland check
- Female share: 2015–2017 ≈ 20–24% (no flag), 2018–2024 ≈ 24–28% (d).
- Spike in 2018 (first flagged year): female graduates +37% (790 → 1086),
  share 21.2% → 25.4%; 2019 back to 23.6%.
- Overall upward trend plausible, but 2018 jump may partly reflect the
  definition change.
- Hypothesis (unverified): NFQ Level 8 conversion
  programmes (e.g. Springboard+ Higher Diplomas) may have been included in
  ISCED 6 from 2018, raising the female share. Not confirmed.
- Decision: keep Ireland, mark 2018–2024 as "definition differs", mention the
  2018 spike.

### Missing values
- 117 of 1230 rows (~10%) = 39 country-years; always missing for all 3 sexes.
- All EU27 countries complete 2015–2024.
- Missing: Georgia 9, Montenegro 7, Albania 7, United Kingdom 5 (Brexit),
  EU28 5, Bosnia and Herzegovina 4, Liechtenstein 2.
- Decision: EU27 analysis unaffected. Georgia excluded from non-EU comparisons
  (9 of 10 years missing). Other non-EU countries only shown for years with data.

### Open questions
- Ireland "d" from 2018: check HEA graduate data; ask Eurostat user support.
- Reasons for "d" in Germany, Belgium, France, Hungary, Montenegro.
- Include non-EU countries in the dashboard?
- 
### Clean table
- Created table `ict_bachelor` from `raw_graduates`: one row per country and
  year, with females / males / total / flag / country_group. Numbers cast to integer.
- Check: 410 rows (= 41 geo × 10 years) ✓
- Female share not stored in the table – calculated in the analysis step,
  so the table only holds source numbers.
- Queries saved in `01_explore.sql`.

### Next steps
- Check females + males = total.
- Calculate female share per country and year.
- First trends: EU27 aggregate over time; highest and lowest countries.
- Upload `01_explore.sql` and `log.md` updates to GitHub (or set up GitHub Desktop).
