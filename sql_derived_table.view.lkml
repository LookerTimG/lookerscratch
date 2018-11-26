view: sql_derived_table {
  derived_table: {
    sql: WITH mCTE
    AS (SELECT order_items.user_id as user_id
          , COUNT(distinct order_items.order_id) as lifetime_order_count
          , SUM(order_items.sale_price) as lifetime_revenue
          , MIN(order_items.created_at) as first_order_date
          , MAX(order_items.created_at) as latest_order_date
      FROM order_items
      WHERE {% condition order_date %} order_items.created_at {% endcondition %}
      GROUP BY user_id
      )
      SELECT user_id
        , lifetime_order_count
        , lifetime_revenue
        , first_order_date
        , latest_order_date
      FROM mCTE
      WHERE lifetime_revenue >= {% parameter minimum_lifetime_revenue %}
       ;;
      datagroup_trigger: order_facts_dg
      distribution: "user_id"
      sortkeys: ["user_id"]
  }

  filter: order_date {
    label: "Orders after date"
    type: date
  }

  parameter: minimum_lifetime_revenue {
    description: "Use with the retail price field"
    type: unquoted
    allowed_value: {
      label: "$1.00"
      value: "1.00"
    }
    allowed_value: {
      label: "$10.00"
      value: "10.00"
    }
    allowed_value: {
      label: "$100.00"
      value: "100.00"
    }
    allowed_value: {
      label: "$1000.00"
      value: "1000.00"
    }
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
    value_format: "$#,##0.00"
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order_date {
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_date_time, latest_order_date_time]
  }
}
