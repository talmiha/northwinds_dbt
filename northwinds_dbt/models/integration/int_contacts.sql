WITH customers as(
    SELECT * FROM {{ref('stg_rds_customers')}}
), contacts as(
    SELECT * FROM {{ref('stg_hubspot_contacts')}}
),merged_contacts as(
    SELECT
    null as hubspot_contact_id,
    customer_id as rds_contact_id,
    first_name,
    last_name,
    phone,
    null as hubspot_company_id,
    company_id as rds_company_id
    FROM customers
    UNION ALL
    SELECT
    contact_id as hubspot_contact_id,
    null as rds_contact_id,
    first_name,
    last_name,
    phone,
    company_id as hubspot_company_id,
    null as rds_company_id
    FROM contacts
),final as(
    SELECT
    MAX(hubspot_contact_id) as hubspot_contact_id,
    MAX(rds_contact_id) as rds_contact_id,
    first_name,
    last_name,
    MAX(phone) as phone,
    MAX(hubspot_company_id) as hubspot_company_id,
    MAX(rds_company_id) as rds_company_id
    FROM merged_contacts
    GROUP BY first_name, last_name
    ORDER BY last_name
)
select {{ dbt_utils.generate_surrogate_key(['first_name', 'last_name', 'phone']) }} as contact_pk,
hubspot_contact_id, rds_contact_id,
first_name, last_name, phone, hubspot_company_id, rds_company_id from final