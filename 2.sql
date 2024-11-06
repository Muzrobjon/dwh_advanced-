CREATE TABLE DimDate  (
    date_id VARCHAR(45) PRIMARY KEY,
    date DATE,
    day INT,
    month INT,
    year INT,
    quarter INT,
    week_of_year INT
);

CREATE TABLE DimCustomer  (
    customer_id VARCHAR(10) PRIMARY KEY,
    company_name VARCHAR(45),
    contact_name VARCHAR(40),
    contact_title VARCHAR(35),
    address VARCHAR(50),
    city VARCHAR(25),
    region VARCHAR(25),
    postal_code VARCHAR(10),
    country VARCHAR(20),
    phone VARCHAR(24)
);

CREATE TABLE DimProduct (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(40),
    supplier_id INT,
    category_id INT,
    quantity_per_unit VARCHAR(20),
    unit_price DECIMAL(10, 2),
    units_in_stock INT
);

CREATE TABLE DimEmployee  (
    employee_id INT PRIMARY KEY,
    last_name VARCHAR(25),
    first_name VARCHAR(25),
    title VARCHAR(40),
    birth_date DATE,
    hire_date DATE,
    address VARCHAR(50),
    city VARCHAR(25),
    region VARCHAR(25),
    postal_code VARCHAR(10),
    country VARCHAR(20),
    home_phone VARCHAR(24),
    extension VARCHAR(4)
);

CREATE TABLE DimCategory (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(25),
    description TEXT
);

CREATE TABLE DimShipper (
    shipper_id INT PRIMARY KEY,
    company_name VARCHAR(40),
    phone VARCHAR(24)
);

CREATE TABLE DimSupplier (
    supplier_id INT PRIMARY KEY,
    company_name VARCHAR(40),
    contact_name VARCHAR(30),
    contact_title VARCHAR(30),
    address VARCHAR(60),
    city VARCHAR(20),
    region VARCHAR(20),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    phone VARCHAR(24)
);


CREATE TABLE fact_sales (
    sales_id SERIAL PRIMARY KEY,
    date_id VARCHAR(50),
    customer_id VARCHAR(5),
    product_id INT,
    employee_id INT,
    category_id INT,
    shipper_id INT,
    supplier_id INT,
    quantity_sold INT,
    unit_price DECIMAL(10, 2),
    discount DECIMAL(5, 2),
    total_amount DECIMAL(10, 2) GENERATED ALWAYS AS (quantity_sold * unit_price - discount) STORED, -- I used generated always as and stored it
    tax_amount DECIMAL(10, 2) GENERATED ALWAYS AS ((quantity_sold * unit_price - discount) * 0.1) STORED,
    FOREIGN KEY (date_id) REFERENCES DimDate(date_id),
    FOREIGN KEY (customer_id) REFERENCES DimCustomer(customer_id),
    FOREIGN KEY (product_id) REFERENCES DimProduct(product_id),
    FOREIGN KEY (employee_id) REFERENCES DimEmployee(employee_id),
    FOREIGN KEY (category_id) REFERENCES DimCategory(category_id),
    FOREIGN KEY (shipper_id) REFERENCES DimShipper(shipper_id),
    FOREIGN KEY (supplier_id) REFERENCES DimSupplier(supplier_id)
);
