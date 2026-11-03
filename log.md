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

### Next steps
- Import CSV into DB Browser, first SQL queries, create clean table.
