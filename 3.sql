INSERT INTO staging.staging_categories
SELECT *
FROM northwind.categories;

INSERT INTO staging.staging_customers
SELECT *
FROM northwind.customers;

INSERT INTO staging.staging_employees
SELECT *
FROM northwind.employees;

INSERT INTO staging.staging_order_details
SELECT *
FROM northwind.order_details;

INSERT INTO staging.staging_orders
SELECT *
FROM northwind.orders;

INSERT INTO staging.staging_products
SELECT *
FROM northwind.products;

INSERT INTO staging.staging_shippers
SELECT *
FROM northwind.shippers;

INSERT INTO staging.staging_suppliers
SELECT *
FROM northwind.suppliers;
