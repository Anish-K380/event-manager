begin;

create database event_manager;
\c event_manager;

create table tiers (
       id bigserial primary key,
       name text not null,
       offer_percentage numeric(5,2),
       offer_max numeric(12,2),
       status boolean not null,
       start_time timestamp default current_timestamp,
       end_time timestamp default current_timestamp,
       constraint c_tier_time check (start_time <= end_time)
);

create table users (
       username text primary key,
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
       id text primary key,
       balance numeric(12,2) default 0,
       constraint c_wallet_negative check (balance >= 0),
       constraint fk_no_duplicate foreign key (id) references users(username)
);

create table vendors (
       id bigserial primary key,
       name text not null,
       status boolean not null,
       start_time timestamp default current_timestamp,
       end_time timestamp default current_timestamp,
       constraint c_vendor_time check (start_time <= end_time)
);

create table role (
       id bigserial primary key,
       name text not null,
       status bool not null
);

create table employees (
       id bigserial primary key,
       name text not null,
       role bigint,
       vendor_id bigint not null,
       password_hash text not null,
       status bool not null,
       start_time timestamp default current_timestamp,
       last_access timestamp default current_timestamp,
       constraint c_employee_time check (start_time <= last_access),
       constraint fk_emp_role foreign key (role) references role(id),
       constraint fk_emp_vendor foreign key (vendor_id) references vendors(id)
);

create table items (
       id bigserial primary key,
       name text not null,
       vendor_id bigint not null,
       price numeric(12,2) not null,
       stock bigint not null,
       status boolean not null,
       start_time timestamp default current_timestamp,
       end_time timestamp default current_timestamp,
       constraint c_item_time check (start_time <= end_time),
       constraint c_stock check (stock >= 0),
       constraint fk_item_vendor foreign key (vendor_id) references vendors(id)
);

create table item_group (
       id bigint primary key,
       constraint fk_item_group_id foreign key (id) references items(id)
);

create table single_items (
       id bigint primary key,
       constraint fk_item_id foreign key (id) references items(id)
);

create table item_group_detail (
       item_group_id bigint not null,
       item_id bigint not null,
       qty bigint not null,
       constraint c_item_qty check (qty > 0),
       constraint fk_item_grp_id foreign key (item_group_id) references item_group(id),
       constraint fk_item_id foreign key (item_id) references single_items(id)
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
       item_id bigint not null,
       new_price numeric(12,2) not null,
       start_time timestamp default current_timestamp,
       end_time timestamp default current_timestamp,
       constraint c_promoitem_time check (start_time <= end_time),
       constraint fk_promo_item foreign key (item_id) references items(id)
);

create type promo_type as enum ('item','total');

create table transactions (
       id bigserial primary key,
       user_id text not null,
       vendor_id bigint not null,
       promo bigint,
       purchase_time timestamp default current_timestamp,
       promo_scope promo_type,
       cost numeric(12,2) not null,
       constraint c_promo_consistency check (
       		  (promo is null and promo_scope is null)
		  or
		  (promo is not null and promo_scope is not null)
       ),
       constraint fk_transaction_user foreign key (user_id) references users(username),
       constraint fk_transaction_vendor foreign key (vendor_id) references vendors(id)
);

create index transaction_user on transactions (user_id);

create table history (
       transaction_id bigint not null,
       item_id bigint not null,
       qty bigint not null,
       promo bigint,
       cost numeric(12,2) not null,
       constraint c_history_cost check (cost >= 0),
       constraint c_item_promo_consistency check ((promo is null) or (item_id is not null)),
       constraint fk_history_transaction_id foreign key (transaction_id) references transactions (id),
       constraint fk_item_id foreign key (item_id) references items(id),
       constraint fk_item_promo foreign key (promo) references promo_item(id),
       primary key (transaction_id,item_id)
);

create index transaction_history on history (transaction_id);

create table topup_offer (
       id bigserial primary key,
       name text not null,
       new_points numeric(12,2) not null,
       start_time timestamp default current_timestamp,
       end_time timestamp default current_timestamp,
       constraint c_topupoffer_time check (start_time <= end_time)
);

create type payment_mode as enum ('netbanking', 'card', 'upi', 'cash');

create type transaction_status as enum ('success', 'pending', 'failure', 'cancelled');

create table topup (
       id bigserial primary key,
       user_id text not null,
       mode payment_mode not null,
       status transaction_status not null,
       transaction_time timestamp default current_timestamp,
       cost numeric(12,2) not null,
       auth bigint,
       points numeric(12,2) not null,
       offer_id bigint,
       reference_id text,
       constraint c_auth check ((mode <> 'cash') or (auth is not null)),
       constraint c_reference check ((mode = 'cash') or (reference_id is not null)),
       constraint fk_topup_user foreign key (user_id) references users(id),
       constraint fk_topup_offer foreign key (offer_id) references topup_offer(id),
       constraint fk_topup_auth foreign key (auth) references employees(id)
);

create index topup_user_id on topup (user_id);

create type wallet_alter as enum ('topup', 'purchase', 'refund');

create table ledger (
       id bigserial primary key,
       reference_id bigint not null,
       user_id text not null,
       alter_type wallet_alter not null,
       change numeric(12,2) not null,
       change_time timestamp default current_timestamp,
       constraint ledger_user foreign key (user_id) references users(username),
       constraint no_change check (change <> 0),
       constraint change_positive check ((change < 0) or (alter_type in ('topup', 'refund'))),
       constraint change_negative check ((change > 0) or (alter_type = 'purchase'))
);

create index ledger_user_id on ledger (user_id);

create table wastage (
       id bigserial primary key,
       item_id bigint not null,
       qty bigint not null,
       employee_id bigint not null,
       remarks text,
       wastage_time timestamp default current_timestamp,
       constraint c_wastage_qty check (qty > 0),
       constraint fk_wastage_item foreign key (item_id) references items(id),
       constraint fk_wastage_auth foreign key (employee_id) references employees(id)
);

create table refund (
       id bigserial primary key,
       user_id text not null,
       item_id bigint not null,
       qty bigint not null,
       employee_id bigint not null,
       remarks text,
       refund_time timestamp default current_timestamp,
       constraint c_refund_qty check (qty > 0),
       constraint fk_refund_user foreign key (user_id) references users(username),
       constraint fk_refund_item foreign key (item_id) references items(id),
       constraint fk_refund_auth foreign key (employee_id) references employees(id)
);

create index refund_user_id on refund (user_id);

commit;
