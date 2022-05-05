create table if not exists item
(
    id   serial
        constraint item_pk
            primary key,
    name text
);

alter table item
    owner to "user";

