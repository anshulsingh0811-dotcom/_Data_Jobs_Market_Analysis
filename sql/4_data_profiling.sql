-- Analyizing the data in the table to get preview.
SELECT * FROM data_jobs
LIMIT 10;




-- Total number of records = 785741

SELECT COUNT(*) AS total_records
FROM data_jobs;



-- Non null and Null values in column.
SELECT
    COUNT(*) AS total_rows,

    COUNT(job_title_short) AS job_title_short_non_null,
    COUNT(*) - COUNT(job_title_short) AS job_title_short_null,

    COUNT(job_location) AS job_location_non_null,
    COUNT(*) - COUNT(job_location) AS job_location_null,

    COUNT(salary_year_avg) AS salary_year_non_null,
    COUNT(*) - COUNT(salary_year_avg) AS salary_year_null,

    COUNT(job_skills) AS job_skills_non_null,
    COUNT(*) - COUNT(job_skills) AS job_skills_null
FROM data_jobs;

/*[
  {
    "total_rows": "785741",
    "job_title_short_non_null": "785741",
    "job_title_short_null": "0",
    "job_location_non_null": "784696",
    "job_location_null": "1045",
    "salary_year_non_null": "22003",
    "salary_year_null": "763738",
    "job_skills_non_null": "668704",
    "job_skills_null": "117037"
  }
]*/
