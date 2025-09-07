# SQL Mini Project — User Performance Analysis (Beginner Level)

## Project Overview

This project is designed to help beginners understand SQL querying and performance analysis using real-time data from SQL Mentor datasets. In this project, I created and queried a table of user submissions. The goal was to solve a series of SQL problems to extract meaningful insights from user data.

---

## Objectives

* Learn how to use SQL for data analysis tasks such as aggregation, filtering, and ranking.
* Understand how to calculate and manipulate data in a dataset.
* Gain hands-on experience with SQL functions like `COUNT`, `SUM`, `AVG`, `WEEK()`, and `DENSE_RANK()`.
* Develop skills for performance analysis using SQL by solving different types of problems related to user performance.

---
## Dataset: `user_submissions`

The dataset contains information about submissions made by users on an online learning platform. Each submission includes:

* **User ID**
* **Question ID**
* **Points Earned**
* **Submission Timestamp**
* **Username**

This data helps analyze user performance in terms of correct/incorrect submissions, total points, and daily/weekly activity.

---

## SQL Problems and Solutions (MySQL)

### Q1. List All Distinct Users and Their Stats

**Description:** Return username, total submissions, and total points earned by each user.

```sql
SELECT 
    username,
    COUNT(id) AS total_submissions,
    SUM(points) AS points_earned
FROM user_submissions
GROUP BY username
ORDER BY total_submissions DESC;
```

---

### Q2. Calculate the Daily Average Points for Each User

**Description:** For each day, calculate the average points earned by each user.

```sql
SELECT 
    DATE(submitted_at) AS day,
    username,
    AVG(points) AS daily_avg_points
FROM user_submissions
GROUP BY day, username
ORDER BY username;
```

---

### Q3. Find the Top 3 Users with the Most Correct Submissions for Each Day

**Description:** Identify the top 3 users with the most correct submissions per day.

```sql
WITH daily_submissions AS (
    SELECT 
        DATE(submitted_at) AS day,
        username,
        SUM(CASE WHEN points > 0 THEN 1 ELSE 0 END) AS correct_submissions
    FROM user_submissions
    GROUP BY day, username
),
users_rank AS (
    SELECT 
        day,
        username,
        correct_submissions,
        DENSE_RANK() OVER(PARTITION BY day ORDER BY correct_submissions DESC) AS rank_no
    FROM daily_submissions
)
SELECT 
    day,
    username,
    correct_submissions
FROM users_rank
WHERE rank_no <= 3;
```

---

### Q4. Find the Top 5 Users with the Highest Number of Incorrect Submissions

**Description:** Identify the top 5 users with the most incorrect submissions.

```sql
SELECT 
    username,
    SUM(CASE WHEN points < 0 THEN 1 ELSE 0 END) AS incorrect_submissions,
    SUM(CASE WHEN points > 0 THEN 1 ELSE 0 END) AS correct_submissions,
    SUM(CASE WHEN points < 0 THEN points ELSE 0 END) AS incorrect_submissions_points,
    SUM(CASE WHEN points > 0 THEN points ELSE 0 END) AS correct_submissions_points_earned,
    SUM(points) AS total_points
FROM user_submissions
GROUP BY username
ORDER BY incorrect_submissions DESC
LIMIT 5;
```

---

### Q5. Find the Top 5 Performers for Each Week

**Description:** Identify the top 10 users ranked by total points earned per week.

```sql
WITH weekly_points AS (
    SELECT 
        WEEK(submitted_at) AS week_no,
        username,
        SUM(points) AS total_points_earned
    FROM user_submissions
    GROUP BY week_no, username
),
weekly_rank AS (
    SELECT 
        week_no,
        username,
        total_points_earned,
        DENSE_RANK() OVER(PARTITION BY week_no ORDER BY total_points_earned DESC) AS rank_no
    FROM weekly_points
)
SELECT 
    week_no,
    username,
    total_points_earned
FROM weekly_rank
WHERE rank_no <= 5
ORDER BY week_no, total_points_earned DESC;
```

---

## Key SQL Concepts Covered

* **Aggregation** → `COUNT`, `SUM`, `AVG`
* **Date Functions** → `DATE()`, `WEEK()`
* **Conditional Aggregation** → `CASE WHEN`
* **Ranking** → `DENSE_RANK()`
* **Grouping** → `GROUP BY` (by user, day, week)

---

## Conclusion

This beginner-friendly project gave me the opportunity to practice SQL basics with real-world style problems. I applied aggregation, ranking, date functions, and conditional logic in MySQL to analyze user performance effectively.




