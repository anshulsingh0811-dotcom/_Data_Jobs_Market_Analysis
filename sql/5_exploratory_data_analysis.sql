/*
====================================================
EXPLORATORY DATA ANALYSIS (EDA)
Project: Global Data Jobs Market Analysis - 2023
====================================================
*/

/*
-------------------------------------------------------
EDA 1: Distribution of Job Roles
Business Question:
Which job roles had the highest hiring demand in 2023?
-------------------------------------------------------
*/

WITH top_3_roles AS (
    SELECT job_title_short,
    COUNT(*) AS job_count
    FROM data_jobs
    GROUP BY job_title_short
    ORDER BY job_count DESC
    LIMIT 3
)

SELECT
    ROUND(
        100.0 * SUM(job_count) / (SELECT COUNT(*) FROM data_jobs),
        2) AS top_3_percentage
FROM top_3_roles;

  
/*
Observations: 
- Data Analyst, Data Engineer and Data Scientist are the top 3 job roles 
- Together, these roles account for approximately 554,602 job postings (~70% of the dataset)
- This indicates that organizations primarily hired for data analytics, data engineering,
  and data science roles in 2023.
*/
----------------------------------------------------------------------------------------------------------






/*
----------------------------------------------------
EDA 2: Hiring by Country
Business Question:
Which countries have the highest demand for data professionals?
----------------------------------------------------
*/


SELECT 
    job_country,
    COUNT(*) AS job_count
FROM data_jobs
GROUP BY job_country
ORDER BY job_count DESC
LIMIT 10;


/*
Observations:
- The United States accounts for the largest share of job postings.
- India ,United Kingdom and France are the next three largest hiring markets.
- This suggests that these countries have a strong demand for data professionals in 2023.
*/
--------------------------------------------------------------------------------------------------





/*====================================================
EDA 3: Remote Work Distribution

Business Question:
What is the distribution of remote and on-site jobs in 2023?
====================================================
*/

SELECT
    CASE
        WHEN job_work_from_home = TRUE THEN 'Remote'
        ELSE 'On-Site'
    END AS work_type,
    COUNT(*) AS job_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM data_jobs),
        2
    ) AS percentage
FROM data_jobs
GROUP BY work_type
ORDER BY job_count DESC;

--Observations:
-- The majority of job postings are for on-site positions (~91%).
-- With remote jobs accounting for a smaller percentage (~9%) of the total. 
-----------------------------------------------------------------------------------------------------------





/*
====================================================
EDA 4: Remote Work by Job Role

Business Question:
Which job roles offer the highest percentage of remote work opportunities?
====================================================
*/

SELECT 
    job_title_short,
    COUNT(*) AS total_jobs,
    SUM(CASE
           WHEN job_work_from_home = TRUE THEN 1
           ELSE 0
       END) AS remote_jobs_count,
    ROUND(100.0 * SUM(CASE
           WHEN job_work_from_home = TRUE THEN 1
           ELSE 0
       END) / COUNT(*),2) AS remote_jobs_percentage
FROM data_jobs
GROUP BY job_title_short
ORDER BY remote_jobs_percentage DESC

/*
Observations:
- Senior Data Engineer has the highest percentage of remote work opportunities (~15%).
- Data Engineer & Machine Learning Engineer also have a relatively high proportion of remote jobs(11.5% & 10.5% respectively).
- Data Analyst have relatively lower remote work opportunities (6.8%) suggesting that entry and mid-level analyst positions
  are more commonly office-based.
*/
-------------------------------------------------------------------------------------------------------------------------------






/*
====================================================
EDA 5: Average Annual Salary by Job Role

Business Question:
Which job roles have the highest average annual salary?
====================================================
*/

SELECT
    job_title_short,
    COUNT(salary_year_avg) AS salary_records,
    ROUND(AVG(salary_year_avg), 0) AS yearly_average_salary
FROM data_jobs
GROUP BY job_title_short
HAVING COUNT(salary_year_avg) >= 100
ORDER BY yearly_average_salary DESC;


/*
Observations:
- Senior Data Scientist has the highest average annual salary($155k).
- Senior level roles offer higher avg. salaries compared to their junior counterparts.
- Data Analyst and Business Analyst have the lowest average annual salaries among analyzed roles,
  suggesting that these positions are generally entry-level or mid-level roles in the data job market.
- Data Scientists earn approximately 45% higher average salaries than Data Analysts,highlighting the
  salary premium associated with advanced analytics and machine learning skills.
*/
------------------------------------------------------------------------------------------------------------






/*
====================================================
EDA 6: Average Annual Salary by Country for Data Analysts

Business Question:
Which countries offer the highest average annual salaries for data analysts?
====================================================
*/
SELECT
    job_country,
    COUNT(*) AS job_count,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM data_jobs
WHERE 
    salary_year_avg IS NOT NULL
    AND 
    job_title_short = 'Data Analyst'
GROUP BY job_country
HAVING COUNT(*) >=30
ORDER BY avg_salary DESC
LIMIT 10;

/*
Observations:
- Germany has the highest average annual salary for Data Analysts,followed by India and the United States.
- The United States has by far the largest number of salary records (4,350), making its average salary 
  estimate more reliable than countries with relatively few salary records
*/
---------------------------------------------------------------------------------------------------------------





/*
====================================================
EDA 7: Most In-Demand Technical Skills

Business Question:
Which technical skills are most frequently required
across data-related job postings?
====================================================
*/

WITH cleaned_skills AS
(
    SELECT
        TRIM(
            REPLACE(
                UNNEST(
                    STRING_TO_ARRAY(
                        TRIM(BOTH '[]' FROM job_skills),','
                    )
                ),'''',''
            )
        ) AS skill
    FROM data_jobs
    WHERE job_skills IS NOT NULL
)

SELECT
    skill,
    COUNT(*) AS demand_count
FROM cleaned_skills
GROUP BY skill
ORDER BY demand_count DESC
LIMIT 10;


/*
Observations:
- SQL is the most in-demand technical skill, closely followed by Python in data related roles.
- Cloud technologies such as AWS and Azure are among the top five skills, indicating the 
  increasing demand for cloud-based data platforms.
*/
-------------------------------------------------------------------------------------------------------------





/*
====================================================
EDA 8: High Demand & High Salary Skills

Business Question:
Which high-demand technical skills offer the highest average annual salaries?
====================================================
*/

WITH cleaned_skills AS
(
    SELECT
        TRIM(
            REPLACE(
                UNNEST(
                    STRING_TO_ARRAY(
                        TRIM(BOTH '[]' FROM job_skills),','
                    )
                ),'''',''
            )
        ) AS skill,
    salary_year_avg
    FROM data_jobs
    WHERE job_skills IS NOT NULL
)

SELECT 
    skill,
    COUNT(*) AS demand_count,
    COUNT(salary_year_avg) AS salary_records,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM cleaned_skills
GROUP BY skill
HAVING COUNT(*) >= 20000               -- Focus on skills with at least 20,000 job postings
    AND COUNT(salary_year_avg) >= 100  -- For reliable salary estimates 
ORDER BY avg_salary DESC, demand_count DESC
LIMIT 20;

/*
Observations:
- Scala, Kafka, Spark, and Airflow provide an excellent combination of high market demand and high average annual salaries.
- Big data, cloud, and machine learning technologies dominate the list, highlighting their strong demand in the data job market.
- AWS has the highest demand (145K+ job postings) while maintaining a competitive average salary (~$136K).
- Pandas and NumPy remain highly valued skills, offering strong average salaries while maintaining substantial market demand, 
  reflecting their importance in Python-based data analysis and machine learning workflows.
- Developing expertise in data engineering, cloud computing, and machine learning technologies can significantly enhance career
  opportunities and earning potential.
*/
-----------------------------------------------------------------------------------------------------------------------------------




