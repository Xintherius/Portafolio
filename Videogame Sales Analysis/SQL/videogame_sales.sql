-- ==================
-- Data Quality Audit
-- ==================

-- Total Row Count
SELECT COUNT(*) AS total_rows FROM sales;

-- Null counts per column
SELECT
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS null_title,
    SUM(CASE WHEN console IS NULL THEN 1 ELSE 0 END) AS null_console,
    SUM(CASE WHEN genre IS NULL THEN 1 ELSE 0 END) AS null_genre,
    SUM(CASE WHEN publisher IS NULL THEN 1 ELSE 0 END) AS null_publisher,
    SUM(CASE WHEN developer IS NULL THEN 1 ELSE 0 END) AS null_developer,
    SUM(CASE WHEN critic_score IS NULL THEN 1 ELSE 0 END) AS null_critic_score,
    SUM(CASE WHEN total_sales IS NULL THEN 1 ELSE 0 END) AS null_total_sales,
    SUM(CASE WHEN release_date IS NULL THEN 1 ELSE 0 END) AS null_release_date
FROM sales;

-- Repeated Games
SELECT title, console, COUNT(*) AS occurrences
FROM sales
GROUP BY title, console
HAVING occurrences > 1
ORDER BY occurrences DESC;

-- Zero or Negative sales
SELECT COUNT(*) AS zero_or_negative_sales
FROM sales
WHERE total_sales <= 0;


-- =============
-- Data Cleaning
-- =============

-- Are the duplicate titles identical rows?
SELECT
 a.title, a.console, a.total_sales AS sales_a, b.total_sales AS sales_b,
 a.critic_score AS score_a, b.critic_score AS score_b
FROM sales a 
JOIN sales b
    ON LOWER(a.title) = LOWER(b.title)
    AND LOWER(a.console) - LOWER(b.console)
    AND a.title < b.title
WHERE a.total_sales != b.total_sales OR a.critic_score != b.critic_score;

-- Create new clean table 
CREATE TABLE clean_sales AS
SELECT DISTINCT
    title, console, genre, publisher, developer,
    critic_score, total_sales, na_sales, jp_sales,
    pal_sales, other_sales, release_date

FROM sales
WHERE total_sales IS NOT NULL AND total_sales > 0;

-- verification
SELECT COUNT(*) FROM clean_sales;


--=========
-- Analysis
-- ========

-- Sales by Console
SELECT
console,
ROUND(SUM(total_sales),2) AS total_sales_in_M
FROM clean_sales
GROUP BY console
ORDER BY total_sales_in_M DESC;


-- Categorizing Metacritic scores into low, medium, high
SELECT
    CASE
        WHEN critic_score <=5 THEN 'Low Score (<=5)'
        WHEN critic_score BETWEEN 5.1 AND 7 THEN 'Medium Score (5.1-7)'
        ELSE 'High Score (>7)'
    END AS score_category,
    COUNT(*) as count_of_titles
FROM clean_sales
WHERE critic_score IS NOT NULL
GROUP BY score_category
ORDER BY count_of_titles DESC;


-- Genre Popularity by Region
SELECT
genre,
ROUND(SUM(jp_sales),2) AS total_jp,
ROUND(SUM(na_sales),2) AS total_na,
ROUND(SUM(pal_sales),2) AS total_pal

FROM clean_sales
WHERE jp_sales IS NOT NULL OR na_sales IS NOT NULL OR pal_sales IS NOT NULL
GROUP BY genre
ORDER BY total_na DESC;


--Sales per year of release
SELECT 
ROUND(SUM(total_sales),2) AS sales_total,
YEAR(release_date) as  release_year
FROM clean_sales
GROUP BY release_year
ORDER BY sales_total DESC;



