view: order_items {
  sql_table_name: public.order_items ;;

  parameter: select_measure_type_parameter {
    label: "Select A Measure"
    type: string
    default_value: "Total Revenue"
    allowed_value: {
      label: "Total Revenue"     value: "Total Revenue"
      }
    allowed_value: {
      label: "Order Count"     value: "Order Count"
      }
    allowed_value: {
      label: "Average Sale Price"     value: "Average Sale Price"
      }
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: order_total_amt {
    type: sum
    sql: ${sale_price} ;;
    value_format: "$#,##0.00"
  }

  measure: total_revenue {
    type: number
    sql: ${order_total_amt} ;;
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format: "$#,##0.00"
  }

  measure: order_count {
    type:  count_distinct
    sql: ${order_id} ;;
  }

  measure: count_of_selected_measure_type {
    label_from_parameter: select_measure_type_parameter
    type: number
    sql: case
    when {% parameter select_measure_type_parameter %} = 'Total Revenue' then
    ${total_revenue}
    when {% parameter select_measure_type_parameter %} = 'Order Count' then
    ${order_count}
    when {% parameter select_measure_type_parameter %} = 'Average Sale Price' then
    ${average_sale_price}
    end
    ;;
    value_format_name: decimal_0
    }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
