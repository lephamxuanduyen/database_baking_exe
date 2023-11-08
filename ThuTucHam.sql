-- 1.	Trả về tên chi nhánh ngân hàng nếu biết mã của nó. HÀM

create or alter function fFindBranch(@id char(5))
returns nvarchar(50)
as
begin
	declare @name nvarchar(50)
	set @name = (select br_name from branch where BR_id = @id)
	return @name
end
GO

-- test

print(dbo.fFindBranch('VB001'))
GO

-- 2.	Trả về tên, địa chỉ và số điện thoại của khách hàng nếu biết mã khách.THỦ TỤC

create or alter proc spFindInfCus @id char(6), @name nvarchar(50) out, @add nvarchar(150) out, @phone varchar(11) out
as
begin
	set @name = (select Cust_name from customer where Cust_id = @id)
	set @add = (select Cust_ad from customer where Cust_id = @id)
	set @phone = (select cust_phone from customer where Cust_id = @id)
end
GO

-- test

declare @name nvarchar(50), @add nvarchar(150), @phone varchar(11), @id char(6) = '000001'
exec spFindInfCus @id, @name out, @add out, @phone out
print(@name)
print(@add)
print(@phone)
GO

-- 3.	In ra danh sách khách hàng của một chi nhánh cụ thể nếu biết mã chi nhánh đó.HÀM

create or alter function fFindCusOfBranch(@id char(5))
returns table
as
return select Cust_id, Cust_name, Cust_ad, Cust_phone
		from customer
		where br_id = @id
GO

-- test
select * from dbo.fFindCusOfBranch('VB005')
GO

-- 4.	Kiểm tra một khách hàng nào đó đã tồn tại trong hệ thống CSDL của ngân hàng chưa nếu biết: họ tên, số điện thoại của họ. Đã tồn tại trả về 1, ngược lại trả về 0 HÀM

create or alter function fExistCus(@name nvarchar(50), @phone varchar(11))
returns bit
as
begin
	declare @kq bit, @cnt int
	set @cnt = (select COUNT(*) from customer
				where Cust_name = @name and Cust_phone = @phone)
	set @kq = case
					when @cnt!=0 then 1
					else 0
				end
	return @kq
end
GO

-- test

select * from customer

print(dbo.fExistCus(N'Hà Công Lực','0883388203'))
GO

-- 5.	Cập nhật số tiền trong tài khoản nếu biết mã số tài khoản và số tiền mới. Thành công trả về 1, thất bại trả về 0 THỦ TỤC

create or alter proc spUpdateBalance @stk char(10), @balance int, @kq bit out
as
begin
	declare @cnt int = (select count(*) from account
				where Ac_no = @stk)
	set @kq = case
					when @cnt!=0 then 1
					else 0
				end
	update account
	set ac_balance = @balance
	where Ac_no = @stk
end
GO

-- test
select * from account --88118000->123456789
declare @stk char(10) = '1000000001', @balance int = 123456789, @kq bit
exec spUpdateBalance @stk, @balance, @kq out
print(@kq)
GO

-- 6.	Cập nhật địa chỉ của khách hàng nếu biết mã số của họ. Thành công trả về 1, thất bại trả về 0 THỦ TỤC

create or alter proc spUpdateAdd @id char(6), @add nvarchar(150), @kq bit out
as
begin
	declare @cnt int = (select count(*) from customer
						where Cust_id = @id)
	set @kq = case
					when @cnt!=0 then 1
					else 0
				end
	update customer
	set Cust_ad = @add
	where Cust_id = @id
end
GO

-- test

declare @id char(6) = '000001', @add nvarchar(150) = N'87 Dũng Sỹ Thanh Khê', @kq bit
exec spUpdateAdd @id, @add, @kq out
print(@kq)
Go

select * from customer
Go

-- 7.	Trả về số tiền có trong tài khoản nếu biết mã tài khoản. HÀM

create or alter function fFindBalance(@stk char(10))
returns int
as
begin
	declare @balance int = (select ac_balance
							from account
							where Ac_no = @stk)
	return @balance
end
GO

-- test

print(dbo.fFindBalance('1000000001'))
GO

-- 8.	Trả về số lượng khách hàng, tổng tiền trong các tài khoản nếu biết mã chi nhánh. THỦ TỤC

create proc spCusOfBranch @id char(5), @cnt int out, @amount int out
as 
begin
	set @cnt = (select count(*) from customer
				where Br_id = @id)
	set @amount = (select sum(ac_balance)
					from Branch br join customer c on br.BR_id = c.Br_id
									join account a on c.Cust_id = a.cust_id
					where br.Br_id = @id)
end
GO

-- test

declare @cnt int, @amount int, @id char(5) = 'VB005'
exec spCusOfBranch @id, @cnt out, @amount out
print(N'Số lượng khách:'+str(@cnt))
print(N'Tổng tiền:'+str(@amount))
GO

-- 9.	Kiểm tra một giao dịch có bất thường hay không nếu biết mã giao dịch. Giao dịch bất thường: giao dịch gửi diễn ra ngoài giờ hành chính, giao dịch rút diễn ra vào thời điểm 0am  3am HÀM

create or alter function fCheckTrans(@id char(10))
returns nvarchar(20)
as
begin
	declare @kq nvarchar(20), @cnt int
	set @cnt = (select count(*)
				from transactions
				where ( ((t_time between '00:00' and '03:00') and t_type = 0) 
				or (((t_time between '00:00' and '07:00') or (t_time between '17:00' and '24:00')) and t_type = 1))
				and t_id = @id)
	set @kq = case
					when @cnt!=0 then N'Bất thường'
					else N'Bình thường'
				end
	return @kq
end
GO

-- test
select * from transactions

print(dbo.fCheckTrans('0000000201'))
GO

-- 10.	Trả về mã giao dịch mới. Mã giao dịch tiếp theo được tính như sau: MAX(mã giao dịch đang có) + 1. Hãy đảm bảo số lượng kí tự luôn đúng với quy định về mã giao dịch HÀM

create or alter function fGetNewT_id()
returns char(10)
as
begin
	declare @cnt int
	set @cnt = (select MAX(cast(t_id as int))
				from transactions)
	return concat(REPLICATE('0', 10 - len(@cnt+1)),(@cnt+1))
end
GO

create or alter proc spGetNewT_id @t_id char(10) out
as
begin
	declare @cnt int
	set @cnt = (select MAX(t_id)
				from transactions)
	set @t_id = concat(REPLICATE('0', 10 - len(@cnt+1)),(@cnt+1))
end
GO

-- test

print(dbo.fGetNewT_id())
GO

declare @t_id char(10)
exec spGetNewT_id @t_id out
print(@t_id)
GO

-- 11.	Thêm một bản ghi vào bảng TRANSACTIONS nếu biết các thông tin ngày giao dịch, thời gian giao dịch, số tài khoản, loại giao dịch, số tiền giao dịch. Công việc cần làm bao gồm:
	-- a.	Kiểm tra ngày và thời gian giao dịch có hợp lệ không. Nếu không, ngừng xử lý 
	-- b.	Kiểm tra số tài khoản có tồn tại trong bảng ACCOUNT không? Nếu không, ngừng xử lý 
	-- c.	Kiểm tra loại giao dịch có phù hợp không? Nếu không, ngừng xử lý
	-- d.	Kiểm tra số tiền có hợp lệ không (lớn hơn 0)? Nếu không, ngừng xử lý 
	-- e.	Tính mã giao dịch mới
	-- f.	Thêm mới bản ghi vào bảng TRANSACTIONS 
	-- g.	Cập nhật bảng ACCOUNT bằng cách cộng hoặc trừ số tiền vừa thực hiện giao dịch tùy theo loại giao dịch
	-- 	THỦ TỤC

create or alter proc spUpdateTransactions @t_date date, @t_time time, @stk char(10), @t_type bit, @t_amount int, @ret bit = 0 out
as
begin
	-- Kiểm tra ngày hợp lệ
	if @t_date > GETDATE()
	begin
		set @ret = 0
		return
	end

	-- Số tài khoản có tồn tại không
	if not exists(select 1 from account where Ac_no = @stk)
	begin
		set @ret = 0
		return
	end

	-- Kiểm tra loại giao dịch có phù hợp không? Nếu không, ngừng xử lý
	if @t_type not in (0,1)
	begin
		set @ret = 0
		return
	end

	-- Kiểm tra số tiền có hợp lệ không (lớn hơn 0)? Nếu không, ngừng xử lý 
	if @t_amount<=0
	begin
		set @ret = 0
		return
	end

	-- Tính mã giao dịch mới
	declare @t_id char(10) = dbo.fGetNewT_id()

	-- Thêm mới bản ghi vào bảng TRANSACTIONS 
	insert into transactions values(@t_id, @t_type, @t_amount, @t_date, @t_time, @stk)
	if @@ROWCOUNT <= 0 
	begin
		set @ret = 0
		return
	end
	-- Cập nhật bảng ACCOUNT bằng cách cộng hoặc trừ số tiền vừa thực hiện giao dịch tùy theo loại giao dịch
	update account
	set ac_balance =    case @t_type 
							when 0 then ac_balance - @t_amount
							when 1 then ac_balance + @t_amount
						end
	if @@ROWCOUNT <= 0 
	begin
		set @ret = 0
		return
	end

	set @ret = 1
end
Go

-- test

select * from transactions --0000000406
select * from account
GO

declare @date date = '2023/01/10', @time time = '09:30', @stk char(10) = '1000000002', @type bit = 0, @amount int = 6868, @y_n bit
exec spUpdateTransactions @date, @time, @stk, @type, @amount, @y_n out
print(@y_n)
GO

-- 12.	Thêm mới một tài khoản nếu biết: mã khách hàng, loại tài khoản, số tiền trong tài khoản. Bao gồm những công việc sau:
	-- a.	Kiểm tra mã khách hàng đã tồn tại trong bảng CUSTOMER chưa? Nếu chưa, ngừng xử lý
	-- b.	Kiểm tra loại tài khoản có hợp lệ không? Nếu không, ngừng xử lý
	-- c.	Kiểm tra số tiền có hợp lệ không? Nếu NULL thì để mặc định là 50000, nhỏ hơn 0 thì ngừng xử lý. 
	-- d.	Tính số tài khoản mới. Số tài khoản mới bằng MAX(các số tài khoản cũ) + 1
	-- e.	Thêm mới bản ghi vào bảng ACCOUNT với dữ liệu đã có. 
	-- 	THỦ TỤC

create or alter proc spCreateNewAccount @id char(6), @ac_type bit, @balance int, @y_n bit =0 out
as
begin
	-- a.	Kiểm tra mã khách hàng đã tồn tại trong bảng CUSTOMER chưa? Nếu chưa, ngừng xử lý
	-- b.	Kiểm tra loại tài khoản có hợp lệ không? Nếu không, ngừng xử lý
	-- c.	Kiểm tra số tiền có hợp lệ không? Nếu NULL thì để mặc định là 50000, nhỏ hơn 0 thì ngừng xử lý. 
	-- d.	Tính số tài khoản mới. Số tài khoản mới bằng MAX(các số tài khoản cũ) + 1
	-- e.	Thêm mới bản ghi vào bảng ACCOUNT với dữ liệu đã có. 
end
Go

-- test
select * from account
declare @id char(6) = '000001', @ac_type bit = 0, @ac_balance int = 6868,@y_n bit
exec spCreateNewAccount @id, @ac_type, @ac_balance, @y_n
print(@y_n)
Go

-- 13.	Kiểm tra thông tin khách hàng đã tồn tại trong hệ thống hay chưa nếu biết họ tên và số điện thoại. Tồn tại trả về 1, không tồn tại trả về 0 HÀM
-- 14.	Tính mã giao dịch mới. Mã giao dịch tiếp theo được tính như sau: MAX(mã giao dịch đang có) + 1. Hãy đảm bảo số lượng kí tự luôn đúng với quy định về mã giao dịch HÀM
-- 15.	Tính mã tài khoản mới. (định nghĩa tương tự như câu trên) HÀM
-- 16.	Trả về tên chi nhánh ngân hàng nếu biết mã của nó. HÀM
-- 17.	Trả về tên của khách hàng nếu biết mã khách. HÀM
-- 18.	Trả về số tiền có trong tài khoản nếu biết mã tài khoản. HÀM
-- 19.	Trả về số lượng khách hàng nếu biết mã chi nhánh. HÀM
-- 20.	Kiểm tra một giao dịch có bất thường hay không nếu biết mã giao dịch. Giao dịch bất thường: giao dịch gửi diễn ra ngoài giờ hành chính, giao dịch rút diễn ra vào thời điểm 0am  3am HÀM
-- 21.	Sinh mã khách hàng tự động. Module này có chức năng tạo và trả về mã khách hàng mới bằng cách lấy MAX(mã khách hàng cũ) + 1. HÀM
-- 22.	Sinh mã chi nhánh tự động. Sơ đồ thuật toán của module được mô tả như sau:


-- khi xóa 1 giao dịch trong bảng transaction, hãy cập nhập t_type = 9

create or alter trigger tDelTrans
on transactions
instead of delete
as
begin
	update transactions set t_type = 9

end