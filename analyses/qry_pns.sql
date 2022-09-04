select 
        -- survey design variables
        upa_pns, v0024, 
        v0029, v00292, v00293,
        v0028, v00282, v00283,
        -- variables for analyses
        case 
          when j001 = '1' then 'very good'
          when j001 = '2' then 'good'
          when j001 = '3' then 'regular'
          when j001 = '4' then 'bad'
          when j001 = '5' then 'very bad'
                else null
        end as health_perception,
        case
          when c006 = '1' then 'male'
          when c006 = '2' then 'female'
          else null
        end as gender, 
        cast( c008 as integer) as age, 
        case
          when q092 = '1' then 'yes'
          when q092 = '2' then 'no'
          else null
        end as diagnosed_depression, 
        case
          when q11006 = '1' then 'yes'
          when q11006 = '2' then 'no'
          else null
        end as diagnosed_anxiety, 
        case
          when g057 = '1' then 'none'
          when g057 = '2' then 'some'
          when g057 = '3' then 'heavily'
          when g057 = '4' then 'fully'
          else null
        end as hearing_impairment_level, 
        case
          when g05801 = '1' then 'yes'
          when g05801 = '2' then 'no'
          else null
        end as brazilian_sign_language_use 
from ed2019.microdata 
where v0029 ~ '\d+' -- v0029 not empty
and v0015 = '01' -- only realized interviews
-- limit 10
