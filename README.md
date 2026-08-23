
# Stolen/Missing Vehicle Reporting — SQL Capstone

A SQL capstone project completed as part of my Data Analytics training at [AltSchool Africa](https://altschoolafrica.com/). AltSchool provided a relational database of individuals, cars, and reports, along with a set of business questions and the expected answers. My task was to write the SQL queries needed to arrive at those answers.

## About the database

The database (`crime_reports.sqlite`) models a vehicle reporting system, with the following core tables:

- **individuals** — people registered in the system (owners, reporters)
- **cars** — vehicles linked to their registered owner
- **reports** — status reports filed against cars (e.g. stolen, recovered), including where they were last seen and how far from the owner
- **locations** — named locations referenced by individuals, investigators, and reports
- **investigators** — officers assigned to reports, each tied to a jurisdiction

## Questions answered

1. Top 10 individuals by number of registered vehicles
2. Individuals ranked by cars owned (full breakdown)
3. Most recent status report for each car, with owner and vehicle details
4. Count of reports by status
5. Investigators ranked by number of assigned reports, with jurisdiction
6. Latest report per car (id, status, date)
7. Average distance from owner and report count, grouped by status
8. Individuals with the most reports filed on their vehicles
9. Report counts by last-seen location and plate
10. Most recent report per investigator, with jurisdiction

## SQL concepts used

- Joins across multiple related tables
- Aggregation (`COUNT`, `AVG`) with `GROUP BY`
- Window functions (`ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)`) to find the latest record per group
- Common Table Expressions (CTEs) for readability and reuse
- Sorting and filtering with `ORDER BY`, `LIMIT`, and `WHERE`

## How to run

1. Clone this repo
2. Open `crime_reports.sqlite` in any SQLite client (DB Browser for SQLite, TablePlus, VS Code SQLite extension, etc.)
3. Run the queries in the `/queries` folder against the database
4. Compare results against the `question_*` tables included in the database, which hold the expected answers provided by AltSchool

## Notes

This was a practice exercise using a pre-built database and known target answers, the goal was to build confidence writing correct, readable SQL to solve realistic reporting questions, not to design the schema or data from scratch.
