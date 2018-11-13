
\copy (WITH data_repeatcomplaints as (SELECT officer_id, CASE WHEN SUM(CASE WHEN incident_date > '2013-12-31 23:59:59-06' THEN 1 ELSE 0 END) > 0 THEN 1  ELSE 0 END AS label FROM data_allegation AS a JOIN data_officerallegation AS oa ON a.id = oa.allegation_id JOIN data_officer AS o ON oa.officer_id = o.id WHERE active <> 'No' GROUP BY officer_id ORDER BY officer_id ) SELECT allegation_id, oa.officer_id, summary, label FROM data_allegation AS a JOIN data_officerallegation AS oa ON a.id = oa.allegation_id JOIN data_repeatcomplaints AS rc ON rc.officer_id = oa.officer_id WHERE summary <> '') To 'summaries_with_labels.csv' With CSV HEADER;

WITH data_repeatcomplaints as ( 
    SELECT officer_id, 
        CASE WHEN SUM(CASE WHEN incident_date > '2013-12-31 23:59:59-06' 
                           THEN 1 
                           ELSE 0 
                      END) > 0
            THEN 1
            ELSE 0
        END AS label
    FROM data_allegation AS a
    JOIN data_officerallegation AS oa ON a.id = oa.allegation_id
    JOIN data_officer AS o ON oa.officer_id = o.id
    WHERE active <> 'No'
    GROUP BY officer_id
    ORDER BY officer_id
)
SELECT allegation_id, oa.officer_id, summary, label
FROM data_allegation AS a
JOIN data_officerallegation AS oa ON a.id = oa.allegation_id
JOIN data_repeatcomplaints AS rc ON rc.officer_id = oa.officer_id
WHERE summary <> '';

\copy (WITH data_repeatcomplaints as (SELECT officer_id, CASE WHEN SUM(CASE WHEN incident_date > '2013-12-31 23:59:59-06' THEN 1 ELSE 0 END) > 0 THEN 1 ELSE 0 END AS recent_complaint FROM data_allegation AS a JOIN data_officerallegation AS oa ON a.id = oa.allegation_id JOIN data_officer AS o ON oa.officer_id = o.id WHERE active <> 'No' GROUP BY officer_id ORDER BY officer_id) SELECT allegation_id, summary, CASE WHEN SUM(recent_complaint) > (COUNT(recent_complaint) / 2.0) THEN 1 ELSE 0 END AS label FROM data_allegation AS a JOIN data_officerallegation AS oa ON a.id = oa.allegation_id JOIN data_repeatcomplaints AS rc ON rc.officer_id = oa.officer_id WHERE summary <> '' GROUP BY allegation_id, summary) To 'allegations_with_labels.csv' With CSV HEADER;

WITH data_repeatcomplaints as ( 
    SELECT officer_id, 
        CASE WHEN SUM(CASE WHEN incident_date > '2013-12-31 23:59:59-06' 
                           THEN 1 
                           ELSE 0 
                      END) > 0
            THEN 1
            ELSE 0
        END AS recent_complaint
    FROM data_allegation AS a
    JOIN data_officerallegation AS oa ON a.id = oa.allegation_id
    JOIN data_officer AS o ON oa.officer_id = o.id
    WHERE active <> 'No'
    GROUP BY officer_id
    ORDER BY officer_id
)
SELECT allegation_id, summary, 
    CASE WHEN SUM(recent_complaint) > (COUNT(recent_complaint) / 2.0)
         THEN 1
         ELSE 0
    END AS label
FROM data_allegation AS a
JOIN data_officerallegation AS oa ON a.id = oa.allegation_id
JOIN data_repeatcomplaints AS rc ON rc.officer_id = oa.officer_id
WHERE summary <> ''
GROUP BY allegation_id, summary;



579 allegations
574 summaries??
969 officers
1074 records