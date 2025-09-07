SELECT DATABASE();
USE sql_mentor_db;


CREATE TABLE user_submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    question_id INT,
    points INT,
    submitted_at TIMESTAMP,
    username VARCHAR(50)
);

SELECT * FROM user_submissions;


-- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)
SELECT 
    username,
    COUNT(id) AS total_submissions,
    SUM(points) AS points_earned
FROM user_submissions
GROUP BY username
ORDER BY total_submissions DESC;


-- Q.2 Calculate the daily average points for each user.
SELECT 
    DATE(submitted_at) AS day,
    username,
    AVG(points) AS daily_avg_points
FROM user_submissions
GROUP BY day, username
ORDER BY username;


-- Q.3 Find the top 3 users with the most correct submissions for each day.
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


-- Q.4 Find the top 5 users with the highest number of incorrect submissions.
SELECT 
    username,
    SUM(CASE WHEN points < 0 THEN 1 ELSE 0 END) AS incorrect_submissions,
    SUM(CASE WHEN points > 0 THEN 1 ELSE 0 END) AS correct_submissions,
    SUM(CASE WHEN points < 0 THEN points ELSE 0 END) AS incorrect_submissions_points,
    SUM(CASE WHEN points > 0 THEN points ELSE 0 END) AS correct_submissions_points_earned,
    SUM(points) AS points_earned
FROM user_submissions
GROUP BY username
ORDER BY incorrect_submissions DESC
LIMIT 5;


-- Q.5 Find the top 5 performers for each week.
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


