DELIMITER //
CREATE PROCEDURE clean_data()
BEGIN
    DROP TABLE IF EXISTS clean;
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
    INSERT INTO clean
    SELECT
        CASE
            WHEN patno LIKE '%XX%' THEN REPLACE(patno, 'XX', '00')
            WHEN patno LIKE '%X%' THEN REPLACE(patno, 'X', '0')
            WHEN patno REGEXP '^[0-9]{3}$' THEN patno
            ELSE NULL
        END,
        CASE
			WHEN gender IN ('m', 'M','1') THEN 'M'
            WHEN gender IN ('f', 'F','2') THEN 'F'
            ELSE NULL
        END,
        CASE
			WHEN SUBSTRING_INDEX(visit, '/', 1) IN(4,6,9,11)
                    AND SUBSTRING_INDEX(SUBSTRING_INDEX(visit, '/', 2), '/', -1) BETWEEN 1 AND 30
                    AND SUBSTRING_INDEX(visit, '/', -1) BETWEEN 1995 AND 2023
				THEN visit
			WHEN SUBSTRING_INDEX(visit, '/', 1) IN(1,3,5,7,8,10,12)
                    AND SUBSTRING_INDEX(SUBSTRING_INDEX(visit, '/', 2), '/', -1) BETWEEN 1 AND 31
                    AND SUBSTRING_INDEX(visit, '/', -1) BETWEEN 1995 AND 2023
				THEN visit
			WHEN SUBSTRING_INDEX(visit, '/', 1) IN(2)
                    AND SUBSTRING_INDEX(SUBSTRING_INDEX(visit, '/', 2), '/', -1) BETWEEN 1 AND 28
                    AND SUBSTRING_INDEX(visit, '/', -1) BETWEEN 1995 AND 2023
				THEN visit
			WHEN visit LIKE '%/98' THEN
					CONCAT(SUBSTRING_INDEX(visit, '/', 1), '/',
					SUBSTRING_INDEX(SUBSTRING_INDEX(visit, '/', 2), '/', -1), '/1998')
			WHEN SUBSTRING_INDEX(visit, '/', 1) BETWEEN 13 AND 31
                    AND SUBSTRING_INDEX(SUBSTRING_INDEX(visit, '/', 2), '/', -1) BETWEEN 1 AND 12
                    AND SUBSTRING_INDEX(visit, '/', -1) BETWEEN 1995 AND 2023
                THEN CONCAT(
                    SUBSTRING_INDEX(SUBSTRING_INDEX(visit, '/', 2), '/', -1),
                    '/',
                    SUBSTRING_INDEX(visit, '/', 1),
                    '/',
                    SUBSTRING_INDEX(visit, '/', -1))
			ELSE NULL
        END,
        CASE
            WHEN hr BETWEEN 40 AND 100 THEN hr
            ELSE NULL
        END,
        CASE
            WHEN sbp BETWEEN 80 AND 200 THEN sbp
            ELSE NULL
        END,
        CASE
            WHEN dbp BETWEEN 60 AND 120 THEN dbp
            ELSE NULL
        END,
        CASE
            WHEN dx LIKE '%X%' THEN REPLACE(dx, 'X', '0')
            WHEN dx REGEXP '^[0-9]{1,3}$' OR dx IS NULL THEN dx
            ELSE NULL
        END,
        CASE
        	WHEN ae LIKE '%A%' THEN REPLACE(ae, 'A', '0')
            WHEN ae LIKE '%B%' THEN REPLACE(ae, 'B', '1')
            WHEN ae IN ('0', '1') THEN ae
            ELSE NULL
        END
    FROM patient;
    
CREATE TABLE tmp_clean LIKE clean;

ALTER TABLE tmp_clean ADD UNIQUE(patno);

INSERT IGNORE INTO tmp_clean SELECT * FROM clean ORDER BY patno;

RENAME TABLE clean TO backup_clean, tmp_clean TO clean;
DROP TABLE backup_clean;

END //
DELIMITER ;
CALL clean_data();