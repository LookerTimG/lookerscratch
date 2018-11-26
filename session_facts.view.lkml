view: session_facts {
  derived_table: {
    sql: WITH session_facts AS (
      SELECT
      session_id
      ,COALESCE(user_id::varchar, ip_address) as identifier
      ,FIRST_VALUE (created_at) OVER (PARTITION BY session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED   PRECEDING AND UNBOUNDED FOLLOWING) AS session_start
      ,LAST_VALUE (created_at) OVER (PARTITION BY session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_end
      ,FIRST_VALUE (event_type) OVER (PARTITION BY session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_landing_page
      ,LAST_VALUE  (event_type) OVER (PARTITION BY session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_exit_page
      FROM events
      -- WHERE {% condition session_start_date %} created_at {% endcondition %}
       )
       SELECT sf.*
            , e.created_at
        FROM session_facts sf
        INNER JOIN events e
        ON sf.session_id = e.session_id
       GROUP BY 1, 2, 3, 4, 5, 6, 7
    ;;
  }

  parameter: time_type {
    type: unquoted
    default_value: "day"
    allowed_value: {
      label: "Days"
      value: "day"
      }
      allowed_value: {
        label: "Weeks"
        value: "week"
        }
    }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: created_at {
    type: date
  }

  dimension: time_in_funnel {
    type: number
    sql: datediff( {% parameter time_type %}, ${created_at}, GETDATE()) ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: identifier {
    type: string
    sql: ${TABLE}.identifier ;;
  }

  dimension_group: session_start {
    type: time
    sql: ${TABLE}.session_start ;;
  }

  dimension_group: session_end {
    type: time
    sql: ${TABLE}.session_end ;;
  }

  dimension: session_landing_page {
    type: string
    sql: ${TABLE}.session_landing_page ;;
  }

  dimension: session_exit_page {
    type: string
    sql: ${TABLE}.session_exit_page ;;
  }

  set: detail {
    fields: [
      session_id,
      identifier,
      session_start_time,
      session_end_time,
      session_landing_page,
      session_exit_page
    ]
  }
}
