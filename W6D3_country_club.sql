
--Produce a list of start times for bookings by members named 'David Farrell'?
SELECT mem.id AS id, mem.surname AS surname, mem.first_name AS first_name, book.start_time AS start_time FROM members mem JOIN bookings book ON (book.member_id = mem.id) WHERE first_name = 'David' AND surname = 'Farrell';


--Produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.
SELECT book.start_time, fac.name FROM bookings book JOIN facilities fac ON (book.facility_id = fac.id) WHERE start_time BETWEEN '2012-09-21 00:00:00' AND '2012-09-21 23:59:59' AND name LIKE 'Tennis%' ORDER BY start_time;

--Produce a list of all members who have used a tennis court? Include in your output the name of the court, and the name of the member formatted as first name, surname. Ensure no duplicate data, and order by the first name.
SELECT DISTINCT mem.id, mem.first_name, mem.surname, fac.name AS facility FROM members mem JOIN bookings book ON (book.member_id = mem.id) JOIN facilities fac ON (book.facility_id = fac.id) WHERE name LIKE 'Tennis%' AND mem.first_name != 'GUEST' ORDER BY mem.first_name, mem.surname;

--Produce a number of how many times Nancy Dare has used the pool table facility?
SELECT mem.first_name, mem.surname, name AS facility, count(mem.id) AS times_visited FROM members mem JOIN bookings book ON (book.member_id = mem.id) JOIN facilities fac ON (book.facility_id = fac.id) WHERE name = 'Pool Table' AND mem.first_name = 'Nancy' AND mem.surname = 'Dare' GROUP BY mem.id, fac.name;


--Produce a list of how many times Nancy Dare has visited each country club facility.
SELECT mem.first_name, mem.surname, name AS facility, count(mem.id) AS times_visited FROM members mem JOIN bookings book ON (book.member_id = mem.id) JOIN facilities fac ON (book.facility_id = fac.id) WHERE mem.first_name = 'Nancy' AND mem.surname = 'Dare' GROUP BY mem.id, fac.name ORDER BY times_visited DESC;


-- Produce a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).
--
-- Hint: SELF JOIN The tables we are joining don't have to be different tables. We can join a table with itself. This is called a self join. In this case we have to use aliases for the table otherwise PostgreSQL will not know which id column of which table instance we mean.

SELECT mem.first_name, mem.surname, remem.recommended_by, remem.id AS recommended FROM members mem JOIN members remem ON (mem.id = remem.id) WHERE mem.recommended_by IS NOT NULL;

SELECT DISTINCT m1.first_name, m1.surname FROM members m1 JOIN members m2 ON (m1.id = m2.recommended_by);

-- Output a list of all members, including the individual who recommended them (if any), without using any JOINs? Ensure that there are no duplicates in the list, and that member is formatted as one column and ordered by member.
--
-- Hint: To concatenate two columns to look like one you can use the ||
-- Example: SELECT DISTINCT ... || ' ' || ... AS ...,
-- Hint: See Subqueries Here and Here

SELECT DISTINCT m1.first_name || ' ' || m1.surname AS member,
    (SELECT m2.first_name || ' ' || m2.surname AS recommender
        FROM members m2
        WHERE m2.id = m1.recommended_by
    ) FROM members m1;
