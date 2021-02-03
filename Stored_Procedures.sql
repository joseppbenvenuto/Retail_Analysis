# Stats
DROP PROCEDURE IF EXISTS spStats;
DELIMITER $$
CREATE PROCEDURE spStats(IN p_table VARCHAR(25), IN p_col VARCHAR(25))
BEGIN

	# ------------------------------------------------------------------------------------------------------------------------------------
	# MIN
    # ------------------------------------------------------------------------------------------------------------------------------------
    SET @query1 = CONCAT('DROP TABLE IF EXISTS min;'); 
    
    PREPARE stmt1 FROM @query1;
	EXECUTE stmt1;
	DEALLOCATE PREPARE stmt1;
    
	SET @query2 = CONCAT('CREATE TABLE min AS SELECT ROUND(MIN(`',p_col,'`),0) AS ',p_col,'_min
	 FROM `',p_table,'`;');

    PREPARE stmt2 FROM @query2;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
    
    # Add a primary key
	SET @query3 = CONCAT('ALTER TABLE min ADD COLUMN Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;');
    
    PREPARE stmt3 FROM @query3;
    EXECUTE stmt3;
    DEALLOCATE PREPARE stmt3;
   
    # ------------------------------------------------------------------------------------------------------------------------------------
	# 25th percentile
    # ------------------------------------------------------------------------------------------------------------------------------------
    SET @query4 = CONCAT('DROP TABLE IF EXISTS temp;'); 
    
    PREPARE stmt4 FROM @query4;
	EXECUTE stmt4;
	DEALLOCATE PREPARE stmt4;
    
	SET @query5 = CONCAT('CREATE TABLE temp AS SELECT `',p_col,'` , ROUND(((PERCENT_RANK() OVER (ORDER BY `',p_col,'`)) * 100), 0) AS ranking 
    FROM ',p_table,';');
	
	PREPARE stmt5 FROM @query5;
    EXECUTE stmt5;
    DEALLOCATE PREPARE stmt5;
    
	SET @query6 = CONCAT('DROP TABLE IF EXISTS 25_percentile;'); 
    
    PREPARE stmt6 FROM @query6;
	EXECUTE stmt6;
	DEALLOCATE PREPARE stmt6;
    
    SET @query7 = CONCAT('CREATE TABLE 25_percentile AS SELECT ROUND(AVG(`',p_col,'`),0) AS ',p_col,'_25_percentile
    FROM temp 
    WHERE ranking IN (25, 24);');
    
    PREPARE stmt7 FROM @query7;
    EXECUTE stmt7;
    DEALLOCATE PREPARE stmt7;
    
    # Add a primary key
	SET @query8 = CONCAT('ALTER TABLE 25_percentile ADD COLUMN Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;');
    
    PREPARE stmt8 FROM @query8;
    EXECUTE stmt8;
    DEALLOCATE PREPARE stmt8;
    
    # ------------------------------------------------------------------------------------------------------------------------------------
	# MEAN
    # ------------------------------------------------------------------------------------------------------------------------------------
	SET @query9 = CONCAT('DROP TABLE IF EXISTS mean;'); 
    
    PREPARE stmt9 FROM @query9;
	EXECUTE stmt9;
	DEALLOCATE PREPARE stmt9;
    
	SET @query10 = CONCAT('CREATE TABLE mean AS SELECT ROUND(AVG(`',p_col,'`),0) AS ',p_col,'_mean
	 FROM `',p_table,'`;');

    PREPARE stmt10 FROM @query10;
    EXECUTE stmt10;
    DEALLOCATE PREPARE stmt10;
    
	# Add a primary key
	SET @query11 = CONCAT('ALTER TABLE mean ADD COLUMN Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;');
    
    PREPARE stmt11 FROM @query11;
    EXECUTE stmt11;
    DEALLOCATE PREPARE stmt11;
    
    # ------------------------------------------------------------------------------------------------------------------------------------
	# Median
    # ------------------------------------------------------------------------------------------------------------------------------------
	SET @query12 = CONCAT('DROP TABLE IF EXISTS median;'); 
    
    PREPARE stmt12 FROM @query12;
	EXECUTE stmt12;
	DEALLOCATE PREPARE stmt12;
    
    SET @rowindex := -1;
    
    SET @query13 = CONCAT('CREATE TABLE median AS SELECT ROUND(AVG(d. `',p_col,'`),0) AS ',p_col,'_median 
	FROM
	   (SELECT @rowindex:=@rowindex + 1 AS rowindex,'
			   ,p_table,'.`',p_col,'` AS `',p_col,'`
		FROM `',p_table,'`
		ORDER BY `',p_table,'`.`',p_col,'`) AS d
	WHERE
	d.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));');
    
    PREPARE stmt13 FROM @query13;
    EXECUTE stmt13;
    DEALLOCATE PREPARE stmt13;
    
	# Add a primary key
	SET @query14 = CONCAT('ALTER TABLE median ADD COLUMN Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;');
    
    PREPARE stmt14 FROM @query14;
    EXECUTE stmt14;
    DEALLOCATE PREPARE stmt14;
    
    # ------------------------------------------------------------------------------------------------------------------------------------
	# Standard Deviation
    # ------------------------------------------------------------------------------------------------------------------------------------
	SET @query28 = CONCAT('DROP TABLE IF EXISTS std;'); 
    
    PREPARE stmt28 FROM @query28;
	EXECUTE stmt28;
	DEALLOCATE PREPARE stmt28;
    
	SET @query29 = CONCAT('CREATE TABLE std AS SELECT ROUND(STD(`',p_col,'`),0) AS ',p_col,'_std
	 FROM `',p_table,'`;');

    PREPARE stmt29 FROM @query29;
    EXECUTE stmt29;
    DEALLOCATE PREPARE stmt29;
    
	# Add a primary key
	SET @query30 = CONCAT('ALTER TABLE std ADD COLUMN Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;');
    
    PREPARE stmt30 FROM @query30;
    EXECUTE stmt30;
    DEALLOCATE PREPARE stmt30;
    
	# ------------------------------------------------------------------------------------------------------------------------------------
	# Variance
    # ------------------------------------------------------------------------------------------------------------------------------------
	SET @query31 = CONCAT('DROP TABLE IF EXISTS var;'); 
    
    PREPARE stmt31 FROM @query31;
	EXECUTE stmt31;
	DEALLOCATE PREPARE stmt31;
    
	SET @query32 = CONCAT('CREATE TABLE var AS SELECT ROUND(VARIANCE(`',p_col,'`),0) AS ',p_col,'_var
	 FROM `',p_table,'`;');

    PREPARE stmt32 FROM @query32;
    EXECUTE stmt32;
    DEALLOCATE PREPARE stmt32;
    
	# Add a primary key
	SET @query33 = CONCAT('ALTER TABLE var ADD COLUMN Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;');
    
    PREPARE stmt33 FROM @query33;
    EXECUTE stmt33;
    DEALLOCATE PREPARE stmt33;
    
    # ------------------------------------------------------------------------------------------------------------------------------------
	# 75th Percentile
    # ------------------------------------------------------------------------------------------------------------------------------------
	SET @query15 = CONCAT('DROP TABLE IF EXISTS 75_percentile;'); 
    
    PREPARE stmt15 FROM @query15;
	EXECUTE stmt15;
	DEALLOCATE PREPARE stmt15;
    
    SET @query16 = CONCAT('CREATE TABLE 75_percentile AS SELECT ROUND(AVG(`',p_col,'`),0) AS ',p_col,'_75_percentile
    FROM temp 
    WHERE ranking IN (75, 76);');
    
    PREPARE stmt16 FROM @query16;
    EXECUTE stmt16;
    DEALLOCATE PREPARE stmt16;

	SET @query17 = CONCAT('DROP TABLE IF EXISTS temp;');
    
    PREPARE stmt17 FROM @query17;
    EXECUTE stmt17;
    DEALLOCATE PREPARE stmt17;
    
	# Add a primary key
	SET @query18 = CONCAT('ALTER TABLE 75_percentile ADD COLUMN Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;');
    
    PREPARE stmt18 FROM @query18;
    EXECUTE stmt18;
    DEALLOCATE PREPARE stmt18;
    
	# ------------------------------------------------------------------------------------------------------------------------------------
	# MAX
    # ------------------------------------------------------------------------------------------------------------------------------------
	SET @query19 = CONCAT('DROP TABLE IF EXISTS max;'); 
    
    PREPARE stmt19 FROM @query19;
	EXECUTE stmt19;
	DEALLOCATE PREPARE stmt19;
    
	SET @query20 = CONCAT('CREATE TABLE max AS SELECT ROUND(MAX(`',p_col,'`),0) AS ',p_col,'_max
	 FROM `',p_table,'`;');

    PREPARE stmt20 FROM @query20;
    EXECUTE stmt20;
    DEALLOCATE PREPARE stmt20;
    
    # Add a primary key
	SET @query20 = CONCAT('ALTER TABLE max ADD COLUMN Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;');
    
    PREPARE stmt20 FROM @query20;
    EXECUTE stmt20;
    DEALLOCATE PREPARE stmt20;
    
    # ------------------------------------------------------------------------------------------------------------------------------------
	# Join All Tables
    # ------------------------------------------------------------------------------------------------------------------------------------
    SET @query21 = CONCAT('SELECT min.`',p_col,'_min`, q1.`',p_col,'_25_percentile`, mean.`',p_col,'_mean`, med.`',p_col,'_median`, std.`',p_col,'_std`, var.`',p_col,'_var`, 
    q3.`',p_col,'_75_percentile`, max.`',p_col,'_max`
    FROM min AS min JOIN 25_percentile AS q1
	ON min.Id = q1.Id
	JOIN mean AS mean 
	ON q1.Id = mean.Id
	JOIN median AS med
	ON mean.Id = med.Id
	JOIN 75_percentile AS q3
	ON med.Id = q3.Id
	JOIN max as max
	ON q3.Id = max.Id
    JOIN std AS std
    ON max.Id = std.Id
    JOIN var AS var
    ON std.Id = var.Id;');
    
    PREPARE stmt21 FROM @query21;
    EXECUTE stmt21;
    DEALLOCATE PREPARE stmt21;
    
    # ------------------------------------------------------------------------------------------------------------------------------------
	# DROP Remaining Tables
    # ------------------------------------------------------------------------------------------------------------------------------------
    SET @query22 = CONCAT('DROP TABLE IF EXISTS 25_percentile;');
    
    PREPARE stmt22 FROM @query22;
    EXECUTE stmt22;
    DEALLOCATE PREPARE stmt22;
    
    SET @query23 = CONCAT('DROP TABLE IF EXISTS 75_percentile;');
    
    PREPARE stmt23 FROM @query23;
    EXECUTE stmt23;
    DEALLOCATE PREPARE stmt23;
    
    SET @query24 = CONCAT('DROP TABLE IF EXISTS max;');
    
    PREPARE stmt24 FROM @query24;
    EXECUTE stmt24;
    DEALLOCATE PREPARE stmt24;
    
    SET @query25 = CONCAT('DROP TABLE IF EXISTS mean;');
    
    PREPARE stmt25 FROM @query25;
    EXECUTE stmt25;
    DEALLOCATE PREPARE stmt25;
    
    SET @query26 = CONCAT('DROP TABLE IF EXISTS median;');
    
    PREPARE stmt26 FROM @query26;
    EXECUTE stmt26;
    DEALLOCATE PREPARE stmt26;
    
    SET @query27 = CONCAT('DROP TABLE IF EXISTS min;');
    
    PREPARE stmt27 FROM @query27;
    EXECUTE stmt27;
    DEALLOCATE PREPARE stmt27;
    
    SET @query34 = CONCAT('DROP TABLE IF EXISTS std;');
    
    PREPARE stmt34 FROM @query34;
    EXECUTE stmt34;
    DEALLOCATE PREPARE stmt34;
    
	SET @query35 = CONCAT('DROP TABLE IF EXISTS var;');
    
    PREPARE stmt35 FROM @query35;
    EXECUTE stmt35;
    DEALLOCATE PREPARE stmt35;

END
$$ DELIMITER ;

# Pivot table
DROP PROCEDURE IF EXISTS spPivot;
DELIMITER $$
CREATE PROCEDURE spPivot (IN p_db_name VARCHAR(50), IN p_table_name VARCHAR(50), IN p_column_id VARCHAR(50), IN p_column_pivot VARCHAR(50), IN p_column_value VARCHAR(50), IN p_aggregation VARCHAR(20), IN p_out_table_name VARCHAR(60))
BEGIN
DECLARE query0 varchar(5000);
DECLARE query1 varchar(5000);
DECLARE query2 varchar(5000);
DECLARE out_table_name VARCHAR(60);

SET @query0 = CONCAT('DROP TABLE IF EXISTS ', p_db_name,'.p_temp',';');
PREPARE stmt FROM @query0;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @query0 = CONCAT('create table p_temp as select ',p_column_id,', ', p_column_value, ', replace(', p_column_pivot,'," ", "" ) as ', p_column_pivot,' from ',p_db_name,'.',p_table_name,';');
PREPARE stmt FROM @query0;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET p_table_name = 'p_temp';

SET @query1 = CONCAT('''',p_aggregation,'(IF(',p_column_pivot,' = '''''',',p_column_pivot,','''''', ',p_column_value,', NULL)) AS '',',p_column_pivot,',''_'',''',p_column_value,'''',',''',p_aggregation,'''');
SET @sql = NULL;
SET @query2 = CONCAT('SELECT GROUP_CONCAT(DISTINCT CONCAT(',@query1,')) INTO @sql FROM ',p_db_name,'.',p_table_name,';');
PREPARE stmt FROM @query2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @query0 = CONCAT('DROP TABLE IF EXISTS ', p_db_name,'.',p_out_table_name,';');
PREPARE stmt FROM @query0;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = CONCAT('CREATE TABLE ',p_db_name,'.',p_out_table_name,' SELECT ',p_column_id,', ', @sql, ' FROM ',p_db_name,'.',p_table_name,' GROUP BY ',p_column_id);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END$$
DELIMITER ;