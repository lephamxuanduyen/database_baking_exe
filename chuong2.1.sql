/*Liệt kê những khách hàng không thuộc các chi nhánh miền bắc*/

select Cust_id 'Mã khách hàng', Cust_name 'Tên khách hàng', Br_id 'Mã chi nhánh'
from customer
where Br_id not like 'VB%';

/*===========================================================*/

/*10. Liệt kê những tài khoản nhiều hơn 100 triệu trong tài khoản*/

select cus.cust_id 'Mã khách hàng', cus.Cust_name 'Tên khách hàng', sum(ac.ac_balance) 'Tổng tài khoản'
from customer cus join account ac on cus.Cust_id = cus.Cust_id
group by cus.Cust_id
having sum(ac.ac_balance)>100000000;

/*===========================================================*/

/*11. Liệt kê những giao dịch gửi tiền diễn ra ngoài giờ hành chính*/

select t_id 'Mã giao dịch', t_type 'Loại giao dịch',dayofweek(t_date)+1 'Thứ',t_date 'Ngày giao dịch', t_time 'Thời gian giao dịch', ac_no 'Số tài khoản'
from transactions
where (((t_time between '00:00' and '07:30') or (t_time between '11:30' and '13:00') or (t_time between '17:00' and '24:00')) and (dayofweek(t_date)!=1 or dayofweek(t_date)!=7)) or dayofweek(t_date)=1 or dayofweek(t_date)=7 ;

/*============================================================*/

/*12. Liệt kê những giao dịch rút tiền diễn ra vào khoảng từ 0-3h sáng*/

select t_id 'Mã giao dịch', t_type 'Loại giao dịch', t_amount 'Số tiền', ac_no 'Số tài khoản'
from transactions
where t_time between '00:00' and '03:00';

/*=============================================================*/

/*13. Tìm những khách hàng có địa chỉ ở Ngũ Hành Sơn – Đà nẵng*/

select Cust_id 'Mã khách hàng', Cust_name 'Tên khách hàng', Cust_ad 'Địa chỉ'
from customer
where cust_ad like '%Ngũ Hành Sơn%Đà Nẵng%';
/*=============================================================*/

/*14. Liệt kê những chi nhánh chưa có địa chỉ*/

select BR_id 'Mã chi nhánh', BR_name 'Tên chi nhánh'
from branch
where BR_ad='';

/*==============================================================*/

/*15. Liệt kê những giao dịch rút tiền bất thường (nhỏ hơn 50.000)*/

select t_id 'Mã giao dịch', t_amount 'Số tiền', ac_no 'Số tài khoản'
from transactions
where t_type=0 and t_amount<50000;

/*===============================================================*/

/*16. Liệt kê các giao dịch gửi tiền diễn ra trong năm 2017.*/

select t_id 'Mã giao dịch', t_amount 'Số tiền',ac_no 'Số tài khoản'
from transactions
where t_type=1 and year(t_date)=2017;

/*==============================================================*/

/*17. Liệt kê những giao dịch bất thường (tiền trong tài khoản âm)*/

select t.t_id 'Mã giao dịch', t.t_amount 'Số tiền', ac.Ac_no 'Số tài khoản', ac.ac_balance 'Tiền tài khoản'
from transactions t join account ac on t.ac_no=ac.ac_no
where ac.ac_balance<0;

/*===============================================================*/

/*18. Hiển thị tên khách hàng và tên tỉnh/thành phố mà họ sống*/

select Cust_name "Tên khách hàng", trim(right(cust_ad,locate(",",reverse(cust_ad))-1)) "Tỉnh/ Thành phố"
from customer
where Cust_ad like "%,%" or Cust_ad like "%-%,%"
union
select Cust_name "Tên khách hàng", trim(right(cust_ad,locate("-",reverse(cust_ad))-1)) "Tỉnh/ Thành phố"
from customer
where Cust_ad not like "%,%";

/*===============================================================*/

/*19. Hiển thị danh sách khách hàng có họ tên không bắt đầu bằng chữ N, T*/

select Cust_id 'Mã khách hàng', Cust_name 'Tên khách hàng'
from customer
except
select Cust_id 'Mã khách hàng', Cust_name 'Tên khách hàng'
from customer
where Cust_name like 'N%' or Cust_name like 'T%';

/*===============================================================*/

/*20. Hiển thị danh sách khách hàng có kí tự thứ 3 từ cuối lên là chữ a, u, i*/

select Cust_id 'Mã khách hàng', Cust_name 'Tên khách hàng'
from customer
where Cust_name like '%a__' or Cust_name like '%u__' or Cust_name like '%i__';

/*===============================================================*/

/*21. Hiển thị khách hàng có tên đệm là Thị hoặc Văn*/

select Cust_id 'Mã khách hàng', Cust_name 'Tên khách hàng'
from customer
where Cust_name like '%%Thị &' or Cust_name like '%Văn %';

/*================================================================*/

/*22. Hiển thị khách hàng có địa chỉ sống ở vùng nông thôn. Với quy ước: nông thôn là vùng mà địa chỉ chứa: thôn, xã, xóm*/

select Cust_name "Tên khách hàng", Cust_ad "Địa chỉ"
from customer
where (Cust_ad like "%\thôn%" or (Cust_ad like "%- xã%" or Cust_ad like "%, xã%") or Cust_ad like "%\xóm%") and (Cust_ad not like "%\thị xã%");

/*================================================================*/

/*23. Hiển thị danh sách khách hàng có kí tự thứ hai của TÊN là chữ u hoặc ũ hoặc a. Chú ý: TÊN là từ cuối cùng của cột cust_name*/

alter table customer change column cust_name cust_name text character set utf8mb4 collate utf8mb4_bin;

select cus.Cust_id "ID khách hàng", cus.Cust_name "Tên khách hàng"
from customer cus
where (right(cust_name,locate(" ",reverse(cust_name))-1) like '_u%' collate utf8mb4_bin) or (right(cust_name,locate(" ",reverse(cust_name))-1) like '_ũ%' collate utf8mb4_bin) or (right(cust_name,locate(" ",reverse(cust_name))-1) like '_a%' collate utf8mb4_bin);