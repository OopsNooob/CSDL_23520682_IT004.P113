CREATE DATABASE QLTHUESACH

CREATE TABLE DOCGIA
(
MaDG char(5) primary key,
HoTen varchar(30),
NgaySinh smalldatetime,
DiaChi varchar(30),
SoDT varchar(15)
)

CREATE TABLE SACH
(
MaSach char(5) primary key,
TenSach varchar(25),
TheLoai varchar(25),
NhaXuatBan varchar(30)
)

CREATE TABLE PHIEUTHUE
(
MaPT char(5) primary key,
MaDG char(5) foreign key references DOCGIA(MaDG),
NgayThue smalldatetime,
NgayTra smalldatetime,
SoSachThue int
)

CREATE TABLE CHITIET_PT
(
MaPT char(5) not null foreign key references PHIEUTHUE(MaPT),
MaSach char(5) not null foreign key references SACH(MaSach)
)

ALTER TABLE CHITIET_PT
ADD primary key(MaPT, MaSach)


-- 2.1. Mỗi lần thuê  sách, độc giả không được thuê quá 10 ngày. (1.5 đ)  
CREATE TRIGGER kiemtra_SoNgayThue ON PHIEUTHUE
FOR INSERT, UPDATE
AS
BEGIN
DECLARE @NgayThue smalldatetime, @NgayTra smalldatetime
SELECT @NgayThue = NgayThue, @NgayTra = NgayTra FROM inserted
IF ( @NgayTra - @NgayThue > 10)
BEGIN
RAISERROR('Doc gia khong duoc thue qua 10 ngay',16,1)
ROLLBACK TRANSACTION
END
END

--2.2. Số sách thuê trong bảng phiếu thuê bằng tổng số lần 
--thuê sách có trong bảng chi tiết phiếu thuê. (1.5 đ)  
 CREATE TRIGGER kiemtra_SoSachThue ON CHITIET_PT
 FOR INSERT, DELETE
 AS
 BEGIN
 DECLARE @MaPT char(5), @SoSachThue int
 IF EXISTS (SELECT * FROM inserted)
 BEGIN
SELECT @MaPT = MaPT FROM inserted
SELECT @SoSachThue = (SELECT COUNT(MaSach) FROM CHITIET_PT 
						WHERE MaPT = @MaPT
						)
UPDATE PHIEUTHUE
SET SoSachThue = @SoSachThue
WHERE MaPT = @MaPT
END
IF EXISTS (SELECT * FROM deleted)
 BEGIN
SELECT @MaPT = MaPT FROM deleted
SELECT @SoSachThue = (SELECT COUNT(MaSach) FROM CHITIET_PT 
						WHERE MaPT = @MaPT
						)
UPDATE PHIEUTHUE
SET SoSachThue = @SoSachThue
WHERE MaPT = @MaPT
END
END

--3.1. Tìm các độc giả (MaDG,HoTen) đã thuê sách thuộc 
--thể loại “Tin học” trong năm 2007. (1.5 đ)  
SELECT D.MaDG, HoTen FROM DOCGIA D JOIN PHIEUTHUE P ON P.MaDG = D.MaDG
							JOIN CHITIET_PT C ON C.MaPT = P.MaPT
							JOIN SACH S ON S.MaSach = C.MaSach
WHERE TheLoai = 'Tin học' AND YEAR(NgayThue) = 2007

-- 3.2. Tìm các độc giả (MaDG,HoTen) đã thuê nhiều 
--thể loại sách nhất. (1.5 đ)  
SELECT D.MaDG, HoTen FROM DOCGIA D JOIN PHIEUTHUE P ON P.MaDG = D.MaDG
							JOIN CHITIET_PT C ON C.MaPT = P.MaPT
							JOIN SACH S ON S.MaSach = C.MaSach
GROUP BY D.MaDG, HoTen
HAVING COUNT(TheLoai) >= ALL (SELECT COUNT(TheLoai) FROM SACH S
								JOIN CHITIET_PT C ON C.MaSach = S.MaSach
								JOIN PHIEUTHUE P ON P.MaPT = C.MaPT
								JOIN DOCGIA D ON D.MaDG = P.MaDG
								GROUP BY D.MaDG, HoTen
								)


--3.3. Trong mỗi thể loại sách, cho biết tên sách được thuê nhiều nhất. (1 đ)  
SELECT TenSach, TheLoai FROM SACH S JOIN CHITIET_PT C ON C.MaSach = S.MaSach
GROUP BY TheLoai, TenSach
HAVING COUNT(MaPT) >= ALL (SELECT COUNT(MaPT) FROM CHITIET_PT C
							JOIN SACH S2 ON S2.MaSach = C.MaSach
							WHERE S.TheLoai = S2.TheLoai
							GROUP BY TenSach
							)