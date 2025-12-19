create table food_material
(
    id              int auto_increment
        primary key,
    name            varchar(255)                        not null,
    category        varchar(100)                        null,
    add_time        timestamp default CURRENT_TIMESTAMP null,
    quantity        int                                 null,
    expiration_time timestamp                           null,
    avatar          varchar(255)                        null,
    comment         varchar(150)                        null,
    constraint name
        unique (name)
);

create table menu
(
    id          int auto_increment
        primary key,
    user_id     int                                 not null,
    title       varchar(255)                        not null,
    description text                                null,
    avatar      varchar(255)                        null,
    comment     varchar(500)                        null,
    created_at  timestamp default CURRENT_TIMESTAMP null,
    updated_at  timestamp default CURRENT_TIMESTAMP null
);

create table menu_food
(
    id            int auto_increment
        primary key,
    menu_id       int not null,
    ingredient_id int not null
);



