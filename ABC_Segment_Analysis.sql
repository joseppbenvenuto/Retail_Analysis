# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Set Enviroment
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Create Coal database
CREATE DATABASE ABC;

# Use Coal database
USE ABC;

# Drop safe mode
SET SQL_SAFE_UPDATES = 0;

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Instructions
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# For ease of use and accurate calculations, all queries should be executed consecutively. 

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# customer_attributes Data Cleaning & Categorical Univariate EDA
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# View customer_attributes Single-View
SELECT * 
FROM customer_attributes;

# There are 0 null values
SELECT COUNT(*) AS null_count
FROM customer_attributes
WHERE household_id IS NULL OR loyalty IS NULL OR preferred_store_format IS NULL OR lifestyle IS NULL OR gender IS NULL;

# Create replica customer_attributes table to manipulate
DROP TABLE IF EXISTS customer_attributes1;
CREATE TABLE customer_attributes1 AS
SELECT * 
FROM customer_attributes;

# household_id has 0 blank vlaues
SELECT COUNT(*) AS count_blanks
FROM customer_attributes1
WHERE household_id = '';

# loyalty has 0 blank vlaues
SELECT COUNT(*) AS count_blanks
FROM customer_attributes1
WHERE loyalty = '';

# preferred_store_format has 14 blank vlaues
SELECT COUNT(*) AS count_blanks
FROM customer_attributes1
WHERE preferred_store_format = '';

# Convert blanks to N/A values
UPDATE customer_attributes1 
SET preferred_store_format = 'N/A' 
WHERE preferred_store_format = '';

# lifestyle has 149 blank vlaues
SELECT COUNT(*) AS count_blanks
FROM customer_attributes1
WHERE lifestyle = '';

# Convert blanks to N/A values
UPDATE customer_attributes1 
SET lifestyle = 'N/A' 
WHERE lifestyle = '';

# gender has 11 blank vlaues
SELECT COUNT(*) AS count_blanks
FROM customer_attributes1
WHERE gender = '';

# Convert blanks to N/A values
UPDATE customer_attributes1 
SET gender = 'N/A' 
WHERE gender = ' ';

# There are 6000 distinct households
SELECT COUNT(DISTINCT(household_id)) AS count_distinct_houshold_Id
FROM customer_attributes1;

# Double check that there are 6000 distinct households
SELECT DISTINCT(household_id) AS distinct_houshold_Id, COUNT(household_id) AS count_distinct_houshold_id
FROM customer_attributes1
GROUP BY distinct_houshold_id
HAVING count_distinct_houshold_id > 1;

# Set variable to represent distinct housholds 
SET @total_customers = (SELECT COUNT(DISTINCT(household_id)) FROM customer_attributes1);

# There are 4 distinct loyalty types 
SELECT DISTINCT(loyalty) AS distinct_loyalty, 
COUNT(loyalty) AS count_loyalty,
ROUND((COUNT(loyalty)/@total_customers) * 100, 0) AS percent_of_total_customers
FROM customer_attributes1
GROUP BY distinct_loyalty
ORDER BY count_loyalty DESC;
# ABC's customer Loyalty appears to be in good shape with 88% of its business being generated from Occasional and Very Frequent customers.
# Occasional and Very Frequent Shoppers translates to 98% of total visits, 98% of total spend, 98% of the total quantity purchased.

# There are 5 distinct preferred_store_format types
SELECT DISTINCT(preferred_store_format) AS distinct_preferred_store_format, 
COUNT(preferred_store_format) AS count_preferred_store_format,
ROUND((COUNT(preferred_store_format)/@total_customers) * 100, 0) AS percent_of_total_customers
FROM customer_attributes1
GROUP BY distinct_preferred_store_format
ORDER BY count_preferred_store_format DESC;
# 81% of ABC's consumers prefer Large and Very Large stores.
# Large and Very Large Stores translates to 84% of total visits to the retailer, 90% of total spend, 92% of the total quantity purchased. 
# 19% of ABC's customers prefer Mom and Pop, Others, and Small store formats and translates into 16% of total visits to the retailer, 10% of total spend, 
# 8% of total quantity purchased.

# There are 3 distinct customer lifestyle types
# Very Affluent Customers representing 26% of totlal customers
SELECT DISTINCT(lifestyle) AS distinct_lifestyle, 
COUNT(lifestyle) AS count_lifestyle,
ROUND((COUNT(lifestyle)/@total_customers) * 100, 0) AS percent_of_total_customers
FROM customer_attributes1
GROUP BY distinct_lifestyle
ORDER BY count_lifestyle DESC;
# 72% of ABC's customers are Middle Class and Low Affluent customers.
# Middle Class and Low Affluent Customers translates to 74% of total visits to the retailer, 71% of total spend, 72% of the total quantity purchased.
# It appears that Very Affluent customers represent 26% of ABC's customers and translates to 26% of total visits to the retailer, 29% of total spend, 
# 27% of the total quantity purchased.

# There are 3 distinct gender types
SELECT DISTINCT(gender) AS distinct_gender, 
COUNT(gender) AS count_gender,
ROUND((COUNT(gender)/@total_customers) * 100, 0) AS percent_of_total_customers
FROM customer_attributes1
GROUP BY distinct_gender
ORDER BY count_gender DESC;
# The 79% of ABC's are Female customers and translate to 77% of total visits to the retailer, 78% of total spend, 79% of the total quantity purchased.
# Despite being a lesser portion of ABC's customers, Males represent 18% of total customers and are 20% of total visits to the retailer, 
# 19% of total spend, 18% of total quantity purchased.

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# transactions Data Cleaning & Numeric Univariate EDA
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# View transactions Single-View
SELECT * 
FROM transactions;

# There are 0 null values
SELECT COUNT(*) AS null_count
FROM transactions
WHERE household_id IS NULL OR Home_Shopping_Flg IS NULL OR visits IS NULL OR tot_spend IS NULL OR tot_qty IS NULL;

# Create replica transactions table to manipulate
DROP TABLE IF EXISTS transactions1;
CREATE TABLE transactions1 AS
SELECT * 
FROM transactions;

# household_id has 0 blank vlaues
SELECT COUNT(*) AS count_blanks
FROM transactions1
WHERE household_id = '';

# Home_Shopping_Flg has 0 blank vlaues
SELECT COUNT(*) AS count_blanks
FROM transactions1
WHERE Home_Shopping_Flg = '' AND Home_Shopping_Flg != 0;

# visits has 0 blank vlaues
SELECT COUNT(*) AS count_blanks
FROM transactions1
WHERE visits = '' AND visits != 0;

# tot_spend has 0 blank vlaues
SELECT COUNT(*) AS count_blanks
FROM transactions1
WHERE tot_spend = '' AND tot_spend != 0;

# tot_qty has 0 blank vlaues
SELECT COUNT(*) AS count_blanks
FROM transactions1
WHERE tot_qty = '' AND tot_qty != 0;

# There are 5586 distinct households
SELECT COUNT(DISTINCT(household_id)) AS count_distinct_houshold_id
FROM transactions1;

# Duplicate household_id
SELECT DISTINCT(household_id) AS distinct_houshold_id, COUNT(household_id) AS count_distinct_houshold_id
FROM transactions1
GROUP BY distinct_houshold_id
HAVING count_distinct_houshold_id > 1;
# Duplicates represents multi-channel consumers.

# Set variable to represent distinct housholds 
SET @total_customers = (SELECT COUNT(DISTINCT(household_id)) AS count_distinct_houshold_id FROM transactions1);

# There are 2 distinct home_shopping_flg types
SELECT DISTINCT(Home_Shopping_Flg) AS distinct_home_shopping_flg, 
COUNT(Home_Shopping_Flg) AS count_home_shopping_flg,
ROUND((COUNT(Home_Shopping_Flg)/@total_customers) * 100, 0) AS percent_of_total_customers
FROM transactions1
GROUP BY distinct_home_shopping_flg
ORDER BY count_home_shopping_flg;
# 8% of shoopers shop online
# 99% of shoppers shop instore
# There is an overlap of shoppers shopping both onlin eand instore

# Descriptive stats for visits
CALL spStats('transactions1','visits');
# Descriptive stats for tot_spend
CALL spStats('transactions1','tot_spend');
# Descriptive stats for tot_qty
CALL spStats('transactions1','tot_qty');

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Joining Tables Cleaning & Bivariate EDA Totals 
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Create table to manipulate
DROP TABLE IF EXISTS home_shopping;
CREATE TABLE home_shopping AS
SELECT household_id, SUM(Home_Shopping_Flg) AS home_channel_flags
FROM transactions1
GROUP BY household_id;

# Create table to manipulate
DROP TABLE IF EXISTS multi_channel;
CREATE TABLE multi_channel AS
SELECT household_id, COUNT(household_id) AS count_household_id
FROM transactions1
GROUP BY household_id;

# Create table to find at home only, instore only, and multi-channel customers
DROP TABLE IF EXISTS channel_segments;
CREATE TABLE channel_segments AS
SELECT multi.household_id, 
IF((multi.count_household_id + home.home_channel_flags) = 1, 'Instore', IF((multi.count_household_id + home.home_channel_flags) = 2, 'Online', 'Multi-Channel')) AS channels
FROM multi_channel AS multi JOIN home_shopping AS home
ON multi.household_id = home.household_id;

# Drop tables
DROP TABLE IF EXISTS home_shopping;
DROP TABLE IF EXISTS multi_channel;

# Join customer_attributes, transactions1, and channel segments table to create a comprehensive single-view with no duplicates
DROP TABLE IF EXISTS singleview;
CREATE TABLE singleview AS
SELECT cus.household_id, cus.loyalty, cus.preferred_store_format, cus.lifestyle, cus.gender, IFNULL(ch.channels, 'No Visit') AS channel, 
ROUND(IFNULL(SUM(trans.visits),0),0) AS visits, ROUND(IFNULL(SUM(trans.tot_spend),0),2) AS tot_spend, ROUND(IFNULL(SUM(trans.tot_qty),0),0) AS tot_qty 
FROM customer_attributes1 AS cus LEFT JOIN transactions1 AS trans
ON cus.household_id = trans.household_id
LEFT JOIN channel_segments AS ch
ON trans.household_id = ch.household_id
GROUP BY cus.household_id, cus.loyalty, cus.preferred_store_format, cus.lifestyle, cus.gender, channel;

# Create table with rank values for visits and tot_spend
DROP TABLE IF EXISTS singleview1;
CREATE TABLE singleview1 AS
SELECT household_id, loyalty, preferred_store_format, lifestyle, gender, channel,
visits, IF(CEILING(ROUND(PERCENT_RANK() OVER (ORDER BY visits),3) * 10) <= 1, 1, CEILING(ROUND(PERCENT_RANK() OVER (ORDER BY  visits),3) * 10)) AS ranking_visits, 
tot_spend, IF(CEILING(ROUND(PERCENT_RANK() OVER (ORDER BY tot_spend),3) * 10) <= 1, 1, CEILING(ROUND(PERCENT_RANK() OVER (ORDER BY  tot_spend),3) * 10)) AS ranking_tot_spend,
tot_qty
FROM singleview
ORDER BY  household_id;

# Create a comprehensive rank value per household to determine high, medium, and low value customers
DROP TABLE IF EXISTS singleview2;
CREATE TABLE singleview2 AS
SELECT household_id, loyalty, preferred_store_format, lifestyle, gender, channel, visits, tot_spend, tot_qty,
IF(CEILING(ROUND(PERCENT_RANK() OVER (ORDER BY (ranking_visits + ranking_tot_spend)),3) * 3) <= 1, 1, 
	CEILING(ROUND(PERCENT_RANK() OVER (ORDER BY  (ranking_visits + ranking_tot_spend)),3) * 3)) AS value_rank_score,
IF(IF(CEILING(ROUND(PERCENT_RANK() OVER (ORDER BY (ranking_visits + ranking_tot_spend)),3) * 3) <= 1, 1, 
	CEILING(ROUND(PERCENT_RANK() OVER (ORDER BY  (ranking_visits + ranking_tot_spend)),3) * 3)) = 1, 'Low', 
    IF(IF(CEILING(ROUND(PERCENT_RANK() OVER (ORDER BY (ranking_visits + ranking_tot_spend)),3) * 3) <= 1, 1, 
	CEILING(ROUND(PERCENT_RANK() OVER (ORDER BY  (ranking_visits + ranking_tot_spend)),3) * 3)) = 2, 'Medium', 'High')) AS value
FROM singleview1;

# Drop tables
DROP TABLE IF EXISTS customer_attributes1;
DROP TABLE IF EXISTS transactions1;
DROP TABLE IF EXISTS channel_segments;
DROP TABLE IF EXISTS singleview;
DROP TABLE IF EXISTS singleview1;

# Total spending customers - 5584
SELECT COUNT(household_id) AS total_spending_customers 
FROM singleview2
WHERE tot_spend > 0;

# Total non-spending customers - 416
SELECT COUNT(household_id) AS total_non_spending_customers 
FROM singleview2
WHERE tot_spend = 0;

# Total visiting customers - 5586
SELECT COUNT(household_id) AS total_visiting_customers 
FROM singleview2
WHERE channel != 'No Visit';

# Total non-visiting customers - 414
SELECT COUNT(household_id) AS total_non_visiting_customers 
FROM singleview2
WHERE channel = 'No Visit';

# Descriptive stats for visits
CALL spStats('singleview2','visits');
# Descriptive stats for tot_spend
CALL spStats('singleview2','tot_spend');
# Descriptive stats for tot_qty
CALL spStats('singleview2','tot_qty');

# There are 6000 distinct households
SELECT COUNT(DISTINCT(household_id)) AS count_distinct_houshold_Id
FROM singleview2;

# Double check that there are 6000 distinct households
SELECT DISTINCT(household_id) AS distinct_houshold_Id, COUNT(household_id) AS count_distinct_houshold_Id
FROM singleview2
GROUP BY distinct_houshold_Id
HAVING count_distinct_houshold_Id > 1;

# Set variables to store total values for rate calculations
SET @total_customers = (SELECT COUNT(DISTINCT(household_id)) FROM singleview2);
SET @total_visits = (SELECT SUM(visits) FROM singleview2);
SET @total_tot_spend = (SELECT SUM(tot_spend) FROM singleview2);
SET @total_tot_qty = (SELECT SUM(tot_qty) FROM singleview2);

# loyalty type totals and rates
SELECT DISTINCT(loyalty) AS distinct_loyalty,
COUNT(loyalty) AS count_loyalty, 
ROUND((COUNT(loyalty)/@total_customers) * 100, 0) AS percent_of_total_customers,
ROUND(SUM(visits),0) AS sum_visits,  ROUND((SUM(visits)/@total_visits) * 100, 0) AS percent_of_total_visits,
ROUND(SUM(tot_spend),0) AS sum_tot_spend,  ROUND((SUM(tot_spend)/@total_tot_spend) * 100, 0) AS percent_of_tot_spend, 
ROUND(SUM(tot_qty),0) AS sum_tot_qty, ROUND((SUM(tot_qty)/@total_tot_qty) * 100, 0) AS percent_of_tot_qty
FROM singleview2
GROUP BY distinct_loyalty
ORDER BY count_loyalty DESC;
# ABC's customer Loyalty appears to be in good shape with 88% of its business being generated from Occasional and Very Frequent customers.
# Occasional and Very Frequent Shoppers translates to 98% of total visits, 98% of total spend, 98% of the total quantity purchased.

# preferred_store_format type totals and rates
SELECT DISTINCT(preferred_store_format) AS distinct_preferred_store_format,
COUNT(preferred_store_format) AS count_preferred_store_format, 
ROUND((COUNT(preferred_store_format)/@total_customers) * 100, 0) AS percent_of_total_customers,
ROUND(SUM(visits),0) AS sum_visits,  ROUND((SUM(visits)/@total_visits) * 100, 0) AS percent_of_total_visits,
ROUND(SUM(tot_spend),0) AS sum_tot_spend,  ROUND((SUM(tot_spend)/@total_tot_spend) * 100, 0) AS percent_of_tot_spend, 
ROUND(SUM(tot_qty),0) AS sum_tot_qty, ROUND((SUM(tot_qty)/@total_tot_qty) * 100, 0) AS percent_of_tot_qty
FROM singleview2
GROUP BY distinct_preferred_store_format
ORDER BY count_preferred_store_format DESC;
# 81% of ABC's customers prefer Large and Very Large stores.
# Large and Very Large Stores translates to 84% of total visits to the retailer, 90% of total spend, 92% of the total quantity purchased. 
# 19% of ABC's customers prefer Mom and Pop, Others, and Small store formats and translates into 16% of total visits to the retailer, 10% of total spend, 8% of total quantity purchased.

# lifestyle type totals and rates
SELECT DISTINCT(lifestyle) AS distinct_lifestyle,
COUNT(lifestyle) AS count_lifestyle, 
ROUND((COUNT(lifestyle)/@total_customers) * 100, 0) AS percent_of_total_customers,
ROUND(SUM(visits),0) AS sum_visits,  ROUND((SUM(visits)/@total_visits) * 100, 0) AS percent_of_total_visits,
ROUND(SUM(tot_spend),0) AS sum_tot_spend,  ROUND((SUM(tot_spend)/@total_tot_spend) * 100, 0) AS percent_of_tot_spend, 
ROUND(SUM(tot_qty),0) AS sum_tot_qty, ROUND((SUM(tot_qty)/@total_tot_qty) * 100, 0) AS percent_of_tot_qty
FROM singleview2
GROUP BY distinct_lifestyle
ORDER BY count_lifestyle DESC;
# 72% of ABC's customers are Middle Class and Low Affluent customers.
# Middle Class and Low Affluent Customers translates to 74% of total visits to the retailer, 71% of total spend, 72% of the total quantity purchased.
# It appears that Very Affluent customers represent 26% of ABC's customers and translates to 26% of total visits to the retailer, 29% of total spend, 27% of the total quantity purchased.

# gender type totals and rates
SELECT DISTINCT(gender) AS distinct_gender,
COUNT(gender) AS count_gender, 
ROUND((COUNT(gender)/@total_customers) * 100, 0) AS percent_of_total_customers,
ROUND(SUM(visits),0) AS sum_visits,  ROUND((SUM(visits)/@total_visits) * 100, 0) AS percent_of_total_visits,
ROUND(SUM(tot_spend),0) AS sum_tot_spend,  ROUND((SUM(tot_spend)/@total_tot_spend) * 100, 0) AS percent_of_tot_spend, 
ROUND(SUM(tot_qty),0) AS sum_tot_qty, ROUND((SUM(tot_qty)/@total_tot_qty) * 100, 0) AS percent_of_tot_qty
FROM singleview2
GROUP BY distinct_gender
ORDER BY count_gender DESC;
# The 79% of ABC's are Female customers and translate to 77% of total visits to the retailer, 78% of total spend, 79% of the total quantity purchased.
# Despite being a lesser portion of ABC's customers, Males represent 18% of total customers and are 20% of total visits to the retailer, 19% of total spend, 18% of total quantity purchased.

# channel type totals and rates
SELECT DISTINCT(channel) AS distinct_channel,
COUNT(channel) AS count_channel, 
ROUND((COUNT(channel)/@total_customers) * 100, 0) AS percent_of_total_customers,
ROUND(SUM(visits),0) AS sum_visits,  ROUND((SUM(visits)/@total_visits) * 100, 0) AS percent_of_total_visits,
ROUND(SUM(tot_spend),0) AS sum_tot_spend,  ROUND((SUM(tot_spend)/@total_tot_spend) * 100, 0) AS percent_of_tot_spend, 
ROUND(SUM(tot_qty),0) AS sum_tot_qty, ROUND((SUM(tot_qty)/@total_tot_qty) * 100, 0) AS percent_of_tot_qty
FROM singleview2
GROUP BY distinct_channel
ORDER BY count_channel DESC;
# 86% of ABC's customers shop instore and translate to 90% of total visits to the retailer, 86% of total spend, 86% of the total quantity purchased.
# 7% of ABC's customers shop through Multi-Channel and translate to 10% of total visits to the retailer, 13% of total spend, 13% of the total quantity purchased
# Customers who don't visit represent 7% of ABC's customer base. Why Do they not visit?
# Less than 1% of ABC's customers shop Online and 0% for all other metrics.

# value type totals and rates
SELECT DISTINCT(value) AS distinct_value,
COUNT(value) AS count_value, 
ROUND((COUNT(value)/@total_customers) * 100, 0) AS percent_of_total_customers,
ROUND(SUM(visits),0) AS sum_visits,  ROUND((SUM(visits)/@total_visits) * 100, 0) AS percent_of_total_visits,
ROUND(SUM(tot_spend),0) AS sum_tot_spend,  ROUND((SUM(tot_spend)/@total_tot_spend) * 100, 0) AS percent_of_tot_spend, 
ROUND(SUM(tot_qty),0) AS sum_tot_qty, ROUND((SUM(tot_qty)/@total_tot_qty) * 100, 0) AS percent_of_tot_qty
FROM singleview2
GROUP BY distinct_value
ORDER BY count_value DESC;
# ABC's customer base consists of High-Value customers being 32% total customers even with Medium and lagging behind Low-value customers that represent 32% and 37%, 
# however, High-Value customers represent 67% of total visits, 70% of total spend, 69% of total qty. Can we find deeper value in these customers?

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# EDA Biivariate Averages  
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# loyalty type metric averages and rates
SELECT loyalty, ROUND(AVG(visits),0) AS avg_visits, ROUND(AVG(tot_spend),0) AS avg_tot_spend, ROUND(AVG(tot_qty),0) AS avg_tot_qty, 
ROUND((AVG(tot_spend)/AVG(tot_qty)),0) AS avg_spend_per_qty, ROUND((AVG(tot_spend)/AVG(visits)),0) AS avg_basket_size
FROM singleview2
GROUP BY loyalty;
# It appears that loyal shoppers, Occasional and Very Frequent Shoppers, spend the least per item in comparison to lesser loyal shoppers. 
# Very frequent shoppers have the largest basket size, purchasing a greater number of items with the lesser loyal shoppers trailing, however, Occasional Shoppers have a basket size 77% 
# less than Very Frequent Shoppers and trail all types shoppers.
#
# Lapsing and No Longer Shopping shoppers spend 29% more than Occasional and Very Frequent Shoppers per item.
# We can see a pattern between Very Frequent and Occasional Shoppers, where Occasional Shoppers spend and visit less, however, perhaps the higher prices Lapsing and No Longer Shopping 
# shoppers spend maybe what deteriorates their loyalty to ABC.

# preferred_store_format type metric averages and rates
SELECT preferred_store_format, ROUND(AVG(visits),0) AS avg_visits, ROUND(AVG(tot_spend),0) AS avg_tot_spend, ROUND(AVG(tot_qty),0) AS avg_tot_qty, 
ROUND((AVG(tot_spend)/AVG(tot_qty)),0) AS avg_spend_per_qty, ROUND((AVG(tot_spend)/AVG(visits)),0) AS avg_basket_size
FROM singleview2
GROUP BY preferred_store_format;
# Intuitively, Very Large and Large Stores have the most visits and larger basket sizes with a shopper's spending less per item, however, Large stores show stronger numbers than Very Large Stores.
# Large stores have 2% more visits, 5% greater total spend, 13% more quantity sold, 16% greater spend per item, and 2% greater basket sizes.
# Despite Large Stores having a 16% larger spend per item than Very Large Stores, we see Large stores doing well in every metric and represent 47% of ABC's total customer base, 
# 13% larger than Very large Stores.
#
# The remaining store formats are small and fluctuate metrics.

# lifestyle type metric averages and rates
SELECT lifestyle, ROUND(AVG(visits),0) AS avg_visits, ROUND(AVG(tot_spend),0) AS avg_tot_spend, ROUND(AVG(tot_qty),0) AS avg_tot_qty, 
ROUND((AVG(tot_spend)/AVG(tot_qty)),0) AS avg_spend_per_qty, ROUND((AVG(tot_spend)/AVG(visits)),0) AS avg_basket_size
FROM singleview2
GROUP BY lifestyle;
# Despite Very Affluent Customers visiting 9% less than Middle-Class customers, Very Affluent Customers have a total spend 8% greater, 1% more quantity sold, 6% more spend per item, 
# and have a 17% larger basket size.
#
# Low Affluent customers trail both Very Affluent and Middle-Class customers, however, not by massive margins. Low Affluent Customers visit the same amount as Very Affluent Customers, 
# have a total spend 24% greater, 9% less quantity sold, 14% less spend per item, and have a 13% lesser basket size.

# gender type metric averages and rates
SELECT gender, ROUND(AVG(visits),0) AS avg_visits, ROUND(AVG(tot_spend),0) AS avg_tot_spend, ROUND(AVG(tot_qty),0) AS avg_tot_qty, 
ROUND((AVG(tot_spend)/AVG(tot_qty)),0) AS avg_spend_per_qty, ROUND((AVG(tot_spend)/AVG(visits)),0) AS avg_basket_size
FROM singleview2
GROUP BY gender;
# Despite females being ABC's largest customer base, X has 17% more visits, 12% more total spend, and purchased 6% more items than females.
# Taking the above into consideration, females spend 6% less per item in comparison to the highest spending which has been done by males. Females also have the largest basket size by roughly 3%.
#
# Despite the fluctuation, all genders present tremendous opportunities in terms of the metrics mentioned.

# channel type metric averages and rates
SELECT channel, ROUND(AVG(visits),0) AS avg_visits, ROUND(AVG(tot_spend),0) AS avg_tot_spend, ROUND(AVG(tot_qty),0) AS avg_tot_qty, 
IFNULL(ROUND((AVG(tot_spend)/AVG(tot_qty)),0),0) AS avg_spend_per_qty, IFNULL(ROUND((AVG(tot_spend)/AVG(visits)),0),0) AS avg_basket_size
FROM singleview2
GROUP BY channel;
# Multi-Channel appears to have the strongest numbers out of all the channels in four out of the five metrics. Multi-Channel is followed by Instore. 
# Multi-Channel customers visit 35% more, have a total spend 94% greater, have 93% more quantity sold, and is even for spend per item with the Instore channel. 
#
# However, when observing Online, we see that that the basket size is 72% greater than Multi-Channel basket sizes.

# value type metric averages and rates
SELECT value, ROUND(AVG(visits),0) AS avg_visits, ROUND(AVG(tot_spend),0) AS avg_tot_spend, ROUND(AVG(tot_qty),0) AS avg_tot_qty, 
ROUND((AVG(tot_spend)/AVG(tot_qty)),0) AS avg_spend_per_qty, ROUND((AVG(tot_spend)/AVG(visits)),0) AS avg_basket_size
FROM singleview2
GROUP BY value;
# High and Medium value customers represent close to 100% of ABC's customer visits with High-Value representing the majority between the two types of customers. 
# Intuitively, High-Value has the strongest numbers followed by Medium. 
# High-Value customers visit 146% more, have a total spend 184% greater, 164% more quantity sold, spend roughly the same amount per item, and have an 13% greater basket size than 
# Medium-Value customers.

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# EDA Multivariate Metric Averages By Channel Type
# Example: Average Visits Per Instore Lapsing Shopper
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# loyalty averages by channel types 
SELECT channel, loyalty, ROUND(AVG(visits),0) AS avg_visits, ROUND(AVG(tot_spend),0) AS avg_tot_spend, ROUND(AVG(tot_qty),0) AS avg_tot_qty, 
IFNULL(ROUND((AVG(tot_spend)/AVG(tot_qty)),0),0) AS avg_spend_per_qty, IFNULL(ROUND((AVG(tot_spend)/AVG(visits)),0),0) AS avg_basket_size
FROM singleview2
GROUP BY channel, loyalty
ORDER BY channel;
# Multi-Channel has the strongest numbers amongst all loyalty types. Multi-Channel customers seem to be finding good value in terms of the lesser spend per item, however, 
# a small number of customers seem to find better value through Online only. Online has a lower spend per item and a significant increase in basket sizes across all loyalty types.
# Instore seems to have a greater spend per item. 

# preferred_store_format averages by channel types 
SELECT channel, preferred_store_format, ROUND(AVG(visits),0) AS avg_visits, ROUND(AVG(tot_spend),0) AS avg_tot_spend, ROUND(AVG(tot_qty),0) AS avg_tot_qty, 
IFNULL(ROUND((AVG(tot_spend)/AVG(tot_qty)),0),0) AS avg_spend_per_qty, IFNULL(ROUND((AVG(tot_spend)/AVG(visits)),0),0) AS avg_basket_size
FROM singleview2
GROUP BY channel, preferred_store_format
ORDER BY channel;
# Multi-Channel has strong numbers across all metrics while Online retains their significantly larger basket sizes.
# Online also retains a less spend per item while  Instore retains a larger spend per item. 
# Instore is seemingly even with Multi-Channel when comparing their spend per item.
# The pattern for the preferred store format remains unchanged.

# lifestyle averages by channel types 
SELECT channel, lifestyle, ROUND(AVG(visits),0) AS avg_visits, ROUND(AVG(tot_spend),0) AS avg_tot_spend, ROUND(AVG(tot_qty),0) AS avg_tot_qty, 
IFNULL(ROUND((AVG(tot_spend)/AVG(tot_qty)),0),0) AS avg_spend_per_qty, IFNULL(ROUND((AVG(tot_spend)/AVG(visits)),0),0) AS avg_basket_size
FROM singleview2
GROUP BY channel, lifestyle
ORDER BY channel;
# Multi-Channel has strong numbers across all metrics while Online retains their significantly larger basket sizes.
# Online also retains a less spend per item while  Instore retains a larger spend per item. 
# The pattern for lifestyle remains unchanged.

# gender averages by channel types 
SELECT channel, gender, ROUND(AVG(visits),0) AS avg_visits, ROUND(AVG(tot_spend),0) AS avg_tot_spend, ROUND(AVG(tot_qty),0) AS avg_tot_qty, 
IFNULL(ROUND((AVG(tot_spend)/AVG(tot_qty)),0),0) AS avg_spend_per_qty, IFNULL(ROUND((AVG(tot_spend)/AVG(visits)),0),0) AS avg_basket_size
FROM singleview2
GROUP BY channel, gender
ORDER BY channel;
# Multi-Channel has strong numbers across all metrics while Online retains their significantly larger basket sizes.
# Online also retains a less spend per item while  Instore retains a larger spend per item. 
# The pattern for gender remains unchanged outside of males spending more than females per item through the Online format.

# value averages by channel types 
SELECT channel, value, ROUND(AVG(visits),0) AS avg_visits, ROUND(AVG(tot_spend),0) AS avg_tot_spend, ROUND(AVG(tot_qty),0) AS avg_tot_qty, 
IFNULL(ROUND((AVG(tot_spend)/AVG(tot_qty)),0),0) AS avg_spend_per_qty, IFNULL(ROUND((AVG(tot_spend)/AVG(visits)),0),0) AS avg_basket_size
FROM singleview2
GROUP BY channel, value
ORDER BY channel;
# For High-Value customer visits, Instore customers visit 3% more than the next highest visiting customer type (Multi-Channel). 
# Multi-channel's High-Value customers have and average total spend 7% more than the next highest being Online's High-Value customers.
# Online's High-Value customers appear to have a 12% greater quantity sold, roughly even per item, and 147% greater basket size than Multi-Channel.

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# EDA Bivariate Percentages of Channel Type By given metric. 
# Example: Number of Total Instore Lapsing Customers Over Toal Instore Customers
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Create a temp table to calculate channel by loyalty counts
DROP TABLE IF EXISTS temp1;
CREATE TABLE temp1 AS
SELECT channel, loyalty, ROUND(COUNT(*),0) AS count
FROM singleview2
GROUP BY loyalty, channel
ORDER BY channel;

# Create a temp table to calculate total channel counts 
DROP TABLE IF EXISTS temp2;
CREATE TABLE temp2 AS
SELECT channel, ROUND(COUNT(*),0) AS total_count
FROM singleview2
GROUP BY channel
ORDER BY channel;

# Join temp tables to calculate percentages of channel type by loyalty
SELECT t1.*, t2.total_count, ROUND((t1.count/total_count) * 100, 0) AS loyalty_percent_of_channel 
FROM temp1 AS t1 JOIN temp2 AS t2
ON t1.channel = t2.channel
ORDER BY channel, loyalty_percent_of_channel;
# Multi-Channel has a more loyal customer base when comparing to Instore and Online customers.

# Create a temp table to calculate channel by preferred_store_format counts
DROP TABLE IF EXISTS temp1;
CREATE TABLE temp1 AS
SELECT channel, preferred_store_format, ROUND(COUNT(*),0) AS count
FROM singleview2
GROUP BY preferred_store_format, channel
ORDER BY channel;

# Join temp tables to calculate percentages of channel type by preferred_store_format
SELECT t1.*, t2.total_count, ROUND((t1.count/total_count) * 100, 0) AS preferred_store_format_percent_of_channel 
FROM temp1 AS t1 JOIN temp2 AS t2
ON t1.channel = t2.channel
ORDER BY channel, preferred_store_format_percent_of_channel;
# The majority of the channels do the bulk of business at Large and Very large Stores.

# Create a temp table to calculate channel by lifestyle counts
DROP TABLE IF EXISTS temp1;
CREATE TABLE temp1 AS
SELECT channel, lifestyle, ROUND(COUNT(*),0) AS count
FROM singleview2
GROUP BY lifestyle, channel
ORDER BY channel;

# Join temp tables to calculate percentages of channel type by lifestyle
SELECT t1.*, t2.total_count, ROUND((t1.count/total_count) * 100, 0) AS lifestyle_percent_of_channel 
FROM temp1 AS t1 JOIN temp2 AS t2
ON t1.channel = t2.channel
ORDER BY channel, lifestyle_percent_of_channel;
# Multi-Channel has a strong mix between the different customer lifestyles; stronger than Instore, however, Online has a strong Middle-Class customer base.

# Create a temp table to calculate channel by gender counts
DROP TABLE IF EXISTS temp1;
CREATE TABLE temp1 AS
SELECT channel, gender, ROUND(COUNT(*),0) AS count
FROM singleview2
GROUP BY gender, channel
ORDER BY channel;

# Join temp tables to calculate percentages of channel type by gender
SELECT t1.*, t2.total_count, ROUND((t1.count/total_count) * 100, 0) AS gender_percent_of_channel 
FROM temp1 AS t1 JOIN temp2 AS t2
ON t1.channel = t2.channel
ORDER BY channel, gender_percent_of_channel;
# The genders between channels are very similar with a little variation.

# Create a temp table to calculate channel by value counts
DROP TABLE IF EXISTS temp1;
CREATE TABLE temp1 AS
SELECT channel, value, ROUND(COUNT(*),0) AS count
FROM singleview2
GROUP BY value, channel
ORDER BY channel;

# Join temp tables to calculate percentages of channel type by value
SELECT t1.*, t2.total_count, ROUND((t1.count/total_count) * 100, 0) AS value_percent_of_channel 
FROM temp1 AS t1 JOIN temp2 AS t2
ON t1.channel = t2.channel
ORDER BY channel, value_percent_of_channel;
# Multi-Channel has a strong customer mix of 58% High-Value, 9% Low-Value, and 33% Medium-Value customers, even stronger than Instore. 
# Online displays a very low High-Value base of 7%, a High Low-Value base of 69%, and a moderate Medium-Value base of 24%.

# Drop tables
DROP TABLE IF EXISTS temp1;
DROP TABLE IF EXISTS temp2;
DROP TABLE IF EXISTS singleview2;

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Summary 
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ABC's Online format shows strength in basket sizes. When observing the Online format we see an average of $79 per basket, that's 72% larger than the next highest belonging 
# to Multi-Channel with $44 per basket. 
#
# Online has some drawbacks with a total of only 29 shoppers, 69% are Low-Value, and only 7% are High-Value. 
#
# Despite the Online format having few High-Value customers, the High-Value customers appear to have a 12% greater quantity sold, a roughly even spend per item, and 147% greater basket size 
# than Multi-Channel's.
#
# Multi-Channel shows strength with consistency in value metrics. The average values are not the hgihest but not the lowest. 
# Multi-Channel has many High-Value, Very Affluent, and Loyal customers. 
#
# Blending the Online and Instore formats create a Multi-Channel format that seems to generate value for both the customers and the business. Customers here spend, visit, and purchase 
# more items consistently in comparison to the other channels. 
# 
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Recommendations 
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1. Invite Instore only customers to the Online format. This can be done using various promotions at test locations.
# 2. Invite Online only customers to the Instore format. This can be done using various promotions at test locations.
#
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Further Questions 
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1. Does the Online plotform have a cheaper business model with a larger return on investment? Is this why customers pay less and purchase more on a quantity and basket size basis?
# 2. Does the Online plotform sell specific items only? What are they if true?
# 3. Can we create a sticky environment for consumers by moving consumers to a Multi-Channel format but at the same time maintain the high number or increase the Online only shopping in 
#    pursuit of the higher margins? 

