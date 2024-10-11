with

orders as (
	select * from  {{ ref('fct_orders_enriched') }} co 
)

,cohort_count as (
	select 
		customer_gender,
		period,
		count(*) as count_by_cohort_period
	from orders
	where refunded_at is null
	group by 1,2
)

,starting_customers as (
	select 
		customer_gender,
		period,
		count_by_cohort_period,
		max(count_by_cohort_period) over (partition by customer_gender) as starting_customer_count_by_cohort
	from cohort_count
	order by 2,1
)

,final as (
	select 
		customer_gender,
		starting_customer_count_by_cohort as num_of_customers,
		period,
		round(count_by_cohort_period/starting_customer_count_by_cohort::decimal,4)*100 as retention_rate
	from starting_customers
	where period <> 0
	order by 2,1
)

select * from final