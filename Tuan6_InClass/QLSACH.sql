CREATE DATABASE QLSACH

CREATE TABLE TACGIA 
(
MaTG char(5) primary key,
HoTen varchar(20),
DiaChi varchar(50),
NgSinh smalldatetime,
SoDT varchar(15)
)

CREATE TABLE SACH
(
MaSach char(5) primary key,
TenSach varchar(25),
TheLoai varchar(25)
)

CREATE TABLE TACGIA_SACH
(
MaTG char(5) not null foreign key references TACGIA(MaTG),
MaSach char(5) not null foreign key references SACH(MaSach)
)

ALTER TABLE TACGIA_SACH
ADD primary key (MaTG, MaSach)

CREATE TABLE PHATHANH
(
MaPH char(5) primary key,
MaSach char(5) foreign key references SACH(MaSach),
NgayPH smalldatetime,
SoLuong int,
NhaXuatBan varchar(20)
) 

-- 2.1. Ngày phát hành sách phải lớn hơn ngày sinh của tác giả. (1.5 đ)  
CREATE TRIGGER kiemtra_NgayPH ON PHATHANH
FOR UPDATE, INSERT
AS
BEGIN
DECLARE @NgayPH smalldatetime, @MaSach char(5), @NgSinh smalldatetime, @MaTG char(5)
SELECT @NgayPH = NgayPH , @MaSach = MaSach FROM inserted
SELECT @MaTG = (SELECT DISTINCT MaTG FROM TACGIA_SACH WHERE MaSach = @MaSach)
SELECT @NgSinh = (SELECT NgSinh FROM TACGIA WHERE MaTG = @MaTG)
IF (@NgayPH < @NgSinh)
BEGIN
RAISERROR ('Ngay phat hanh khong duoc nho hon ngay sinh', 16,1)
ROLLBACK TRANSACTION
END
END

--2.2. Sách thuộc thể loại “Giáo khoa” 
--chỉ do nhà xuất bản “Giáo dục” phát hành. (1.5 đ)  
CREATE TRIGGER kiemtra_TheLoaiSach ON PHATHANH
FOR INSERT, UPDATE
AS
BEGIN
DECLARE @MaSach char(5), @TheLoai varchar(25), @MaPH char(5)
SELECT @MaPH = MaPH, @MaSach = MaSach FROM inserted
SELECT @TheLoai = TheLoai FROM SACH WHERE MaSach = @MaSach
IF (@TheLoai = N'Giáo khoa')
BEGIN
UPDATE PHATHANH
SET NhaXuatBan = N'Giáo dục'
WHERE MaPH = @MaPH
END
END

-- 3.1. Tìm tác giả (MaTG,HoTen,SoDT) của những quyển 
--sách thuộc thể loại “Văn học” do nhà xuất bản Trẻ phát hành. (1.5 đ)  
SELECT TG.MaTG, HoTen, SoDT FROM TACGIA TG JOIN TACGIA_SACH TGS ON
							TG.MaTG = TGS.MaTG JOIN SACH S ON
							S.MaSach = TGS.MaSach JOIN PHATHANH PH
							ON PH.MaSach = S.MaSach
WHERE TheLoai = N'Văn học' AND NhaXuatBan = N'Trẻ'

--3.2. Tìm nhà xuất bản phát hành nhiều thể loại sách nhất.(1.5 đ)  
SELECT NhaXuatBan FROM PHATHANH JOIN SACH ON SACH.MaSach = PHATHANH.MaSach
GROUP BY NhaXuatBan
HAVING COUNT(TheLoai) >= ALL (SELECT COUNT(TheLoai) FROM PHATHANH JOIN
							SACH ON SACH.MaSach = PHATHANH.MaSach
	 			)
															   
--3.3. Trong mỗi nhà xuất bản, tìm tác giả (MaTG,HoTen) 
-- có số lần phát hành nhiều sách nhất. (1 đ)  
SELECT TG.MaTG, HoTen, NhaXuatBan FROM TACGIA TG JOIN TACGIA_SACH TGS
									ON TGS.MaTG = TG.MaTG JOIN
									PHATHANH PH1 ON PH1.MaSach = TGS.MaSach
GROUP BY NhaXuatBan, TG.MaTG, HoTen
HAVING COUNT(PH1.MaPH) >= ALL (SELECT COUNT(PH2.MaPH) FROM PHATHANH PH2
							JOIN TACGIA_SACH TGS ON TGS.MaSach = PH2.MaSach
							JOIN TACGIA TG ON TG.MaTG = TGS.MaTG
							WHERE PH1.NhaXuatBan = PH2.NhaXuatBan
							GROUP BY TG.MaTG
							)
