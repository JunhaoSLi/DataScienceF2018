# Questions

These are the questions we decided to look into for this checkpoint:

1. When considering officers involved in cases that resulted in settlements, is there a correlation between the amount that the officer cost the city of Chicago and the number of complaints levied against the officer?

2. Does the correlation between cost to city and complaints levied change when considering race and gender of officer? Do officers with the same number of complaints levied against them have to pay different amounts when considering race and gender?

3. Is there a correlation between the groups of complainants that make the most allegations and the groups of individuals that are arrested the most by beat?

4. Is there a correlation between number of allegations received before an officer’s first settlement case and number of allegations received after?

# Procedure

Three custom tables were made for these questions, `complaints_per_cop`, `total_cost_per_officer`, and `min_settlement_dates`.

`complaints_per_cop` was made with the following query within the CPDB:

```
SELECT officer_id, COUNT(*) AS num_complaints
FROM data_officer 
JOIN data_officerallegation ON data_officer.id = data_officerallegation.officer_id
GROUP BY officer_id
ORDER BY officer_id
```

`total_cost_per_officer` was made using the following steps in Trifacta (all tables from this point are named as they appear in the CPDB and settlement database except for officer_map which was the linking table between the CPB and settlement database provided by Professor Rogers):
1. Join `cops_cop` with  `cops_casecop` on `id` and `cop_id`, respectively.
2. Join with `cases_payment` on `case_id` and `case_id`.
3. Join with `officer_map` on `cop_id` and `settlement_cop_id`.
4. Join with `data_officer` on `cpdb_id` and `id`.
5. Compute a pivot table with `data_officer.id`, `data_officer.race`, `data_officer.gender` as columns for `SUM(payment) + SUM(fees_costs)`.

`min_settlement_dates` was made with same procedure as `total_cost_per_officer` except by (1) replacing the join in step 2 with
a join with `cases_case` and (2) replacing the pivot table columns in step 5 with just `data_officer.id` and replacing the formula with `MIN(cases_case.date_closed)`.

## Queries

With the tables above and the CPDB, the following queries were used to answer our questions.

Question 1:

```
REGULAR QUERY

\copy (SELECT num_complaints, total_cost FROM total_cost_per_officer, complaints_per_cop WHERE total_cost_per_officer.officer_id=complaints_per_cop.officer_id) to 'complaints_and_cost.csv' with csv;

AGGREGATE QUERY

\copy (SELECT num_complaints, AVG(total_cost) FROM total_cost_per_officer, complaints_per_cop WHERE total_cost_per_officer.officer_id=complaints_per_cop.officer_id GROUP BY complaints_per_cop.num_complaints ORDER BY complaints_per_cop.num_complaints) to 'aggregate_complaints_and_cost.csv' with csv;
```

Question 2:

```
QUERY FOR RACES / GENDERS (AGGREGATE)

\copy (SELECT num_complaints, AVG(total_cost), race, gender FROM total_cost_per_officer, complaints_per_cop, data_officer WHERE data_officer.id=total_cost_per_officer.officer_id AND total_cost_per_officer.officer_id=complaints_per_cop.officer_id GROUP BY data_officer.race, data_officer.gender, complaints_per_cop.num_complaints ORDER BY data_officer.race, data_officer.gender, num_complaints) to 'aggregate_complaints_and_cost_by_race_and_gender.csv' with csv;
```

Question 3:

```
ALLEGATIONS AFTER FIRST SETTLEMENT QUERY

\copy (SELECT cop_id, COUNT(allegation_id) FROM min_settlement_dates, data_officer, data_officerallegation WHERE min_settlement_dates.cop_id=data_officer.id AND data_officer.id=data_officerallegation.officer_id AND data_officerallegation.start_date > min_settlement_dates.min_settlement_date_closed GROUP BY cop_id) to 'allegations_after_settlement.csv' with csv;

ALLEGATIONS BEFORE FIRST SETTLEMENT QUERY

\copy (SELECT cop_id, COUNT(allegation_id) FROM min_settlement_dates, data_officer, data_officerallegation WHERE min_settlement_dates.cop_id=data_officer.id  AND data_officer.id=data_officerallegation.officer_id AND data_officerallegation.start_date < min_settlement_dates.min_settlement_date_closed GROUP BY cop_id) to 'allegations_before_settlement.csv' with csv;

COUNT OF ALLEGATIONS AGAINST BLACK OFFICERS

SELECT COUNT(DISTINCT allegation_id)
FROM data_allegation AS a
JOIN data_officerallegation AS oa ON a.id = oa.allegation_id
JOIN data_officer AS o ON o.id = oa.officer_id
WHERE o.race='Black' AND o.gender='M';

COUNT OF ALLEGATIONS AGAINST BLACK OFFICERS FROM PEERS

SELECT COUNT(DISTINCT allegation_id)
FROM data_allegation AS a
JOIN data_officerallegation AS oa ON a.id = oa.allegation_id
JOIN data_officer AS o ON o.id = oa.officer_id
WHERE o.race='Black' AND o.gender='M' AND a.is_officer_complaint='t';

COUNT OF ALLEGATIONS AGAINST ALL OFFICERS

SELECT COUNT(DISTINCT allegation_id)
FROM data_allegation AS a
JOIN data_officerallegation AS oa ON a.id = oa.allegation_id
JOIN data_officer AS o ON o.id = oa.officer_id;

COUNT OF ALLEGATIONS AGAINST ALL OFFICERS FROM PEERS

SELECT COUNT(DISTINCT allegation_id)
FROM data_allegation AS a
JOIN data_officerallegation AS oa ON a.id = oa.allegation_id
JOIN data_officer AS o ON o.id = oa.officer_id
WHERE a.is_officer_complaint='t';

DISTRIBUTION OF ALLEGATION CATEGORIES FOR ALL OFFICERS

SELECT COUNT(DISTINCT allegation_id)
FROM data_allegation AS a
JOIN data_officerallegation AS oa ON a.id = oa.allegation_id
JOIN data_officer AS o ON o.id = oa.officer_id
WHERE a.is_officer_complaint='t';
SELECT ac.category, COUNT(DISTINCT allegation_id) /134962.0 as count
FROM data_officerallegation AS oa
JOIN data_allegationcategory AS ac ON ac.id = oa.allegation_category_id
GROUP BY ac.category
ORDER BY count;

DISTRIBUTION OF ALLEGATION CATEGORIES FOR BLACK OFFICERS

SELECT ac.category, COUNT(DISTINCT allegation_id) /47225.0 as proportion
FROM data_officerallegation AS oa
JOIN data_officer AS o ON o.id = oa.officer_id
JOIN data_allegationcategory as ac ON ac.id = oa.allegation_category_id
WHERE o.race='Black'
GROUP BY ac.category
ORDER BY proportion;

PROPORTION OF ALLEGATIONS INVOLVING BLACK OFFICERS BY YEAR

WITH totalc AS (
SELECT date_part('year', incident_date) AS yr, COUNT(DISTINCT allegation_id) as total_count
FROM data_allegation AS a
JOIN data_officerallegation AS oa ON a.id = oa.allegation_id
JOIN data_officer AS o ON o.id = oa.officer_id
GROUP BY yr
)
, blackc AS (
    SELECT date_part('year', incident_date) AS yr, COUNT(DISTINCT allegation_id) as black_count
    FROM data_allegation AS a
    JOIN data_officerallegation AS oa ON a.id = oa.allegation_id
    JOIN data_officer AS o ON o.id = oa.officer_id
    WHERE o.race='Black'
    GROUP BY yr
)
SELECT totalc.yr, black_count / CAST(total_count AS FLOAT)
FROM totalc
LEFT JOIN blackc ON totalc.yr = blackc.yr;
```

Question 4:

```
COMPLAINANT RACE PER BEAT

WITH complainant_table AS (SELECT beat_table.name, beat_table.complainant_race FROM (SELECT data_area.name, complainant_race.race AS complainant_race FROM data_area JOIN (SELECT data_allegation.beat_id, data_complainant.race FROM data_allegation INNER JOIN data_complainant ON data_allegation.id = data_complainant.allegation_id) AS complainant_race ON complainant_race.beat_id = data_area.id) AS beat_table ORDER BY beat_table.name) SELECT complainant_table.name, mode() WITHIN GROUP (ORDER BY complainant_table.complainant_race) FROM complainant_table GROUP BY complainant_table.name;

ARREST RACE PER BEAT

SELECT arr_beat, mode() WITHIN GROUP (ORDER BY arr_race) FROM data_arrests GROUP BY arr_beat;
```
