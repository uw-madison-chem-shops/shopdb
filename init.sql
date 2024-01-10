CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE vendors (
	id UUID DEFAULT uuid_generate_v4 (),
	name VARCHAR ( 255 ) UNIQUE NOT NULL,
	description TEXT,
	url TEXT UNIQUE NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE parts (
	id UUID DEFAULT uuid_generate_v4 (),
	manufacturer VARCHAR ( 255 ),
	manufacturer_product_number VARCHAR ( 255 ),
	description TEXT NOT NULL,
	attributes JSON,
	image_urls TEXT[],
	status VARCHAR ( 255 ) NOT NULL,
	price FLOAT8,
	location VARCHAR ( 255 ),
	PRIMARY KEY (id),
	CHECK (status IN ('Active', 'Obsolete', 'Not Normally Stocked'))
);

CREATE TABLE orders (
	id UUID DEFAULT uuid_generate_v4 (),
	part UUID NOT NULL,
	vendor UUID NOT NULL,
	quantity float8 NOT NULL,
	price_each float8 NOT NULL,
	date_ordered DATE,
	date_recieved DATE,
	attributes JSON,
	PRIMARY KEY (id),
	CONSTRAINT fk_part FOREIGN KEY ( part ) REFERENCES parts(id)
);

CREATE TABLE jobs (
	id SERIAL,
	status VARCHAR ( 255 ) NOT NULL,
	date_submitted DATE NOT NULL,
	date_closed DATE,
	customer_name VARCHAR ( 255 ),
	PRIMARY KEY (id),
	CHECK (status IN ('Not Started', 'In Progress', 'Completed', 'Deferred', 'Waiting'))
);

CREATE TABLE charges (
	id UUID DEFAULT uuid_generate_v4 (),
	customer_name VARCHAR ( 255 ),
	funding_string VARCHAR ( 255 ),
	job INT,
	description TEXT,
	part UUID,
	part_quantity FLOAT8,
	part_price FLOAT8,
	timestamp TIMESTAMPTZ NOT NULL,
	extended_price FLOAT8,
	cleared BOOL DEFAULT FALSE NOT NULL,
	PRIMARY KEY (id),
	CONSTRAINT fk_job FOREIGN KEY ( job ) REFERENCES jobs(id),
	CONSTRAINT fk_part FOREIGN KEY ( part ) REFERENCES parts(id)
);
