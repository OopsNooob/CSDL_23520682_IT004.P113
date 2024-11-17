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
LANTHI  tinyint not null,
NGTHI smalldatetime,
DIEM numeric(4,2),
KQUA varchar(10)
)

ALTER TABLE KETQUATHI
ADD primary key (MAHV, MAMH, LANTHI)

/** Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.**/
ALTER TABLE GIAOVIEN 
ADD CHECK (GIOITINH = 'Nam' or GIOITINH = 'Nu')
ALTER TABLE HOCVIEN
ADD CHECK (GIOITINH = 'Nam' or GIOITINH = 'Nu')

/** Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22)**/
ALTER TABLE KETQUATHI
ADD CHECK (DIEM <= 10.00 AND DIEM >= 0.00)

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

INSERT INTO KHOA (MAKHOA, TENKHOA, NGTLAP, TRGKHOA)
VALUES
('KHMT','Khoa hoc may tinh','6/7/2005','GV01'),
('HTTT','He thong thong tin','6/7/2005','GV02'),
('CNPM','Cong nghe phan mem','6/7/2005','GV04'),
('MTT','Mang va truyen thong','10/20/2005','GV03'),
('KTMT','Ky thuat may tinh','12/20/2005','')

INSERT INTO GIAOVIEN (MAGV, HOTEN, HOCVI, HOCHAM, GIOITINH, NGSINH, NGVL, HESO, MUCLUONG, MAKHOA)
VALUES
('GV01','Ho Thanh Son','PTS','GS','Nam','5/2/1950','1/11/2004',5.00,2250000,'KHMT'),
('GV02','Tran Tam Thanh','TS','PGS','Nam','12/17/1965','4/20/2004',4.50,2025000,'HTTT'),
('GV03','Do Nghiem Phung','TS','GS','Nu','8/1/1950','9/23/2004',4.00,1800000,'CNPM'),
('GV04','Tran Nam Son','TS','PGS','Nam','2/22/1961','1/12/2005',4.50,2025000,'KTMT'),
('GV05','Mai Thanh Danh','ThS','GV','Nam','3/12/1958','1/12/2005',3.00,1350000,'HTTT'),
('GV06','Tran Doan Hung','TS','GV','Nam','3/11/1953','1/12/2005',4.50,2025000,'KHMT'),
('GV07','Nguyen Minh Tien','ThS','GV','Nam','11/23/1971','3/1/2005',4.00,1800000,'KHMT'),
('GV08','Le Thi Tran','KS','','Nu','3/26/1974','3/1/2005',1.69,760500,'KHMT'),
('GV09','Nguyen To Lan','ThS','GV','Nu','12/31/1966','3/1/2005',4.00,1800000,'HTTT'),
('GV10','Le Tran Anh Loan','KS','','Nu','7/17/1972','3/1/2005',1.86,837000,'CNPM'),
('GV11','Ho Thanh Tung','CN','GV','Nam','1/12/1980','5/15/2005',2.67,1201500,'MTT'),
('GV12','Tran Van Anh','CN','','Nu','3/29/1981','5/15/2005',1.69,760500,'CNPM'),
('GV13','Nguyen Linh Dan','CN','','Nu','5/23/1980','5/15/2005',1.69,760500,'KTMT'),
('GV14','Truong Minh Chau','ThS','GV','Nu','11/30/1976','5/15/2005',3.00,1350000,'MTT'),
('GV15','Le Ha Thanh','ThS','GV','Nam','5/4/1978','5/15/2005',3.00,1350000,'KHMT')
 

INSERT INTO MONHOC (MAMH, TENMH, TCLT, TCTH, MAKHOA)
VALUES
('THDC','Tin hoc dai cuong',4,1,'KHMT'),
('CTRR','Cau truc roi rac',5,0,'KHMT'),
('CSDL','Co so du lieu',3,1,'HTTT'),
('CTDLGT','Cau truc du lieu va giai thuat',3,1,'KHMT'),
('PTTKTT','Phan tich thiet ke thuat toan',3,0,'KHMT'),
('DHMT','Do hoa may tinh',3,1,'KHMT'),
('KTMT','Kien truc may tinh',3,0,'KTMT'),
('TKCSDL','Thiet ke co so du lieu',3,1,'HTTT'),
('PTTKHTTT','Phan tich thiet ke he thong thong tin',4,1,'HTTT'),
('HDH','He dieu hanh',4,0,'KTMT'),
('NMCNPM','Nhap mon cong nghe phan mem',3,0,'CNPM'),
('LTCFW','Lap trinh C for win',3,1,'CNPM'),
('LTHDT','Lap trinh huong doi tuong',3,1,'CNPM')

INSERT INTO LOP (MALOP, TENLOP, TRGLOP, SISO, MAGVCN)
VALUES
('K11','Lop 1 khoa 1','K1108',11,'GV07'),
('K12','Lop 2 khoa 1','K1205',12,'GV09'),
('K13','Lop 3 khoa 1','K1305',12,'GV14')

INSERT INTO HOCVIEN (MAHV, HO, TEN, NGSINH, GIOITINH, NOISINH, MALOP)
VALUES
('K1101','Nguyen Van','A','1/27/1986','Nam','TpHCM','K11'),
('K1102','Tran Ngoc','Han','3/1/1986','Nu','Kien Giang','K11'),
('K1103','Ha Duy','Lap','4/18/1986','Nam','Nghe An','K11'),
('K1104','Tran Ngoc','Linh','3/30/1986','Nu','Tay Ninh','K11'),
('K1105','Tran Minh','Long','2/27/1986','Nam','TpHCM','K11'),
('K1106','Le Nhat','Minh','1/24/1986','Nam','TpHCM','K11'),
('K1107','Nguyen Nhu','Nhut','1/27/1986','Nam','Ha Noi','K11'),
('K1108','Nguyen Manh','Tam','2/27/1986','Nam','Kien Giang','K11'),
('K1109','Phan Thi Thanh','Tam','1/27/1986','Nu','Vinh Long','K11'),
('K1110','Le Hoai','Thuong','2/5/1986','Nu','Can Tho','K11'),
('K1111','Le Ha','Vinh','12/25/1986','Nam','Vinh Long','K11'),
('K1201','Nguyen Van','B','2/11/1986','Nam','TpHCM','K12'),
('K1202','Nguyen Thi Kim','Duyen','1/18/1986','Nu','TpHCM','K12'),
('K1203','Tran Thi Kim','Duyen','9/17/1986','Nu','TpHCM','K12'),
('K1204','Truong My','Hanh','5/19/1986','Nu','Dong Nai','K12'),
('K1205','Nguyen Thanh','Nam','4/17/1986','Nam','TpHCM','K12'),
('K1206','Nguyen Thi Truc','Thanh','3/4/1986','Nu','Kien Giang','K12'),
('K1207','Tran Thi Bich','Thuy','2/8/1986','Nu','Nghe An','K12'),
('K1208','Huynh Thi Kim','Trieu','4/8/1986','Nu','Tay Ninh','K12'),
('K1209','Pham Thanh','Trieu','2/23/1986','Nam','TpHCM','K12'),
('K1210','Ngo Thanh','Tuan','2/14/1986','Nam','TpHCM','K12'),
('K1211','Do Thi','Xuan','3/9/1986','Nu','Ha Noi','K12'),
('K1212','Le Thi Phi','Yen','3/12/1986','Nu','TpHCM','K12'),
('K1301','Nguyen Thi Kim','Cuc','6/9/1986','Nu','Kien Giang','K13'),
('K1302','Truong Thi My','Hien','3/18/1986','Nu','Nghe An','K13'),
('K1303','Le Duc','Hien','3/12/1986','Nam','Tay Ninh','K13'),
('K1304','Le Quang','Hien','4/18/1986','Nam','TpHCM','K13'),
('K1305','Le Thi','Huong','3/27/1986','Nu','TpHCM','K13'),
('K1306','Nguyen Thai','Huu','3/30/1986','Nam','Ha Noi','K13'),
('K1307','Tran Minh','Man','5/28/1986','Nam','TpHCM','K13'),
('K1308','Nguyen Hieu','Nghia','4/8/1986','Nam','Kien Giang','K13'),
('K1309','Nguyen Trung','Nghia','1/18/1987','Nam','Nghe An','K13'),
('K1310','Tran Thi Hong','Tham','4/22/1986','Nu','Tay Ninh','K13'),
('K1311','Tran Minh','Thuc','4/4/1986','Nam','TpHCM','K13'),
('K1312','Nguyen Thi Kim','Yen','9/7/1986','Nu','TpHCM','K13')

INSERT INTO GIANGDAY (MALOP, MAMH, MAGV, HOCKY, NAM, TUNGAY, DENNGAY)
VALUES
('K11','THDC','GV07',1,2006,'1/2/2006','5/12/2006'),
('K12','THDC','GV06',1,2006,'1/2/2006','5/12/2006'),
('K13','THDC','GV15',1,2006,'1/2/2006','5/12/2006'),
('K11','CTRR','GV02',1,2006,'1/9/2006','5/17/2006'),
('K12','CTRR','GV02',1,2006,'1/9/2006','5/17/2006'),
('K13','CTRR','GV08',1,2006,'1/9/2006','5/17/2006'),
('K11','CSDL','GV05',2,2006,'6/1/2006','7/15/2006'),
('K12','CSDL','GV09',2,2006,'6/1/2006','7/15/2006'),
('K13','CTDLGT','GV15',2,2006,'6/1/2006','7/15/2006'),
('K13','CSDL','GV05',3,2006,'8/1/2006','12/15/2006'),
('K13','DHMT','GV07',3,2006,'8/1/2006','12/15/2006'),
('K11','CTDLGT','GV15',3,2006,'8/1/2006','12/15/2006'),
('K12','CTDLGT','GV15',3,2006,'8/1/2006','12/15/2006'),
('K11','HDH','GV04',1,2007,'1/2/2007','2/18/2007'),
('K12','HDH','GV04',1,2007,'1/2/2007','3/20/2007'),
('K11','DHMT','GV07',1,2007,'2/18/2007','3/20/2007')

INSERT INTO DIEUKIEN(MAMH, MAMH_TRUOC)
VALUES
('CSDL','CTRR'),
('CSDL','CTDLGT'),
('CTDLGT','THDC'),
('PTTKTT','THDC'),
('PTTKTT','CTDLGT'),
('DHMT','THDC'),
('LTHDT','THDC'),
('PTTKHTTT','CSDL')

INSERT INTO KETQUATHI (MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA)
VALUES
('K1101','CSDL',1,'7/20/2006',10.00,'Dat'),
('K1101','CTDLGT',1,'12/28/2006',9.00,'Dat'),
('K1101','THDC',1,'5/20/2006',9.00,'Dat'),
('K1101','CTRR',1,'5/13/2006',9.50,'Dat'),
('K1102','CSDL',1,'7/20/2006',4.00,'Khong Dat'),
('K1102','CSDL',2,'7/27/2006',4.25,'Khong Dat'),
('K1102','CSDL',3,'8/10/2006',4.50,'Khong Dat'),
('K1102','CTDLGT',1,'12/28/2006',4.50,'Khong Dat'),
('K1102','CTDLGT',2,'1/5/2007',4.00,'Khong Dat'),
('K1102','CTDLGT',3,'1/15/2007',6.00,'Dat'),
('K1102','THDC',1,'5/20/2006',5.00,'Dat'),
('K1102','CTRR',1,'5/13/2006',7.00,'Dat'),
('K1103','CSDL',1,'7/20/2006',3.50,'Khong Dat'),
('K1103','CSDL',2,'7/27/2006',8.25,'Dat'),
('K1103','CTDLGT',1,'12/28/2006',7.00,'Dat'),
('K1103','THDC',1,'5/20/2006',8.00,'Dat'),
('K1103','CTRR',1,'5/13/2006',6.50,'Dat'),
('K1104','CSDL',1,'7/20/2006',3.75,'Khong Dat'),
('K1104','CTDLGT',1,'12/28/2006',4.00,'Khong Dat'),
('K1104','THDC',1,'5/20/2006',4.00,'Khong Dat'),
('K1104','CTRR',1,'5/13/2006',4.00,'Khong Dat'),
('K1104','CTRR',2,'5/20/2006',3.50,'Khong Dat'),
('K1104','CTRR',3,'6/30/2006',4.00,'Khong Dat'),
('K1201','CSDL',1,'7/20/2006',6.00,'Dat'),
('K1201','CTDLGT',1,'12/28/2006',5.00,'Dat'),
('K1201','THDC',1,'5/20/2006',8.50,'Dat'),
('K1201','CTRR',1,'5/13/2006',9.00,'Dat'),
('K1202','CSDL',1,'7/20/2006',8.00,'Dat'),
('K1202','CTDLGT',1,'12/28/2006',4.00,'Khong Dat'),
('K1202','CTDLGT',2,'1/5/2007',5.00,'Dat'),
('K1202','THDC',1,'5/20/2006',4.00,'Khong Dat'),
('K1202','THDC',2,'5/27/2006',4.00,'Khong Dat'),
('K1202','CTRR',1,'5/13/2006',3.00,'Khong Dat'),
('K1202','CTRR',2,'5/20/2006',4.00,'Khong Dat'),
('K1202','CTRR',3,'6/30/2006',6.25,'Dat'),
('K1203','CSDL',1,'7/20/2006',9.25,'Dat'),
('K1203','CTDLGT',1,'12/28/2006',9.50,'Dat'),
('K1203','THDC',1,'5/20/2006',10.00,'Dat'),
('K1203','CTRR',1,'5/13/2006',10.00,'Dat'),
('K1204','CSDL',1,'7/20/2006',8.50,'Dat'),
('K1204','CTDLGT',1,'12/28/2006',6.75,'Dat'),
('K1204','THDC',1,'5/20/2006',4.00,'Khong Dat'),
('K1204','CTRR',1,'5/13/2006',6.00,'Dat'),
('K1301','CSDL',1,'12/20/2006',4.25,'Khong Dat'),
('K1301','CTDLGT',1,'7/25/2006',8.00,'Dat'),
('K1301','THDC',1,'5/20/2006',7.75,'Dat'),
('K1301','CTRR',1,'5/13/2006',8.00,'Dat'),
('K1302','CSDL',1,'12/20/2006',6.75,'Dat'),
('K1302','CTDLGT',1,'7/25/2006',5.00,'Dat'),
('K1302','THDC',1,'5/20/2006',8.00,'Dat'),
('K1302','CTRR',1,'5/13/2006',8.50,'Dat'),
('K1303','CSDL',1,'12/20/2006',4.00,'Khong Dat'),
('K1303','CTDLGT',1,'7/25/2006',4.50,'Khong Dat'),
('K1303','CTDLGT',2,'8/7/2006',4.00,'Khong Dat'),
('K1303','CTDLGT',3,'8/15/2006',4.25,'Khong Dat'),
('K1303','THDC',1,'5/20/2006',4.50,'Khong Dat'),
('K1303','CTRR',1,'5/13/2006',3.25,'Khong Dat'),
('K1303','CTRR',2,'5/20/2006',5.00,'Dat'),
('K1304','CSDL',1,'12/20/2006',7.75,'Dat'),
('K1304','CTDLGT',1,'7/25/2006',9.75,'Dat'),
('K1304','THDC',1,'5/20/2006',5.50,'Dat'),
('K1304','CTRR',1,'5/13/2006',5.00,'Dat'),
('K1305','CSDL',1,'12/20/2006',9.25,'Dat'),
('K1305','CTDLGT',1,'7/25/2006',10.00,'Dat'),
('K1305','THDC',1,'5/20/2006',8.00,'Dat'),
('K1305','CTRR',1,'5/13/2006',10.00,'Dat')

--11. Học viên ít nhất là 18 tuổi.
ALTER TABLE HOCVIEN
ADD CHECK (DATEDIFF(YEAR, NGSINH, GETDATE()) >=18)

-- 12. Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
ALTER TABLE GIANGDAY
ADD CHECK (TUNGAY < DENNGAY)

-- 13. Giáo viên khi vào làm ít nhất là 22 tuổi
ALTER TABLE GIAOVIEN
ADD CHECK (DATEDIFF(YEAR, NGSINH, NGVL) >=22)

--14. Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
ALTER TABLE MONHOC
WITH NOCHECK
ADD CHECK (ABS(TCLT - TCTH)  <= 3)

-- 1. In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT MAHV, HO, TEN, NGSINH, LOP.MALOP FROM LOP JOIN HOCVIEN ON HOCVIEN.MALOP = LOP.MALOP

-- 2. In ra bảng điểm khi thi (mã học viên, họ tên, lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo tên, họ học viên.
SELECT KETQUATHI.MAHV, HO, TEN, LANTHI, DIEM FROM HOCVIEN JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE MALOP = 'K12' AND MAMH = 'CTRR'
ORDER BY TEN ASC, HO ASC

-- 3. In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt.
SELECT HOCVIEN.MAHV, HO, TEN FROM HOCVIEN JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE LANTHI = '1' AND KQUA = 'Dat'

-- 4. In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
SELECT HOCVIEN.MAHV, HO, TEN FROM HOCVIEN JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE MALOP = 'K11' AND MAMH = 'CTRR' AND LANTHI = '1' AND KQUA = 'Khong dat'

-- 5. * Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).
SELECT HOCVIEN.MAHV, HO, TEN FROM HOCVIEN JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE MALOP LIKE 'K%' AND MAMH = 'CTRR' AND KQUA = 'Khong dat'

-- 1. Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.
UPDATE GIAOVIEN
SET HESO  = HESO + 0.2
WHERE MAGV IN(SELECT TRGKHOA FROM KHOA)

/* 2. Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên (tất cả các 
môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau 
cùng).*/
UPDATE HOCVIEN
SET DIEMTB = 
(
SELECT AVG(LANCUOI.DIEM)
FROM (
SELECT KQ.MAHV, KQ.MAMH, KQ.DIEM
FROM KETQUATHI KQ
	JOIN (
	SELECT MAHV, MAMH, MAX(LANTHI) AS MAX_LANTHI
	FROM KETQUATHI
	GROUP BY MAHV, MAMH
		) AS MAX_KETQUA ON KQ.MAHV = MAX_KETQUA.MAHV AND KQ.MAMH = MAX_KETQUA.MAMH AND KQ.LANTHI = MAX_KETQUA.MAX_LANTHI
	) AS LANCUOI
WHERE LANCUOI.MAHV = HOCVIEN.MAHV
)
WHERE MAHV IN (
    SELECT DISTINCT MAHV 
    FROM KETQUATHI
);

/*3. Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất 
kỳ thi lần thứ 3 dưới 5 điểm.*/
UPDATE HOCVIEN
SET GHICHU = 'Cam thi'
WHERE MAHV IN (SELECT MAHV FROM KETQUATHI WHERE LANTHI = 3 AND DIEM < 5)


/*4. Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau:
o Nếu DIEMTB  9 thì XEPLOAI =”XS”
o Nếu 8  DIEMTB < 9 thì XEPLOAI = “G”
o Nếu 6.5  DIEMTB < 8 thì XEPLOAI = “K”
o Nếu 5  DIEMTB < 6.5 thì XEPLOAI = “TB”
o Nếu DIEMTB < 5 thì XEPLOAI = ”Y” */
UPDATE HOCVIEN 
SET XEPLOAI = CASE
WHEN (DIEMTB >= 9) THEN 'XS'
WHEN (DIEMTB >= 8) THEN 'G'
WHEN (DIEMTB >= 6.5) THEN 'TB'
WHEN (DIEMTB >= 5) THEN 'TB'
ELSE 'Y'
END


/*6. Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 
2006*/.
SELECT DISTINCT mh.MAMH, mh.TENMH FROM MONHOC mh
JOIN GIANGDAY gd ON mh.MAMH = gd.MAMH
JOIN GIAOVIEN gv ON gv.MAGV = gd.MAGV
WHERE gv.HOTEN = 'Tran Tam Thanh' AND gd.HOCKY = 1 AND gd.NAM = 2006

/*7. Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy 
trong học kỳ 1 năm 2006.*/
SELECT MAMH, TENMH FROM MONHOC
WHERE MAMH IN (SELECT MAMH FROM GIANGDAY WHERE MAGV IN (SELECT MAGVCN FROM LOP WHERE MALOP = 'K11') AND HOCKY = 1 AND NAM = 2006)

/*8. Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So 
Du Lieu”.*/
SELECT HO, TEN FROM HOCVIEN
WHERE MAHV IN (SELECT TRGLOP FROM LOP WHERE MALOP IN (SELECT MALOP FROM GIANGDAY WHERE MAGV IN(SELECT MAGV FROM GIAOVIEN WHERE HoTen = 'Nguyen To Lan') 
AND MAMH IN(SELECT MAMH FROM MONHOC WHERE TENMH = 'Co So Du Lieu')))

/*9. In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So 
Du Lieu”.*/
SELECT MH.MAMH, MH.TENMH FROM MONHOC MH
WHERE MH.MAMH IN (SELECT MAMH_TRUOC FROM DIEUKIEN WHERE MAMH = 'CSDL')

/*10. Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, 
tên môn học) nào.*/
SELECT MH.MAMH, MH.TENMH FROM MONHOC MH 
WHERE MH.MAMH IN (SELECT MAMH FROM DIEUKIEN WHERE MAMH_TRUOC = 'CTRR')

-- 11. Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006.
SELECT HOTEN FROM GIAOVIEN 
WHERE MAGV IN
(
SELECT GV.MAGV FROM GIAOVIEN GV JOIN GIANGDAY GD ON GV.MAGV = GD.MAGV
WHERE MAMH = 'CTRR' AND MALOP = 'K11' AND NAM = '2006' AND HOCKY = '1'
INTERSECT
SELECT GV.MAGV FROM GIAOVIEN GV JOIN GIANGDAY GD ON GV.MAGV = GD.MAGV
WHERE MAMH = 'CTRR' AND MALOP = 'K12' AND NAM = '2006' AND HOCKY = '1'
)

-- 12. Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này.
SELECT MAHV, HO, TEN FROM HOCVIEN
WHERE MAHV IN 
(
SELECT HV.MAHV FROM HOCVIEN HV JOIN KETQUATHI KQT ON HV.MAHV = KQT.MAHV
WHERE MAMH = 'CSDL'  AND KQUA = 'Khong Dat'
EXCEPT
SELECT HV.MAHV FROM HOCVIEN HV JOIN KETQUATHI KQT ON HV.MAHV = KQT.MAHV
WHERE MAMH = 'CSDL'  AND KQUA = 'Dat'
)

-- 13. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.
SELECT MAGV, HOTEN FROM GIAOVIEN
WHERE MAGV NOT IN
(
SELECT GV.MAGV FROM GIAOVIEN GV JOIN GIANGDAY GD ON GV.MAGV = GD.MAGV
)

-- 14. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách.
SELECT MAGV, HOTEN FROM GIAOVIEN
WHERE MAGV NOT IN
(
SELECT GV.MAGV, HOTEN FROM GIAOVIEN GV JOIN GIANGDAY GD ON GV.MAGV = GD.MAGV
WHERE MAMH IN (SELECT MAMH FROM MONHOC WHERE MAKHOA = GV.MAKHOA)
)

-- 15. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat” hoặc thi lần thứ 2 môn CTRR được 5 điểm.
SELECT HO+ ' ' + TEN AS 'HoVaTen' FROM HOCVIEN 
WHERE MAHV NOT IN
(
SELECT HV.MAHV FROM HOCVIEN HV JOIN KETQUATHI KQT ON HV.MAHV = KQT.MAHV
WHERE HV.MALOP = 'K11' AND  KQT.LANTHI > 3 AND KQT.KQUA = 'Khong dat'
UNION
SELECT HV.MAHV FROM HOCVIEN HV JOIN KETQUATHI KQT ON HV.MAHV = KQT.MAHV  
WHERE HV.MALOP = 'K11' AND  KQT.LANTHI = 2 AND KQT.MAMH = 'CTRR' AND DIEM = 5
)

-- 16. Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.
SELECT HOTEN, COUNT(MAMH) AS 'SoLop' 
FROM GIAOVIEN GV JOIN GIANGDAY GD ON GV.MAGV = GD.MAGV
WHERE MAMH = 'CTRR' AND GV.MAGV IN (
									SELECT GV.MAGV FROM GIAOVIEN GV JOIN GIANGDAY GD ON GV.MAGV = GD.MAGV
								   )
GROUP BY GV.HOTEN
HAVING COUNT(MAMH) >= 2

-- 17. Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
SELECT KQ.MAHV, KQ.DIEM FROM KETQUATHI KQ
JOIN 
(SELECT MAHV, MAX(LANTHI) AS LANCUOI FROM KETQUATHI 
WHERE MAMH = 'CSDL'
GROUP BY MAHV
) AS SAUCUNG ON KQ.MAHV = SAUCUNG.MAHV AND KQ.LANTHI = SAUCUNG.LANCUOI
WHERE MAMH = 'CSDL'

-- 18. Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).
SELECT KQ.MAHV, KQ.DIEM FROM KETQUATHI KQ
JOIN 
(SELECT MAHV, MAX(DIEM) AS CAONHAT FROM KETQUATHI 
WHERE MAMH = 'CSDL'
GROUP BY MAHV
) AS LONNHAT ON KQ.MAHV = LONNHAT.MAHV AND KQ.DIEM = LONNHAT.CAONHAT
WHERE KQ.MAMH = 'CSDL'

-- 19. Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất. 
SELECT MAKHOA, TENKHOA FROM KHOA
WHERE NGTLAP <= ALL (SELECT NGTLAP FROM KHOA)

-- 20. Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”. 
SELECT COUNT(MAGV) 'SoGV' FROM GIAOVIEN
WHERE HOCHAM IN ('GS', 'PGS')

-- 21. Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa. 
SELECT MAKHOA, COUNT(MAGV) 'SoGV' FROM GIAOVIEN
WHERE HOCVI IN ('CN','KS', 'Ths', 'TS', 'PTS')
GROUP BY MAKHOA

-- 22. Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt). 
SELECT 
    MAMH,
    SUM(CASE WHEN KQUA = 'Dat' THEN 1 ELSE 0 END) AS 'SoHVDat',
    SUM(CASE WHEN KQUA = 'Khong Dat' THEN 1 ELSE 0 END) AS 'SoHVKhongDat'
FROM KETQUATHI
GROUP BY MAMH 
    	   
-- 23. Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học. 
SELECT MAGV, HOTEN FROM GIAOVIEN 
WHERE MAGV IN (
				SELECT GV.MAGV FROM GIAOVIEN GV JOIN GIANGDAY GD ON GV.MAGV = GD.MAGV JOIN LOP L ON L.MALOP = GD.MALOP
				WHERE GV.MAGV = L.MAGVCN
				GROUP BY GV.MAGV
				HAVING COUNT(MAMH) >= 1
			  )

-- 24. Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất. 
SELECT HO+ ' ' + TEN AS 'HoVaTen' FROM HOCVIEN HV
WHERE HV.MAHV IN (SELECT MAHV FROM HOCVIEN HV JOIN LOP L ON HV.MAHV = L.TRGLOP
				WHERE SISO >= ALL (SELECT SISO FROM LOP	)
		   	     )

-- 25. * Tìm họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần thi). 
SELECT HO+ ' ' + TEN AS 'HoVaTen' FROM HOCVIEN HV
WHERE HV.MAHV IN (SELECT L.TRGLOP FROM HOCVIEN HV JOIN LOP L ON HV.MAHV = L.TRGLOP JOIN KETQUATHI KQ ON KQ.MAHV = HV.MAHV
				WHERE KQUA = 'Khong Dat'
				GROUP BY L.TRGLOP, KQ.MAMH
				HAVING COUNT(DISTINCT MAMH) > 3
				AND COUNT (DISTINCT CASE WHEN KQ.KQUA = 'Dat'  THEN KQ.LANTHI ELSE NULL END) = 0
		   	     )

-- 26. Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất. 
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS 'HoVaTen'
FROM HOCVIEN HV
WHERE HV.MAHV IN 
(
    SELECT TOP 1 MAHV
    FROM KETQUATHI
    WHERE DIEM >= 9
    GROUP BY MAHV
    ORDER BY COUNT(DISTINCT MAMH) DESC
)
              
-- 27. Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất. 
WITH RANKBYCLASS AS
(
SELECT HV.MAHV, HV.HO + ' ' + HV.TEN AS 'HoVaTen', GD.MALOP, 
		COUNT(DISTINCT KQT.MAMH) AS 'SoMH',
		RANK() OVER (PARTITION BY GD.MALOP ORDER BY COUNT(DISTINCT KQT.MAMH) DESC) AS 'RANK'
		FROM HOCVIEN HV JOIN KETQUATHI KQT ON HV.MAHV = KQT.MAHV JOIN GIANGDAY GD ON GD.MAMH = KQT.MAMH AND HV.MALOP = GD.MALOP
		WHERE KQT.DIEM >= 9
		GROUP BY HV.MAHV, HV.HO, HV.TEN, GD.MALOP
)
SELECT MAHV, HoVaTen, MALOP, SoMH FROM RANKBYCLASS
WHERE RANK = 1
ORDER BY MALOP, HoVaTen;
              
-- 28. Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp. 
SELECT GV.MAGV, HOTEN, COUNT(MAMH) 'SoMH', COUNT(MALOP) 'SoLop' FROM GIAOVIEN GV JOIN GIANGDAY GD ON GV.MAGV = GD.MAGV
GROUP BY GV.MAGV, HOTEN, HOCKY, NAM
ORDER BY HOCKY, NAM

-- 29. Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất. 
WITH StatGV AS (SELECT GV.MAGV, HOTEN,HOCKY, NAM, COUNT(DISTINCT MAMH) 'SoMH', COUNT(DISTINCT L.MALOP) 'SoLop', 
COUNT(DISTINCT GD.MAMH) + COUNT(DISTINCT L.MALOP) AS 'TongGiangDay' 
FROM GIAOVIEN GV JOIN GIANGDAY GD ON GV.MAGV = GD.MAGV JOIN LOP L ON L.MALOP = GD.MALOP
GROUP BY  GV.MAGV, GV.HOTEN, GD.HOCKY, GD.NAM
),
RankGV AS 
(
SELECT MAGV, HOTEN,HOCKY, NAM, SoMH, SoLop, TongGiangDay ,
	RANK() OVER (PARTITION BY HOCKY, NAM ORDER BY TongGiangDay DESC) AS 'RANK'
FROM StatGV
)

SELECT MAGV, HOTEN, SoLop, SoMH FROM RankGV
WHERE RANK = 1
ORDER BY HOCKY, NAM

-- 30. Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất. 
SELECT MH.MAMH, TENMH FROM MONHOC MH JOIN KETQUATHI KQT ON MH.MAMH = KQT.MAMH
WHERE KQUA = 'Khong Dat' AND LANTHI = 1
GROUP BY MH.MAMH, TENMH
HAVING COUNT(MAHV) >= ALL (SELECT COUNT(MAHV) FROM KETQUATHI
							WHERE KQUA = 'Khong Dat' AND LANTHI = 1
							GROUP BY MAMH
							)

-- 31. Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1). 
SELECT DISTINCT HV.MAHV, HO + ' ' + TEN AS 'HoVaTen' FROM HOCVIEN HV JOIN KETQUATHI KQT ON HV.MAHV = KQT.MAHV 
WHERE LANTHI = 1 AND KQT.MAHV NOT IN (
										SELECT MAHV FROM KETQUATHI
										WHERE KQUA = 'Khong Dat' AND LANTHI = 1
										)


-- 32. * Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng). 
SELECT DISTINCT HV.MAHV, HO + ' ' + TEN AS 'HoVaTen' FROM HOCVIEN HV JOIN KETQUATHI KQT ON HV.MAHV = KQT.MAHV 
JOIN (
    SELECT MAHV, MAMH, MAX(LANTHI) AS LANCUOI FROM KETQUATHI
    GROUP BY MAHV, MAMH
     ) SAUCUNG  ON KQT.MAHV = SAUCUNG.MAHV AND KQT.MAMH = SAUCUNG.MAMH AND KQT.LANTHI = SAUCUNG.LANCUOI
GROUP BY HV.MAHV, HO, TEN
HAVING COUNT(DISTINCT KQT.MAMH) = COUNT(DISTINCT CASE WHEN KQUA = 'Dat' THEN KQT.MAMH END)

-- 33. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn và đều đạt (chỉ xét lần thi thứ 1). 
SELECT DISTINCT HV.MAHV, HO + ' ' + TEN AS 'HoVaTen' FROM HOCVIEN HV JOIN KETQUATHI KQT ON HV.MAHV = KQT.MAHV  JOIN MONHOC MH ON MH.MAMH = KQT.MAMH
WHERE LANTHI = 1
GROUP BY HV.MAHV, HO, TEN
HAVING COUNT(DISTINCT MH.MAMH) = COUNT(DISTINCT CASE WHEN KQUA = 'Dat' THEN KQT.MAMH END)

-- 34. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn và đều đạt (chỉ xét lần thi sau cùng). 
SELECT DISTINCT HV.MAHV, HO + ' ' + TEN AS 'HoVaTen' FROM HOCVIEN HV JOIN KETQUATHI KQT ON HV.MAHV = KQT.MAHV JOIN MONHOC MH ON MH.MAMH = KQT.MAMH
JOIN (
    SELECT MAHV, MAMH, MAX(LANTHI) AS LANCUOI FROM KETQUATHI
    GROUP BY MAHV, MAMH
     ) SAUCUNG  ON KQT.MAHV = SAUCUNG.MAHV AND KQT.MAMH = SAUCUNG.MAMH AND KQT.LANTHI = SAUCUNG.LANCUOI
GROUP BY HV.MAHV, HO, TEN
HAVING COUNT(DISTINCT KQT.MAMH) = (SELECT COUNT(*) FROM MONHOC)
	AND COUNT(DISTINCT CASE WHEN KQUA = 'Dat' THEN KQT.MAMH END) = (SELECT COUNT(*) FROM MONHOC)

-- 35. ** Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần thi sau cùng).
SELECT DISTINCT HV.MAHV, HO + ' ' + TEN AS 'HoVaTen' FROM HOCVIEN HV JOIN KETQUATHI KQT ON HV.MAHV = KQT.MAHV JOIN MONHOC MH ON MH.MAMH = KQT.MAMH
JOIN (
    SELECT MAHV, MAMH, MAX(LANTHI) AS LANCUOI FROM KETQUATHI
    GROUP BY MAHV, MAMH
     ) SAUCUNG  ON KQT.MAHV = SAUCUNG.MAHV AND KQT.MAMH = SAUCUNG.MAMH AND KQT.LANTHI = SAUCUNG.LANCUOI
WHERE DIEM = (SELECT MAX(DIEM) FROM KETQUATHI KQ2
				WHERE KQT.MAMH = KQ2.MAMH
				GROUP BY KQ2.MAMH
				)

-- 9. Lớp trưởng của một lớp phải là học viên của lớp đó. 
CREATE TRIGGER THEMSUA_LOP ON LOP
FOR INSERT, UPDATE
AS
BEGIN 
IF NOT EXISTS (SELECT * FROM INSERTED I, HOCVIEN HV
				WHERE I.TRGLOP = HV.MAHV AND I.MALOP = HV.MALOP
				)
				BEGIN 
					PRINT 'Lop truong cua lop khong phai la hoc vien cua lop'
					ROLLBACK TRANSACTION
				END
END

CREATE TRIGGER XOA_HOCVIEN ON HOCVIEN
FOR DELETE
AS 
BEGIN
IF EXISTS (SELECT * FROM DELETED D, LOP L
			WHERE L.TRGLOP = D.MAHV AND D.MALOP = L.MALOP)
			BEGIN 
				PRINT 'Hoc vien dang la lop truong'
				ROLLBACK TRANSACTION
			END
END

-- 10. Trưởng khoa phải là giáo viên thuộc khoa và có học vị “TS” hoặc “PTS”. 
CREATE TRIGGER SUA_TRGKHOA ON KHOA
FOR UPDATE
AS 
BEGIN
DECLARE @MAKHOA char(4), @TRGKHOA char(4), @MAGV char(4), @MAKHOAGV char(4)
SELECT @MAKHOA = MAKHOA, @TRGKHOA = @TRGKHOA FROM INSERTED
SELECT @MAGV = MAGV, @MAKHOAGV = MAKHOA FROM GIAOVIEN WHERE MAGV = @TRGKHOA
IF (@MAKHOAGV = @MAKHOA AND @MAGV IN (SELECT MAGV FROM GIAOVIEN WHERE HOCVI IN ('TS', 'PTS')))
BEGIN
PRINT 'SUA THANH CONG'
END
ELSE
BEGIN 
PRINT 'Truong khoa khong la giao vien thuoc khoa hoc co hoc vi TS, PTS'
ROLLBACK TRANSACTION
END
END

CREATE TRIGGER SUA_MAKHOA_HOCVI ON GIAOVIEN
FOR UPDATE 
AS
BEGIN
DECLARE @MAKHOAGV char(4), @HOCVI varchar(10), @MAGV char(4)
SELECT @MAKHOAGV = MAKHOA, @HOCVI = HOCVI FROM INSERTED
IF (@MAGV IN (SELECT TRGKHOA FROM KHOA) AND @HOCVI IN ('TS', 'PTS'))
BEGIN
PRINT 'SUA THANH CONG'
END
ELSE
BEGIN
PRINT 'Giao vien dang la truong khoa va co hoc vi la TS hoac PTS'
ROLLBACK TRANSACTION
END
END

-- 15. Học viên chỉ được thi một môn học nào đó khi lớp của học viên đã học xong môn học này. 
CREATE TRIGGER THEMSUA_NGTHI ON KETQUATHI
FOR INSERT, UPDATE
AS
BEGIN 
DECLARE @MAHV char(5), @MALOP char(3), @NGTHI smalldatetime, @DENNGAY smalldatetime, @MAMH varchar(10)
SELECT @MAHV = MAHV, @MAMH = MAMH, @NGTHI = NGTHI FROM INSERTED
SELECT @MALOP = MALOP FROM HOCVIEN WHERE MAHV = @MAHV
SELECT @DENNGAY = DENNGAY FROM GIANGDAY WHERE MALOP = @MALOP AND MAMH = @MAMH
IF (@NGTHI > @DENNGAY)
BEGIN 
PRINT 'Thuc hien thanh cong'
END
ELSE 
BEGIN
PRINT 'Ngay thi truoc ngay ket thuc mon hoc'
ROLLBACK TRANSACTION
END
END

CREATE TRIGGER THEMSUA_DENNGAY ON GIANGDAY
FOR UPDATE
AS
BEGIN 
DECLARE @MAHV char(5), @MALOP char(3), @NGTHI smalldatetime, @DENNGAY smalldatetime, @MAMH varchar(10)
SELECT @MALOP = MALOP, @MAMH = MAMH, @DENNGAY = DENNGAY FROM INSERTED
SELECT @MAHV = MAHV FROM HOCVIEN WHERE MALOP = @MALOP
SELECT @NGTHI = NGTHI FROM KETQUATHI WHERE MAHV = @MAHV AND MAMH = @MAMH
IF (@NGTHI > @DENNGAY)
BEGIN 
PRINT 'Thuc hien thanh cong'
END
ELSE 
BEGIN
PRINT 'Ngay thi truoc ngay ket thuc mon hoc'
ROLLBACK TRANSACTION
END
END

-- 16. Mỗi học kỳ của một năm học, một lớp chỉ được học tối đa 3 môn. 
CREATE TRIGGER THEM_GIANGDAY ON GIANGDAY
FOR INSERT
AS
BEGIN
DECLARE @MALOP char(3), @SOMON int
SELECT @MALOP = MALOP FROM INSERTED
SELECT @SOMON = (SELECT COUNT(*) FROM GIANGDAY
					WHERE MALOP = @MALOP
					)
IF (@SOMON > 3)
BEGIN 
PRINT 'Mot lop chi hoc toi da 3 mon'
ROLLBACK TRANSACTION
END
ELSE
BEGIN
PRINT 'Them thanh cong'
END
END

-- 17. Sỉ số của một lớp bằng với số lượng học viên thuộc lớp đó. 
CREATE TRIGGER SUA_SISO ON LOP
FOR UPDATE
AS
BEGIN
DECLARE @MALOP char(3), @SISO int, @SOHV int
SELECT @MALOP = MALOP, @SISO = SISO FROM INSERTED
SELECT @SOHV = (SELECT COUNT(*) FROM HOCVIEN
					WHERE MALOP = @MALOP
					)
IF (@SOHV != @SISO)
BEGIN 
PRINT 'Si so cua lop phai bang voi so hoc vien thuoc lop do'
ROLLBACK TRANSACTION
END
ELSE
BEGIN
PRINT 'Sua thanh cong'
END
END

CREATE TRIGGER THEMSUA_MALOP ON HOCVIEN
FOR UPDATE, INSERT
AS
BEGIN
DECLARE @MALOP char(3), @SISO int, @MAHV char(5), @SOHV int
SELECT @MALOP = MALOP FROM INSERTED
SELECT @SISO = SISO FROM LOP WHERE MALOP = @MALOP
SELECT @SOHV = (SELECT COUNT(*) FROM HOCVIEN
					WHERE MALOP = @MALOP
					)
IF (@SOHV != @SISO)
BEGIN 
PRINT 'Si so cua lop phai bang voi so hoc vien thuoc lop do'
ROLLBACK TRANSACTION
END
ELSE
BEGIN
PRINT 'Sua thanh cong'
END
END

-- 18. Trong quan hệ DIEUKIEN giá trị của thuộc tính MAMH và MAMH_TRUOC trong cùng 
-- một bộ không được giống nhau (“A”,”A”) và cũng không tồn tại hai bộ (“A”,”B”) và 
-- (“B”,”A”). 
CREATE TRIGGER THEMSUA_DIEUKIEN ON DIEUKIEN
FOR UPDATE, INSERT
AS
BEGIN
DECLARE @MAMH varchar(10), @MAMH_TRUOC varchar(10)
SELECT @MAMH = MAMH, @MAMH_TRUOC = @MAMH_TRUOC FROM INSERTED
IF (@MAMH = @MAMH_TRUOC OR @MAMH IN (SELECT MAMH FROM DIEUKIEN WHERE MAMH_TRUOC = @MAMH_TRUOC))
BEGIN
PRINT 'Thao tac khong thanh cong'
ROLLBACK TRANSACTION
END
ELSE
BEGIN
PRINT 'Thao tac thanh cong'
END 
END

-- 19. Các giáo viên có cùng học vị, học hàm, hệ số lương thì mức lương bằng nhau. 
CREATE TRIGGER THEMSUA_GIAOVIEN ON GIAOVIEN
FOR INSERT, UPDATE
AS 
BEGIN
DECLARE @HOCVI varchar(10), @HOCHAM varchar(10), @HESO numeric(4,2), @MUCLUONG money
SELECT @HOCVI = HOCVI, @HOCHAM = HOCHAM, @HESO = HESO, @MUCLUONG = MUCLUONG FROM INSERTED
IF (@MUCLUONG != (SELECT MUCLUONG FROM GIAOVIEN WHERE HOCVI = @HOCVI AND HOCHAM = @HOCHAM AND HESO = @HESO))
BEGIN
PRINT 'Muc luong khac nhau'
ROLLBACK TRANSACTION
END
ELSE
BEGIN 
PRINT 'Thao tac thanh cong'
END
END

-- 20. Học viên chỉ được thi lại (lần thi >1) khi điểm của lần thi trước đó dưới 5. 
CREATE TRIGGER THEMSUA_LANTHI ON KETQUATHI
FOR INSERT, UPDATE
AS
BEGIN
DECLARE @DIEM numeric(4,2), @LANTHI tinyint, @MAHV char(5), @MAMH varchar(10), @LANTHITRUOC tinyint
SELECT @MAHV = MAHV, @MAMH = MAMH, @LANTHI = LANTHI FROM INSERTED
SELECT @LANTHITRUOC = (SELECT COUNT(*) FROM KETQUATHI WHERE MAHV = @MAHV AND MAMH = @MAMH)
SELECT @DIEM = DIEM FROM KETQUATHI WHERE MAHV = @MAHV AND MAMH = @MAMH AND LANTHI = @LANTHITRUOC
IF (@LANTHI > 1 AND @DIEM < 5)
BEGIN
PRINT 'Thao tac thanh cong'
END
ELSE
BEGIN 
PRINT 'Hoc vien chi duoc thi lai khi diem lan thi truoc duoi 5'
ROLLBACK TRANSACTION
END
END

-- 21. Ngày thi của lần thi sau phải lớn hơn ngày thi của lần thi trước (cùng học viên, cùng môn học). 
CREATE TRIGGER THEMSUA_NGTHI_LANTHI ON KETQUATHI
FOR INSERT, UPDATE
AS
BEGIN
DECLARE @LANTHI tinyint, @MAHV char(5), @MAMH varchar(10), @LANTHITRUOC tinyint, @NGTHITRUOC smalldatetime, @NGTHI smalldatetime
SELECT @MAHV = MAHV, @MAMH = MAMH, @LANTHI = LANTHI FROM INSERTED
SELECT @LANTHITRUOC = (SELECT COUNT(*) FROM KETQUATHI WHERE MAHV = @MAHV AND MAMH = @MAMH)
SELECT @NGTHITRUOC = NGTHI FROM KETQUATHI WHERE MAHV = @MAHV AND MAMH = @MAMH AND LANTHI = @LANTHITRUOC
SELECT @NGTHI = NGTHI FROM KETQUATHI WHERE MAHV = @MAHV AND MAMH = @MAMH AND LANTHI = @LANTHI
IF (@NGTHI >= @NGTHITRUOC)
BEGIN
PRINT 'Thao tac thanh cong'
END
ELSE
BEGIN 
PRINT 'Ngay thi lan thi sau phai lon hon ngay thi lan thi truoc do'
ROLLBACK TRANSACTION
END
END

-- 22. Khi phân công giảng dạy một môn học, phải xét đến thứ tự trước sau giữa các môn học (sau 
-- khi học xong những môn học phải học trước mới được học những môn liền sau). 
CREATE TRIGGER THEMSUA_GIANGDAY ON GIANGDAY
FOR INSERT, UPDATE
AS 
BEGIN
DECLARE @MALOP char(3), @MAGV char(4), @MAMH varchar(10)
SELECT @MALOP = MALOP, @MAGV = MAGV, @MAMH = MAMH FROM INSERTED
IF EXISTS (SELECT 1 FROM DIEUKIEN DK 
           LEFT JOIN KETQUATHI KQT ON DK.MAMH_TRUOC = KQT.MAMH 
		   AND KQT.MAHV IN (SELECT MAHV FROM HOCVIEN WHERE MALOP = @MALOP)
			WHERE DK.MAMH = @MAMH	
			)
BEGIN 
PRINT 'Phai hoc het cac mon hoc truoc'
ROLLBACK TRANSACTION
END
ELSE
BEGIN 
PRINT 'Thao tac thanh cong'
END
END

-- 23. Giáo viên chỉ được phân công dạy những môn thuộc khoa giáo viên đó phụ trách.
CREATE TRIGGER THEMSUA_PHANCONG_GIANGDAY ON GIANGDAY
FOR INSERT, UPDATE
AS
BEGIN
DECLARE @MAMH varchar(10), @MAGV char(4), @MAKHOAGV varchar(4), @MAKHOAMH varchar(4)
SELECT @MAMH = MAMH, @MAGV = MAGV FROM INSERTED
SELECT @MAKHOAGV = MAKHOA FROM GIAOVIEN WHERE MAGV = @MAGV
SELECT @MAKHOAMH = MAKHOA FROM MONHOC WHERE MAMH = @MAMH
IF (@MAKHOAGV != @MAKHOAMH)
BEGIN
PRINT 'Giao vien chi duoc phan cong day cac mon thuoc khoa giao vien do phu trach'
ROLLBACK TRANSACTION
END
ELSE
BEGIN
PRINT 'Thao tac thanh cong'
END
END