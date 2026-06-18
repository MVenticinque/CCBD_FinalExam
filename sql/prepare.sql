-- agg views
create or replace view {DATASET}.county_agg as (
  select
    county_str,
    county_code,
    state,
    sector_code,
    sector_label,
    year,
    num_employees,
    annual_payroll,
    num_businesses,
    annual_payroll / nullif(num_employees, 0) as avg_pay_ct
  from {DATASET}.cbp_county
);


create or replace view {DATASET}.state_agg as (
  select 
    state_str,
    state,
    year,
    sector_code,
    sector_label,
    sum(annual_payroll)  as total_pay_st,
    sum(num_employees)   as total_emp_st,
    sum(num_businesses)  as total_bs_st,
    sum(annual_payroll) / nullif(sum(num_employees), 0) as avg_pay_st
  from {DATASET}.cbp_state
  where lfo = '001'
    and bsize_code = '001'
  group by state_str, state, year, sector_code, sector_label
);

create or replace table {DATASET}.ratio_df as (
  select
    c.*,
    s.total_pay_st,
    s.total_emp_st,
    s.total_bs_st,
    s.avg_pay_st,
    c.avg_pay_ct / nullif(s.avg_pay_st, 0) as pay_ratio
  from {DATASET}.county_agg c
  join {DATASET}.state_agg s
    on c.state   = s.state
    and c.year        = s.year
    and c.sector_code = s.sector_code
  where s.avg_pay_st is not null
    and c.avg_pay_ct is not null
);