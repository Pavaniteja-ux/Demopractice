with src as (
    select
        salesorderlinekey,
        resellerkey,
        customerkey,
        productkey,
        orderdatekey,
        duedatekey,
        shipdatekey,
        salesterritorykey,
        order_quantity               as order_quantity_raw,
        unit_price                   as unit_price_raw,
        extended_amount              as extended_amount_raw,
        unit_price_discount_pct      as unit_price_discount_pct_raw,
        product_standard_cost        as product_standard_cost_raw,
        total_product_cost           as total_product_cost_raw,
        sales_amount                 as sales_amount_raw
    from {{ source('raw', 'salesdata') }}
),
cleaned as (
    select
        try_to_number(salesorderlinekey)                                                as sales_order_line_key,
        try_to_number(resellerkey)                                                      as reseller_key,
        try_to_number(customerkey)                                                      as customer_key,
        try_to_number(productkey)                                                       as product_key,
        try_to_number(orderdatekey)                                                     as order_date_key,
        try_to_number(duedatekey)                                                       as due_date_key,
        try_to_number(shipdatekey)                                                      as ship_date_key,
        try_to_number(salesterritorykey)                                                as sales_territory_key,
        coalesce(try_to_number(order_quantity_raw), 0) as order_quantity,
        coalesce(try_to_number(replace(replace(unit_price_raw, '$', ''), ',', '')), 0) as unit_price,
        coalesce(try_to_number(replace(replace(extended_amount_raw, '$', ''), ',', '')), 0) as extended_amount,
        coalesce(try_to_number(replace(unit_price_discount_pct_raw, '%', '')), 0) / 100 as unit_price_discount_pct,
        coalesce(try_to_number(replace(replace(product_standard_cost_raw, '$', ''), ',', '')), 0) as product_standard_cost,
        coalesce(try_to_number(replace(replace(total_product_cost_raw, '$', ''), ',', '')), 0) as total_product_cost,
        coalesce(try_to_number(replace(replace(sales_amount_raw, '$', ''), ',', '')), 0) as sales_amount
    from src
)
select *
from cleaned


