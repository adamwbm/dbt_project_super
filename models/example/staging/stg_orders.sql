with 

source as (
    select * from {{ ref('seed_orders') }}
)

,transformed as (
    select 
        id as order_id,
        customer_id,
        currency,
        total_price,
        to_timestamp(created_at, 'MM/DD/YYYY HH24:MI:SS') as created_at,
        to_timestamp(refunded_at, 'MM/DD/YYYY HH24:MI:SS') as refunded_at
    from source
)

select * from transformed