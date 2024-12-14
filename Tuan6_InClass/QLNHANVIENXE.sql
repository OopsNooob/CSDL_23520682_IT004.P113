CREATE DATABASE QLNHANVIENXE

CREATE TABLE PHONGBAN
(
MaPhong char(5) primary key,
TenPhong varchar(25),
TruongPhong char(5)
)

CREATE TABLE NHANVIEN
(
MaNV char(5) primary key,
HoTen varchar(20),
NgayVL smalldatetime,
HSLuong numeric(4,2),
MaPhong char(5) foreign key references PHONGBAN(MaPhong)
)



CREATE TABLE XE 
(
MaXe char(5) primary key,
LoaiXe varchar(20),
SoChoNgoi int,
NamSX int
)

CREATE TABLE PHANCONG
(
MaPC char(5) primary key,
MaNV char(5) foreign key references NHANVIEN(MaNV),
MaXe char(5) foreign key references XE(MaXe),
NgayDi smalldatetime,
NgayVe smalldatetime,
NoiDen varchar(25)
)

-- 2.1. Năm sản xuất của xe loại Toyota phải từ năm 2006 
-- trở về sau. (1.5 đ)  
CREATE TRIGGER kiemtraNam ON XE
FOR INSERT, UPDATE
AS
BEGIN
DECLARE @MaXe char(5), @LoaiXe varchar(20), @NamSX int
SELECT @MaXe = MaXe, @LoaiXe = LoaiXe, @NamSX = NamSX FROM inserted
IF (@NamSX < 2006 AND @LoaiXe = 'Toyota')
BEGIN
RAISERROR ('Nam san xuat cua xe loai Toyota phai tu nam 2006 tro ve sau', 16,1)
ROLLBACK TRANSACTION
END
END

-- 2.2. Nhân viên thuộc phòng lái xe “Ngoại thành” 
--chỉ được phân công lái xe loại Toyota. (1.5 đ)  
CREATE TRIGGER kiemtra_PhanCong ON PHANCONG
FOR INSERT, UPDATE
AS
BEGIN
DECLARE @MaNV char(5), @MaXe char(5), @LoaiXe varchar(20), @MaPhong char(5), @TenPhong varchar(25)
SELECT @MaNV = MaNV, @MaXe = MaXe FROM inserted
SELECT @LoaiXe = LoaiXe FROM XE WHERE MaXe = @MaXe
SELECT @MaPhong = MaPhong FROM NHANVIEN WHERE MaNV = @MaNV
SELECT @TenPhong= TenPhong FROM PHONGBAN WHERE MaPhong = @MaPhong
IF (@TenPhong = 'Ngoại thành' AND @LoaiXe != 'Toyota')
BEGIN
RAISERROR ('Nhan vien ngoai thanh chi duoc phan cong lai xe Toyota',16,1)
ROLLBACK TRANSACTION
END
END

--3.1. Tìm nhân viên (MaNV,HoTen) thuộc phòng lái xe “Nội thành” 
-- được phân công lái loại xe Toyota có số chỗ ngồi là 4. (1.5 đ)  
SELECT N.MaNV, HoTen FROM PHONGBAN P JOIN NHANVIEN N ON P.MaPhong = N.MaPhong
						JOIN PHANCONG PC ON PC.MaNV = N.MaNV JOIN
						XE ON XE.MaXe = PC.MaXe
WHERE TenPhong = 'Nội thành' AND LoaiXe = 'Toyota' AND SoChoNgoi = 4

-- 3.2. Tìm nhân viên(MANV,HoTen) là trưởng phòng được 
-- phân công lái tất cả các loại xe. (1.5 đ)  
SELECT MaNV, HoTen FROM NHANVIEN N JOIN PHONGBAN P ON P.TruongPhong = N.MaNV
WHERE NOT EXISTS (SELECT * FROM XE
					WHERE NOT EXISTS (SELECT * FROM PHANCONG PC
										WHERE PC.MaXe = XE.MaXe
										AND PC.MaNV = N.MaNV
										))


--3.3. Trong mỗi phòng ban,tìm nhân viên (MaNV,HoTen) được 
-- phân công lái ít nhất loại xe Toyota. (1 đ)  
SELECT N.MaNV, HoTen, P.MaPhong FROM PHONGBAN P JOIN NHANVIEN N ON N.MaPhong = P.MaPhong
						JOIN PHANCONG PC ON PC.MaNV = N.MaNV
						JOIN XE ON XE.MaXe = PC.MaXe
WHERE LoaiXe = 'Toyota'
GROUP BY P.MaPhong, N.MaNV, HoTen
HAVING COUNT(XE.MaXe) <= ALL (SELECT COUNT(XE.MaXe) FROM XE
								JOIN PHANCONG PC ON PC.MaXe = XE.MaXe
								JOIN NHANVIEN N2 ON N2.MaNV = PC.MaNV
								JOIN PHONGBAN P2 ON P2.MaPhong = N2.MaPhong
								WHERE XE.LoaiXe = 'Toyota' AND P2.MaPhong = P.MaPhong
								GROUP BY N2.MaNV
								)