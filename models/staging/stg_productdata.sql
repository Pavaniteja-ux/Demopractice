with src as (
    select
        productkey,
        sku                         as sku_raw,
        product                     as product_name_raw,
        standard_cost               as standard_cost_raw,
        color                       as color_raw,
        list_price                  as list_price_raw,
        model                       as model_raw,
        subcategory                 as subcategory_raw,
        category                    as category_raw
    from {{ source('raw', 'productdata') }}
),
cleaned as (
    select
        try_to_number(productkey)                                                as product_key,
        trim(sku_raw)                                                            as sku,
        initcap(trim(product_name_raw))                                          as product_name,
        try_to_number(replace(replace(standard_cost_raw, '$', ''), ',', ''))     as standard_cost,
        nullif(initcap(trim(color_raw)), 'NA')                                   as color,
        try_to_number(replace(replace(list_price_raw, '$', ''), ',', ''))        as list_price,
        initcap(trim(model_raw))                                                 as model,
        initcap(trim(subcategory_raw))                                           as subcategory,
        initcap(trim(category_raw))                                              as category
    from src
    where try_to_number(productkey) is not null
),
dedup as (
    select *
    from cleaned
    qualify row_number() over (partition by product_key order by sku, product_name) = 1
)
select *
from dedup