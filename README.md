# India District Crosswalks: PC91 ↔ PC01 ↔ PC11

Population-weighted district-level crosswalks harmonizing the three major Indian
Population Census vintages — 1991 (PC91), 2001 (PC01), and 2011 (PC11) — built
from SHRUG sub-district (shrid) level data.

## Why this exists

Indian districts changed substantially between census rounds: boundaries were
redrawn, states bifurcated, and new districts were carved out. Panel datasets
that span multiple census years need a way to link districts across vintages.
These crosswalks provide that link using population weights derived from the
SHRUG (Sub-national Human Development Report of Urban and Rural Government)
data published by the Development Data Lab.

## Census geographies

| Vintage | Districts | Common use |
|---|---|---|
| PC91 (1991 census) | 484 | DHS/NFHS 1992–93, 1998–99; birth-level analysis |
| PC01 (2001 census) | ~593 | DLHS-2, DLHS-3 |
| PC11 (2011 census) | ~640 | DHS/NFHS 2015–16, 2019–21; DLHS-4; Economic Census |

## Files

### District name/ID lookup tables

| File | Unique on |
|---|---|
| `pc91_distname_distid.dta` | `pc91_state_id` + `pc91_district_id` |
| `pc01_distname_distid.dta` | `pc01_state_id` + `pc01_district_id` |
| `pc11_distname_distid.dta` | `pc11_state_id` + `pc11_district_id` |

Each contains `state_id`, `district_id`, `state_name`, `district_name` for that
census vintage. Useful as merge keys to attach readable names to any analysis
dataset.

---

### Full many-to-many crosswalks

Two files, one per census-pair, each with one row per district pair that shares population.

**`pc91_pc11_district_xwalk.dta`** — PC91 × PC11 pairs (originally distributed by
the Development Data Lab as part of SHRUG; mirrored here for convenience).

| Variable | Description |
|---|---|
| `pc91_state_id`, `pc91_district_id`, `pc91_state_name`, `pc91_district_name` | PC91 district identifiers |
| `pc11_state_id`, `pc11_district_id`, `pc11_state_name`, `pc11_district_name` | PC11 district identifiers |
| `sharepop_pc91` | Fraction of the PC91 district's 1991 population in this pair |
| `sharepop_pc11` | Fraction of the PC11 district's 2011 population in this pair |

**`pc91_pc01_district_xwalk.dta`** — PC91 × PC01 pairs (built from scratch using
the same SHRUG shrid-level methodology).

| Variable | Description |
|---|---|
| `pc91_state_id`, `pc91_district_id`, `pc91_state_name`, `pc91_district_name` | PC91 district identifiers |
| `pc01_state_id`, `pc01_district_id`, `pc01_state_name`, `pc01_district_name` | PC01 district identifiers |
| `sharepop_pc91` | Fraction of the PC91 district's 1991 population in this pair |
| `sharepop_pc01` | Fraction of the PC01 district's 2001 population in this pair |

---

### 1:1 unique district mappings

For merging panel datasets where a strict 1:1 key is needed. Each file collapses
the many-to-many crosswalk to a single "dominant" match per district using the
highest population share.

| File | Unit | Logic |
|---|---|---|
| `pc91_pc11_district_mapping.dta` | Unique on PC91 district | PC11 district that received the largest share of the PC91 district's population |
| `pc11_pc91_district_mapping.dta` | Unique on PC11 district | PC91 district that contributed the largest share of the PC11 district's population |
| `pc91_pc01_district_mapping.dta` | Unique on PC91 district | PC01 district that received the largest share of the PC91 district's population |
| `pc01_pc91_district_mapping.dta` | Unique on PC01 district | PC91 district that contributed the largest share of the PC01 district's population |

Each file retains the population share of the dominant match and a count variable
(`n_pc11_dests`, `n_pc91_sources`, etc.) recording how many districts were
collapsed.

**Caveat:** Dominant-match mappings discard information when districts were split
or merged across censuses. For outcome aggregation (e.g., summing populations
or events), use the full many-to-many crosswalk and aggregate with `sharepop_*`
weights instead.

---

### District-level population for Economic Census years

The four Economic Census rounds were conducted in 1990, 1998, 2005, and 2013 —
years for which no census population count exists. These files provide linearly
interpolated/extrapolated population denominators at the PC11 district level.

**Interpolation weights:**

| EC year | Formula |
|---|---|
| 1990 | PC91 population (one year before 1991 census; used as proxy) |
| 1998 | 0.3 × PC91 + 0.7 × PC01 |
| 2005 | 0.6 × PC01 + 0.4 × PC11 |
| 2013 | −0.2 × PC01 + 1.2 × PC11 (linear extrapolation beyond PC11) |

**`pc11level_ec_poplns_90_98_05_13.dta`**  
Unit: PC11 district. Variables: `pc11_state_id`, `pc11_district_id`, `pc11_state_name`,
`pc11_district_name`, `popln_90`, `popln_98`, `popln_05`, `popln_13`.

**`pc11level_ec_poplns_90_98_05_13_rural_urban.dta`**  
Same unit, adds `pop_r_90` / `pop_u_90` etc. (rural and urban splits for each EC
year). Rural/urban status is **fixed at the 1991 census classification** for all
years to avoid endogeneity: districts reclassified as urban after an economic
shock would otherwise mechanically shift rural/urban population shares across the
panel.

---

### DLHS district-to-census mappings

The District Level Household Survey (DLHS) uses its own internal district codes that differ
from Population Census identifiers. These files bridge each DLHS round to the appropriate
census geography so that survey data can be merged with the crosswalks above.

| File | Survey round | Maps to | Districts |
|---|---|---|---|
| `dlhs2districts_pc01_mapping.dta` | DLHS-2 (2002–04) | PC01 | ~580 |
| `dlhs3districts_pc01_mapping.dta` | DLHS-3 (2007–08) | PC01 | ~580 |
| `dlhs4districts_pc11_mapping.dta` | DLHS-4 (2012–13) | PC11 | 559 |

**Common variables in all three files:**

| Variable | Description |
|---|---|
| `state_code` | State code as it appears in the DLHS raw data |
| `district_code` | District code as it appears in the DLHS raw data |
| `state_name` | State name as it appears in the DLHS raw data |
| `district_name` | District name as it appears in the DLHS raw data |
| `pc0X_state_id` / `pc11_state_id` | Census state identifier (SHRUG-compatible) |
| `pc0X_district_id` / `pc11_district_id` | Census district identifier (SHRUG-compatible) |
| `pc0X_state_name` / `pc11_state_name` | Census state name (SHRUG-compatible) |
| `pc0X_district_name` / `pc11_district_name` | Census district name (SHRUG-compatible) |

**Notes by round:**

- **DLHS-2 → PC01.** Straightforward name harmonization. A small number of districts with
  identical names across states were disambiguated by manually adding the correct DLHS
  state and district codes.

- **DLHS-3 → PC01.** DLHS-3 was fielded after a wave of post-2001 district splits. New
  districts created between 2001 and 2008 (e.g., Tarn Taran from Amritsar, Chirang from
  Bongaigaon, Simdega from Gumla) are collapsed back to their PC01 parent district so the
  mapping remains valid at the 2001 census geography.

- **DLHS-4 → PC11.** Data from Gujarat, Jammu & Kashmir, and several union territories
  (Dadra & Nagar Haveli, Daman & Diu, Delhi, Lakshadweep) were not collected or not
  released for DLHS-4 and are therefore absent from this mapping file.

**Typical usage — merge DLHS-3 data to PC01 identifiers, then on to PC11:**
```stata
* Step 1: attach PC01 IDs to DLHS-3 microdata
rename state state_code
rename dist district_code
merge m:1 state_code district_code ///
    using "dlhs3districts_pc01_mapping.dta", keep(match master) nogen

* Step 2: map PC01 → PC11 using the 1:1 unique mapping
merge m:1 pc01_state_id pc01_district_id ///
    using "pc01_pc91_district_mapping.dta", keep(match master) nogen
```

Generated by: `DLHS2_pc01_mapping.do`, `DLHS3_pc01_mapping.do`, `DLHS4_pc11_mapping.do`
(in `Do files/DHS-cleaning/`).

---

## Methodology

All crosswalks are built at the SHRUG sub-district (shrid2) level. Each shrid2 is
assigned to its PC91, PC01, and PC11 district. Population is then summed to the
district-pair level and divided by district totals to produce `sharepop_*` weights.
The full construction code is in `pc91_pc01_pc11_district_xwalks.do`.

The PC91–PC11 shrid-to-district concordance (`pc91_pc11_district_xwalk.dta`) was
originally distributed by the Development Data Lab as part of SHRUG and is mirrored
here with attribution. The PC91–PC01 concordance was built from scratch using the
same shrid-level methodology.

## Data source

Built using **SHRUG** (Socioeconomic High-resolution Rural-Urban Geographic) data,
Development Data Lab. Please cite:

> Asher, S., Lunt, T., Matsuura, R. and Novosad, P. (2021). Development Research at
> High Geographic Resolution: An Analysis of Night Lights, Firms, and Poverty in
> India using the SHRUG Open Data Platform. *The World Bank Economic Review*, 35(4):
> 845–871.

## Usage (Stata)

**Attach a PC11 district ID to a PC91-keyed dataset:**
```stata
merge m:1 pc91_state_id pc91_district_id ///
    using "pc91_pc11_district_mapping.dta", keep(match master)
```

**Population-weighted aggregation from PC91 to PC11 districts:**
```stata
merge m:1 pc91_state_id pc91_district_id ///
    using "pc91_pc01_district_xwalk.dta", keep(match master)
gen outcome_weighted = outcome * sharepop_pc91
collapse (sum) outcome_weighted, by(pc11_state_id pc11_district_id)
```

**Merge Economic Census population denominators:**
```stata
merge 1:1 pc11_state_id pc11_district_id ///
    using "pc11level_ec_poplns_90_98_05_13.dta", keep(match master)
```

## License

Code: MIT. Data files: CC BY 4.0 (consistent with SHRUG's license). Please cite
this repository and the SHRUG paper above if you use these files.
