view: order_facts {
  derived_table: {
    datagroup_trigger: order_facts_dg
    distribution: "user_id"
    sortkeys: ["user_id"]
    explore_source: order_items {
      column: id { field: order_items.order_id }
      column: order_total_amt {}
      column: count {}
      derived_column: order_revenue_rank {
        sql: rank() over(order by order_total_amt desc) ;; }
      }
  }

  dimension: id {
    type: number
  }

  dimension: order_total_amt {
    type: number
    value_format: "$#,##0.00"
  }

  dimension: count {
    type: number
  }

  dimension: order_revenue_rank {
    type:  number
  }

}
