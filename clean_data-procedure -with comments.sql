DELIMITER //
CREATE PROCEDURE clean_data()
BEGIN
    -- Drop the 'clean' table if it already exists
    DROP TABLE IF EXISTS clean;
    
    -- Create the 'clean' table with the required columns and data types
    CREATE TABLE clean (
        patno VARCHAR(3),
        gender VARCHAR(1),
        visit varchar(10),
        hr NUMERIC(3,0),
        sbp NUMERIC(3,0),
        dbp NUMERIC(3,0),
        dx VARCHAR(3),
        ae VARCHAR(1)
    );
    
    -- Insert the cleaned and transformed data from 'patient' table into 'clean' table
    INSERT INTO clean
    SELECT
        -- Clean and transform 'patno' column data
        CASE
            WHEN patno LIKE '%XX%' THEN REPLACE(patno, 'XX', '00') -- Replace 'XX' with '00'
            WHEN patno LIKE '%X%' THEN REPLACE(patno, 'X', '0') -- Replace 'X' with '0'
            WHEN patno REGEXP '^[0-9]{3}$' THEN patno -- Keep the value as is if it is a 3-digit number
            ELSE NULL -- Set the value to NULL if it doesn't meet any of the above conditions
        END,
        -- Clean and transform 'gender' column data
        CASE
            WHEN gender IN ('m', 'M','1') THEN 'M' -- Replace 'm', 'M' and '1' with 'M'
            WHEN gender IN ('f', 'F','2') THEN 'F' -- Replace 'f', 'F' and '2' with 'F'
            ELSE NULL -- Set the value to NULL if it doesn't meet any of the above conditions
        END,
        -- Clean and transform 'visit' column data
        CASE
            -- When the visit month is between April, June, September, November and the visit day is between 1 and 30 and the visit year is between 1995 and 2023, keep the value as is
            WHEN SUBSTRING_INDEX(visit, '/', 1) IN(4,6,9,11)
                    AND SUBSTRING_INDEX(SUBSTRING_INDEX(visit, '/', 2), '/', -1) BETWEEN 1 AND 30
                    AND SUBSTRING_INDEX(visit, '/', -1) BETWEEN 1995 AND 2023
                THEN visit
            -- When the visit month is between January, March, May, July, August, October and December and the visit day is between 1 and 31 and the visit year is between 1995 and 2023, keep the value as is
            WHEN SUBSTRING_INDEX(visit, '/', 1) IN(1,3,5,7,8,10,12)
                    AND SUBSTRING_INDEX(SUBSTRING_INDEX(visit, '/', 2), '/', -1) BETWEEN 1 AND 31
                    AND SUBSTRING_INDEX(visit, '/', -1) BETWEEN 1995 AND 2023
                THEN visit
            -- When the visit month is February and the visit day is between 1 and 28 and the visit year is between 1995 and 2023, keep the value as is
            WHEN SUBSTRING_INDEX(visit, '/', 1) IN(2)
                    AND SUBSTRING_INDEX(SUBSTRING_INDEX(visit, '/', 2), '/', -1) BETWEEN 1 AND 28
                    AND SUBSTRING_INDEX(visit, '/', -1) BETWEEN 1995 AND 2023
                THEN visit
			-- Replace the year with 1998 if the year is '98'
			WHEN visit LIKE '%/98' THEN
					CONCAT(SUBSTRING_INDEX(visit, '/', 1), '/',
					SUBSTRING_INDEX(SUBSTRING_INDEX(visit, '/', 2), '/', -1), '/1998')
			-- Swap the day and month if they are within valid ranges, and leave the year untouched
			WHEN SUBSTRING_INDEX(visit, '/', 1) BETWEEN 13 AND 31
                    AND SUBSTRING_INDEX(SUBSTRING_INDEX(visit, '/', 2), '/', -1) BETWEEN 1 AND 12
                    AND SUBSTRING_INDEX(visit, '/', -1) BETWEEN 1995 AND 2023
                THEN CONCAT(
                    SUBSTRING_INDEX(SUBSTRING_INDEX(visit, '/', 2), '/', -1),
                    '/',
                    SUBSTRING_INDEX(visit, '/', 1),
                    '/',
                    SUBSTRING_INDEX(visit, '/', -1))
			ELSE NULL -- Set the value to NULL if it doesn't meet any of the above conditions
        END,
        -- Clean and transform 'hr' column data
        CASE
			 -- Clean up the hr column by nulling out values outside of a valid range
            WHEN hr BETWEEN 40 AND 100 THEN hr
            ELSE NULL -- Set the value to NULL if it doesn't meet any of the above conditions
        END,
        -- Clean and transform 'sbp' column data
        CASE
			 -- Clean up the sbp column by nulling out values outside of a valid range
            WHEN sbp BETWEEN 80 AND 200 THEN sbp
            ELSE NULL -- Set the value to NULL if it doesn't meet any of the above conditions
        END,
        -- Clean and transform 'dbp' column data
        CASE
			 -- Clean up the dbp column by nulling out values outside of a valid range
            WHEN dbp BETWEEN 60 AND 120 THEN dbp
            ELSE NULL -- Set the value to NULL if it doesn't meet any of the above conditions
        END,
        -- Clean and transform 'dx' column data
        CASE
			-- Clean up the dx column by replacing 'X' with '0' and nulling out values not in a valid format of 1-3 digits
            WHEN dx LIKE '%X%' THEN REPLACE(dx, 'X', '0')
            WHEN dx REGEXP '^[0-9]{1,3}$' OR dx IS NULL THEN dx
            ELSE NULL -- Set the value to NULL if it doesn't meet any of the above conditions
        END,
        -- Clean and transform 'ae' column data
        CASE
			-- Clean up the ae column by replacing 'A' with '0', 'B' with '1', and nulling out values not in a valid format of either 0 or 1
        	WHEN ae LIKE '%A%' THEN REPLACE(ae, 'A', '0')
            WHEN ae LIKE '%B%' THEN REPLACE(ae, 'B', '1')
            WHEN ae IN ('0', '1') THEN ae
            ELSE NULL -- Set the value to NULL if it doesn't meet any of the above conditions
        END
    FROM patient;

CREATE TABLE tmp_clean LIKE clean; -- Copy the cleaned data into a temporary table with a unique patno index

ALTER TABLE tmp_clean ADD UNIQUE(patno); -- This will drop any duplicates that exist and ensure that the final cleaned data set has unique patno values

INSERT IGNORE INTO tmp_clean SELECT * FROM clean ORDER BY patno; -- Insert the values 

RENAME TABLE clean TO backup_clean, tmp_clean TO clean; -- Rename the original table to backup_clean, and rename the temporary table to clean. This will effectively replace the original table with the cleaned table

DROP TABLE backup_clean; -- Drop the backup table, which is no longer needed

END //
DELIMITER ;
CALL clean_data(); -- Call the clean_data stored procedure

