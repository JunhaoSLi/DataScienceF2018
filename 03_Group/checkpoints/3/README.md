# Questions

The questions we looked into for this checkpoint are:

1. Is there a correlation between race, gender, and length of appointment for officers?

2. Are the groups of officers with the highest allegation rates by beat often of the same rance and gender?

3. How do allegations in beats cluster when connected based on having the same race of officer and race of victim?

# Procedure

Our workflows for answering these questions can be seen in the IPython notebooks within the `notebooks` directory with their names being with their associated question.

All csv's are named after their corresponding table within the CPDB except for `allegation_races.csv`.

`allegation_races.csv` was made using the following steps within Trifacta:
1. Join `data_officer` with  `data_officerallegation` on `id` and `officer_id`, respectively.
2. Join with `data_allegation` on `allegation_id` and `id`.
3. Join with `data_victim` on `allegation_id` and `id`.
4. Compute a custom column for each officer race using the formula `IF(data_officer.race={race}, Y, N)`.
5. Compute a custom column for each victim race using the formula `IF(data_victim.race={race}, Y, N)`.
6. Delete all columns except for `allegation_id`, `beat_id`, and the 10 custom columns.
