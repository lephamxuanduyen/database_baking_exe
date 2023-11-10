-- 1.	Khi thêm mới dữ liệu trong bảng transactions hãy thực hiện các công việc sau:
-- a.	Kiểm tra trạng thái tài khoản của giao dịch hiện hành. Nếu trạng thái tài khoản ac_type = 9 thì đưa ra thông báo ‘tài khoản đã bị xóa’ và hủy thao tác đã thực hiện. Ngược lại:  
-- i.	Nếu là giao dịch gửi: số dư = số dư + tiền gửi. 
-- ii.	Nếu là giao dịch rút: số dư = số dư – tiền rút. Nếu số dư sau khi thực hiện giao dịch < 50.000 thì đưa ra thông báo ‘không đủ tiền’ và hủy thao tác đã thực hiện.

CREATE OR ALTER TRIGGER tCau1
ON TRANSACTIONS
AFTER INSERT
AS
BEGIN
	DECLARE @TYPE CHAR(1), @t_type bit, @amount int
	set @TYPE = (select ac_type 
				from inserted i join account a on i.ac_no = a.Ac_no)
	if @TYPE = 9
	begin
		print(N'Tài khoản đã bị khóa.')
		rollback
	end

	select @t_type = t_type from inserted
	select @amount = t_amount from inserted
	declare @ac_balance int = (select ac_balance from inserted i join account a on i.ac_no = a.Ac_no)
	declare @ac_no char(10) = (select ac_no from inserted)
	if @t_type = 1
	begin
		update account
		set ac_balance = @ac_balance + @amount
		where Ac_no = @ac_no
	end
	else
	begin
		if @ac_balance-@amount<50000
		begin
			print(N'Không đủ tiền')
			rollback
		end
		else
		begin
			update account
			set ac_balance = @ac_balance - @amount
			where Ac_no = @ac_no
		end
	end

END
GO

-- test

insert into transactions values
('0000000415','0',172950000,'2023/11/09','07:45','1000000003')

select * from transactions
select * from account
GO
-- 2.	Sau khi xóa dữ liệu trong transactions hãy tính lại số dư:
-- a.	Nếu là giao dịch rút
-- Số dư = số dư cũ + t_amount
-- b.	Nếu là giao dịch gửi
-- Số dư = số dư cũ – t_amount

create or alter trigger tCau2
on transactions
after delete
as
begin
	declare @type bit = (select t_type from deleted)
	declare @amount int = (select t_amount from deleted)
	declare @ac_no char(10) = (select ac_no from deleted)
	update account
	set ac_balance = case @type
						when 0 then ac_balance - @amount
						when 1 then ac_balance + @amount
					end
	where ac_no = @ac_no
end
GO

-- test 

select * from transactions
select * from account

delete from transactions
where t_id = '0000000406'
GO

-- ac_no = '1000000001'
-- ac_balance = '89847500'

-- 3.	Khi cập nhật hoặc sửa dữ liệu tên khách hàng, hãy đảm bảo tên khách không nhỏ hơn 5 kí tự. 

create or alter trigger tCau3
on customer
after update
as
begin
	declare @ten nvarchar(100) = (select cust_name from inserted)
	if len(@ten)<5
	begin
		rollback
	end
end
GO

-- test

update customer
set cust_name = N'Hà Công Lực'
where cust_id = '000001'

select * from customer
GO

-- 4.	Khi xóa dữ liệu trong bảng account, hãy thực hiện thao tác cập nhật trạng thái tài khoản là 9 (không dùng nữa) thay vì xóa.

create or alter trigger tCau4
on account
instead of delete
as
begin
	declare @ac_no char(10) = (select ac_no from deleted)
	update account
	set ac_type = 9
	where ac_no = @ac_no
end
Go

-- test

select * from account

delete from account
where ac_no = '1000000027'
GO

-- 5.	Khi thêm mới dữ liệu trong bảng transactions hãy thực hiện các công việc sau:
-- a.	Kiểm tra trạng thái tài khoản của giao dịch hiện hành. Nếu trạng thái tài khoản ac_type = 9 thì đưa ra thông báo ‘tài khoản đã bị xóa’ và hủy thao tác đã thực hiện. Ngược lại:  
-- i.	Nếu là giao dịch gửi: số dư = số dư + tiền gửi. 
-- ii.	Nếu là giao dịch rút: số dư = số dư – tiền rút. Nếu số dư sau khi thực hiện giao dịch < 50.000 thì đưa ra thông báo ‘không đủ tiền’ và hủy thao tác đã thực hiện.

-- Trùng câu 1

-- 6.	Khi sửa dữ liệu trong bảng transactions hãy tính lại số dư:
-- Số dư = số dư cũ + (số dữ mới – số dư cũ)

create or alter trigger tCau6
on transactions
after update
as
begin
	declare @amount_old int = (select t_amount from deleted)
	declare @amount_new int = (select t_amount from inserted)
	declare @ac_no char(10) = (select ac_no from inserted)
	update account
	set ac_balance = ac_balance + (@amount_new - @amount_old)
	where Ac_no = @ac_no
end
GO

-- test
select * from account
select * from transactions
select * from account where ac_no = '1000000041' -- ac_balance = 227374000 -> 227322000

update transactions
set t_amount = '1700000'
where t_id = '0000000201'
GO

-- 7.	Sau khi xóa dữ liệu trong transactions hãy tính lại số dư:
-- a.	Nếu là giao dịch rút
-- Số dư = số dư cũ + t_amount
-- b.	Nếu là giao dịch gửi
-- Số dư = số dư cũ – t_amount

-- Trùng câu 2

-- 8.	Khi cập nhật hoặc sửa dữ liệu tên khách hàng, hãy đảm bảo tên khách không nhỏ hơn 5 kí tự. 

-- Trùng câu 3

-- 9.	Khi tác động đến bảng account (thêm, sửa, xóa), hãy kiểm tra loại tài khoản. Nếu ac_type = 9 (đã bị xóa) thì đưa ra thông báo ‘tài khoản đã bị xóa’ và hủy các thao tác vừa thực hiện.

create or alter trigger tCau9
on account
after insert, update, delete
as
begin
	declare @ac_ins char(1) = (select ac_type from inserted)
	declare @ac_del char(1) = (select ac_type from deleted)
	if @ac_ins = 9 or @ac_del = 9
	begin
		rollback
	end
end
GO

-- test

insert into account values
('1000000406',88118000,'9','000001')
GO

-- 10.	Khi thêm mới dữ liệu vào bảng customer, kiểm tra nếu họ tên và số điện thoại đã tồn tại trong bảng thì đưa ra thông báo ‘đã tồn tại khách hàng’ và hủy toàn bộ thao tác.

create or alter trigger tCau10
on customer
after insert
as
begin
	declare @ten nvarchar(100) = (select cust_name from inserted)
	declare @sdt varchar(11)   = (select cust_phone from inserted)
	declare @cnt int = (select count(*)
						from customer
						where Cust_name = @ten and Cust_phone = @sdt)
	if @cnt != 0 
	begin
		rollback
	end
end
GO

-- test

insert into customer values
('000036',N'Hà Công Lực','01283388103',N'NGUYỄN TIẾN DUẨN - THÔN 3 - XÃ DHÊYANG - EAHLEO - ĐĂKLĂK','VT009')
GO

-- 11.	Khi thêm mới dữ liệu vào bảng account, hãy kiển tra mã khách hàng. Nếu mã khách hàng chưa tồn tại trong bảng customer thì đưa ra thông báo ‘khách hàng chưa tồn tại, hãy tạo mới khách hàng trước’ và hủy toàn bộ thao tác. 

create or alter trigger tCau11
on account
after insert
as
begin
	declare @id nvarchar(100) = (select cust_id from inserted)
	declare @cnt int = (select count(*)
						from customer
						where Cust_id = @id)
	if @cnt = 0 
	begin
		print(N'Khách hàng chưa tồn tại, hãy tạo mới khách hàng trước')
		rollback
	end
end
GO

-- test

insert into account values
('1000000056',88118000,'1','00001')
GO
select * from account
delete from account
where ac_no = '1000000055'

-- 12.	Khi tác động đến bảng account (thêm, sửa, xóa), hãy kiểm tra loại tài khoản. Nếu ac_type = 9 (đã bị xóa) thì đưa ra thông báo ‘tài khoản đã bị xóa’ và hủy các thao tác vừa thực hiện.

-- trùng câu 9

-- 13.	Khi thêm mới dữ liệu vào bảng customer, kiểm tra nếu họ tên và số điện thoại đã tồn tại trong bảng thì đưa ra thông báo ‘đã tồn tại khách hàng’ và hủy toàn bộ thao tác.

-- trùng câu 10

-- 14.	Khi thêm mới dữ liệu vào bảng account, hãy kiểm tra mã khách hàng. Nếu mã khách hàng chưa tồn tại trong bảng customer thì đưa ra thông báo ‘khách hàng chưa tồn tại, hãy tạo mới khách hàng trước’ và hủy toàn bộ thao tác.  

-- trùng câu 11