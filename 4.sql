INSERT INTO dimcustomer (customer_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone)
SELECT customer_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone
FROM staging.staging_customers;


INSERT INTO dimproduct (product_id, product_name, supplier_id, category_id, quantity_per_unit, unit_price, units_in_stock)
SELECT product_id, product_name, supplier_id, category_id, quantity_per_unit, unit_price, units_in_stock
FROM staging.staging_products;


INSERT INTO dimemployee (employee_id, last_name, first_name, title, birth_date, hire_date, address, city, region, postal_code, country, home_phone, extension)
SELECT employee_id, last_name, first_name, title, birth_date, hire_date, address, city, region, postal_code, country, home_phone, extension
FROM staging.staging_employees;


INSERT INTO dimcategory (category_id, category_name, description)
SELECT category_id, category_name, description
FROM staging.staging_categories;


INSERT INTO dimshipper (shipper_id, company_name, phone)
SELECT shipper_id, company_name, phone
FROM staging.staging_shippers;


INSERT INTO dimsupplier (supplier_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone)
SELECT supplier_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone
FROM staging.staging_suppliers;



INSERT INTO DimDate (date_id, Date, Day, Month, Year, Quarter, week_of_year)
SELECT DISTINCT
    EXTRACT(EPOCH FROM order_date)::BIGINT AS DateID,  -- Using EPOCH as a unique identifier
    order_date AS Date,
    EXTRACT(DAY FROM order_date) AS Day,
    EXTRACT(MONTH FROM order_date) AS Month,
    EXTRACT(YEAR FROM order_date) AS Year,
    EXTRACT(QUARTER FROM order_date) AS Quarter,
    EXTRACT(WEEK FROM order_date) AS WeekOfYear
FROM staging.staging_orders;

INSERT INTO fact_sales (date_id, customer_id, product_id, employee_id, category_id, shipper_id, supplier_id, quantity_sold, unit_price, discount)
SELECT
    d.date_id,   
    c.customer_id,  
    p.product_id,  
    e.employee_id,  
    cat.category_id,  
    s.shipper_id,  
    sup.supplier_id, 
    od.quantity, 
    od.unit_price, 
    od.discount
FROM staging.staging_order_details od
JOIN staging.staging_orders o ON od.order_id = o.order_id 
JOIN staging.staging_customers c ON o.customer_id = c.customer_id 
JOIN staging.staging_products p ON od.product_id = p.product_id  
LEFT JOIN staging.staging_employees e ON o.employee_id = e.employee_id 
LEFT JOIN staging.staging_categories cat ON p.category_id = cat.category_id 
LEFT JOIN staging.staging_shippers s ON o.shipvia = s.shipper_id  
LEFT JOIN staging.staging_suppliers sup ON p.supplier_id = sup.supplier_id
LEFT JOIN dimdate d ON o.order_date = d.date;

SELECT 
    'FactSales Missing References' AS check_type,
    COUNT(*) AS missing_reference_count
FROM fact_sales fs
LEFT JOIN DimCustomer dc ON fs.customer_id = dc.customer_id
LEFT JOIN DimCategory dct ON fs.category_id = dct.category_id
LEFT JOIN DimDate dd ON fs.date_id = dd.date_id
LEFT JOIN DimEmployee de ON fs.employee_id = de.employee_id
LEFT JOIN DimProduct dp ON fs.product_id = dp.product_id
LEFT JOIN DimShipper dsh ON fs.shipper_id = dsh.shipper_id
LEFT JOIN DimSupplier ds ON fs.supplier_id = ds.supplier_id
WHERE dc.customer_id IS NULL 
    OR dct.category_id IS NULL 
    OR dd.date_id IS NULL 
    OR de.employee_id IS NULL 
    OR dp.product_id IS NULL 
    OR dsh.shipper_id IS NULL
    OR ds.supplier_id IS NULL;
	
	SELECT
    'Categories' AS TableName,
    CASE WHEN (SELECT COUNT(*) FROM staging.staging_categories) = (SELECT COUNT(*) FROM DimCategory)
         THEN 'Match' ELSE 'Mismatch' END AS RecordMatchStatus

UNION ALL

SELECT
    'Customers' AS TableName,
    CASE WHEN (SELECT COUNT(*) FROM staging.staging_customers) = (SELECT COUNT(*) FROM DimCustomer)
         THEN 'Match' ELSE 'Mismatch' END AS RecordMatchStatus

UNION ALL

SELECT
    'Orders' AS TableName,
    CASE WHEN (SELECT COUNT(*) FROM staging.staging_orders) = (SELECT COUNT(*) FROM DimDate)
         THEN 'Match' ELSE 'Mismatch' END AS RecordMatchStatus

UNION ALL

SELECT
    'Products' AS TableName,
    CASE WHEN (SELECT COUNT(*) FROM staging.staging_products) = (SELECT COUNT(*) FROM DimProduct)
         THEN 'Match' ELSE 'Mismatch' END AS RecordMatchStatus

UNION ALL

SELECT
    'Employees' AS TableName,
    CASE WHEN (SELECT COUNT(*) FROM staging.staging_employees) = (SELECT COUNT(*) FROM DimEmployee)
         THEN 'Match' ELSE 'Mismatch' END AS RecordMatchStatus

UNION ALL

SELECT
    'Shippers' AS TableName,
    CASE WHEN (SELECT COUNT(*) FROM staging.staging_shippers) = (SELECT COUNT(*) FROM DimShipper)
         THEN 'Match' ELSE 'Mismatch' END AS RecordMatchStatus

UNION ALL

SELECT
    'Suppliers' AS TableName,
    CASE WHEN (SELECT COUNT(*) FROM staging.staging_suppliers) = (SELECT COUNT(*) FROM DimSupplier)
         THEN 'Match' ELSE 'Mismatch' END AS RecordMatchStatus

UNION ALL

SELECT
    'Order Details' AS TableName,
    CASE WHEN (SELECT COUNT(*) FROM staging.staging_order_details) = (SELECT COUNT(*) FROM Fact_Sales)
         THEN 'Match' ELSE 'Mismatch' END AS RecordMatchStatus;