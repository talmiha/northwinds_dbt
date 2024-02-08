WITH customers as (
    SELECT * FROM "northwinds"."public"."customers"
),
companies as (
    SELECT * FROM dev.stg_rds_companies
),
renamed as(
  SELECT 
  concat('rds-', customer_id) as customer_id,
  SPLIT_PART(contact_name, ' ', 1) as first_name,
  SPLIT_PART(contact_name, ' ', -1) as last_name, 
  REPLACE(TRANSLATE(phone, '(,),-,.', ''), ' ', '') as updated_phone,
  company_id
  FROM customers
  JOIN companies ON companies.name = customers.company_name
), 
final as 
 (SELECT
   customer_id,
   first_name,
   last_name,
   CASE WHEN LENGTH(updated_phone) = 10 THEN
       '(' || SUBSTRING(updated_phone, 1, 3) || ') ' || 
       SUBSTRING(updated_phone, 4, 3) || '-' ||
       SUBSTRING(updated_phone, 7, 4) 
       END as phone,
   company_id
  FROM renamed
)
SELECT * FROM final