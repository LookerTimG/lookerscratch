view: native_derived_table {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: order_total_amt {}
      column: count {}
    }
  }
  dimension: user_id {
    type: number
  }
  measure: order_total_amt {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: count {
    type: number
  }
}
