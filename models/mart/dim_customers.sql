with

customers as (
    select 
        customer_id,
        name,
        gender,
        email,
        state,
        country,
        created_at
    from {{ ref('stg_customers') }}
)

select * from customers