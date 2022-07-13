-- creating a separate model to unstructure the event data in channels
-- Each call data transformation are taking place here

-- Extracting guid and events data from channels column 
with channel_data as (

    select   
        channel::jsonb->0->>'guid' as call_guid, 
        channel::json->0->'events' as events
    from    table6

    union all

    select  
        channel::jsonb->1->>'guid' as call_guid,
        channel::json->1->'events' as events
    from    table6

    union all

    select  
        channel::jsonb->2->>'guid' as call_guid,
        channel::json->2->'events' as events 
    from    table6
    
),

--  Transorming each level of events data which is different call stage data
zero_level_data as (
    
    select 
            call_guid,
            events::jsonb->0->>'type' as call_type,
            ((events::json->0->>'duration')::float)/1000 as call_duration 
    from     channel_data
    where    events is not null
),

first_level_data as (

   select 
            call_guid,
            events::jsonb->1->>'type' as call_type,
            ((events::json->1->>'duration')::float)/1000 as call_duration 
   from     channel_data
   where    events is not null
),

second_level_data as (

   select 
            call_guid,
            events::jsonb->2->>'type' as call_type,
            ((events::json->2->>'duration')::float)/1000  as call_duration 
   from     channel_data
   where    events is not null
),

thrid_level_data as (
    
   select 
            call_guid,
            events::jsonb->3->>'type' as call_type,
            ((events::json->3->>'duration')::float)/1000   as call_duration 
   from     channel_data
   where    events is not null
),

fourth_level_data as (
 
   select 
            call_guid,
            events::jsonb->4->>'type' as call_type,
            ((events::json->4->>'duration')::float)/1000  as call_duration 
   from     channel_data
   where    events is not null
),


-- Combining them into have one single view whichcan have duplicates
full_events_extracted_data as (

    select  *
    from    zero_level_data
            union all
    select  *
    from    first_level_data 
            union all
    select  *
    from    second_level_data  
            union all
    select  *
    from    thrid_level_data  
            union all
    select  *
    from    fourth_level_data
           
)

select * from full_events_extracted_data