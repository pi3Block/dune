class ChangeTimeRangeOnCanCancelFuction < ActiveRecord::Migration

  def up
    execute "
    drop function can_cancel(contributions);
    create function can_cancel(contributions) returns boolean as $$
        select
          $1.state = 'waiting_confirmation' and
          (
            (
              select count(1) as total_of_days
              from generate_series($1.created_at::date, current_date, '1 day') day
              WHERE extract(dow from day) not in (0,1)
            )  > 6
          )
      $$ language sql

    "
  end

  def down
    execute "
      drop function can_cancel(contributions);
      create function can_cancel(contributions) returns boolean as $$
        select
          $1.state = 'waiting_confirmation' and
          (
            ((
              select count(1) as total_of_days
              from generate_series($1.created_at::date, current_date, '1 day') day
              WHERE extract(dow from day) not in (0,1)
            )  > 4)
            OR
            (
              lower($1.payment_choice) = lower('DebitoBancario')
              AND
                (
                  select count(1) as total_of_days
                  from generate_series($1.created_at::date, current_date, '1 day') day
                  WHERE extract(dow from day) not in (0,1)
                )  > 1)
          )
      $$ language sql
    "
  end
end
