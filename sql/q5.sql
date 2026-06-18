/*Which counties saw a net growth in business establishments despite shrinking payrolls/headcounts?*/

create or replace view {DATASET}.q5_base as (
  select
    state,
    county_code,
    county_str,
    year,
    avg(annual_payroll / nullif(num_employees, 0)) as avg_pay,
    sum(num_businesses) as tot_businesses
  from {DATASET}.cbp_county
  where num_employees > 0
  group by state, county_code, county_str, year
);

create or replace view {DATASET}.q5 as (
  select
    state,
    county_code,
    county_str,
    year,
    avg_pay,
    tot_businesses,
    lag(avg_pay, 1)        over (partition by county_code, state order by year) as prev_avg_pay,
    lag(tot_businesses, 1) over (partition by county_code, state order by year) as prev_tot_businesses
  from {DATASET}.q5_base
);

select
  county_str,
  year,
  tot_businesses,
  round(((avg_pay - prev_avg_pay) / nullif(prev_avg_pay, 0)) * 100, 2) as salary_var,
  round(((tot_businesses - prev_tot_businesses) / nullif(prev_tot_businesses, 0)) * 100, 2) as b_var
from {DATASET}.q5
where prev_avg_pay is not null
  and ((avg_pay - prev_avg_pay) / nullif(prev_avg_pay, 0)) * 100 < 0
  and ((tot_businesses - prev_tot_businesses) / nullif(prev_tot_businesses, 0)) * 100 > 0
  and tot_businesses >= 500
order by b_var desc;