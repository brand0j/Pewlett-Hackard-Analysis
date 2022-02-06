# Pewlett-Hackard-Analysis

## Overview of Project

### Purpose

In this analysis we aim to determine the amount of retiring employees per title and to identify which employees would be eligible to be a part of a mentorship program which will help train the next wave of employees to take their place. Through the use of SQL this task will be made easier since we will be referencing multiple tables, combining them, and performing other queries to gain insight. 

## Results
The first step in this process is to establish a data table containing all of the current employees who are eligible for retirement. To do this, we will use the built in functions within SQL to filter our data as neede. It is important that we exclude employees that have already retired from the company since this would skew our assessment, along with removing duplicate entries (employees who were promoted show up as having multiple titles associated with their employee # throughout their time with the company). First we will use the following code to create a table holding all of the employees that would be eligible for retirement:

```
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

```
![retirement_titles](https://github.com/brand0j/Pewlett-Hackard-Analysis/blob/main/Resources/retirement_titles.PNG)

You can see from the image above that their are duplicate entries within our table and you can confirm that these signify employees being promoted. To further filter this data we will to select the current title for each employee. In addition, we will also only be interested in employees who are still with the company for obvious reasons. Using ```SELECT DISTINCT ON``` we can accomplish this.

```
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

```
![unique_titles](https://github.com/brand0j/Pewlett-Hackard-Analysis/blob/main/Resources/unique_titles.PNG)

With a ```SELECT COUNT()``` call we can determine the amount of retiring employees for each title which yields the following table:

```
--Get a count of how many people are retiring in each title
SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY ut.count DESC
```

![title_count](https://github.com/brand0j/Pewlett-Hackard-Analysis/blob/main/Resources/title_count.PNG)

As you can see from the table, there are 72,458 employees eligible for retirement which leaves a lot of positions to be filled. The next step is to identify which current employees would be able to help mentor others to fill the imminent vacancies within the company. Using the following code we obtain a table of employees eligible for mentorship roles.

```
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
```

![mentorship_eligibility](https://github.com/brand0j/Pewlett-Hackard-Analysis/blob/main/Resources/mentorship_eligibility.PNG)


## Summary
To answer the questions presented I will need to explain through the use of two additional tables. The first being a query to obtain the count of eligible mentors grouped by their title. The second being a count of all current employees by title. The following code was implemented to obtain these:

```
--Count of employees eligible to be mentors by title
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
```

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

![current_employees](https://github.com/brand0j/Pewlett-Hackard-Analysis/blob/main/Resources/current_employees.PNG)
![title_count](https://github.com/brand0j/Pewlett-Hackard-Analysis/blob/main/Resources/title_count.PNG)
![mentorship_eligibility_count](https://github.com/brand0j/Pewlett-Hackard-Analysis/blob/main/Resources/mentorship_eligibility_count.PNG)


The tables presented above from left to right are as follows: Current Employees (by title), Retiring Employees (by title), Mentorship Eligible Employees (by title)
You can immediately notice there is a huge disparity between the amount of retiring employees and the amount of eligible mentors within the company (for Senior Engineers there are 25,916 employees ready for retirement with only 169 eligible mentors). This poses a huge problem for the company and would leave many departments short staffed since there are not enough mentors to accomodate for the number of potentially retiring employees.
