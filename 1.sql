CREATE SCHEMA Staging;
CREATE TABLE Staging.staging_orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(5),
    employee_id INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    shipvia INT,
    freight DECIMAL(10, 2)
);

CREATE TABLE Staging.staging_order_details (
    order_id INT,
    product_id INT,
    unit_price DECIMAL(15, 2),
    quantity INT,
    discount REAL,
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE Staging.staging_products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(42),
    supplier_id INT,
    category_id INT,
    quantity_per_unit VARCHAR(25),
    unit_price DECIMAL(15, 2),
    units_in_stock INT,
    units_on_order INT,
    reorder_level INT,
    discontinued BOOLEAN
);

CREATE TABLE Staging.staging_customers (
    customer_id VARCHAR(5) PRIMARY KEY,
    company_name VARCHAR(42),
    contact_name VARCHAR(42),
    contact_title VARCHAR(30),
    address VARCHAR(60),
    city VARCHAR(20),
    region VARCHAR(20),
    postal_code VARCHAR(10),
    country VARCHAR(20),
    phone VARCHAR(24),
    fax VARCHAR(24)
);

CREATE TABLE Staging.staging_employees (
    employee_id INT PRIMARY KEY,
    last_name VARCHAR(25),
    first_name VARCHAR(15),
    title VARCHAR(30),
    title_of_courtesy VARCHAR(25),
    birth_date DATE,
    hire_date DATE,
    address VARCHAR(60),
    city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    home_phone VARCHAR(24),
    extension VARCHAR(4),
    notes TEXT,
    reports_to INT
);

CREATE TABLE Staging.staging_categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(25),
    description TEXT
);

CREATE TABLE Staging.staging_shippers (
    shipper_id INT PRIMARY KEY,
    company_name VARCHAR(44),
    phone VARCHAR(24)
);

CREATE TABLE Staging.staging_suppliers (
    supplier_id INT PRIMARY KEY,
    company_name VARCHAR(40),
    contact_name VARCHAR(30),
    contact_title VARCHAR(30),
    address VARCHAR(60),
    city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    phone VARCHAR(24),
    fax VARCHAR(24),
    home_page TEXT
);
