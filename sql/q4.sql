/*Which sectors have the highest concentration of corporate, sole-proprietorship/partnership, government/no-profit jobs?*/

create or replace view {DATASET}.q4 as (
  select
    sector_code,
    sector_label,
    year,
    sum(case when lfo in ('9101', '9111') then num_businesses else 0 end) as corporate,
    sum(case when lfo in ('920', '930')   then num_businesses else 0 end) as sole,
    sum(case when lfo in ('932', '933')   then num_businesses else 0 end) as gov_np,
    sum(num_businesses)                                                    as total_b
  from {DATASET}.cbp_state
  where bsize_code = '001'
    and sector_code != '00'
  group by sector_code, sector_label, year
);

create or replace view {DATASET}.q4_2 as (
  select
    sector_code,
    sector_label,
    year,
    sum(case when lfo in ('9101', '9111') then num_employees else 0 end) as corporate,
    sum(case when lfo in ('920', '930')   then num_employees else 0 end) as sole,
    sum(case when lfo in ('932', '933')   then num_employees else 0 end) as gov_np,
    sum(num_employees) as total_emp
  from {DATASET}.cbp_state
  where bsize_code = '001'
    and sector_code != '00'
  group by sector_code, sector_label, year
);

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
from {DATASET}.q4
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
from {DATASET}.q4_2
where year = 2023
order by sole_share desc;