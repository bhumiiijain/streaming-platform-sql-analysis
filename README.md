
# 🎬 Streaming Platform Catalog Analysis
### A SQL-based competitive analysis of Netflix, Hulu, Prime Video & Disney+

**By Bhumika Jain** | Product Management / Product Analyst  
**Tools:** MySQL · Python · Matplotlib  
**Dataset:** [Movies on Streaming Platforms – Kaggle](https://www.kaggle.com/datasets/ruchi798/movies-on-netflix-prime-video-hulu-and-disney) | 9,515 titles  

---

## 📌 Project Overview

Streaming platforms make billions of dollars in content decisions — what to license, what to produce, what to cancel — based on catalog analytics. This project simulates the role of a **Product Analyst on a streaming content strategy team**, tasked with benchmarking platform catalogs to answer five strategic questions:

1. How does catalog size compare across platforms?
2. Are platforms competing on volume, quality, or both?
3. How fresh is each platform's content library?
4. How exclusive is each platform's catalog?
5. What does the audience age-rating mix say about platform positioning?

---

## 🔑 Key Findings

| Metric | Netflix | Hulu | Prime Video | Disney+ |
|--------|---------|------|-------------|---------|
| Catalog Size | 3,695 | 1,047 | **4,113** | 922 |
| Avg RT Score | 54.4 | **60.4** | 50.4 | 58.3 |
| Avg Release Year | **2014.8** | 2011.8 | 2002.1 | 1997.0 |
| % Exclusive Content | 96.1% | 87.0% | 94.8% | **97.6%** |
| % "Fresh" (RT ≥ 60) | 33.3% | **52.1%** | 21.4% | 44.3% |

**Headline insight:** Catalog size and content quality are inversely related. Prime Video holds the largest catalog (4,113 titles) but the lowest quality density — only 21.4% of its rated titles are "Fresh" on Rotten Tomatoes. Hulu, with the smallest catalog (1,047 titles), leads on quality density at 52.1%. This is a classic **quality-vs-quantity tradeoff** with direct implications for content acquisition strategy.

---

## 📊 Analysis Queries (9 total)

| # | Question | SQL Technique |
|---|----------|---------------|
| 1 | Catalog size per platform | UNION ALL aggregation |
| 2 | Avg critic score per platform | Conditional AVG with CASE WHEN |
| 3 | Content freshness (avg release year) | Conditional AVG with CASE WHEN |
| 4 | Exclusivity % per platform | Complex CASE WHEN + division |
| 5 | Content age mix by decade | GROUP BY + CASE WHEN pivot |
| 6 | Audience age-rating mix | GROUP BY multi-column pivot |
| 7 | Top 5 titles per platform by RT score | CTE + DENSE_RANK() window function |
| 8 | Quality density (% Fresh per platform) | Conditional SUM pivot |
| 9 | Hidden gems (RT ≥ 85, exclusive) | Multi-condition WHERE filter |

---

## 🛠️ How to Run This Yourself

### Prerequisites
- MySQL Workbench
- Python 3.x with pandas (for data cleaning only)

### Step 1: Download the dataset
Download from [Kaggle](https://www.kaggle.com/datasets/ruchi798/movies-on-netflix-prime-video-hulu-and-disney) → `MoviesOnStreamingPlatforms.csv`

### Step 2: Set up the database
```sql
CREATE DATABASE streaming_analytics;
USE streaming_analytics;

CREATE TABLE titles (
    id INT,
    title VARCHAR(500) CHARACTER SET utf8mb4,
    year INT,
    age VARCHAR(10),
    rotten_tomatoes VARCHAR(10),
    netflix TINYINT,
    hulu TINYINT,
    prime_video TINYINT,
    disney_plus TINYINT,
    rt_score DECIMAL(4,1),
    platform_count INT
);
```

### Step 3: Import the CSV
Use MySQL Workbench Table Data Import Wizard or LOAD DATA LOCAL INFILE.

### Step 4: Run the queries
All 9 queries are in `analysis_queries.sql` — run them in order in MySQL Workbench.

## 👩‍💻 About

**Bhumika Jain** — Final year CSE student at KMIT, Hyderabad | Pursuing PM with Generative & Agentic AI certification (BITSoM CEPD) | Targeting Product Manager / Product Analyst roles

[LinkedIn](https://linkedin.com/in/bhumikajain) · [GitHub](https://github.com/bhumiiijain)
