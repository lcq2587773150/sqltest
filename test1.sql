# 1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数
select s.*,sc1.s_score score_01,sc2.s_score score_02 from student s
inner join (select * from score where c_id = 1) sc1 on s.s_id = sc1.s_id
inner join (select * from score where c_id = 2) sc2 on s.s_id = sc2.s_id
where sc1.s_score > sc2.s_score;

# 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数
select s.*,sc1.s_score score_01,sc2.s_score score_02 from student s
inner join (select * from score where c_id = 1) sc1 on s.s_id = sc1.s_id
inner join (select * from score where c_id = 2) sc2 on s.s_id = sc2.s_id
where sc1.s_score < sc2.s_score;

# 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
select s.s_id,s.s_name,avg_score from student s inner join
(select s_id,avg(s_score) avg_score from score group by s_id having avg_score >= 60) t1
on s.s_id = t1.s_id;

# 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩(包括有成绩的和无成绩的)
select s.s_id,s.s_name,ifnull(avg_score,0) from student s left join
(select s_id,avg(s_score) avg_score from score group by s_id) t1
on s.s_id = t1.s_id where avg_score is null or avg_score < 60;

# 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
select s.s_id,s.s_name,ifnull(class,0) class,ifnull(sum_score,0) sum_score from student s left join
(select s_id,count(c_id) class,sum(s_score) sum_score from score group by s_id) t1
on s.s_id = t1.s_id;

# 6、查询"李"姓老师的数量
select count(*) from teacher where t_name like '李%';

# 7、查询学过"张三"老师授课的同学的信息
select * from student where s_id in
(select s_id from score sc inner join (select c_id from course c inner join teacher t on c.t_id = t.t_id
where t_name = '张三')t1 on sc.c_id = t1.c_id);

# 8、查询没学过"张三"老师授课的同学的信息
select * from student where s_id not in
(select s_id from score sc inner join (select c_id from course c inner join teacher t on c.t_id = t.t_id
where t_name = '张三')t1 on sc.c_id = t1.c_id);

# 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
select * from student where s_id in
(select s_id from score where c_id in (1,2) group by s_id having count(*) = 2);

# 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息
select * from student where s_id in
(select s_id from score where c_id = 1 and s_id not in
(select s_id from score where c_id = 2));

# 11、查询没有学全所有课程的同学的信息
select count(1) sum from course;

select s_id from score group by s_id
having count(s_id) = (select count(1) sum from course);

select * from student where s_id not in (select s_id from score
group by s_id having count(s_id) = (select count(1) sum from course));

# 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息
select c_id from score where s_id = 01;
select distinct sc.s_id from student st,score sc
where sc.s_id = st.s_id && sc.c_id
in (select c_id from score where s_id = 01);

select * from student s where s_id in
(select distinct sc.s_id from student st,score sc
where sc.s_id = st.s_id && sc.c_id in (select c_id from score where s_id = 01));

# 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息
select c_id from score where s_id = 01;
select count(c_id) from score where s_id = 01;

select s_id from score sc left join (select c_id from score where s_id = 01) s on s.c_id = sc.c_id
group by s_id having count(s_id) = (select count(c_id) from score where s_id = 01);
select * from student st where s_id in (select s_id from score sc
left join (select c_id from score where s_id = 01) s on s.c_id = sc.c_id
group by s_id having count(s_id) = (select count(c_id) from score where s_id = 01));

# 14、查询没学过"张三"老师讲授的任一门课程的学生姓名
select st.s_name from student st left join
(select st.*, t_name from student st, score sc,course c, teacher t
where sc.s_id = st.s_id && c.c_id = sc.c_id && c.t_id = t.t_id && t_name = '张三') s
on s.s_id = st.s_id
where s.s_id is null;

# 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select s_id from score sc where sc.s_score < 60 group by s_id having count(s_id) >= 2;

select st.s_id, s_name, avg(s_score) from score sc,student st
where sc.s_id = st.s_id && sc.s_score < 60
group by st.s_id
having count(st.s_id) >= 2;

# 16、检索"01"课程分数小于60，按分数降序排列的学生信息
select st.* from student st left join score sc
on sc.s_id = st.s_id && sc.c_id = 01
where ifnull(sc.s_score, 0) < 60
order by s_id desc;

# 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
select s_id, avg(ifnull(s_score, 0)) from score group by s_id;
select st.s_id, s_name, c_name, s_score, avg from student st, score sc, course c,
(select s_id, avg(ifnull(s_score, 0)) avg from score group by s_id) s
where st.s_id = sc.s_id && sc.c_id = c.c_id && s.s_id = st.s_id
order by avg desc;

# 18、查询各科成绩最高分、最低分和平均分，以如下形式显示：
# 课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
# – 及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
select c.c_id, c_name, max(s_score), min(s_score), avg(s_score) from student st,score sc,course c
where sc.s_id = st.s_id && sc.c_id = c.c_id
group by c.c_id;

# 19、按各科成绩进行排序，并显示排名
select c_id, s_score, row_number() over (partition by c_id order by s_score desc ) `row_number` from score;

# 20、查询学生的总成绩并进行排名
select s_id, sum(s_score) from score group by s_id;
select s.s_id, s_name, ifnull(t.scores, 0) from student s
left join (select s_id, sum(s_score) scores from score
group by s_id) t on s.s_id = t.s_id
order by t.scores desc;