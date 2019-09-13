-- create database  
CREATE DATABASE customer OPTIONS (ANNOTATION 'Customer VDB');
USE DATABASE customer;

-- create translators and connections to source
CREATE FOREIGN DATA WRAPPER postgresql;
CREATE SERVER monolithdb TYPE 'NONE' FOREIGN DATA WRAPPER postgresql;

-- create schema, then import the metadata from the PostgreSQL database
CREATE SCHEMA monolith SERVER monolithdb OPTIONS("VISIBLE" 'false');
CREATE VIRTUAL SCHEMA DataServiceLayer;

SET SCHEMA monolith;
IMPORT FOREIGN SCHEMA public FROM SERVER monolithdb INTO monolith OPTIONS("importer.useFullSchemaName" 'false', "importer.TableTypes" 'TABLE', "importer.importKeys" 'false');

SET SCHEMA DataServiceLayer;

CREATE VIEW customer(
    id integer NOT NULL,
    email string(256) NOT NULL,
    country string(256) NOT NULL,
    CONSTRAINT customer_pk PRIMARY KEY(id)
)
AS
    SELECT
        c.id,
        c.email,
        co.name as country
    FROM
        Monolith.customer c
        inner join Monolith.city as ci on (c.city_id = ci.id)
        inner join Monolith.country as co on (ci.country_id = co.id);
CREATE VIEW details(
    id integer NOT NULL,
    fullname string(256) NOT NULL,
    email string(256) NOT NULL,
    address string(256) NOT NULL,
    member_since date NOT NULL,
    rewards_id string(256) NOT NULL,
    credit_card_number string(256) NOT NULL,
    credit_card_type string(256) NOT NULL,
    expiration_date string(256) NOT NULL,
    CONSTRAINT details_pk PRIMARY KEY(id)
)
AS
    SELECT
        cu.id
        , cu."name" as fullname
        , cu.email
        , cu.address_line_1 || ', ' || ci.name as address
        , member_since
        , rewards_id
        , 'xxxxxxxxxxxx' || RIGHT(p.credit_card_number, 4) as credit_card_number
        , p.credit_card_type
        , FORMATDATE(p.expiration_date, 'MM/yyyy') as expiration_date
    FROM
        Monolith.customer cu 
        INNER JOIN Monolith.city ci ON cu.city_id = ci.id
        INNER JOIN Monolith.payment_info p ON cu.id = p.customer_id;