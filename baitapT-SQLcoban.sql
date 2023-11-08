-- 1.	Viết đoạn code thực hiện việc chuyển đổi đầu số điện thoại di động theo quy định của bộ Thông tin và truyền thông cho một khách hàng bất kì, ví dụ với: Dương Ngọc Long
use bank
go

declare @dau char(4),@duoi char(7), @dauDoi char(3), @sdt varchar(11), @length int, @ten NVARCHAR(100)
set @ten = N'Dương Ngọc Long'
set @length = (select len(Cust_phone) from customer
				where cust_name = @ten)
set @sdt = (select Cust_phone from customer
			where cust_name = @ten)
set @duoi = (select right(Cust_phone,7) from customer
				where cust_name=@ten)
if @length = 10 
	begin
		print(@sdt)
	end
else 
	begin
		set @dau = (select left(Cust_phone,4) from customer
				where cust_name = @ten)
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
		where Cust_name=@ten
	end
GO

select Cust_phone from customer where Cust_name = N'Dương Ngọc Long'
GO

-- 2.	Trong vòng 10 năm trở lại đây Nguyễn Lê Minh Quân có thực hiện giao dịch nào không? Nếu có, hãy trừ 50.000 phí duy trì tài khoản. 

declare @cnt_acno int
set @cnt_acno = (select count(a.Ac_no)
				from customer c join account a on c.Cust_id = a.cust_id
								join transactions t on a.Ac_no = t.ac_no
				where Cust_name = N'Nguyễn Lê Minh Quân'
				and  DATEDIFF(year,t_date,GETDATE())<=10)
if @cnt_acno>0
	begin
	print(N'Nguyễn Lê Minh Quân có thực hiện giao dịch trong 10 năm gần đây')
	update account
	set ac_balance = ac_balance - 50000
	where ac_no = (select a.Ac_no
					from customer c join account a on c.Cust_id = a.cust_id
					where Cust_name = N'Nguyễn Lê Minh Quân')
	end
else
	print(N'Nguyễn Lê Minh Quân không giao dịch trong 10 năm gần đây')
GO

-- 3.	Trần Quang Khải thực hiện giao dịch gần đây nhất vào thứ mấy? (thứ hai, thứ ba, thứ tư,…, chủ nhật) và vào mùa nào (mùa xuân, mùa hạ, mùa thu, mùa đông)?

declare @date date, @thu varchar(15), @mua varchar(10)
set @date = (select top 1(t_date)
			from customer c join account a on c.Cust_id = a.cust_id
							join transactions t on a.Ac_no = t.ac_no
			where Cust_name = N'Trần Quang Khải'
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
print(@thu)
set @mua = case DATEPART(QQ,@date)
				when 1 then N'Spring'
				when 2 then N'Summer'
				when 3 then N'Autumn'
				when 4 then N'Winter'
				end
print(@mua)
GO

-- 4.	Đưa ra nhận xét về nhà mạng mà Lê Anh Huy đang sử dụng? (Viettel, Mobi phone, Vinaphone, Vietnamobile, khác)

declare @mang varchar(20), @num varchar(11)
set @num = (select cust_phone
			from customer
			where Cust_name = N'Lê Anh Huy')
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
print(@mang)
Go

-- 5.	Số điện thoại của Trần Quang Khải là số tiến, số lùi hay số lộn xộn. Định nghĩa: trừ 3 số đầu tiên, các số còn lại tăng dần gọi là số tiến, ví dụ: 098356789 là số tiến

-- p[i] < p[i+1]
		-- if i=len(num) -> tiến
		-- if 4<i<len(num) ->lộn xộn (tiến - lùi - ...)
		-- if i=4
			--p[i]>p[i+1]
				-- if i=len(num) -> lùi
				-- else -> lộn xộn (lùi - tiến - ...)

declare @num varchar(11), @kq nvarchar(10), @i int = 4, @len int
set @num = (select cust_phone
			from customer
			where Cust_name = N'Trần Quang Khải')
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
print(@num)
print(@kq)
GO

-- 6.	Hà Công Lực thực hiện giao dịch gần đây nhất vào buổi nào(sáng, trưa, chiều, tối, đêm)?

declare @time time, @buoi nvarchar(10)
set @time = (select top 1(t_time)
			from customer c join account a on c.Cust_id = a.cust_id
							join transactions t on a.Ac_no = t.ac_no
			where Cust_name = N'Hà Công Lực' and t_date = (select top 1(t_date)
															from customer c join account a on c.Cust_id = a.cust_id
																			join transactions t on a.Ac_no = t.ac_no
															where Cust_name = N'Hà Công Lực'
															ORDER BY t_date DESC)
			ORDER BY t_time DESC)
set @buoi = case 
				when @time between '06:00' and '10:59' then N'Sáng'
				when @time between '11:00' and '13:59' then N'Trưa'
				when @time between '14:00' and '17:59' then N'Chiều'
				when @time between '18:00' and '23:59' then N'Tối'
				when @time between '00:00' and '05:59' then N'Đêm'
				end
print(@time)
print(@buoi)
GO

-- 7.	Chi nhánh ngân hàng mà Trương Duy Tường đang sử dụng thuộc miền nào? Gợi ý: nếu mã chi nhánh là VN  miền nam, VT  miền trung, VB  miền bắc, còn lại: bị sai mã.
declare @id varchar(6), @output nvarchar(20)
set @id = (select br_id from customer where Cust_name = N'Trương Duy Tường')
set @output = case
				when @id like 'VN%' then N'Miền Nam'
				when @id like 'VT%' then N'Miền Trung'
				when @id like 'VB%' then N'Miền Bắc'
				end
print(@output)
-- 8.	Căn cứ vào số điện thoại của Trần Phước Đạt, hãy nhận định anh này dùng dịch vụ di động của hãng nào: Viettel, Mobi phone, Vina phone, hãng khác.

declare @mang varchar(20), @num varchar(11)
set @num = (select cust_phone
			from customer
			where Cust_name = N'Trần Phước Đạt')
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
print(@id)
print(@mang)
Go

-- 9.	Hãy nhận định Lê Anh Huy ở vùng nông thôn hay thành thị. Gợi ý: nông thôn thì địa chỉ thường có chứa chữ “thôn” hoặc “xóm” hoặc “đội” hoặc “xã” hoặc “huyện”
declare @address nvarchar(100), @kq nvarchar(10) = N'Thành phố'
set @address = (select cust_ad from customer where cust_name = N'Lê Anh Huy')
print @address
if @kq like N'%thôn%' or @kq like N'%xóm%' or @kq like N'%đội%' or @kq like N'%xã%' or @kq like N'%huyện%'
	set @kq = N'Nông thôn'
print(@kq)
GO

-- 10.	Hãy kiểm tra tài khoản của Trần Văn Thiện Thanh, nếu tiền trong tài khoản của anh ta nhỏ hơn không hoặc bằng không nhưng 6 tháng gần đây không có giao dịch thì hãy đóng tài khoản bằng cách cập nhật ac_type = ‘K’

declare @amount int, @ac_no char(10)
set @amount = (select sum(ac_balance)
				from customer c join account a on c.Cust_id = a.cust_id
				where Cust_name = N'Trần Văn Thiện Thanh'
				GROUP BY c.cust_id)
set @ac_no = (select a.ac_no
			from customer c join account a on c.Cust_id = a.cust_id
							join transactions t on a.Ac_no = t.ac_no
			where Cust_name = N'Trần Văn Thiện Thanh' and DATEDIFF(YEAR,getdate(),t_date)=0 and DATEDIFF(MONTH,getdate(),t_date)<=6)
print(N'Số tiền trong tài khoản khách hàng Trần Văn Thiện Thanh là:'+str(@amount))
if @amount <=0 and @ac_no = null
begin
	update account
	set ac_type = 'K'
	where Ac_no = @ac_no
end
GO

-- 11.	Mã số giao dịch gần đây nhất của Huỳnh Tấn Dũng là số chẵn hay số lẻ? 

declare @id varchar(10) = (select top 1(t_id)
							from customer c join account a on c.Cust_id = a.cust_id
											join transactions t on a.Ac_no = t.ac_no
							where Cust_name = N'Huỳnh Tấn Dũng'
							order by t_date desc)
if cast(@id as int)%2=0 print(N'Chẵn')
else
begin
	print(@id)
	print(N'Lẻ')
end
GO

-- 12.	Có bao nhiêu giao dịch diễn ra trong tháng 9/2016 với tổng tiền mỗi loại là bao nhiêu (bao nhiêu tiền rút, bao nhiêu tiền gửi)

declare @cnt int, @rut int = 0, @gui int = 0
set @cnt = (select COUNT(t_id)
			from transactions
			where t_date between '2016/09/01' and '2016/09/30')
if @cnt > 0 
begin
	print(N'Có giao dịch')
	set @rut = (select SUM(t_amount)
				from transactions
				where t_date between '2016/09/01' and '2016/09/30' and t_type=0
				GROUP BY t_type)
	set @gui = (select SUM(t_amount)
				from transactions
				where t_date between '2016/09/01' and '2016/09/30' and t_type=1
				GROUP BY t_type)
	print(N'Số tiền rút: ' + str(@rut))
	print(N'Số tiền gửi: ' + str(@gui))
end
else print(N'Không có giao dịch.')
GO

-- 13.	Ở Hà Nội ngân hàng Vietcombank có bao nhiêu chi nhánh và có bao nhiêu khách hàng? Trả lời theo mẫu: “Ở Hà Nội, Vietcombank có … chi nhánh và có …khách hàng”

declare @br int, @cust int
set @br = (select count(br_id)
			from Branch
			where BR_name like N'%Hà Nội')
set @cust = (select count(c.cust_id)
			from Branch b join customer c on b.Br_id = c.Br_id
			where BR_name like N'%Hà Nội%')
print(N'Ở Hà Nội, Vietcombank có ' + cast(@br as char(1)) + N' chi nhánh và có ' + cast(@cust as char(1)) + N' khách hàng')
GO

-- 14.	Tài khoản có nhiều tiền nhất là của ai, số tiền hiện có trong tài khoản đó là bao nhiêu? Tài khoản này thuộc chi nhánh nào?

declare @c_id char(10), @amount int, @name nvarchar(50), @br_name nvarchar(50)
set @c_id = (select c.cust_id
			from Branch b join customer c on b.br_id = c.br_id
							join account a on c.cust_id = a.cust_id
			group by c.cust_id
			having sum(ac_balance)>= all (select sum(ac_balance)
									from Branch b join customer c on b.br_id = c.br_id
													join account a on c.cust_id = a.cust_id
									group by c.cust_id))
set @name = (select cust_name from customer where Cust_id = @c_id)
set @amount = (select sum(ac_balance)
				from account
				where cust_id = @c_id)
set @br_name = (select br_name
				from Branch b join customer c on b.Br_id = c.Br_id
				where Cust_id = @c_id)
print(N'Tài khoản có nhiều thiền nhất là của ' + @name + N', số tiền hiện có trong tài khoản là ' + str(@amount) + N'. Tài khoán đó thuộc chi nhánh ' + @br_name)
GO				

-- 15.	Có bao nhiêu khách hàng ở Đà Nẵng?

declare @cnt int
set @cnt = (select count(cust_id)
			from customer
			where Cust_ad like N'%Đà Nẵng%')
print(N'Số khách hàng Đà Nẵng:'+str(@cnt))
GO

-- 16.	Có bao nhiêu khách hàng ở Quảng Nam nhưng mở tài khoản Sài Gòn
declare @cnt int
set @cnt = (select COUNT(cust_id)
			from customer c join Branch b on c.Br_id = b.BR_id
			where Cust_ad like N'%Quảng Nam%' and BR_name like N'%Sài Gòn%')
print(N'Số khách hàng ở Quảng Nam nhưng mở tài khoản Sài Gòn:' + str(@cnt))
GO

-- 17.	Ai là người thực hiện giao dịch có mã số 0000000387, thuộc chi nhánh nào? Giao dịch này thuộc loại nào?

declare @c_id char(6), @t_type char(1),@name nvarchar(50), @br_name nvarchar(50), @type_txt nvarchar(4)
set @c_id = (select c.Cust_id
			from customer c join account a on c.Cust_id = a.cust_id
							join transactions t on t.ac_no = a.Ac_no
			where t_id = '0000000387')
set @name = (select cust_name
			from customer
			where Cust_id = @c_id)
set @t_type = (select t_type
				from transactions
				where t_id = '0000000387')
set @br_name = (select br_name
				from Branch b join customer c on b.br_id = c.Br_id
				where Cust_id = @c_id)
set @type_txt = case @t_type
					when 1 then N'rút'
					when 0 then N'gửi'
				end
print(N'Khách hàng ' + @name + N' thuộc chi nhánh ' + @br_name + N', giao dịch loại ' + @type_txt)
GO

-- 18.	Hiển thị danh sách khách hàng gồm: họ và tên, số điện thoại, số lượng tài khoản đang có và nhận xét. Nếu < 1 tài khoản  “Bất thường”, còn lại “Bình thường”

declare @list table(name nvarchar(100), phone varchar(11), cnt int, cmt nvarchar(100))
INSERT INTO @list(name, phone, cnt) SELECT Cust_name, Cust_phone, COUNT(C.Cust_NAME)
									FROM customer C JOIN account A ON C.Cust_id = A.cust_id
									GROUP BY Cust_NAME, Cust_phone
UPDATE @list
SET cmt = case
			when cnt<0 then N'Bất thường'
			when cnt>=0 then N'Bình thường'
			end
SELECT * FROM @list
GO

-- 19.	Viết đoạn code nhận xét tiền trong tài khoản của ông Hà Công Lực. <100.000: ít, < 5.000.000  trung bình, còn lại: nhiều

declare @amount int, @inkq nvarchar(10)
set @amount = (select sum(ac_balance)
				from customer c join account a on c.Cust_id = a.cust_id
				where Cust_name = N'Hà Công Lực')
set @inkq = case
				when @amount<100000 then N'Ít'
				when @amount>= 100000 and @amount<500000 then N'Trung bình'
				else N'Nhiều'
			end
print(@amount)
print(@inkq)
GO

-- 20.	Hiển thị danh sách các giao dịch của chi nhánh Huế với các thông tin: mã giao dịch, thời gian giao dịch, số tiền giao dịch, loại giao dịch (rút/gửi), số tài khoản. 
-- Ví dụ:
-- Mã giao dịch	Thời gian GD	    Số tiền GD	Loại GD	Số tài khoản
-- 00133455	    2017-11-30 09:00	3000000	Rút	04847374948

declare @huetrans table(id char(10),time varchar(30), amount int, type nvarchar(3), ac char(10))
insert into @huetrans(id, time, amount, type, ac) select t_id,CONCAT(t_date,' ',t_time) as datetime, t_amount, t_type, a.Ac_no
													from transactions t join account a on t.ac_no = a.Ac_no
																		join customer c on c.Cust_id = a.cust_id
																		join Branch b on c.Br_id = b.Br_id
													where BR_name like N'%Huế%'
update @huetrans
set type = case type
			when '1' then N'Gửi'
			when '0' then N'Rút'
			end
select id N'Mã giao dịch', time N'Thời gian', amount N'Số tiền giao dịch', type N'Loại giao dịch', ac N'Số tài khoản'
from @huetrans
GO

-- 21.	Kiểm tra xem khách hàng Nguyễn Đức Duy có ở Quang Nam hay không?

declare @cnt int
set @cnt = (select count(Cust_id)
			from customer 
			where Cust_name = N'Nguyễn Đức Duy' and Cust_ad like N'%Quảng Nam%')
if @cnt = 0 print('NO')
else print('YES')
GO

-- 22.	Điều tra số tiền trong tài khoản ông Lê Quang Phong có hợp lệ hay không? (Hợp lệ: tổng tiền gửi – tổng tiền rút = số tiền hiện có trong tài khoản). Nếu hợp lệ, đưa ra thông báo “Hợp lệ”, ngược lại hãy cập nhật lại tài khoản sao cho số tiền trong tài khoản khớp với tổng số tiền đã giao dịch (ac_balance = sum(tổng tiền gửi) – sum(tổng tiền rút)

declare @tong int, @rut int, @gui int
set @tong = (select sum(ac_balance)
			from customer c join account a on c.Cust_id = a.cust_id
			where Cust_name = N'Lê Quang Phong')
set @gui = (select sum(t_amount)
			from customer c join account a on c.Cust_id = a.cust_id
							join transactions t on t.ac_no = a.Ac_no
			where Cust_name = N'Lê Quang Phong' and t_type = 1)
set @rut = (select sum(t_amount)
			from customer c join account a on c.Cust_id = a.cust_id
							join transactions t on t.ac_no = a.Ac_no
			where Cust_name = N'Lê Quang Phong' and t_type = 0)
print(@gui-@rut)
if @gui - @rut = @tong print(N'Hợp lệ')
else 
begin
	declare @stk varchar(15)
	set @stk = (select ac_no
				from account a join customer c on a.cust_id = c.Cust_id
				where Cust_name = N'Lê Quang Phong')
	update account
	set ac_balance = @gui - @rut
	where ac_no = @stk
end
GO

-- 23.	Chi nhánh Đà Nẵng có giao dịch gửi tiền nào diễn ra vào ngày chủ nhật hay không? Nếu có, hãy hiển thị số lần giao dịch, nếu không, hãy đưa ra thông báo “không có”

declare @cnt int = (select count(t_id)
					from transactions t join account a on t.ac_no = a.Ac_no
										join customer c on c.Cust_id = a.cust_id
										join Branch b on b.BR_id = c.Br_id
					where DATEPART(WEEKDAY,t_date)=1 and BR_name like N'%Đà Nẵng%')
if @cnt = 0 print(N'Chi nhánh Đà Nẵng không có giao dịch vào Chủ Nhật')
else print(N'Số giao dịch vào Chủ Nhật của chi nhánh Đà Nẵng:'+str(@cnt))
GO

-- 24.	Kiểm tra xem khu vực miền bắc có nhiều phòng giao dịch hơn khu vực miền trung ko? Miền bắc có mã bắt đầu bằng VB, miền trung có mã bắt đầu bằng VT

declare @mb int, @mt int
set @mb = (select count(br_id)
			from Branch
			where BR_id like 'VB%')
set @mb = (select count(br_id)
			from Branch
			where BR_id like 'VT%')
if @mb > @mt print('YES')
else print('NO')
GO

-- 25.	In ra dãy số lẻ từ 1 – n, với n là giá trị tự chọn

-- in:n
-- out: 1->n số lẻ

-- a=1
-- str += a
-- a += 2

Create proc spinSoLe(@n int, @out varchar(1000) output)
as
begin
	set @out = ''
	declare @a int = 1
	while @a<=@n
	begin
		set @out += cast(@a as char(5))
		set @a +=2
	end
end
GO

declare @out varchar(1000), @n int= 100
Exec spinSoLe @n, @out output
print(@out)
GO

-- 26.	In ra dãy số chẵn từ 0 – n, với n là giá trị tự chọn

Create proc in_so_chan(@n int, @output varchar(1000) output)
as
begin
	set @output = ''
	declare @a int = 0
	while @a<=@n
	begin
		set @output += cast(@a as char(5))
		set @a +=2
	end
end
Go

declare @output varchar(1000), @n int = 100
Exec in_so_chan @n, @output output
print(@output)
GO

-- 27.	In ra 100 số đầu tiền trong dãy số Fibonaci

declare @a bigint=0, @b bigint=1, @n int=100, @c bigint
while @n>0
begin
	set @c = @a + @b
	set @a = @b
	set @b = @c
	set @n = @n - 1
	print(str(@a))
end
GO

-- 28.	In ra tam giác sao: 
-- a)	tam giác vuông
-- *
-- **
-- ***
-- ****
-- *****

declare @i int, @str varchar(10)
set @i=1
while @i<=5
	begin
--		set @str = ''
--		while len(@str)<@i
--			begin
--				set @str = @str + '*'
--			end
		print(replicate('*',@i))
		set @i = @i + 1
	end
GO
-- b)	tam giác cân
-- 
--     *
--    ***
--   *****
--  *******
-- *********

-- Vẽ tam giác cân với chiều cao 5

DECLARE @height INT = 50, @sao int=1
while @sao<=@height
begin
-- n-1 trống + 2n-1 *
	print(replicate(' ',@height-@sao) + replicate('*',2*@sao-1))
	set @sao = @sao + 1
end
GO

-- c)	In bảng cửu chương

declare @bangCuuChuong int, @so int, @kq int, @inkq varchar(1000)
set @so=1
while @so<=10
begin
	set @bangCuuChuong=2
	set @inkq = ''
	while @bangCuuChuong<=9
	begin
		set @kq=@bangCuuChuong*@so
		set @inkq = @inkq + cast(@bangCuuChuong as char(2))+ ' x ' + cast(@so as char(2)) + ' = ' + cast(@kq as char(2)) + '       '
		--print(@kq)
		set @bangCuuChuong=@bangCuuChuong+1
	end
	print(@inkq)
	set @so = @so +1
end
GO

-- d)	Viết đoạn code đọc số. Ví dụ: 1.234.567  Một triệu hai trăm ba mươi tư ngàn năm trăm sáu mươi bảy đồng. (Giả sử số lớn nhất là hàng trăm tỉ)
-- e)	Kiểm tra số điện thoại của Lê Quang Phong là số tiến hay số lùi. 
-- Gợi ý:
-- Với những số điện thoại có 10 số, thì trừ 3 số đầu tiên, nếu số sau lớn hơn hoặc bằng số trước thì là số tiến, ngược lại là số lùi. Ví dụ: 0981.244.789 (tiến), 0912.776.541 (lùi), 0912.563.897 (lộn xộn)
-- Với những số điện thoại có 11 số thì trừ 4 số đầu tiên.  

declare @num varchar(11), @kq nvarchar(10), @i int, @len int
set @num = (select cust_phone
			from customer
			where Cust_name = N'Lê Quang Phong')
set @len = len(@num)
if @len=10 set @i=3
else set @i=4
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
print(@num)
print(@kq)
GO