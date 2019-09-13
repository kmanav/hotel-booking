-- create database  
CREATE DATABASE reservation OPTIONS (ANNOTATION 'Reservation VDB');
USE DATABASE reservation;

-- create translators and connections to source
CREATE FOREIGN DATA WRAPPER postgresql;
CREATE SERVER monolithdb TYPE 'NONE' FOREIGN DATA WRAPPER postgresql;

-- create schema, then import the metadata from the PostgreSQL database
CREATE SCHEMA monolith SERVER monolithdb OPTIONS("VISIBLE" 'false');
CREATE VIRTUAL SCHEMA DataServiceLayer;

SET SCHEMA monolith;
IMPORT FOREIGN SCHEMA public FROM SERVER monolithdb INTO monolith OPTIONS("importer.useFullSchemaName" 'false', "importer.TableTypes" 'TABLE', "importer.importKeys" 'false');

SET SCHEMA DataServiceLayer;

CREATE VIEW reservation(
    id string(256) NOT NULL,
    customer_id integer NOT NULL,
    hotel_name string(256) NOT NULL,
    hotel_city string(256) NOT NULL,
    hotel_country string(256) NOT NULL,
    checkin date NOT NULL,
    checkout date NOT NULL,
    status string(256) NOT NULL,
    CONSTRAINT user_pk PRIMARY KEY(id)
) OPTIONS(UPDATABLE 'TRUE')
AS
    SELECT
        r.id,
        r.customer_id,
        h.name,
        hc.name,
        hy.name,
        r.checkin,
        r.checkout,
        r.status
    FROM
        monolith.reservation as r
        inner join monolith.room rm on (r.room_id = rm.id)
      	inner join monolith.hotel as h on (rm.hotel_id = h.id)
      	inner join monolith.city as hc on (h.city_id = hc.id)
      	inner join monolith.country as hy on (hc.country_id = hy.id);

CREATE TRIGGER ON "DataServiceLayer.reservation" INSTEAD OF UPDATE AS 
FOR EACH ROW
BEGIN ATOMIC
    IF(CHANGING.status)
    BEGIN
        UPDATE monolith.reservation SET status = "NEW".status WHERE id = "OLD".id;
    END
END;

CREATE VIEW source_reservation(
    id string(256) NOT NULL,
    customer_id integer NOT NULL,
    room_id integer NOT NULL,
    checkin date NOT NULL,
    checkout date NOT NULL,
    daily_rate bigdecimal NOT NULL,
    status string(256) NOT NULL,
    CONSTRAINT source_reservation_pk PRIMARY KEY(id)
) OPTIONS(UPDATABLE 'TRUE')
AS
    SELECT
        id, customer_id, room_id, checkin, checkout, daily_rate, status
    FROM
        monolith.reservation as r;
        
CREATE VIEW reservation_full(
    id string(256) NOT NULL,
    checkin date NOT NULL,
    checkout date NOT NULL,
    daily_rate bigdecimal NOT NULL,
    status string(256) NOT NULL,
    cust_name string(256) NOT NULL,
    cust_email string(256) NOT NULL,
    cust_member_since date NOT NULL,
    cust_rewards_id string(256) NOT NULL,
    cust_address string(256) NOT NULL,
    cust_city string(256) NOT NULL,
    cust_postal_code string(256) NOT NULL,
    cust_country string(256) NOT NULL,
    hotel_name string(256) NOT NULL,
    hotel_address string(256) NOT NULL,
    hotel_city string(256) NOT NULL,
    hotel_postal_code string(256) NOT NULL,
    hotel_country string(256) NOT NULL,
    room_number string(256) NOT NULL,
    room_floor integer NOT NULL,
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
    CONSTRAINT reservation_pk PRIMARY KEY(id)
)
AS
    SELECT
        r.id,
        r.checkin,
        r.checkout,
        r.daily_rate,
        r.status,
        c.name,
        c.email,
        c.member_since,
        c.rewards_id,
        c.address_line_1,
        cc.name,
        cc.postal_code,
        cy.name,
        h.name,
        h.address_line_1,
        hc.name,
        hc.postal_code,
        hy.name,
        rm.room_number,
        rm.floor,
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
        monolith.reservation as r inner join monolith.customer as c on (r.customer_id = c.id)
          inner join monolith.city as cc on (c.city_id = cc.id)
          inner join monolith.country as cy on (cc.country_id = cy.id)
          inner join monolith.room rm on (r.room_id = rm.id)
          inner join monolith.room_config as rc on (rm.room_config_id = rc.id)
          inner join monolith.hotel as h on (rm.hotel_id = h.id)
          inner join monolith.city as hc on (h.city_id = hc.id)
          inner join monolith.country as hy on (hc.country_id = hy.id);