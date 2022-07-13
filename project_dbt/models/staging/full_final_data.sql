{{ config(materialized='table') }}

-- Initial data
with source_data as (

    select  * 
    from    {{ ref('raw_data') }}
  
),

-- Different stages of call data
call_stage_data as(

    select  *
    from    {{ ref('final_events_data') }}

),

-- Combining Initial data with each call stage data based on guid
all_data as (

    select  *
    from    source_data  inner join 
            call_stage_data using (call_guid)

),

-- Final data which is analysis-ready table
final as(

    select  * 
    from    all_data
    order by call_guid
)


select * from final 


