/*1. Có bao nhiêu khách hàng có ở Quảng Nam thuộc chi nhánh ngân hàng Vietcombank Đà Nẵng*/

select br.br_name, count(cus.cust_id)
from customer cus join branch br on cus.br_id=br.br_id
where cus.cust_ad like '%QUẢNG NAM' and br.br_name like '%Đà Nẵng%'
group by br.br_name;

-- select count(cus.cust_id)
-- from customer cus
-- where cus.cust_ad like '%QUẢNG NAM' 

/*=========================================================================*/

/*2. Hiển thị danh sách khách hàng thuộc chi nhánh Vũng Tàu và số dư trong tài khoản của họ.*/

select cus.cust_id, cust_name, sum(ac_balance)
from customer cus join account ac on cus.cust_id = ac.cust_id join branch br on cus.br_id = br.br_id
where br_name like '%Vũng Tàu'
group by cust_id;

/*=========================================================================*/

/*3. Trong quý 1 năm 2012, có bao nhiêu khách hàng thực hiện giao dịch rút tiền tại Ngân hàng Vietcombank?*/

select count(*) 'Số khách hàng rút tiền trong quý 1 năm 2012'
from customer cus join account ac on cus.cust_id = ac.cust_id join transactions t on ac.ac_no = t.ac_no
where t.t_date between '2012/01/01' and '2012/03/31' and t_type=0;

/*=========================================================================*/

/*4. Thống kê số lượng giao dịch, tổng tiền giao dịch trong từng tháng của năm 2014*/

select month(t_date)'Tháng', count(t_id) 'Số lượng giao dịch', sum(t_amount) 'Tổng tiền giao dịch'
from transactions
where year(t_date)=2014
group by month(t_date)
order by month(t_date);

/*==========================================================================*/

/*5. Thống kê tổng tiền khách hàng gửi của mỗi chi nhánh, sắp xếp theo thứ tự giảm dần của tổng tiền*/

select cus.br_id 'Mã chi nhánh', br_name 'Tên chi nhánh', sum(t_amount) 'Tổng tiền gửi'
from customer cus join account ac on cus.cust_id = ac.cust_id join branch br on cus.br_id=br.br_id join transactions t on ac.ac_no=t.ac_no
where t_type=1
group by cus.br_id
order by sum(t_amount) desc;

/*===========================================================================*/

/*6. Chi nhánh Sài Gòn có bao nhiêu khách hàng không thực hiện bất kỳ giao dịch nào trong vòng 3 năm trở lại đây. Nếu có thể, hãy hiển thị tên và số điện thoại của các khách đó để phòng marketing xử lý.*/

select count(*) 'Khách hàng không thực hiện giao dịch trong 3 năm gần đây'
from customer c join branch br on c.br_id=br.br_id
where br_name like '%Sài Gòn'
and c.cust_id not in 
					(select cus.cust_id
					from customer cus join account ac on cus.cust_id = ac.cust_id join branch br on cus.br_id=br.br_id join transactions t on ac.ac_no=t.ac_no
					where br_name like '%Sài Gòn'
					and (year(curdate()))-year(t_date)=3)
group by c.cust_id;

select c.cust_id 'Mã khách hàng', cust_name 'Tên khách hàng'
from customer c join branch br on c.br_id=br.br_id
where br_name like '%Sài Gòn'
and c.cust_id not in 
					(select cus.cust_id
					from customer cus join account ac on cus.cust_id = ac.cust_id join branch br on cus.br_id=br.br_id join transactions t on ac.ac_no=t.ac_no
					where br_name like '%Sài Gòn'
					and (year(curdate()))-year(t_date)=3);

/*=============================================================================*/

/*7. Thống kê thông tin giao dịch theo mùa, nội dung thống kê gồm: số lượng giao dịch, lượng tiền giao dịch trung bình, tổng tiền giao dịch, lượng tiền giao dịch nhiều nhất, lượng tiền giao dịch ít nhất.*/

select 
	(case quarter(t_date)
		when 1 then 'Xuân'
        when 2 then 'Hạ'
        when 3 then 'Thu'
        when 4 then 'Đông'
	end) as Season,
    count(t_id) 'Số lượng giao dịch',
    avg(t_amount) 'Lượng tiền giao dịch trung bình',
    sum(t_amount) 'Tổng tiền giao dịch',
    max(t_amount) 'Lượng tiền giao dịch nhiều nhất',
    min(t_amount) 'Lượng tiền giao dịch ít nhất'
from transactions
group by Season;

/*=============================================================================*/

/*8. Tìm số tiền giao dịch nhiều nhất trong năm 2016 của chi nhánh Huế. Nếu có thể, hãy đưa ra tên của khách hàng thực hiện giao dịch đó.*/

select cus.cust_id 'Mã khách hàng', cust_name 'Tên khách hàng',t_id 'Mã giao dịch', t_amount 'Số tiền'
from customer cus join branch br on cus.br_id=br.br_id join account ac on cus.cust_id=ac.cust_id join transactions t on ac.ac_no=t.ac_no
where (t_date between '2016/01/01' and '2016/12/31') and br_name like '%Huế'
	and t_amount >= all
			(select t_amount
			from customer cus join branch br on cus.br_id=br.br_id join account ac on cus.cust_id=ac.cust_id join transactions t on ac.ac_no=t.ac_no
			where (t_date between '2016/01/01' and '2016/12/31') and br_name like '%Huế');

/*=============================================================================*/

/*9. Tìm khách hàng có lượng tiền gửi nhiều nhất vào ngân hàng trong năm 2017 (nhằm mục đích tri ân khách hàng)*/

select c.cust_id'Mã khách hàng',cust_name'Tên khách hàng', sum(t_amount) 'Số tiền'
from customer c join account ac on c.cust_id=ac.cust_id join transactions t on ac.ac_no=t.ac_no
where (t_date between '2017/01/01' and '2017/12/31') and t_type=1
group by c.cust_id
having sum(t_amount)>= all
					(select sum(t_amount)
					from customer c join account ac on c.cust_id=ac.cust_id join transactions t on ac.ac_no=t.ac_no
					where (t_date between '2017/01/01' and '2017/12/31') and t_type=1
					group by c.cust_id);
/*=============================================================================*/

/*10. Tìm những khách hàng có cùng chi nhánh với ông Phan Nguyên Anh*/

select cust_id 'Mã khách hàng', cust_name 'Tên khách hàng'
from customer
where br_id = 
			(select br_id
			from customer
			where cust_name = 'Phan Nguyên Anh')
and cust_name <>'Phan Nguyên Anh';
/*=============================================================================*/

/*11. Liệt kê những giao dịch thực hiện cùng giờ với giao dịch của ông Lê Nguyễn Hoàng Văn ngày 2016-12-02*/
select t_id 'Mã giao dịch', t_type 'Loại', t_amount'Số tiền', cust_name 'Tên khách hàng', a.ac_no'Số tài khoản'
from transactions t join account a on t.ac_no=a.ac_no join customer c on  c.cust_id=a.cust_id
where cust_name<>'Lê Nguyễn Hoàng Văn'
and t_time=
			(select t_time
			from transactions t join account a on t.ac_no=a.ac_no join customer c on  c.cust_id=a.cust_id
			where cust_name = 'Lê Nguyễn Hoàng Văn' and t_date='2016/12/02');

/*=============================================================================*/

/*12. Hiển thị danh sách khách hàng ở cùng thành phố với Trần Văn Thiện Thanh*/

select cust_id'Mã khách hàng', cust_name'Tên khách hàng', right(cust_ad,locate(',',reverse(cust_ad))-2) 'Tỉnh/ Thành phố', cust_ad 'Địa chỉ'
from customer
where cust_name <> 'Trần Văn Thiện Thanh'
and right(cust_ad,locate(',',reverse(cust_ad))-2)=
													(select right(cust_ad,locate(',',reverse(cust_ad))-2)
													from customer
													where cust_name='Trần Văn Thiện Thanh');
SELECT
  name,
  LOCATE(REGEXP('[0-9]', name), 1) AS position
FROM
  customers;                                                
/*=============================================================================*/

/*13. Tìm những giao dịch diễn ra cùng ngày với giao dịch có mã số 0000000217*/

select t_id'Mã giao dịch', t_type'Loại', t_amount'Số tiền', t_date 'Ngày'
from transactions
where t_id<>'0000000217'
and day(t_date) = 
		(select day(t_date)
		from transactions
		where t_id='0000000217');
        
/*=============================================================================*/

/*14. Tìm những giao dịch cùng loại với giao dịch có mã số 0000000387*/

select t_id 'Mã giao dịch',t_amount'Số tiền', ac_no'Số tài khoản',t_date'Ngày', t_time'Thời gian'
from transactions
where t_id<>'0000000387'
and t_type=
		(select t_type
		from transactions
		where t_id='0000000387');
        
/*=============================================================================*/

/*15. Những chi nhánh nào thực hiện nhiều giao dịch gửi tiền trong tháng 12/2015 hơn chi nhánh Đà Nẵng*/

select b.br_id'Mã chi nhánh', br_name'Tên chi nhánh',count(t_id)
from transactions t join account a on t.ac_no=a.ac_no
					join customer c on a.cust_id=c.cust_id
                    join branch b on c.br_id=b.br_id
where (t_date between '2015/12/01' and '2015/12/31') and t_type=1 
group by b.br_id
having count(t_id)>
				(select count(t_id)
				from transactions t join account a on t.ac_no=a.ac_no
									join customer c on a.cust_id=c.cust_id
									join branch b on c.br_id=b.br_id
				where (t_date between '2015/12/01' and '2015/12/31') and t_type=1 and br_name like '%Đà Nẵng');
                
/*=============================================================================*/

/*16. Hãy liệt kê những tài khoản trong vòng 6 tháng trở lại đây không phát sinh giao dịch*/

select ac_no, cust_id, sum(ac_balance) 'Số dư'
from account
where ac_no not in
				(select ac_no
                from transactions
                where year(t_date)=year(curdate()) and month(curdate()) - month(t_date)=6)
group by ac_no;

/*=============================================================================*/

/*17. Ông Phạm Duy Khánh thuộc chi nhánh nào? Từ 01/2017 đến nay ông Khánh đã thực hiện bao nhiêu giao dịch gửi tiền vào ngân hàng với tổng số tiền là bao nhiêu.*/

select cust_name, br_name,count(t_id), sum(t_amount)
from transactions t join account a on t.ac_no=a.ac_no
					join customer c on a.cust_id=c.cust_id
                    join branch b on c.br_id=b.br_id
where cust_name='Phạm Duy Khánh' and t_type=1 and (t_date between '2017/01/01' and curdate())
group by cust_name,br_name;

/*=============================================================================*/

/*18. Thống kê giao dịch theo từng năm, nội dung thống kê gồm: số lượng giao dịch, lượng tiền giao dịch trung bình*/

select year(t_date), count(t_id), avg(t_amount)
from transactions
group by year(t_date)
order by year(t_date);

/*=============================================================================*/

/*19. Thống kê số lượng giao dịch theo ngày và đêm trong năm 2017 ở chi nhánh Hà Nội, Sài Gòn*/

select 
	(case
		when t_time between '06:00' and '18:00' then 'Ngày'
		when (t_time between '18:00' and '24:00') or (t_time between '00:00' and '06:00') then 'Đêm'
	end) as Buoi,
    count(t_id)'Số lượng giao dịch'
from transactions t join account a on t.ac_no=a.ac_no
					join customer c on a.cust_id=c.cust_id
                    join branch b on c.br_id=b.br_id
where (br_name like 'Hà Nội' or br_name like 'Sài Gòn')
and year(t_date)=2017
group by Buoi;

/*=============================================================================*/

/*20. Hiển thị danh sách khách hàng chưa thực hiện giao dịch nào trong năm 2017?*/

select cust_id, cust_name
from customer
where cust_id not in
				(select c.cust_id
				from transactions t join account a on t.ac_no=a.ac_no
									join customer c on a.cust_id=c.cust_id
				where t_date between '2017/01/01' and '2017/12/31');
                
/*=============================================================================*/

/*21. Hiển thị những giao dịch trong mùa xuân của các chi nhánh miền trung. Gợi ý: giả sử một năm có 4 mùa, mỗi mùa kéo dài 3 tháng; chi nhánh miền trung có mã chi nhánh bắt đầu bằng VT.*/

select t_id, t_amount, t_time, t_date
from transactions t join account a on t.ac_no=a.ac_no
					join customer c on a.cust_id=c.cust_id
where c.br_id like 'VT%' and (month(t_date) between 1 and 3);

/*=============================================================================*/

/*22. Hiển thị họ tên và các giao dịch của khách hàng sử dụng số điện thoại có 3 số đầu là 093 và 2 số cuối là 02.*/

select c.cust_id, cust_name,t_id, t_amount, t_time, t_date
from transactions t join account a on t.ac_no = a.ac_no
					join customer c on a.cust_id=c.cust_id
where cust_phone like '093%02';

/*=============================================================================*/

/*23. Hãy liệt kê 2 chi nhánh làm việc kém hiệu quả nhất trong toàn hệ thống (số lượng giao dịch gửi tiền ít nhất) trong quý 3 năm 2017*/

select b.br_id, br_name, count(t_id)
from transactions t join account a on t.ac_no=a.ac_no
					join customer c on a.cust_id=c.cust_id
                    join branch b on c.br_id=b.br_id
where t_type=1 and (t_date between '2017/07/01' and '2017/09/30')
group by b.br_id
order by count(t_id)
limit 2;

/*=============================================================================*/

/*24. Hãy liệt kê 2 chi nhánh có bận mải nhất hệ thống (thực hiện nhiều giao dịch gửi tiền nhất) trong năm 2017.*/

select b.br_id, br_name, count(t_id)
from transactions t join account a on t.ac_no=a.ac_no
					join customer c on a.cust_id=c.cust_id
                    join branch b on c.br_id=b.br_id
where t_type=1 and (t_date between '2017/01/01' and '2017/12/31')
group by b.br_id
order by count(t_id) desc
limit 2;

/*=============================================================================*/

/*25. Tìm giao dịch gửi tiền nhiều nhất trong mùa đông. Nếu có thể, hãy đưa ra tên của người thực hiện giao dịch và chi nhánh.*/

select cust_name, br_name, t_amount
from transactions t join account a on t.ac_no=a.ac_no
					join customer c on a.cust_id=c.cust_id
                    join branch b on c.br_id=b.br_id
where t_type=1 and (month(t_date) between 10 and 12)
and t_amount>= all
			(select t_amount
			from transactions
			where t_type=1 and (month(t_date) between 10 and 12));

/*=============================================================================*/

/*26. Để bổ sung nhân sự cho các chi nhánh, cần có kết quả phân tích về cường độ làm việc của họ. Hãy liệt kê những chi nhánh phải làm việc qua trưa và loại giao dịch là gửi tiền.*/

select distinct br_name
from transactions t join account a on t.ac_no=a.ac_no
					join customer c on a.cust_id=c.cust_id
                    join branch b on c.br_id=b.br_id
where t_type=1 and (t_time between '11:00' and '13:00');

/*=============================================================================*/

/*27. Hãy liệt kê các giao dịch bất thường. Gợi ý: là các giao dịch gửi tiền những được thực hiện ngoài khung giờ làm việc và cho phép overtime (từ sau 16h đến trước 7h)*/

select t_id, t_amount, t_time, t_date
from transactions
where t_type=1 and ((t_time between '16:00' and '24:00') or (t_time between '00:00' and '07:00'));

/*=============================================================================*/

/*28. Hãy điều tra những giao dịch bất thường trong năm 2017. Giao dịch bất thường là giao dịch diễn ra trong khoảng thời gian từ 12h đêm tới 3 giờ sáng.*/

select t_id, t_amount, t_type, t_time, t_date
from transactions
where (t_date between '2017/01/01' and '2017/12/31') and (t_time between '00:00' and '03:00');

/*=============================================================================*/

/*29. Có bao nhiêu người ở Đắc Lắc sở hữu nhiều hơn một tài khoản?*/

select count(cust_id)
from customer
where cust_id=
			(select c.cust_id
			from account a join customer c on a.cust_id=c.cust_id
			where cust_ad like "%ĐăkLăk"
			group by c.cust_id
			having count(ac_no)>1);

/*=============================================================================*/

/*30. Nếu mỗi giao dịch rút tiền ngân hàng thu phí 3.000 đồng, hãy tính xem tổng tiền phí thu được từ thu phí dịch vụ từ năm 2012 đến năm 2017 là bao nhiêu?*/

select count(t_id)*3000 'Phí rút tiền'
from transactions
where t_type=0 and (t_date between '2012/01/01' and '2017/12/31');

/*=============================================================================*/

/* 31. Hiển thị thông tin các khách hàng họ Trần theo các cột sau: Mã khách hàng, họ, tên, Số dư tài khoản*/

select c.cust_id 'Mã khách hàng', left(cust_name,locate(right(cust_name,locate(' ',reverse(cust_name))), cust_name)-1)'Họ', right(cust_name,locate(' ',reverse(cust_name))-1)'Tên', sum(ac_balance) 'Số dư tài khoản'
from account a join customer c on a.cust_id=c.cust_id
where cust_name like 'Trần%'
group by c.cust_id;

/*=============================================================================*/

/*32. Cuối mỗi năm, nhiều khách hàng có xu hướng rút tiền khỏi ngân hàng để chuyển sang ngân hàng khác hoặc chuyển sang hình thức tiết kiệm khác. Hãy lọc những khách hàng có xu hướng rút tiền khỏi ngân hàng bằng hiển thị những người rút gần hết tiền trong tài khoản (tổng tiền rút trong tháng 12/2017 nhiều hơn 100 triệu và số dư trong tài khoản còn lại <= 100.000)*/

select c.cust_id 'Mã khách hàng', cust_name 'Tên khách hàng',sum(t_amount)'Số tiền rút', sum(ac_balance) 'Số dư'
from transactions t join account a on t.ac_no=a.ac_no
					join customer c on a.cust_id=c.cust_id
where (t_date between '2017/12/01' and '2017/12/31') and t_type=0
group by c.cust_id
having sum(t_amount)>100000000 and sum(ac_balance)<=100000;

/*=============================================================================*/

/*33. Thời gian vừa qua, hệ thống CSDL của ngân hàng bị hacker tấn công (giả sử tí cho vui J), tổng tiền trong tài khoản bị thay đổi bất thường. Hãy liệt kê những tài khoản bất thường đó. Gợi ý: tài khoản bất thường là tài khoản có tổng tiền gửi – tổng tiền rút <> số tiền trong tài khoản*/

select 
	c.cust_id 'Mã khách hàng', cust_name 'Tên khách hàng', a.ac_no 'Số tài khoản',
	sum(case t_type
		when 0 then -t_amount
        when 1 then t_amount
        end) 'Tiền gửi - Tiền rút',
	ac_balance 'Số dư'
from transactions t join account a on t.ac_no=a.ac_no
					join customer c on a.cust_id=c.cust_id
group by a.ac_no
having sum(case t_type
		when 0 then -t_amount
        when 1 then t_amount
        end) <> ac_balance;
        
/*=============================================================================*/

/*34.  Do hệ thống mạng bị nghẽn và hệ thống xử lý chưa tốt phần điều khiển đa người dùng nên một số tài khoản bị invalid. Hãy liệt kê những tài khoản đó. Gợi ý: tài khoản bị invalid là những tài khoản có số tiền âm. Nếu có thể hãy liệt kê giao dịch gây ra sự cố tài khoản âm. Giao dịch đó được thực hiện ở chi nhánh nào? (mục đích để quy kết trách nhiệm J)*/

select c.cust_id, cust_name, ac_balance, br_name
from customer c join branch b on c.br_id=b.br_id
				join account a on c.cust_id=a.cust_id
where ac_balance<0;

/*=============================================================================*/

/*35. (Giả sử) Gần đây, một số khách hàng ở chi nhánh Đà Nẵng kiện rằng: tổng tiền trong tài khoản không khớp với số tiền họ thực hiện giao dịch. Hãy điều tra sự việc này bằng cách hiển thị danh sách khách hàng ở Đà Nẵng bao gồm các thông tin sau: mã khách hàng, họ tên khách hàng, tổng tiền đang có trong tài khoản, tổng tiền đã gửi, tổng tiền đã rút, kết luận (nếu tổng tiền gửi – tổng tiền rút = số tiền trong tài khoản à OK, trường hợp còn lại à có sai)*/

select 
	c.cust_id 'Mã khách hàng', cust_name 'Tên khách hàng', ac_balance 'Số dư',
	sum(case t_type
        when 1 then t_amount
        end)'Tổng tiền gửi',
	sum(case t_type
        when 0 then t_amount
        end)'Tổng tiền rút',
	(case
		sum(case t_type
        when 1 then t_amount
        end)
		- sum(case t_type
        when 0 then t_amount
        end) - ac_balance
        when 0 then 'OK'
       else 'Sai'
		end) 'Kết luận'
from transactions t join account a on t.ac_no=a.ac_no
					join customer c on a.cust_id=c.cust_id
                    join branch b on c.br_id=b.br_id
where br_ad like '%Đà Nẵng'
group by a.ac_no;

/*=============================================================================*/

/*36. Ngân hàng cần biết những chi nhánh nào có nhiều giao dịch rút tiền vào buổi chiều để chuẩn bị chuyển tiền tới. Hãy liệt kê danh sách các chi nhánh và lượng tiền rút trung bình theo ngày (chỉ xét những giao dịch diễn ra trong buổi chiều), sắp xếp giảm giần theo lượng tiền giao dịch.*/

select br_name, sum(t_amount)
from transactions t join account a on t.ac_no=a.ac_no
					join customer c on a.cust_id=c.cust_id
                    join branch b on c.br_id=b.br_id
where t_type=0
group by br_name
order by sum(t_amount) desc;

/*=============================================================================*/

