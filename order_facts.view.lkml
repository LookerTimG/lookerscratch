view: order_facts {
  derived_table: {
    explore_source: order_items {
      column: id { field: order_items.order_id }
      column: order_total_amt {}
      column: count {}
      derived_column: order_revenue_rank {
        sql: rank() over(order by total_revenue desc) ;; }
      }
  }
}
