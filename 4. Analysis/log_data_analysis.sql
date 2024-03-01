--1.sql_overall_usage : 전체 사용자의 사용 비율
--두달 간(총 61일) 며칠 사용되었는가(205p)
with action_day_count_per_user AS(
select user_id, count(distinct event_date) AS action_day_count
from log_db group by user_id)

select action_day_count,
	count(distinct user_id) as user_count,
	
	round(100.0 * count(distinct user_id) 
	/ sum(count(distinct user_id)) over(), 2)
	as composition_ratio,
	
	round(100.0 * sum(count(distinct user_id))
				over(order by action_day_count rows
					between unbounded preceding and current row)
			   / sum(count(distinct user_id)) over(), 2)
			   as cumulative_ratio
from action_day_count_per_user
group by action_day_count
order by action_day_count;


--2.sql_event_types
--각 액션 수와 그 비율(190p)
with stats as(
select count(distinct user_session) as total_uu
from log_db)

select l.event_type,
	count(distinct l.user_session) as action_uu,
	count(1) as action_count,
	s.total_uu,
	round(100.0*count(distinct l.user_session)
		/ s.total_uu, 2) as usage_rate,
	round(
		1.0*count(1) / count(distinct l.user_session), 2)
	as count_per_user

from log_db as l cross join stats as s
group by l.event_type, s.total_uu;

alter table log_db add column price int;


--3.sql_rfm : rfm 분석 테이블
--sql_event_types : 각 액션의 전체 수와 그 비율(226p)
with purchase_log as(
select user_id, price, event_date from log_db
where event_type='purchase')

,user_rfm as(
select user_id,
max(event_date) as recent_date,
date('2023-12-01') - max(event_date) as recency,
count(event_date) as frequency,
sum(price) as monetary
from purchase_log
group by user_id)

, user_rfm_rank as(
select user_id, recent_date, recency, monetary
	,case when recency < 14 then 5
	when recency < 28 then 4
	when recency < 60 then 3
	when recency < 90 then 2
	else 1
	end as r
	
	,case when 20 <= frequency then 5
	when 10 <= frequency then 4
	when 5 <= frequency then 3
	when 2 <= frequency then 2
	when 1 <= frequency then 1
	end as f
	
	,case when 300000 <= monetary then 5
	when 100000 <= monetary then 4
	when 30000 <= monetary then 3
	when 5000 <= monetary then 2
	else 1
	end as m
	
	from user_rfm
)

,mst_rfm_index as(
	select 1 as rfm_index
	union all select 2 as rfm_index
	union all select 3 as rfm_index
	union all select 4 as rfm_index
	union all select 5 as rfm_index)
	
,rfm_flag as(
	select m.rfm_index
	,case when m.rfm_index = r.r then 1 else 0 end as r_flag
	,case when m.rfm_index = r.f then 1 else 0 end as f_flag
	,case when m.rfm_index = r.m then 1 else 0 end as m_flag
	from mst_rfm_index as m
	cross join user_rfm_rank as r
	)

select rfm_index
	, sum(r_flag) as r
	, sum(f_flag) as f
	, sum(m_flag) as m
from rfm_flag
group by rfm_index
order by rfm_index desc;


select * from user_rfm;


