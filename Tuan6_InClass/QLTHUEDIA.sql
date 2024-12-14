CREATE DATABASE QLTHUEDIA

CREATE TABLE KHACHHANG
(
MaKH char(5) primary key,
HoTen varchar(30),
DiaChi varchar(30),
SoDT varchar(15),
LoaiKH varchar(10)
)

CREATE TABLE BANG_DIA
(
MaBD char(5) primary key,
TenBD varchar(25),
TheLoai varchar(25)
)

CREATE TABLE PHIEUTHUE
(
MaPT char(5) primary key,
MaKH char(5) foreign key references KHACHHANG(MaKH),
NgayThue smalldatetime,
NgayTra smalldatetime,
Soluongthue int
)

CREATE TABLE CHITIET_PM
(
MaPT char(5) not null foreign key references PHIEUTHUE(MaPT),
MaBD char(5) not null foreign key references BANG_DIA(MaBD)
)

ALTER TABLE CHITIET_PM
ADD primary key (MaPT, MaBD)

--2.1. Thể loại băng đĩa chỉ thuộc các thể loại sau “ca nhạc”, 
--“phim hành động”, “phim tình cảm”, “phim hoạt hình”. (1.5 đ)  
ALTER TABLE BANG_DIA
ADD CHECK( TheLoai IN ('phim hành động', 'ca nhạc', 'phim tình cảm', 'phim hoạt hình'))

--2.2. Chỉ những khách hàng thuộc loại VIP mới được thuê
--với số lượng băng đĩa trên 5. (1.5 đ)  
CREATE TRIGGER kiemtra_SoDiaThue ON PHIEUTHUE
FOR INSERT, UPDATE
AS
BEGIN
DECLARE @Soluongthue int, @MaKH char(5), @LoaiKH varchar(10)
SELECT @Soluongthue = Soluongthue, @MaKH = MaKH FROM inserted
SELECT @LoaiKH = LoaiKH FROM KHACHHANG WHERE MaKH = @MaKH
IF (@Soluongthue > 5 AND @LoaiKH != 'VIP')
BEGIN
RAISERROR('Khach hang VIP moi duoc thue tren 5 dia', 16,1)
ROLLBACK TRANSACTION
END
END

--3.1. Tìm các khách hàng (MaDG,HoTen) đã thuê băng đĩa thuộc 
--thể loại phim “Tình cảm” có số lượng thuê lớn hơn 3. (1.5 đ)  
SELECT K.MaKH, HoTen FROM KHACHHANG K JOIN PHIEUTHUE P ON P.MaKH = K.MaKH
						JOIN CHITIET_PM C ON C.MaPT = P.MaPT
						JOIN BANG_DIA B ON B.MaBD = C.MaBD
WHERE TheLoai = 'Tình cảm' AND Soluongthue > 3

--3.2. Tìm các khách hàng(MaDG,HoTen) thuộc loại VIP đã thuê
--nhiều băng đĩa nhất. (1.5 đ)  
SELECT K.MaKH, HoTen FROM KHACHHANG K JOIN PHIEUTHUE P ON P.MaKH = K.MaKH
WHERE LoaiKH = 'VIP' 
GROUP BY K.MaKH, HoTen
HAVING SUM(Soluongthue) >= ALL (SELECT SUM(Soluongthue) FROM PHIEUTHUE P
							JOIN KHACHHANG K ON K.MaKH = P.MaKH
							WHERE LoaiKH = 'VIP'
							GROUP BY K.MaKH
							)
--3.3. Trong mỗi thể loại băng đĩa, cho biết tên khách hàng nào 
--đã thuê nhiều băng đĩa nhất. (1 đ) 
SELECT HoTen FROM KHACHHANG K JOIN PHIEUTHUE P ON P.MaKH = K.MaKH
						JOIN CHITIET_PM C ON C.MaPT = P.MaPT
						JOIN BANG_DIA B ON B.MaBD = C.MaBD
GROUP BY TheLoai, HoTen
HAVING SUM(Soluongthue) >= ALL (SELECT SUM(Soluongthue) FROM KHACHHANG K JOIN PHIEUTHUE P ON P.MaKH = K.MaKH
						JOIN CHITIET_PM C ON C.MaPT = P.MaPT
						JOIN BANG_DIA B1 ON B1.MaBD = C.MaBD
						WHERE B1.TheLoai = B.TheLoai
						GROUP BY HoTen
						)