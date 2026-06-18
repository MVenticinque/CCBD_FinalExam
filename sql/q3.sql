/*How salaries have changed across different business size between 2017-2023*/

create or replace view {DATASET}.q3_base as (
  select
    year,
    bsize,
    bsize_code,
    avg(annual_payroll / nullif(num_employees, 0)) as avg_salary
  from {DATASET}.cbp_state
  where lfo = '001'
    and bsize_code != '001'
    and sector_code = '00'
    and annual_payroll > 0
    and num_employees > 0
  group by year, bsize, bsize_code
);

create or replace view {DATASET}.q3 as (
  select
    year,
    bsize,
    bsize_code,
    avg_salary,
    first_value(avg_salary) over (
      partition by bsize_code 
      order by year 
      rows between unbounded preceding and unbounded following
    ) as base_2017
  from {DATASET}.q3_base
);

select
  year,
  bsize,
  bsize_code,
  avg_salary,
  round((avg_salary / base_2017) * 100, 2) as idx
from {DATASET}.q3
order by bsize_code, year;
