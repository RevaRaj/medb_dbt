{{ config(materialized='table') }}


with source_data as (

SELECT * from {{ref('raw_data')}}
  
),

call_stage_data as(

select call_guid, ringing, connected, wrap , ringing + connected + wrap as total_duration_secs
from {{ref('ring_data')}}  inner join 
{{ref('connect_data')}} using (call_guid) inner join 
{{ref('wrap_data')}} using (call_guid)

),

all_data as (

select *
from source_data  inner join 
call_stage_data using (call_guid)

),

final as(

select * --call_guid, timestamp_of_call_start,pagent_id, call_end_reason, ringing, connected, wrap , 
from all_data
order by call_guid
)

select * from final




