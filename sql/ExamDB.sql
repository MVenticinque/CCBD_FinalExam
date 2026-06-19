-- Query 1

select 
	county_str, 
	year, 
	sector_label, 
	num_employees,
	num_businesses,
    avg_pay_st,
    avg_pay_ct, 
	pay_ratio
from cbp_dataset.ratio_df 
where num_employees >= 100 
and sector_code != '00'
order by pay_ratio desc 
limit 100;


-- Query 2

select sector_label, p_change from cbp_dataset.q2
where prev_avg_pay is not null  
  and year = 2020
  and p_change < 0
order by p_change, year 
;

-- Query 3

select
  year,
  bsize,
  bsize_code,
  avg_salary,
  round((avg_salary / base_2017) * 100, 2) as idx
from cbp_dataset.q3
order by bsize_code, year;

-- Query 4

select
  sector_code,
  sector_label,
  year,
  corporate,
  sole,
  gov_np,
  total_b,
  round(corporate / nullif(total_b, 0) * 100, 2) as corp_share,
  round(sole     / nullif(total_b, 0) * 100, 2) as sole_share,
  round(gov_np   / nullif(total_b, 0) * 100, 2) as gov_np_share
from cbp_dataset.q4
where year = 2023
order by sole_share desc;

select
  sector_code,
  sector_label,
  year,
  corporate,
  sole,
  gov_np,
  total_emp,
  round(corporate / nullif(total_emp, 0) * 100, 2) as corp_share,
  round(sole     / nullif(total_emp, 0) * 100, 2) as sole_share,
  round(gov_np   / nullif(total_emp, 0) * 100, 2) as gov_np_share
from cbp_dataset.q4_2
where year = 2023
order by sole_share desc;


-- Query 5

select
  county_str,
  year,
  tot_businesses,
  round(((avg_pay - prev_avg_pay) / nullif(prev_avg_pay, 0)) * 100, 2) as salary_var,
  round(((tot_businesses - prev_tot_businesses) / nullif(prev_tot_businesses, 0)) * 100, 2) as b_var
from cbp_dataset.q5
where prev_avg_pay is not null
  and ((avg_pay - prev_avg_pay) / nullif(prev_avg_pay, 0)) * 100 < 0
  and ((tot_businesses - prev_tot_businesses) / nullif(prev_tot_businesses, 0)) * 100 > 0
  and tot_businesses >= 500
order by b_var desc;


