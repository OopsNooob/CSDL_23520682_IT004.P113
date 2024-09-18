CREATE DATABASE QLGIAOVU

CREATE TABLE KHOA 
(
MAKHOA varchar(4) primary key,
TENKHOA varchar(40),
NGTLAP smalldatetime,
TRGKHOA char(4)
)

CREATE TABLE MONHOC 
(
MAMH varchar(10) primary key,
TENMH varchar(40),
TCLT tinyint,
TCTH tinyint,
MAKHOA varchar(4) foreign key references KHOA(MAKHOA)
)

CREATE TABLE DIEUKIEN
(
MAMH varchar(10) not null foreign key references MONHOC(MAMH),
MAMH_TRUOC varchar(10) not null foreign key references MONHOC(MAMH)
)

ALTER TABLE DIEUKIEN
ADD primary key (MAMH, MAMH_TRUOC)

CREATE TABLE GIAOVIEN
(
MAGV char(4) primary key,
HOTEN varchar(40),
HOCVI varchar(10),
HOCHAM varchar(10),
GIOITINH varchar(3),
NGSINH smalldatetime,
NGVL smalldatetime,
HESO numeric(4,2),
MUCLUONG money,
MAKHOA varchar(4) foreign key references KHOA(MAKHOA)
)

CREATE TABLE LOP
(
MALOP char(3) primary key,
TENLOP varchar(40),
TRGLOP char(5),
SISO tinyint,
MAGVCN char(4) foreign key references GIAOVIEN(MAGV)
)

CREATE TABLE HOCVIEN 
(
MAHV char(5) primary key,
HO varchar(40),
TEN varchar(10),
NGSINH smalldatetime,
GIOITINH varchar(3),
NOISINH varchar(40),
MALOP char(3) foreign key references LOP(MALOP)
)
CREATE TABLE GIANGDAY
(
MALOP char(3) not null foreign key references LOP(MALOP),
MAMH varchar(10) not null foreign key references MONHOC(MAMH),
MAGV char(4) not null foreign key references GIAOVIEN(MAGV),
HOCKY tinyint,
NAM smallint,
TUNGAY smalldatetime,
DENNGAY smalldatetime
)

ALTER TABLE GIANGDAY
ADD primary key (MALOP, MAMH, MAGV)

CREATE TABLE KETQUATHI
(
MAHV char(5) not null foreign key references HOCVIEN(MAHV),
MAMH varchar(10) not null foreign key references MONHOC(MAMH),
LANTHI tinyint,
NGTHI smalldatetime,
DIEM numeric(4,2),
KQUA varchar(10)
)

ALTER TABLE KETQUATHI
ADD primary key (MAHV, MAMH)

/** Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.**/
ALTER TABLE GIAOVIEN 
ADD CHECK (GIOITINH = 'Nam' or GIOITINH = 'Nu')
ALTER TABLE HOCVIEN
ADD CHECK (GIOITINH = 'Nam' or GIOITINH = 'Nu')

/** Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22)**/
ALTER TABLE KETQUATHI
ADD CHECK (DIEM <= 10 AND DIEM >= 0)

/** Kết quả thi là “Dat” nếu điểm từ 5 đến 10 và “Khong dat” nếu điểm nhỏ hơn 5**/
UPDATE KETQUATHI
SET KQUA = 'Dat'
WHERE DIEM >=5

UPDATE KETQUATHI
SET KQUA = 'Khong dat' 
WHERE DIEM < 5

/** Học viên thi một môn tối đa 3 lần.**/
ALTER TABLE KETQUATHI
ADD CHECK (LANTHI <=3)

/** Học kỳ chỉ có giá trị từ 1 đến 3.**/
ALTER TABLE GIANGDAY
ADD CHECK (HOCKY >= 1 AND HOCKY <=3)

/** Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.**/
ALTER TABLE GIAOVIEN
ADD CHECK (HOCVI = 'CN' OR HOCVI = 'KS' OR HOCVI = 'ThS' OR HOCVI = 'TS' OR HOCVI = 'PTS')