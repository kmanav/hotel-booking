-- create database  
CREATE DATABASE inventory OPTIONS (ANNOTATION 'Inventory VDB');
USE DATABASE inventory;

-- create translators and connections to source
CREATE FOREIGN DATA WRAPPER postgresql;
CREATE SERVER monolithdb TYPE 'NONE' FOREIGN DATA WRAPPER postgresql;

-- create schema, then import the metadata from the PostgreSQL database
CREATE SCHEMA monolith SERVER monolithdb OPTIONS("VISIBLE" 'false');
CREATE VIRTUAL SCHEMA DataServiceLayer;

SET SCHEMA monolith;
IMPORT FOREIGN SCHEMA public FROM SERVER monolithdb INTO monolith OPTIONS("importer.useFullSchemaName" 'false', "importer.TableTypes" 'TABLE', "importer.importKeys" 'false');

SET SCHEMA DataServiceLayer;

CREATE VIEW hotel(
    id integer NOT NULL,
    name string(256) NOT NULL,
    stars decimal NOT NULL,
    email string(256) NOT NULL,
    url string(256) NOT NULL,
    address string(256) NOT NULL,
    city string(256) NOT NULL,
    postal_code string(256) NOT NULL,
    country string(256) NOT NULL,
    CONSTRAINT hotel_pk PRIMARY KEY(id)
)
AS
    SELECT
        h.id,
        h.name,
        h.stars,
        h.email,
        h.url,
        h.address_line_1,
        c.name,
        c.postal_code,
        y.name
    FROM
        Monolith.hotel as h inner join Monolith.city as c on (h.city_id = c.id)
                            inner join Monolith.country as y on (c.country_id = y.id);

CREATE VIEW room(
    id integer NOT NULL,
    hotel_id integer NOT NULL,
    room_number string NOT NULL,
    floor integer NOT NULL,
    rate bigdecimal NOT NULL,
    living_area boolean NOT NULL,
    microwave boolean NOT NULL,
    num_adjoining_rooms integer NOT NULL,
    num_double_beds integer NOT NULL,
    num_king_beds integer NOT NULL,
    num_pets integer NOT NULL,
    num_pullouts integer NOT NULL,
    num_queen_beds integer NOT NULL,
    refrigerator boolean NOT NULL,
    smoking boolean NOT NULL,
    CONSTRAINT room_pk PRIMARY KEY(id)
)
AS
    SELECT
        rm.id,
        rm.hotel_id,
        rm.room_number,
        rm.floor,
        rm.rate,
        rc.living_area,
        rc.microwave,
        rc.num_adjoining_rooms,
        rc.num_double_beds,
        rc.num_king_beds,
        rc.num_pets,
        rc.num_pullouts,
        rc.num_queen_beds,
        rc.refrigerator,
        rc.smoking
    FROM
        Monolith.room rm
          inner join Monolith.room_config as rc on (rm.room_config_id = rc.id);