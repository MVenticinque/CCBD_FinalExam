/* Which counties significantly outperform their state sector pay? */

select 
	county_str, 
	year, 
	sector_label, 
	num_employees,
	num_businesses,
    avg_pay_st,
    avg_pay_ct, 
	pay_ratio
from {DATASET}.ratio_df 
where num_employees >= 100 
and sector_code != '00'
order by pay_ratio desc 
limit 100;