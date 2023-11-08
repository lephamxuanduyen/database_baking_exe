-- IN RA DÃY Số FIBO



-- IN RA TÊN củA CHI NHÁNH VN012

declare @ten nvarchar(100)
set @ten=(select br_name from branch where br_id='VN012')
print(@ten)

--In ra dãy số lẻ 1-1000

declare @cnt int
set @cnt = 1
while @cnt <= 1000
begin
	print(@cnt)
	set @cnt = @cnt+2
end
GO
--In ra dãy số lẻ 1-1000

declare @cnt int
set @cnt = 2
while @cnt <= 1000
begin
	print(@cnt)
	set @cnt = @cnt+2
end
GO

-- TRẦN VĂN THIỆN THANH đã thực hiện giao dịch nào chưa

declare @cnt int
set @cnt=
		(select count(t.t_id)
		from customer c join account a on c.Cust_id=a.cust_id
						join transactions t on a.Ac_no=t.ac_no
		where Cust_name=N'Trần Văn Thiện Thanh')
if @cnt>0
	begin
		print(N'Trần Văn Thiện Thanh đã thực hiện '+str(@cnt)+N' giao d?ch.')
	end
else
	begin
		print(N'Trần Văn Thiện Thanh đã không thực hiện giao dịch nào.')
	end
go

-- Chi nhánh Huế có bao nhiêu khách hàng

declare @cnt int
set @cnt=
		(select COUNT(c.cust_id)
		from customer c join branch b on c.br_id=b.br_id
		where BR_name like N'%Hu?')
print(N'Số khách hàng của chi nhánh Huế:'+str(@cnt))
GO

-- Ông Trần Văn Thiện Thanh sống ở thành phố nào

(select Cust_ad
from customer
where Cust_name=N'Trần Văn Thiện Thanh')
-- IN ra bảnng cửu chương

declare @bangCuuChuong int, @so int, @kq int
set @bangCuuChuong=1
while @bangCuuChuong<=9
	begin
		print(N'BảNG CỬU CHƯƠNG' + str(@bangCuuChuong))
		set @so=1
		while @so<=10
		begin
			set @kq=@bangCuuChuong*@so
			print(str(@bangCuuChuong)+'x'+str(@so)+'='+str(@kq))
			--print(@kq)
			set @so=@so+1
		end
		set @bangCuuChuong = @bangCuuChuong +1
	end
go


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



-- in ra dãy số FIBO
declare @n int = 100, @a int = 0, @b int = 1, @c int, @in varchar(1000)
set @in = str(@a) + ' ' + str(@b)
while @n<=100
begin
	set @c = @a + @b
	set @in = @in + str(@c)
	set @a = @b
	set @b = @c
	set @n += 1
end
print(@in)


