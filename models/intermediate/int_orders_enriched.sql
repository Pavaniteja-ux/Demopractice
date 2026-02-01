with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customerdata') }}
),

products as (
    select * from {{ ref('stg_productdata') }}
)

select
    o.sales_order_line_key,
    o.order_date_key,
    o.due_date_key,
    o.ship_date_key,
    o.sales_territory_key,

    -- Customer details
    o.customer_key,
    c.customer_id,
    c.customer_name,
    c.city,
    c.state_province,
    c.country_region,
    c.postal_code,

    -- Product details
    o.product_key,
    p.sku,
    p.product_name,
    p.category,
    p.subcategory,
    p.model,
    p.standard_cost,
    p.list_price,
    p.color,

    -- Order facts
    o.order_quantity,
    o.unit_price,
    o.extended_amount,
    o.unit_price_discount_pct,
    o.product_standard_cost,
    o.total_product_cost,
    o.sales_amount

from orders o
left join customers c
    on o.customer_key = c.customer_key
left join products p
    on o.product_key = p.product_key