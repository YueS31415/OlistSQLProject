--create tables
CREATE TABLE geolocation(
    geolocation_zipcode_prefix INT, 
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(100)
    --PRIMARY KEY( geolocation_lat FLOAT,geolocation_lng FLOAT) there are coordidates with multiple zipcodes
);

CREATE TABLE customers(
    customer_id VARCHAR(100)  PRIMARY KEY,
    customer_unique_id VARCHAR(100),
    customer_zipcode_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(100)
);

CREATE TABLE orders(
    order_id VARCHAR(100) PRIMARY KEY,
    customer_id VARCHAR(100),
    order_status VARCHAR(100),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier TIMESTAMP,
    order_delivered_customer TIMESTAMP,
    order_estimated_delivery TIMESTAMP,
   FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_payments(
    order_id VARCHAR(100),
    payment_sequential INT,
    payment_type VARCHAR(100),
    payment_installment INT,
    payment_value FLOAT,
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE order_reviews(
    review_id VARCHAR(100),
    order_id VARCHAR(100),
    review_score INT, 
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    PRIMARY KEY (order_id, review_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE product_category_name_translation(
    product_category_name VARCHAR(255) PRIMARY KEY,
    product_category_name_english VARCHAR(255)
);

--there are null values in product category name so cannot creat fkey
CREATE TABLE products(
    product_id VARCHAR(100) PRIMARY KEY,
    product_category_name VARCHAR(255),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
   -- FOREIGN KEY (product_category_name) REFERENCES product_category_name_translation(product_category_name)
);

CREATE TABLE sellers(
    seller_id VARCHAR(100) PRIMARY KEY,
    seller_zipcode_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(100)
    --FOREIGN KEY (seller_zipcode_prefix) REFERENCES geolocation(geolocation_zipcode_prefix)
);

CREATE TABLE order_items(
    order_id VARCHAR(100),
    order_item_id INT, --sequential number identifying number of items included in the same order.
    product_id VARCHAR(100),
    seller_id VARCHAR(100),
    shipping_limit_date TIMESTAMP,
    price FLOAT,
    freight_value FLOAT,
    PRIMARY KEY (order_id,order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

--set ownership of tables to postgres user
ALTER TABLE customers OWNER to postgres;
ALTER TABLE geolocation OWNER to postgres;
ALTER TABLE order_items OWNER to postgres;
ALTER TABLE order_payments OWNER to postgres;
ALTER TABLE order_reviews OWNER to postgres;
ALTER TABLE orders OWNER to postgres;
ALTER TABLE product_category_name_translation OWNER to postgres;
ALTER TABLE products OWNER to postgres;

