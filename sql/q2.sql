/*Which sectors saw the biggest drop in avg_pay_ct because of COVID?*/

create or replace view {DATASET}.q2_base as (
  select
    sector_code,
    sector_label,
    year,
    avg(avg_pay_ct) as avg_pay
  from {DATASET}.ratio_df
  where sector_code != '00'
    and num_employees >= 100
  group by sector_code, sector_label, year
);

create or replace view {DATASET}.q2 as (
  select
    sector_code,
    sector_label,
    year,
    avg_pay,
    lag(avg_pay, 1) over (partition by sector_code order by year) as prev_avg_pay,
    ((avg_pay - lag(avg_pay, 1) over (partition by sector_code order by year)) 
      / lag(avg_pay, 1) over (partition by sector_code order by year)) * 100 as p_change
  from {DATASET}.q2_base
);


select sector_label, p_change from {DATASET}.q2
where prev_avg_pay is not null  
  and year = 2020
  and p_change < 0
order by p_change, year 
;
