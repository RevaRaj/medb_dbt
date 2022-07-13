--  Extracting each stage( Ringing, Connected, CallRecording, Held, Wrap, DeliveryFailed) data separately
--  Joining them to create a proper view with 
--  total call duration for ( Ringing, Connected, Wrap) stages

with ring_data as (
       
    select 
            call_guid,    
            call_duration as {{ var('ring_stage') }}

    from    {{ ref('event_data') }}
    where   call_type = '{{var("ring")}}' 

),


connected_data as (
  
    select   
            call_guid,    
            call_duration as {{ var('connect_stage') }}

    from    {{ ref('event_data') }}
    where   call_type = '{{var("connect")}}'

),


call_recording_data as (

    
    select  
            call_guid,    
            sum(call_duration) as {{ var('call_record_stage') }}

    from    {{ ref('event_data') }}
    where   call_type = '{{var("call_record")}}' 
    group by call_guid
),


held_data as (

    select   
        call_guid,    
        sum(call_duration) as {{ var('held_stage') }}

    from    {{ ref('event_data') }}
    where   call_type = '{{var("held")}}'
    group by call_guid
),


wrap_data as (

    select 
        call_guid,    
        call_duration as {{ var('wrap_stage') }}

    from    {{ ref('event_data') }}
    where   call_type = '{{var("wrap")}}'
),


delivery_failed_data as (

    select 
        call_guid,    
        call_duration as {{ var('delivery_failed_stage') }}

    from    {{ ref('event_data') }}
    where   call_type = '{{var("delivery_failed")}}' 
),


-- All call stages data are grouped here, replacing null values to 0, if any found
-- Since we need to calculate total duration for each call stage
all_stage_data as(

    select   
            call_guid,
            case when {{ var('ring_stage') }} is null then 0 else {{ var('ring_stage') }} end as ringing_duration,
            case when {{ var('connect_stage') }} is null then 0 else {{ var('connect_stage') }} end as connected_duration,
            case when {{ var('call_record_stage') }} is null then 0 else {{ var('call_record_stage') }} end as call_Recording_duration, 
            case when {{ var('held_stage') }} is null then 0 else {{ var('held_stage') }} end as held_duration,
            case when {{ var('wrap_stage') }} is null then 0 else {{ var('wrap_stage') }} end as wrap_duration,
            case when {{ var('delivery_failed_stage') }} is null then 0 else {{ var('delivery_failed_stage') }} end as delivery_failed_duration

    from    ring_data  full outer join 
            connected_data using (call_guid) full outer join 
            call_recording_data using (call_guid) full outer join
            held_data using (call_guid) full outer join
            wrap_data using (call_guid) full outer join
            delivery_failed_data using (call_guid)


),


total_duration_data as (

    select 
            call_guid,
            ringing_duration,
            connected_duration,
            call_Recording_duration,
            held_duration,
            wrap_duration,
            delivery_failed_duration,
            (ringing_duration + connected_duration + wrap_duration) as total_duration_secs
    
    from all_stage_data

)

select * from total_duration_data