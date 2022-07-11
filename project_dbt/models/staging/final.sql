{{ config(materialized='table') }}

-- ->> used to convert json to int

with source_data as (


SELECT * from {{ref('raw_data')}}

),

data2 as(

    select * from {{ref("channel_data")}}


),

final as (

select call_guid,timestamp_of_call_start, pagent_id, total_duration_sec, call_end_reason,  etype
from source_data inner join 
data2 using (call_guid)
where etype is not null
)

select * from final




