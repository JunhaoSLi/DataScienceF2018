# Question 1

Custom SQL Query to convert Point object to latitude and longitude

```sql
SELECT id, ST_X(Point), ST_Y(Point) FROM data_allegation;
```

Tables used: 

```sql
data_allegation INNER JOIN Custom SQL Query LEFT JOIN data_officer
```

# Question 2

Tables used: 

```sql
data_complainant INNER JOIN data_allegation INNER JOIN data_officerallegation
```