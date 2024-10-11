with

orders as (
	select * from  {{ ref('fct_orders_enriched') }} co 
)

,value_by_period as (
	select 
		customer_gender,
		period,
		sum(total_order_price) as total_value_by_period
	from orders
	where refunded_at is null
	group by 1,2
)

,ltv as (
	select 
		customer_gender,
		period,
		sum(total_value_by_period) over (partition by customer_gender ORDER BY period ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as ltv
	from value_by_period
    order by 2,1
)

select * from ltv