# Mixed-Data Clustering with a Context-Aware Sequence Distance

Clustering of patient data that mixes **categorical, binary, numeric and sequence** attributes. The method adapts Gower's distance so that it can include sequence data, using the *context-aware distance* from [Context Aware Trace Clustering (Bose & van der Aalst, 2009)](https://doi.org/10.1137/1.9781611972795.35) as the sequence component. Work was done for INSIGNEO.

Author: Suraj Tailor (August 2020). See the accompanying paper, *Gower's distance combined with a context aware sequence distance metric*, for the full derivation.

## Method overview

Standard Gower's distance handles binary, categorical, numeric and ordered variables but has no notion of a sequence distance. This project:

1. **Computes a context-aware distance** between every pair of event sequences. This is an edit-distance variant (an adaptation of Levenshtein) whose substitution and insertion/deletion *scores* are learned from the data via 3-gram statistics, rather than using fixed unit costs.
2. **Shifts and scales** the sequence distances so they are positive and lie in [0, 1].
3. **Combines** them with the Gower's distance of the remaining attributes (computed with `cluster::daisy`) using the rearranged formula `D(i,j) = A * (C + B)` (paper, Eq. 19).
4. Runs **hierarchical clustering** (complete linkage) on the combined distance matrix.
5. Picks the number of clusters by maximising the **average silhouette width**, then cuts the tree and writes the assignments.

### Context-aware distance in brief

Three A x A matrices (A = the set of events) are estimated from 3-gram counts across all sequences:

| Matrix | Meaning |
|---|---|
| Substitution | Log-odds score for substituting one event with another |
| `insertRightGivenLeft` (RGL) | Likelihood of an event appearing immediately to the right of a given event |
| `insertLeftGivenRight` (LGR) | Likelihood of an event appearing immediately to the left of a given event |

Only one insertion matrix is used per distance run (RGL or LGR) to limit computation. Scores are shifted by the absolute minimum so that all values are positive, and the sequence distance is `d(S,T) = (|S| + |T|) / Sim(S,T)`.

---

## Repository layout

```
.
├── mainScript.R                 # Full pipeline: context-aware distance + clustering
├── clusterSequences.R           # Simple baseline: plain Levenshtein (adist) + hclust
├── mixed_distance.R             # Demo: Gower (daisy) and k-prototypes on example mixed data
├── dissimilarirty.mtrx.csv      # Example output from mixed_distance.R
├── data/                        # Input CSVs (testdata.csv, uniqueSequences.csv) and clustering output
├── scripts/                     # Function definitions sourced by mainScript.R
├── outputImages/                # Saved silhouette plots (ASW_<suffix>.jpg)
└── tests/                       # Tests for the functions in scripts/
```

### Scripts

- **`mainScript.R`**: the main entry point. Defines global settings, sources everything in `scripts/`, builds the substitution and insertion matrices, computes sequence distances, combines them with Gower's distance, clusters, and plots.
- **`clusterSequences.R`**: a simpler, standalone sequence-only clustering using standard edit distance (`adist`) on sequences encoded as UTF-8 strings (so multi-digit event IDs count as one symbol). Useful as a baseline to compare against the context-aware approach.
- **`mixed_distance.R`**: a small worked example on made-up mixed data showing `daisy(..., metric = "gower")` and `clustMixType::kproto`. Writes the Gower dissimilarity matrix to CSV. Does not involve sequence data.

### Key functions (in `scripts/`)

| Stage | Functions |
|---|---|
| Data preparation | `reduceDataSize`, `fillSeq`, `find3Grams`, `findUnique3Grams`, `calcTotalFreq3Grams` |
| Substitution matrix | `calcCoCountMatrix`, `calcNormalizedCoCount`, `calcCoCountProbVector`, `calcCoCountExpMatrix`, `calcSubsMatrix` |
| Insertion matrices | `getCountRGL`, `getCountLGR`, `calcInsNormVector`, `calcInsProbVector`, `calcNormInsMatrix`, `calcInsMatrix2` |
| Score shifting | `shiftScores` |
| Sequence distance | `getGenericEditDistanceRGL`, `getGenericEditDistanceLGR`, `getGenericEditDistanceRGLAlternate` |
| Combined distance | `getGowerDistance` |
| Clustering | `getMaxNumClusters`, `clusterUniqueSequences`, `treeCut`, `plotDend` |

---
## Requirements

R with the following packages:

```r
install.packages(c("cluster", "clustMixType", "factoextra", "NbClust", "quantmod",
                   "dendextend", "colorspace", "devtools", "ngram", "stringr",
                   "dplyr", "rstudioapi", "stringdist", "miceadds"))
```

`mainScript.R` uses `rstudioapi::getActiveDocumentContext()` to set the working directory, so **run it from RStudio** (or replace that line with an explicit `setwd()`).

---

## Input data format

Sequences are strings of integer event IDs separated by `-`, for example `4-33-12-1`. The input CSV needs these columns:

| Column | Description |
|---|---|
| `id_uniqueSeq` | Unique identifier for the sequence |
| `frequency` | How many patients have this sequence |
| `sequence` | Event IDs joined by `-` |

Sequences with fewer than three events are padded with a blank event (value `CARDINALITY_EVENTS`) because 3-gram extraction needs at least three events.

---

## Usage

1. Put your input CSV in `data/` and set `FN_INPUT` in `mainScript.R` (default `/data/testdata.csv`).
2. Set `CARDINALITY_EVENTS` to the number of unique events **plus one** (for the blank event).
3. Adjust the settings below if needed.
4. Open `mainScript.R` in RStudio and run it.

Output: a CSV of cluster assignments (`FN_OUTPUT`, default `/data/outputClustering.csv`), an optional silhouette plot in `outputImages/`, and a dendrogram.

### Configuration

| Variable | Default | Purpose |
|---|---|---|
| `FN_INPUT` | `/data/testdata.csv` | Input data file |
| `FN_OUTPUT` | `/data/outputClustering.csv` | Cluster assignments output |
| `FN_SUFFIX` | `CHCData` | Label used in plot titles and filenames |
| `MAX_NUMBER_CLUSTERS` | `50` | Max k tried when computing silhouettes (capped at n - 1) |
| `REMOVE_SEQ_FOR_CLUSTERING` | `TRUE` | Cluster only the N most frequent sequences |
| `N` | `30` | Number of sequences kept when the above is `TRUE` |
| `CARDINALITY_EVENTS` | `12` | Number of unique events + 1 |
| `SHIFT_SCORES` | `TRUE` | Shift score matrices so distances are positive |
| `PLOT_SILHOUETTE`, `SAVE_PLOT_SILHOUETTE`, `PLOT_DENDROGRAM` | `TRUE` | Plot toggles |

---

## Known limitations and open items

From the paper's further-work section, plus a few things noticed in the code:

- **Weights are fixed at 1** for every attribute in the Gower's distance, with no user-facing way to change them. An ASW-based weight optimisation (via `optim`, L-BFGS-B) is described in the paper but **not implemented**.
- **Sample attribute data is hard-coded** inside `getGowerDistance`; it needs to be replaced with real patient attributes.
- **Untested functions** (per the paper): `getGenericEditDistanceRGLAlternate`, `getGenericEditDistanceLGR`, `getMaxNumClusters`, `clusterUniqueSequences`, `treeCut`, `plotDend`. `getGowerDistance` would benefit from more testing.
- **Possible bugs to check in `mainScript.R`:**
  - The final call is `plotDend(PLOT_DENDOGRAM, ...)`, but the variable defined earlier is `PLOT_DENDROGRAM` (spelling), which would raise an "object not found" error.
  - The LGR block calls `calcInsNormVector(countRGL)` (marked `#repeat`), whereas the LGR matrix would be expected to use `countLGR`.
- The clustering step currently uses only the RGL-based final distance matrix (`finalDistanceMatrixRGL`).
- The number of unique events is set by hand; auto-detecting it would avoid computing oversized matrices.
- Validation on data with a known, well-understood cluster structure has not yet been done, nor a comparison of alternative sequence metrics or alternative mixed-data clustering methods.

---

## References

1. Bose & van der Aalst, *Context Aware Trace Clustering: Towards Improving Process Mining Results*, 2009.
2. Bose & van der Aalst, *Process Diagnostics Using Trace Alignment*, Information Systems 37(2), 2012.
3. Gower, *A General Coefficient of Similarity and Some of Its Properties*, Biometrics 27(4), 1971.
4. Huang, *Extensions to the k-means Algorithm for Clustering Large Data Sets with Categorical Values*, 1998.
5. Szepannek, *clustMixType: User-Friendly Clustering of Mixed-Type Data in R*, The R Journal, 2019.
6. Bektas & Schumann, *How to Optimize Gower Distance Weights for the k-Medoids Clustering Algorithm*, SDS 2019.
