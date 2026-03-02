begin;

create database event_manager;
\c event_manager;

create table tiers (
       id bigserial primary key,
       name text,
       offer_percentage numeric(5,2),
       offer_max(12,2),
       status boolean,
       start_time timestamp default current_timestamp,
       end_time timestamp default current_timestamp,
       constraint c_tier_time check (start_time <= end_time)
);

create table users (
       id bigserial primary key,
       phone text unique not null,
       name text not null,
       password_hash text not null,
       tier bigint,
       history_retrieval timestamp default current_timestamp,
       created timestamp default current_timestamp,
       final_interaction timestamp default current_timestamp,
       constraint fk_user_tier foreign key (tier) references tiers(id)
);

create table wallet (
       id bigint primary key,
       balance numeric(12,2) default 0,
       constraint c_no_debt check (balance >= 0)
);

create table vendors (
       id bigserial primary key,
       name text not null,
       status boolean,
       start_time timestamp default current_timestamp,
       end_time timestamp default current_timestamp,
       constraint c_vendor_time check (start_time <= end_time)
);

create table role (
       id bigserial primary key,
       name text not null,
       status bool
);

create table employees (
       id bigserial primary key,
       name text not null,
       role bigint,
       vendor_id bigint,
       password_hash text,
       status bool,
       start_time timestamp default current_timestamp,
       last_access timestamp default current_timestamp,
       constraint c_employee_time check (start_time <= last_acces),
       constraint fk_emp_role foreign key (role) references role(id),
       constraint fk_emp_vendor foreign key (vendor_id) references vendors(id)
);

create table items (
       id bigserial primary key,
       name text not null,
       vendor_id bigint,
       price numeric(12,2),
       stock bigint,
       status boolean,
       start_time timestamp default current_timestamp,
       end_time timestamp default current_timestamp,
       constraint c_item_time check (start_time <= end_time),
       constraint c_stock check (stock >= 0),
       constraint fk_item_vendor foreign key (vendor_id) references vendors(id)
);

create table item_group (
       id bigserial primary key,
       name text not null,
       vendor_id bigint,
       price numeric(12,2),
       stock bigint,
       status boolean,
       start_time timestamp default current_timestamp,
       end_time timestamp default current_timestamp,
       constraint c_itemgrp_time check (start_time <= end_time),
       constraint c_stock check (stock >= 0),
       constraint fk_itemgrp_vendor foreign key (vendor_id) references vendors(id)
);

create table item_group_detail (
       item_group_id bigint not null,
       item_id bigint not null,
       qty bigint not null,
       constraint c_item_qty check (qty >= 0),
       constraint fk_item_grp_id foreign key item_group_id references item_group(id),
       constraint fk_item_id foreign key item_id references items(id)
);

create index item_grp_id_detail on item_group_detail (item_group_id);

create table promos (
       id bigserial primary key,
       name text not null,
       offer_percentage numeric(5,2) not null,
       offer_max numeric(12,2) not null,
       start_time timestamp default current_timestamp,
       end_time timestamp default current_timestamp,
       constraint c_promo_time check (start_time <= end_time)
);

create table promo_item (
       id bigserial primary key,
       name text not null,
       item_id not null,
       new_price numeric(12,2) not null,
       start_time timestamp default current_timestamp,
       end_time timestamp default current_timestamp,
       constraint c_promoitem_time check (start_time <= end_time),
       constraint fk_promo_item foreign key (item_id) references items(id)
);

create type promo_type as enum ('item','total');

create table transactions (
       id bigserial primary key,
       user_id bigint not null,
       vendor_id bigint not null,
       promo bigint,
       purchase_time timestamp default current_timestamp,
       promo_scope promo_type,
       cost numeric(12,2),
       constraint c_promo_consistency check (
       		  promo is null and promo_scope is null
		  or
		  promo is not null and promo_scope is not null
       ),
       constraint fk_transaction_user foreign key user_id references users(id),
       constraint fk_transaction_vendor foreign key vendor_id references vendors(id)
);

create table history (
       id bigserial primary key,
       transaction_id bigint not null,
       item_id bigint,
       item_group_id bigint,
       qty bigint not null,
       promo bigint,
       cost numeric(12,2),
       constraint c_history_cost check (cost >= 0),
       constraint c_item_item_group_consistency check (
       		  item_id is null and item_group_id is not null
		  or
		  item_id is not null and item_group_id is null
       ),
       constraint c_item_promo_consistency check (promo is null or item_id is not null),
       constraint fk_item_id foreign key item_id references items(id),
       constraint fk_item_group_id foreign key item_group_id references item_group(id),
       constraint fk_item_promo foreign key promo references promo_item(id)
);
