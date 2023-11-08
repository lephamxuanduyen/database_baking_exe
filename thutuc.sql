-- Viết thủ tục thực hiện việc nêu dưới đây:
-- 1.	Chuyển đổi đầu số điện thoại di động theo quy định của bộ Thông tin và truyền thông nếu biết mã khách của họ.

create proc spSDT @id varchar(10)
as
begin
	declare @dau char(4),@duoi char(7), @dauDoi char(3), @sdt varchar(11), @length int
	set @length = (select len(Cust_phone) from customer
					where Cust_id = @id)
	set @sdt = (select Cust_phone from customer
				where Cust_id = @id)
	set @duoi = (select right(Cust_phone,7) from customer
				where Cust_id = @id)
	if @length = 10 
		begin
			print(@sdt)
		end
	else 
		begin
			set @dau = (select left(Cust_phone,4) from customer
						where Cust_id = @id)
			set @dauDoi = case @dau
							when'0162' then '032'
							when'0163' then '033'
							when'0164' then '034'
							when'0165' then '035'
							when'0166' then '036'
							when'0167' then '037'
							when'0168' then '038'
							when'0169' then '039'
							when'0163' then '033'
							when'0128' then '088'
							when'0123' then '083'
							when'0124' then '084'
							when'0125' then '085'
							when'0127' then '081'
							when'0129' then '082'
							when'0120' then '070'
							when'0121' then '079'
							when'0122' then '077'
							when'0126' then '076'
							when'0128' then '078'
							end 
			set @sdt = @dauDoi+@duoi
			update customer
			set Cust_phone = @dauDoi+@duoi
			where Cust_id = @id
		end
end
GO

-- test

declare @id varchar(10) = '000001'
exec spSDT @id
GO

select * from customer
GO

-- 2.	Kiểm tra trong vòng 10 năm trở lại đây khách hàng có thực hiện giao dịch nào không, nếu biết mã khách của họ? Nếu có, hãy trừ 50.000 phí duy trì tài khoản.

-- in: id
-- out: YES/NO
-- proccess: có giao dịch không, có thì -50000

alter proc spTransY_N @id varchar(10), @yes_no varchar(10) out
as
begin
	declare @cnt_acno int
	set @cnt_acno = (select count(a.Ac_no)
					from customer c join account a on c.Cust_id = a.cust_id
									join transactions t on a.Ac_no = t.ac_no
					where c.Cust_id = @id
					and  DATEDIFF(year,t_date,GETDATE())<=10)
	if @cnt_acno>0
		begin
		set @yes_no = 'YES'
		update account
		set ac_balance = ac_balance - 50000
		from customer c join account a on c.Cust_id = a.cust_id
						join transactions t on a.Ac_no = t.ac_no
		where ac_no = @id
		end
	else
	begin
		set @yes_no = 'NO'
	end
end
GO

-- test

declare @id varchar(10) = '000002', @y_n varchar(10)
exec spTransY_N @id, @y_n output
print(@y_n)
GO

select ac_balance
from account
where cust_id = '000002'
GO

-- 3.	Kiểm tra khách thực hiện giao dịch gần đây nhất vào thứ mấy? (thứ hai, thứ ba, thứ tư,…, chủ nhật) và vào mùa nào (mùa xuân, mùa hạ, mùa thu, mùa đông) nếu biết mã khách.

--in: id
--out: thứ, mùa
alter proc spTransTime @id varchar(10), @thu varchar(15) out, @mua varchar(10) out
as
begin
	declare @date date
	set @date = (select top 1(t_date)
				from customer c join account a on c.Cust_id = a.cust_id
								join transactions t on a.Ac_no = t.ac_no
				where c.cust_id = @id
				ORDER BY t_date DESC)
	set @thu = case datepart(WEEKDAY,@date)
					when 1 then N'Sunday'
					when 2 then N'Monday'
					when 3 then N'Tueday'
					when 4 then N'Wednesday'
					when 5 then N'Thusday'
					when 6 then N'Friday'
					when 7 then N'Saturday'
					end
	set @mua = case DATEPART(QQ,@date)
					when 1 then N'Spring'
					when 2 then N'Summer'
					when 3 then N'Autumn'
					when 4 then N'Winter'
					end
end
GO

-- test 

declare @thu varchar(20), @mua varchar(20), @id varchar(10) = '000003'
exec spTransTime @id, @thu out, @mua out
print(@thu)
print(@mua)
GO

-- 4.	Đưa ra nhận xét về nhà mạng của khách hàng đang sử dụng nếu biết mã khách? (Viettel, Mobi phone, Vinaphone, Vietnamobile, khác)

--in: id
--out: nhà mạng

create proc spNhaMang @id varchar(6), @mang varchar(20) out
as
begin
	declare @num varchar(11)
	set @num = (select cust_phone
				from customer
				where Cust_id = @id)
	set @mang = case LEFT(@num,3)
					when 096 then 'Viettel'
					when 097 then 'Viettel'
					when 098 then 'Viettel'
					when 086 then 'Viettel'
					when 032 then 'Viettel'
					when 033 then 'Viettel'
					when 034 then 'Viettel'
					when 035 then 'Viettel'
					when 036 then 'Viettel'
					when 037 then 'Viettel'
					when 038 then 'Viettel'
					when 039 then 'Viettel'
					when 091 then 'Vinaphone'
					when 094 then 'Vinaphone'
					when 088 then 'Vinaphone'
					when 081 then 'Vinaphone'
					when 082 then 'Vinaphone'
					when 083 then 'Vinaphone'
					when 084 then 'Vinaphone'
					when 085 then 'Vinaphone'
					when 089 then 'Vinaphone'
					when 090 then 'MobiFone'
					when 093 then 'MobiFone'
					when 070 then 'MobiFone'
					when 079 then 'MobiFone'
					when 077 then 'MobiFone'
					when 076 then 'MobiFone'
					when 078 then 'MobiFone'
					when 071 then 'MobiFone'
					when 072 then 'MobiFone'
					when 073 then 'MobiFone'
					when 074 then 'MobiFone'
					when 075 then 'MobiFone'
					when 092 then 'Vietnamobile'
					when 056 then 'Vietnamobile'
					when 058 then 'Vietnamobile'
					when 059 then 'Vietnamobile'
					else N'Khác'
				end
end
GO

declare @mang varchar(20), @id char(6) = '000004'
exec spNhaMang @id, @mang out
print(@mang)
GO

-- 5.	Nếu biết mã khách, hãy kiểm tra số điện thoại của họ là số tiến, số lùi hay số lộn xộn. Định nghĩa: trừ 3 số đầu tiên, các số còn lại tăng dần gọi là số tiến, ví dụ: 098356789 là số tiến

--in: id
--out: tiến/ lùi/ lộn xộn

create or alter proc spTienLui @id char(6), @kq nvarchar(10) out
as 
begin
	declare @num varchar(11), @i int = 4, @len int
	set @num = (select cust_phone
				from customer
				where Cust_id = @id)
	set @len = len(@num)
	while @i< @len
	begin
		if cast(SUBSTRING(@num,@i,1) as int) < cast(SUBSTRING(@num,@i+1,1) as int) set @i += 1
		else break
	end
	if @i = @len set @kq = N'Tiến'
	else
	begin
		if @i > 4 set @kq = N'Lộn xộn'
		else
		begin
			while @i< @len
			begin
				if cast(SUBSTRING(@num,@i,1) as int) > cast(SUBSTRING(@num,@i+1,1) as int) set @i += 1
				else break
			end
			if @i = @len set @kq = N'Lùi'
			else set @kq = N'Tiến'
		end
	end
end
GO

declare @kq nvarchar(10), @id char(6) = '000002'
exec spTienLui @id, @kq out
print(@kq)
GO

-- 6.	Nếu biết mã khách, hãy kiểm tra xem khách thực hiện giao dịch gần đây nhất vào buổi nào(sáng, trưa, chiều, tối, đêm)?

--in: id
--out:buổi

alter proc spTransBuoi @id char(6), @buoi nvarchar(10) out
as
begin
	declare @time time
	set @time = (select top 1(t_time)
				from customer c join account a on c.Cust_id = a.cust_id
								join transactions t on a.Ac_no = t.ac_no
				where c.Cust_id = @id and t_date = (select top 1(t_date)
																from customer c join account a on c.Cust_id = a.cust_id
																				join transactions t on a.Ac_no = t.ac_no
																where c.Cust_id = @id
																ORDER BY t_date DESC)
				ORDER BY t_time DESC)
	set @buoi = case 
					when @time between '06:00' and '10:59' then N'Sáng'
					when @time between '11:00' and '13:59' then N'Trưa'
					when @time between '14:00' and '17:59' then N'Chiều'
					when @time between '18:00' and '23:59' then N'Tối'
					when @time between '00:00' and '05:59' then N'Đêm'
					end
end
GO

declare @buoi nvarchar(10), @id char(6) = '000002'
exec spTransBuoi @id, @buoi out
GO


-- 7.	Nếu biết số điện thoại của khách, hãy kiểm tra chi nhánh ngân hàng mà họ đang sử dụng thuộc miền nào? Gợi ý: nếu mã chi nhánh là VN  miền nam, VT  miền trung, VB  miền bắc, còn lại: bị sai mã.

-- in: sđt
-- out: miền

create proc spFindBrFromPhone @phone varchar(11), @mien nvarchar(10) out
as 
begin
	declare @id varchar(6)
	set @id = (select br_id from customer where Cust_phone = @phone)
	set @mien = case
					when @id like 'VN%' then N'Miền Nam'
					when @id like 'VT%' then N'Miền Trung'
					when @id like 'VB%' then N'Miền Bắc'
				end
end
GO

-- test 

declare @mien nvarchar(10), @phone varchar(11) = '0883388103'
exec spFindBrFromPhone @phone, @mien out
print(@mien)
GO

-- 8.	Căn cứ vào số điện thoại của khách, hãy nhận định vị khách này dùng dịch vụ di động của hãng nào: Viettel, Mobi phone, Vina phone, hãng khác.

-- in: sđt
-- out: nhà mạng

create proc spNhaMangFromPhone @phone varchar(11), @mang nvarchar(20) out
as
begin
	set @mang = case LEFT(@phone,3)
					when 096 then 'Viettel'
					when 097 then 'Viettel'
					when 098 then 'Viettel'
					when 086 then 'Viettel'
					when 032 then 'Viettel'
					when 033 then 'Viettel'
					when 034 then 'Viettel'
					when 035 then 'Viettel'
					when 036 then 'Viettel'
					when 037 then 'Viettel'
					when 038 then 'Viettel'
					when 039 then 'Viettel'
					when 091 then 'Vinaphone'
					when 094 then 'Vinaphone'
					when 088 then 'Vinaphone'
					when 081 then 'Vinaphone'
					when 082 then 'Vinaphone'
					when 083 then 'Vinaphone'
					when 084 then 'Vinaphone'
					when 085 then 'Vinaphone'
					when 089 then 'Vinaphone'
					when 090 then 'MobiFone'
					when 093 then 'MobiFone'
					when 070 then 'MobiFone'
					when 079 then 'MobiFone'
					when 077 then 'MobiFone'
					when 076 then 'MobiFone'
					when 078 then 'MobiFone'
					when 071 then 'MobiFone'
					when 072 then 'MobiFone'
					when 073 then 'MobiFone'
					when 074 then 'MobiFone'
					when 075 then 'MobiFone'
					when 092 then 'Vietnamobile'
					when 056 then 'Vietnamobile'
					when 058 then 'Vietnamobile'
					when 059 then 'Vietnamobile'
					else N'Khác'
				end
end
GO

-- test

declare @mang nvarchar(20), @phone varchar(11) = '0883388103'
exec spNhaMangFromPhone @phone, @mang out
print(@mang)
GO

-- 9.	Hãy nhận định khách hàng ở vùng nông thôn hay thành thị nếu biết mã khách hàng của họ. Gợi ý: nông thôn thì địa chỉ thường có chứa chữ “thôn” hoặc “xóm” hoặc “đội” hoặc “xã” hoặc “huyện”

-- in: cust_id
-- out: thành thị/ nông thôn

create or alter proc spCityOrCountryside @id char(6), @kq nvarchar(10) out
as
begin
	declare @address nvarchar(100)
	set @address = (select cust_ad from customer where cust_id = @id)
	if @address like N'%thôn%' or @address like N'%xóm%' or @address like N'%đội%' or (@address like N'%xã%' and @address like N'%thị xã%') or @address like N'%huyện%'
		set @kq = N'Nông thôn'
	else
		set @kq = N'Thành phố'
end
GO

-- test

declare @kq nvarchar(10), @id char(6) = '000001'
exec spCityOrCountryside @id, @kq out
print(@kq)
GO

-- 10.	Hãy kiểm tra tài khoản của khách nếu biết số điện thoại của họ. Nếu tiền trong tài khoản của họ nhỏ hơn không hoặc bằng không nhưng 6 tháng gần đây không có giao dịch thì hãy đóng tài khoản bằng cách cập nhật ac_type = ‘K’

-- in: phone
-- out: YES/ NO (xóa)

create proc spKhoaTk @phone varchar(11), @kq varchar(3) out
as
begin
	declare @amount table(no char(10), balance int, dk_tg varchar(3), cnt int)
	insert into @amount(no, balance) select Ac_no, ac_balance
										from customer c join account a on c.Cust_id = a.cust_id
										where Cust_phone = @phone
	update @amount
	set cnt = (select COUNT(t_id)
				from customer c join account a on c.Cust_id = a.cust_id
								join transactions t on a.Ac_no = t.ac_no
				where a.Ac_no = no and DATEDIFF(YEAR,getdate(),t_date)=0 and DATEDIFF(MONTH,getdate(),t_date)<=6)
	update @amount
	set dk_tg = case
					when cnt>0 then 'YES'
					when cnt=0 then 'NO'
				end
	update account
	set ac_type  = 'K'
	where Ac_no = (select no
					from @amount
					where dk_tg = 'NO')
	declare @cntkq int
	set @cntkq = (select count(no)
					from @amount
					where dk_tg = 'NO')
	if @cntkq = 0 set @kq = 'YES'
	else set @kq = 'NO'
end
GO

-- test

declare @kq varchar(3), @phone varchar(11) = '0883388103'
exec spKhoaTk @phone, @kq out
print(@kq)
GO

select * from customer
GO

-- 11.	Kiểm tra mã số giao dịch gần đây nhất của khách là số chẵn hay số lẻ nếu biết mã khách. 

-- in: id
-- out: chẵn/ lẻ

create proc spGdChanLe @cust_id char(6), @kq nvarchar(4) out
as
begin
	declare @id varchar(10) = (select top 1(t_id)
								from customer c join account a on c.Cust_id = a.cust_id
												join transactions t on a.Ac_no = t.ac_no
								where c.cust_id = @cust_id
								order by t_date desc)
	if cast(@id as int)%2=0 set @kq=N'Chẵn'
	else set @kq = N'Lẻ'
end
GO

-- test

declare @kq nvarchar(4), @id char(6) = '000001'
exec spGdChanLe @id, @kq out
print(@kq)
go

-- 12.	Trả về số lượng giao dịch diễn ra trong khoảng thời gian nhất định (tháng, năm), tổng tiền mỗi loại giao dịch là bao nhiêu (bao nhiêu tiền rút, bao nhiêu tiền gửi)

-- in: tháng, năm
-- out: số lượng giao dịch, tổng tiền của mỗi loại giao dịch

create proc spGD @thang int, @nam int, @cnt int out, @rut int out, @gui int out
as
begin
	set @cnt = (select COUNT(t_id)
				from transactions
				where MONTH(t_date)=@thang and YEAR(t_date)=@nam)
	set @rut = (select SUM(t_amount)
				from transactions
				where MONTH(t_date)=@thang and YEAR(t_date)=@nam and t_type=0
				GROUP BY t_type)
	set @gui = (select SUM(t_amount)
				from transactions
				where MONTH(t_date)=@thang and YEAR(t_date)=@nam and t_type=1
				GROUP BY t_type)
end
GO

-- test

declare @thang int = 9, @nam int = 2016, @cnt int, @rut int, @gui int
exec spGD @thang, @nam, @cnt out, @rut out, @gui out
print(N'Số giao dịch:'+str(@cnt))
print(N'Tổng rút:'+str(@rut))
print(N'Tổng rút:'+str(@gui))
GO

-- 13.	Trả về số lượng chi nhánh ở một địa phương nhất định.

-- in: địa phương
-- out: số lượng chi nhánh

create or alter proc spBranchLocal @local nvarchar(50), @cnt int out
as
begin
	declare @br int
	set @br = (select count(br_id)
				from Branch
				where BR_name like cast(concat(N'Vietcombank ',@local) as nvarchar))
end
GO

declare @local nvarchar(50) = N'Hà Nội', @cnt int
exec spBranchLocal @local, @cnt out
print(@cnt)
Go
select * from Branch
GO

print(N'%' + N'Đà Nẵng')

-- 14.	Trả về tên khách hàng có nhiều tiền nhất là trong tài khoản, số tiền hiện có trong tài khoản đó là bao nhiêu? Tài khoản này thuộc chi nhánh nào?

-- in: null
-- out: kh có nhiều tiền nhất, số tiền, tên chi nhánh

-- 15.	Trả về số lượng khách của một chi nhánh nhất định.

-- in: tên chi nhánh
-- out: số lượng khách

-- 16.	Tìm tên, số điện thoại, chi nhánh của khách thực hiện giao dịch, nếu biết mã giao dịch.

-- in: t_id
-- out: tên, sđt, chi nhánh

-- 17.	Hiển thị danh sách khách hàng gồm: họ và tên, số điện thoại, số lượng tài khoản đang có và nhận xét. Nếu < 1 tài khoản  “Bất thường”, còn lại “Bình thường”

-- in: null
-- out: ds kh

-- 18.	Nhận xét tiền trong tài khoản của khách nếu biết số điện thoại. <100.000: ít, < 5.000.000  trung bình, còn lại: nhiều

-- in: sđt
-- out: ít/ tb/ nhiều

-- 19.	Kiểm tra khách hàng đã mở tài khoản tại ngân hàng hay chưa nếu biết họ tên và số điện thoại của họ.

-- in: name, phone
-- out: Yes/ NO

create or alter proc spOpen @name nvarchar(50), @phone varchar(11), @kq bit out
as begin
	declare @cnt int
	set @cnt = (select COUNT(Cust_id)
				from customer
				where Cust_name = @name and Cust_phone = @phone)
	set @kq = case 
				when @cnt<=0 then 0 --chưa có tài khoản
				when @cnt>0 then 1 -- có tài khoản
				end
end
Go

create or alter function fOpen(@name nvarchar(50), @phone varchar(11))
returns bit
as
begin
	declare @cnt int
	set @cnt = (select COUNT(*)
				from customer
				where Cust_name = @name and Cust_phone = @phone)
	return case 
				when @cnt<=0 then 0 --chưa có tài khoản
				else 1 -- có tài khoản
				end
end
GO


-- test

declare @name nvarchar(50) = N'Hà Công Lực', @phone varchar(11) = '0883388103', @kq varchar(3)
exec spOpen @name, @phone, @kq out
print(@kq)
GO

print(dbo.fOpen(N'Hà Công Lực','0883388103'))

-- 20.	Điều tra số tiền trong tài khoản của khách có hợp lệ hay không nếu biết mã khách? (Hợp lệ: tổng tiền gửi – tổng tiền rút = số tiền hiện có trong tài khoản). Nếu hợp lệ, đưa ra thông báo “Hợp lệ”, ngược lại hãy cập nhật lại tài khoản sao cho số tiền trong tài khoản khớp với tổng số tiền đã giao dịch (ac_balance = sum(tổng tiền gửi) – sum(tổng tiền rút)

-- in: maKH
-- out: Yes/ NO

create or alter proc spTkHopLe @id char(6), @kq bit out
as
begin
	declare @tong int, @rut int, @gui int
	set @tong = (select sum(ac_balance)
				from customer c join account a on c.Cust_id = a.cust_id
				where c.Cust_id = @id)
	set @gui = (select sum(t_amount)
				from customer c join account a on c.Cust_id = a.cust_id
								join transactions t on t.ac_no = a.Ac_no
				where c.Cust_id = @id and t_type = 1)
	set @rut = (select sum(t_amount)
				from customer c join account a on c.Cust_id = a.cust_id
								join transactions t on t.ac_no = a.Ac_no
				where c.Cust_id = @id and t_type = 0)
 	if @gui - @rut = @tong set @kq = 1
 	else set @kq = 0
 	begin
 		set @kq = 0
 		declare @stk varchar(15)
 		set @stk = (select ac_no
 					from account a join customer c on a.cust_id = c.Cust_id
 					where c.Cust_id = @id)
 		update account
 		set ac_balance = @gui - @rut
 		where ac_no = @stk
 	end
end
GO

declare @id char(6) = '000001', @kq bit
exec spTkHopLe @id, @kq out
print(@kq)
GO

-- 21.	Kiểm tra chi nhánh có giao dịch gửi tiền nào diễn ra vào ngày chủ nhật hay không nếu biết mã chi nhánh? Nếu có, trả về lần giao dịch.

-- in: br_id
-- out: yes/ no

-- 22.	In ra dãy số lẻ từ 1 – n, với n là giá trị tự chọn

--in: n

-- 23.	In ra dãy số chẵn từ 0 – n, với n là giá trị tự chọn

--in: n

-- 24.	In ra 100 số đầu tiền trong dãy số Fibonaci
-- 25.	In ra tam giác sao: 
-- a)	tam giác vuông
-- *
-- **
-- ***
-- ****
-- *****
-- b)	tam giác cân
-- 
--     *
--    ***
--   *****
--  *******
-- *********
-- 
-- 
-- c)	In bảng cửu chương
-- d)	Viết đoạn code đọc số. Ví dụ: 1.234.567  Một triệu hai trăm ba mươi tư ngàn năm trăm sáu mươi bảy đồng. (Giả sử số lớn nhất là hàng trăm tỉ)
-- e)	Kiểm tra số điện thoại của khách là số tiến hay số lùi nếu biết mã khách. 
-- Gợi ý:
-- Với những số điện thoại có 10 số, thì trừ 3 số đầu tiên, nếu số sau lớn hơn hoặc bằng số trước thì là số tiến, ngược lại là số lùi. Ví dụ: 0981.244.789 (tiến), 0912.776.541 (lùi), 0912.563.897 (lộn xộn)
-- Với những số điện thoại có 11 số thì trừ 4 số đầu tiên. 

