CREATE DATABASE QLKHACHHANG;
DROP TABLE KHACHHANG
DROP TABLE NHANVIEN
DROP TABLE SANPHAM
DROP TABLE HOADON
DROP TABLE CTHD
CREATE TABLE KHACHHANG
(
MAKH char(4) primary key,
HOTEN varchar(40),
DCHI varchar(50),
SODT varchar(20),
NGSINH smalldatetime,
NGDK smalldatetime,
DOANHSO money
)

CREATE TABLE NHANVIEN
(
MANV char(4) primary key,
HOTEN varchar(40),
SODT varchar(20),
NGVL smalldatetime
)

CREATE TABLE SANPHAM
(
MASP char(4) primary key,
TENSP varchar(40),
DVT varchar(20),
NUOCSX varchar(40),
GIA money
)

CREATE TABLE HOADON
(
SOHD int primary key,
NGHD smalldatetime,
MAKH char(4) foreign key references KHACHHANG(MAKH),
MANV char(4) foreign key references NHANVIEN(MANV),
TRIGIA money
)

CREATE TABLE CTHD
(
SOHD int not null foreign key references HOADON(SOHD),
MASP char(4) not null foreign key references SANPHAM(MASP),
SL int
)

ALTER TABLE CTHD
ADD primary key (SOHD, MASP)

/** Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM.**/
ALTER TABLE SANPHAM
ADD GHICHU varchar(20)

/**  Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG**/
ALTER TABLE KHACHHANG
ADD LOAIKH tinyint

/** Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100)**/
ALTER TABLE SANPHAM
ALTER COLUMN GHICHU varchar(100)

/** Xóa thuộc tính GHICHU trong quan hệ SANPHAM**/
ALTER TABLE SANPHAM
DROP COLUMN GHICHU

/** Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang lai”, “Thuong xuyen”, “Vip”**/
ALTER TABLE KHACHHANG
ALTER COLUMN LOAIKH varchar(30)

/** Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”)**/
ALTER TABLE SANPHAM
ADD CHECK (DVT = 'Cay' OR DVT = 'Hop' OR DVT = 'Cai' OR DVT = 'Quyen' OR DVT = 'Chuc')

/** Giá bán của sản phẩm từ 500 đồng trở lên**/
ALTER TABLE SANPHAM
ADD CHECK (GIA > 500)

/** Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.**/
ALTER TABLE CTHD
ADD CHECK (SL > 0)

/** Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó.**/
ALTER TABLE KHACHHANG
ADD CHECK (NGDK > NGSINH)

