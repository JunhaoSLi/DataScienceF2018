# Goal

Our goal for this checkpoint was to create a nueral network classifier capable of predicting whether an officer would receive an allegation in the future given the summaries of the allegations the officer had previously been involved in.

# Classifier

Our classifier is located within the `src` folder and can be run using the following command within the directory:

```
python train.py --dataset checkpoint5 --desc checkpoint5 --submit --analysis
```

The training and testing datasets were made from partitions of the datasets within the `datasets` directory. The queries used to construct these datasets are below.

```
-- Allegation ID, officer ID, summary, label of whether officer received a future allegation
\copy (
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
) To 'summaries_with_labels.csv' With CSV HEADER;


-- Allegation ID, summary, label of whether the majority of officers in the allegation received future allegations
\copy (
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
) To 'allegations_with_labels.csv' With CSV HEADER;
```