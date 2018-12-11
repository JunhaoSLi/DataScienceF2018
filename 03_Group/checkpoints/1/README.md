# Questions

These are the questions we decided to look into for this checkpoint:

1. Is there a correlation between race and gender of the officer and the type of complaint (verbal abuse, use of force, etc)?

2. How does the gender of an officer affect the amount of allegations they recieve and the rate at which those allegations lead to punishments?

3. What is the distribution of officers, investigators, and victims across race and gender?

4. Is the distribution of TRRs by officer race proportionate to the distribution of allegations against officers? 

# Procedure

Our analyses were made from the results of queries on the CPDB.

## Queries

With the tables above and the CPDB, the following queries were used to answer our questions.

Question 1:

```
-- Counts of allegations by category
SELECT category, COUNT(*) 
FROM data_allegationcategory JOIN data_officerallegation 
ON data_allegationcategory.id=data_officerallegation.allegation_category_id 
GROUP BY category;

-- Counts of instances of allegations by category against officers of each race and gender
SELECT race, gender, category, COUNT(*) FROM data_allegationcategory JOIN data_officerallegation ON data_allegationcategory.id=data_officerallegation.allegation_category_id JOIN data_officer ON data_officerallegation.officer_id=data_officer.id GROUP BY race, gender, category;
```

Question 2:

```
-- The total number of officer allegations by gender
SELECT data_officer.gender, COUNT(*) FROM data_officer, data_officerallegation WHERE data_officer.id = data_officerallegation.officer_id
GROUP BY data_officer.gender;

-- The total number of officers by gender
SELECT data_officer.gender, COUNT(*) FROM data_officer GROUP BY data_officer.gender;

-- Total number of allegations that ended up with punishments
SELECT data_officer.gender, COUNT(*) FROM data_officer, data_officerallegation WHERE data_officer.id = data_officerallegation.officer_id and data_officerallegation.final_outcome <> 'No Action Taken' and data_officerallegation.final_outcome <> 'Penalty Not Served'
GROUP BY data_officer.gender;

```

Question 3:

```
-- The distribution of investigators by race and gender
SELECT race, gender, COUNT (1) as num 
FROM data_investigator 
GROUP BY race, gender;
ORDER BY race, gender;


-- The distribution of officer by race and gender
SELECT race, gender, COUNT (1) as num 
FROM data_officer GROUP BY race, gender 
ORDER BY race, gender;


-- The distribution of complainants by race and gender
SELECT race, gender, COUNT (1) as num 
FROM data_complainant 
GROUP BY race, gender 
ORDER BY race, gender;
```

Question 4:

```
-- The distribution of counts of allegation against an officer of a race and gender by race and gender
SELECT race, gender, COUNT(*) 
FROM data_officerallegation 
JOIN data_officer ON data_officerallegation.officer_id=data_officer.id 
GROUP BY race, gender;


-- The distribution of TRRs by the race and gender of the officer filing
SELECT race, gender, COUNT(*) 
FROM data_officer 
JOIN trr_trr ON data_officer.id=trr_trr.officer_id 
GROUP BY race, gender;

```
