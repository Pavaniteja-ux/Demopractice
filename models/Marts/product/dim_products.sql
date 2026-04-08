select
    product_key,
    sku,
    product_name,
    category,
    subcategory,
    model,
    color,
    standard_cost,
    list_price
from {{ ref('stg_productdata') }}