with 

orders as (
    select 
    order_id,
    customer_id,
    currency,
    total_price,
    created_at as order_dt,
    refunded_at
from {{ ref('stg_orders') }}
)

select * from orders