COPY geolocation 
FROM 'E:\YueS\SQL\OlistSQLProject\data\olist_geolocation_dataset.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'UTF8');

COPY customers 
FROM 'E:\YueS\SQL\OlistSQLProject\data\olist_customers_dataset.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'UTF8');

COPY orders 
FROM 'E:\YueS\SQL\OlistSQLProject\data\olist_orders_dataset.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'UTF8');

COPY order_payments FROM 'E:\YueS\SQL\OlistSQLProject\data\olist_order_payments_dataset.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'UTF8');

COPY order_reviews FROM 'E:\YueS\SQL\OlistSQLProject\data\olist_order_reviews_dataset.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'UTF8');

COPY product_category_name_translation 
FROM 'E:\YueS\SQL\OlistSQLProject\data\product_category_name_translation.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'UTF8');

COPY products 
FROM 'E:\YueS\SQL\OlistSQLProject\data\olist_products_dataset.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'UTF8'); 

COPY sellers FROM 'E:\YueS\SQL\OlistSQLProject\data\olist_sellers_dataset.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'UTF8'); 

COPY order_items FROM 'E:\YueS\SQL\OlistSQLProject\data\olist_order_items_dataset.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'UTF8'); 

--change datatype because the data shows date only
ALTER TABLE order_reviews
ALTER COLUMN review_creation_date TYPE DATE;
ALTER TABLE orders
ALTER COLUMN order_estimated_delivery TYPE DATE;

--remove duplicates
DELETE FROM geolocation g1 
    USING geolocation g2
    WHERE (g1.*)=(g2.*)
   AND g2.ctid>g1.ctid;

--double check
ALTER TABLE geolocation ADD id SERIAL;
SELECT*
FROM geolocation
ORDER BY id DESC
LIMIT 30;

ALTER TABLE geolocation DROP id;

/*
--cannot create primary and foreign keys because the data has coordinates with different zipcodes
SELECT *
FROM   geolocation g1
WHERE  EXISTS (
   SELECT FROM geolocation g2
   WHERE  (g1.geolocation_lat = g2.geolocation_lat AND g1.geolocation_lng=g2.geolocation_lng AND g1.geolocation_city=g2.geolocation_city)
   AND    g1.ctid <> g2.ctid
   )
ORDER BY g1.geolocation_lat,g1.geolocation_lng;
ALTER TABLE geolocation ADD CONSTRAINT unique_geolocation_zipcode_prefix UNIQUE (geolocation_zipcode_prefix);
    ADD CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers (id);

-- there are two versions of city names: one with ~, one without
UPDATE geolocation
SET geolocation_city='sao paulo'
WHERE geolocation_city='são paulo';

--sao paulo is not the only city with the above problem, don' know how to fix this yet.
--fuzzy search?
CREATE EXTENSION pg_trgm;
SELECT geolocation_city FROM geolocation
WHERE geolocation_city % 'san pablo' LIMIT 10;


DROP TABLE if exists order_items cascade;
*/
