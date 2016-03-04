class CreateOrderSearchMatview < ActiveRecord::Migration
  def up
    execute <<-SQL
    CREATE MATERIALIZED VIEW order_search_matview AS
    SELECT 
    o.id AS pg_search_id,
    o.created_at AS created_at,
    o.firstname AS firstname,
    o.lastname AS lastname,
    o.email AS email,
    o.address1 AS address1,
    o.address2 AS address2,
    o.city AS city,
    o.state AS state,
    o.search_body AS search_body,
    array_to_string(array_agg(op.product_id),',') AS pid,
    array_to_string(array_agg(p.name), ',') AS pname
    FROM orders o
    INNER JOIN orderproducts op ON op.order_id = o.id
    INNER JOIN products p ON op.product_id = p.id
    GROUP BY o.id 
    Order By o.id desc;

    CREATE UNIQUE INDEX order_search_id
      ON order_search_matview(pg_search_id);
    SQL
  end

  def down
    DROP MATERIALIZED VIEW IF EXISTS order_search_matview
  end
end
