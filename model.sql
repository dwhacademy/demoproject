-- Create tables
CREATE TABLE IF NOT EXISTS products
(
    product_id BIGINT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    PRIMARY KEY(product_id)
);
