with 

order_line_items as (
    select * from {{ ref('fct_order_line_items') }}
)

,products as (
    select * from {{ ref('dim_products') }}
)

,orders as (
    select * from {{ ref('fct_orders') }}
)

,vendors as (
    select * from {{ ref('dim_vendors') }}
)

,customers as (
    select * from {{ ref('dim_customers') }}
)

,final as (
    select 
        oli.order_line_item_id,
        oli.order_id,
        p.product_id,
        p.name as product_name,
        oli.quantity,
        c.customer_id,
        c.name as customer_name,
        c.gender as customer_gender,
        c.state as customer_state,
        c.country as customer_country,
        o.total_price as total_order_price,
        p.price as unit_price,
        p.cost as unit_cost,
        o.order_dt,
        extract(year from o.order_dt) as order_year,
        extract(month from o.order_dt) as order_month,
        o.refunded_at,
        v.vendor_id,
        v.name as vendor_name
    from order_line_items oli
    inner join products p
        on p.product_id = oli.product_id
    inner join orders o
        on o.order_id = oli.order_id
    inner join vendors v
        on v.vendor_id = p.vendor_id
    inner join customers c
        on c.customer_id = o.customer_id
    order by order_line_item_id
)

select * from final