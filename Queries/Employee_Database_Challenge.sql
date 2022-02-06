
--Create titles table leaving off Primary key since there are duplicate primary keys
DROP TABLE titles;
CREATE TABLE titles(
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL
);

--Joining two tables
SELECT em.emp_no,
	em.first_name,
	em.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO retirement_titles
FROM employees as em
LEFT JOIN titles as ti
ON em.emp_no = ti.emp_no
WHERE (em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;


-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON(emp_no) emp_no,
	first_name,
	last_name,
	from_date,
	to_date,
	title
INTO unique_titles
FROM retirement_titles
WHERE (to_date = '9999-01-01')
ORDER BY emp_no


--Get a count of how many people are retiring in each title
SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY ut.count DESC



--Mentorship Elegibility
SELECT DISTINCT ON (emp_no) em.emp_no,
	em.first_name,
	em.last_name,
	em.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship_eligibility
FROM employees as em
INNER JOIN dept_emp as de
ON em.emp_no = de.emp_no
LEFT JOIN titles as ti
ON em.emp_no = ti.emp_no
WHERE (de.to_date = '9999-01-01')
	AND (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY em.emp_no;


--SUMMARY ANALYSIS
--Count of eligible mentors in each title
SELECT COUNT(me.emp_no) AS "Eligible Mentors", me.title 
FROM mentorship_eligibility as me
GROUP BY me.title
ORDER BY me.count DESC

--Count of current employees by title
SELECT COUNT(DISTINCT emp_no),
	title
FROM titles
WHERE (to_date = '9999-01-01')
GROUP BY title
ORDER BY count DESC


