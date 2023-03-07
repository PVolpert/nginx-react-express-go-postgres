#!/bin/bash
set -e

source /run/secrets/db-env

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE DATABASE $webapp_dbname;
  CREATE USER $api_name WITH PASSWORD '$api_pw';
EOSQL


psql -v ON_ERROR_STOP=1 --dbname "$webapp_dbname"<<-EOSQL
	CREATE TABLE meals (
    id varchar(5) PRIMARY KEY ,
    name varchar(20),
    description text,
    price numeric(1000,2)
);


INSERT INTO meals
WITH mealsJSON As (
SELECT '[
    {
      "id": "m1",
      "name": "Sushi",
      "description": "Finest fish and veggies",
      "price": 22.99
    },
    {
      "id": "m2",
      "name": "Schnitzel",
      "description": "A german specialty!",
      "price": 16.5
    },
    {
      "id": "m3",
      "name": "Barbecue Burger",
      "description": "American, raw, meaty",
      "price": 12.99
    },
    {
      "id": "m4",
      "name": "Green Bowl",
      "description": "Healthy...and green...",
      "price": 18.99
    }
  ]'::jsonb as start_values ),
mealRowsJSON as
(SELECT meal
FROM mealsJSON as mJ,jsonb_array_elements(mJ.start_values) as meal
)
SELECT meal ->> 'id' as id, meal ->> 'name' as name, meal ->> 'description' as description, (meal ->> 'price')::numeric as price
FROM  mealRowsJSON;

CREATE FUNCTION mealsAsJSON () returns jsonb AS
\$\$
    WITH mealObjects as
    (SELECT id,row_to_json(meals)  as object
    FROM meals),
    mealArray AS
    (SELECT array_agg(object order by id) as mealsArr
    FROM mealObjects)
    SELECT array_to_json(mealArray.mealsArr)::jsonb
    FROM mealArray
\$\$ LANGUAGE sql IMMUTABLE;
GRANT EXECUTE ON FUNCTION mealsAsJSON() TO $api_name;
GRANT SELECT ON TABLE meals TO $api_name;
EOSQL