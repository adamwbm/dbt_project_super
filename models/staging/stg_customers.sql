with 

source as (
    select * from {{ ref('seed_customers') }}
)

,transformed as (
    select 
        id as customer_id,
        name,
        gender,
        email,
        state,
        country,
        to_timestamp(created_at, 'MM/DD/YYYY HH24:MI:SS') as created_at
    from source

)

select * from transformed