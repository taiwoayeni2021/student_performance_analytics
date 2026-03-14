--To create Table named student_performance
CREATE TABLE student_performance(
	student_id				TEXT,
	school					TEXT,
	student_class			TEXT,
	gender					TEXT,
	subject					TEXT,
	teacher					TEXT,
	attendance_rate			NUMERIC,
	homework_score			NUMERIC,
	midterm_score			NUMERIC,
	final_exam_score		NUMERIC,
	overall_score			NUMERIC	
);

--Import data into the table

--To alter the table by creating two new columns
ALTER TABLE student_performance
ADD COLUMN performance_category TEXT;

UPDATE student_performance
SET performance_category =
CASE
	WHEN overall_score >= 80 THEN 'Excellent'
	WHEN overall_score >= 60 THEN 'Good'
	WHEN overall_score >= 40 THEN 'Average'
	ELSE 'Poor'
END;

ALTER TABLE student_performance
ADD COLUMN attendance_category TEXT;

UPDATE student_performance
SET attendance_category =
CASE
	WHEN attendance_rate >= 90 THEN 'High'
	WHEN attendance_rate >= 75 THEN 'Moderate'
	ELSE 'Low'
END;


--1. Subject Performance
---a. Subject with highest/lowest average scores
SELECT subject, ROUND(AVG(overall_score),2) AS highest_average_score
FROM student_performance
GROUP BY subject
ORDER BY highest_average_score DESC;

---b. Subjects where most students fall into the poor performance category
SELECT subject, COUNT(*) AS poor_students
FROM student_performance
WHERE performance_category = 'Poor'
GROUP BY subject
ORDER BY poor_students DESC;

--2. Grade Level Performance
---a.Student Class performance(Best/Worst)
SELECT student_class, ROUND(AVG(overall_score), 2) AS avg_overall_score
FROM student_performance
GROUP BY student_class
ORDER BY avg_overall_score DESC;

---b. Are there Grade Levels with a high number of students in the Poor category?
SELECT student_class, COUNT(*) AS poor_students
FROM student_performance
WHERE performance_category = 'Poor'
GROUP BY student_class
ORDER BY poor_students DESC;

--3. Attendance Analysis
---a. Does Attendance affect overall performance?
SELECT attendance_category, ROUND(AVG(overall_score), 2) AS avg_score
FROM student_performance
GROUP BY attendance_category
ORDER BY avg_score DESC;

---b. How performance vary across High, Moderate, and Low Attendance categories?
SELECT attendance_category, performance_category, COUNT(*) AS student_count
FROM student_performance
GROUP BY attendance_category, performance_category
ORDER BY attendance_category, student_count DESC;

--4. Teacher Analysis
---a. Teacher with highest and lowest average overall scores
SELECT teacher, ROUND(AVG(overall_score), 2) AS avg_overall_score
FROM student_performance
GROUP BY teacher
ORDER BY avg_overall_score DESC;

---b. Are certain teachers producing more excellent or poor students than others?
SELECT teacher, performance_category, COUNT(*) AS performance_category_count
FROM student_performance
WHERE performance_category IN ('Excellent', 'Poor')
GROUP BY teacher, performance_category
ORDER BY teacher, performance_category_count DESC;

--5. Gender Analysis
---a. Are there performance differences between Male and Female Students?
SELECT gender, COUNT(*) AS total_students,
ROUND(AVG(overall_score), 2) AS avg_overall_score
FROM student_performance
GROUP BY gender;

---b. Does attendance vary by gender?
SELECT gender, COUNT(*) AS total_students,
ROUND(AVG(attendance_rate), 2) AS avg_attendance_rate
FROM student_performance
GROUP BY gender;

--6. School comparison
---a. Which school has the highest overall performance?
SELECT school, COUNT(*), ROUND(AVG(overall_score), 2) AS avg_overall_score
FROM student_performance
GROUP BY school
ORDER BY avg_overall_score DESC;

--7. Distribution insights
---a. How many students fall into each Performance category?
SELECT performance_category, COUNT(*) AS number_of_students
FROM student_performance
GROUP BY performance_category
ORDER BY number_of_students  DESC;

---b. How many students are in each Attendance category?
SELECT attendance_category, COUNT(*) AS number_of_students
FROM student_performance
GROUP BY attendance_category
ORDER BY number_of_students DESC;

--8. Combined insights
---a. Which subject + student_class combinations are most challenging?
SELECT subject, student_class, ROUND(AVG(overall_score),2) AS avg_overall_score
FROM student_performance
GROUP BY subject, student_class
ORDER BY avg_overall_score;

---b. Which teachers need support in specific subjects based on student outcomes?
SELECT teacher, subject, COUNT(*) AS total_number_of_students,
ROUND(AVG(overall_score),2) AS avg_overall_score
FROM student_performance
GROUP BY teacher, subject
ORDER BY avg_overall_score;
