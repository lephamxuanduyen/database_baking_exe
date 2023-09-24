select * from transactions;

/*Liệt kê khách hàng sống ở Đà Nẵng*/
select Cust_id ID ,Cust_name 'Họ tên', Cust_ad 'Địa chỉ'
from customer
where Cust_ad like '%Đà Nẵng%';


/*Liệt kê những giao dịch diễn ra trong quý 4 năm 2016*/
select t_id, t_amount, t_date
from transactions
where (month(t_date) between 10 and 12) and year(t_date)=2016;

select t_id, t_amount, t_date
from transactions
where datepart(quarter, t_date)=4 and datepart(year, t_data)=2016;

select t_id, t_amount, t_date
from transactions
where t_date between 01/10/2016 and 31/12/2016;

/*Liệt kê những giao dịch diễn ra trong mùa thu năm 2016*/
select t_id, t_amount, t_date
from transactions
where (month(t_date) between 7 and 9) and year(t_date)=2016;


/*Liệt kê chi nhánh chưa có địa chỉ*/
select br_id, br_name
from branch
where BR_ad = '';

/*Hiển thị danh sách khách hàng có kí tự thứ 3 từ cuối lên là chữ a,u,i*/
select cust_id, cust_name
from customer
where Cust_name like '%a__' or Cust_name like '%u__' or Cust_name like '%i__' ;

/*Liệt kê những khách hàng không sử dụng số điện thoại của mobi phone*/
select cust_id, cust_name, Cust_phone
from customer
where length(cust_phone)!=10;

/*Hiển thị tên khách hàng và tên tỉnh/ thành phố mà họ sống*/
/*Chạy bằng sql server*/
select cust_id 'Mã khách hàng', cust_name 'Tên khách hàng', right(Cust_ad,charindex(',',REVERSE(cust_ad))-1) 'Thành phố'
from customer
where Cust_ad like '%,%'
union
select cust_id 'Mã khách hàng', cust_name 'Tên khách hàng', right(Cust_ad,charindex('-',REVERSE(cust_ad))-1) 'Thành phố'
from customer
where Cust_ad like '%- %'
