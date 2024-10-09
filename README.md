# YouGrow - DBT Project

## Intro
This project uses DBT (Data Build Tool) with a Postgres DB to conduct analytics for the company YouGrow.

## Project Structure
```bash
├── models/
│   ├── staging/
│   ├── marts/
│   └── reporting/  
├── seed/
├── dbt_project.yml
├── README.md
└── requirements.txt
```

## Requirements
- Ensure Docker is installed on your machine. You can download it from: https://www.docker.com/products/docker-desktop

Ensure all required packages are installed by running the following:
```bash
pip install -r requirements.txt
dbt deps
```

The following dependencies are necessary for running the project. These are managed in the `requirements.txt` file:
- dbt-postgres

### PostgreSQL Setup
To create a local PostgreSQL instance using Docker, run the following command:
```bash
docker run --name postgres \
    -e POSTGRES_USER=myusername \
    -e POSTGRES_PASSWORD=mypassword \
    -p 5432:5432 \
    -v /your/local/path:/var/lib/postgresql/data \
    -d postgres
```
Make sure to replace `/your/local/path` with the actual directory on your machine where you'd like to store the PostgreSQL data.


## Assumptions
I excluded refunds from the analysis models, as I assumed these records should not factor in to the metrics below, but this would require a further discussion with the business to confirm.

## Questions

**Question 1**: 
To provide monthly order level KPIs, I constructed an order line level table to build a kpi table on top of. These 4 metrics can all be calculated together in an aggregated table, which I did in the kpis_monthly model in the reporting folder.

**Question 2**: 
To provide monthly customer/order level KPIs, I created a separate KPI table because they are a different granularity (order AND customer level) than the previous request. This model can be found in the reporting folder. To keep the data flexible, the customer dimensional attributes were added to the fct_order_line_enriched table and only rolled up to a monthly/customer level in the customer_orders table. From here, the reporting can be handled in different ways. If the end user is SQL savvy and has access directly to the warehouse, the customer_orders sql can be run independently with the desired filters early in the script (where I left a comment). Otherwise the fact and dimension tables (for Power BI as an example, since its more performant with a star schema) or the enriched table could be brought into a dashboard where the transformations can be made so that the filtering options are dynamic. 

Additonally, helper columns were added including new_customer_ind and first_order_dt to help with downstream analyses whether it be within a BI tool or spreadsheet.

**Question 3**: 
For a subscription model, I would need to know what the subscription does for the customer. Does it give discounts to the customer for the other products, or does it function as an independent product that provides additional benefits.

Depending on the answer to the above, it could make sense to include the subscription as a product in the dim_product table with a new product_type field to indicate whether or not it is a subscription product and a start and end date (if applicable).

An alternative could be to track customers that are subscribed in a separate dimension table. This would make applying discounts to products purchased under a subscribed customer easy, by tying the subscription status to the order using the subscriptions valid date range and the order date. This subscription table would need to be tracked across time and would implement an SCD Type 2 model to ensure all of the cancellations/renewals/etc. are captured across time.

Assuming there are monthly payments, this table could then be broken out into individual records where each record is treated as an order to pair the granularity with the orders table and then unioned so that they can be tracked uniformly with the others.