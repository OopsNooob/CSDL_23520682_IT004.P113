-- Câu hỏi SQL từ cơ bản đến nâng cao, bao gồm trigger

-- Cơ bản:
-- 1. Liệt kê tất cả chuyên gia trong cơ sở dữ liệu.
SELECT * FROM ChuyenGia

-- 2. Hiển thị tên và email của các chuyên gia nữ.
SELECT HoTen, Email FROM ChuyenGia
WHERE GioiTinh = N'Nữ'

--3. Liệt kê các công ty có trên 100 nhân viên.
SELECT * FROM CongTy
WHERE SoNhanVien > 100

--4. Hiển thị tên và ngày bắt đầu của các dự án trong năm 2023.
SELECT TenDuAn, NgayBatDau FROM DuAn
WHERE YEAR(NgayBatDau) = 2023

--5. Đếm số lượng chuyên gia trong mỗi chuyên ngành.
SELECT ChuyenNganh, COUNT(*) AS 'SoLuong' FROM ChuyenGia 
GROUP BY ChuyenNganh

-- Trung cấp:
--6. Liệt kê tên chuyên gia và số lượng dự án họ tham gia.
SELECT HoTen, COUNT(MaDuAn) AS 'SoLuongDuAn' FROM ChuyenGia CG JOIN ChuyenGia_DuAn CGDA ON CG.MaChuyenGia = CGDA.MaChuyenGia
GROUP BY HoTen

--7. Tìm các dự án có sự tham gia của chuyên gia có kỹ năng 'Python' cấp độ 4 trở lên.
SELECT CGDA.MaDuAn, TenDuAn FROM DuAn DA JOIN ChuyenGia_DuAn CGDA ON CGDA.MaDuAn = DA.MaDuAn JOIN ChuyenGia_KyNang CGKN 
							ON CGKN.MaChuyenGia = CGDA.MaChuyenGia JOIN KyNang KN ON KN.MaKyNang = CGKN.MaKyNang
WHERE TenKyNang = 'Python' AND CapDo >= 4
								 

--8. Hiển thị tên công ty và số lượng dự án đang thực hiện.
SELECT TenCongTy, COUNT(MaDuAn) AS 'SoLuongDuAn' FROM CongTy CT JOIN DuAn DA ON DA.MaCongTy = CT.MaCongTy
GROUP BY TenCongTy

--9. Tìm chuyên gia có số năm kinh nghiệm cao nhất trong mỗi chuyên ngành.
SELECT MaChuyenGia, HoTen, ChuyenNganh, NamKinhNghiem FROM ChuyenGia CG1
GROUP BY MaChuyenGia, HoTen, ChuyenNganh, NamKinhNghiem
HAVING NamKinhNghiem >= ALL (SELECT NamKinhNghiem FROM ChuyenGia CG2
								WHERE CG2.ChuyenNganh = CG1.ChuyenNganh
								GROUP BY MaChuyenGia, NamKinhNghiem
								)


--10. Liệt kê các cặp chuyên gia đã từng làm việc cùng nhau trong ít nhất một dự án.
SELECT DISTINCT 
	CG1.HoTen AS ChuyenGia1,
	CG2.HoTen AS ChuyenGia2,
	DA.MaDuAn
FROM ChuyenGia_DuAn CGDA1 JOIN ChuyenGia_DuAn CGDA2 ON CGDA1.MaDuAn = CGDA2.MaDuAn AND CGDA1.MaChuyenGia < CGDA2.MaChuyenGia
JOIN ChuyenGia CG1 ON CG1.MaChuyenGia = CGDA1.MaChuyenGia
JOIN ChuyenGia CG2 ON CG2.MaChuyenGia = CGDA2.MaChuyenGia
JOIN DuAn DA ON DA.MaDuAn = CGDA1.MaDuAn

-- Nâng cao:
--11. Tính tổng thời gian (theo ngày) mà mỗi chuyên gia đã tham gia vào các dự án.
SELECT HoTen,
 SUM(DATEDIFF(DAY, CGDA.NgayThamGia, COALESCE(DA.NgayKetThuc, GETDATE()))) AS 'TongThoiGian'
 FROM ChuyenGia CG JOIN ChuyenGia_DuAn CGDA ON CGDA.MaChuyenGia = CG.MaChuyenGia JOIN
 DuAn DA ON DA.MaDuAn = CGDA.MaDuAn
 GROUP BY CG.MaChuyenGia, HoTen

--12. Tìm các công ty có tỷ lệ dự án hoàn thành cao nhất (trên 90%).
SELECT CT.MaCongTy, TenCongTy,
		CAST(DuAnStats.SoDuAnHoanThanh AS FLOAT) / DuAnStats.TongDuAn * 100 AS 'TyLeHoanThanh'
		
FROM CongTy CT JOIN 
(SELECT MaCongTy, COUNT(*) AS 'TongDuAn',
		SUM (CASE WHEN TrangThai = N'Hoàn thành' THEN 1 ELSE 0 END) AS 'SoDuAnHoanThanh'
		FROM DuAn
		GROUP BY MaCongTy
) AS DuAnStats ON CT.MaCongTy = DuAnStats.MaCongTy
WHERE CAST(DuAnStats.SoDuAnHoanThanh AS FLOAT) / DuAnStats.TongDuAn > 0.9

--13. Liệt kê top 3 kỹ năng được yêu cầu nhiều nhất trong các dự án.
SELECT TOP 3 KN.MaKyNang, TenKyNang, COUNT(DISTINCT DA.MaDuAn) AS 'SoLanYeuCau' FROM KyNang KN JOIN ChuyenGia_KyNang CGKN ON CGKN.MaKyNang
																= KN.MaKyNang JOIN ChuyenGia_DuAn CGDA ON CGDA.MaChuyenGia =
																CGKN.MaChuyenGia JOIN DuAn DA ON DA.MaDuAn = CGDA.MaDuAn
GROUP BY KN.MaKyNang, TenKyNang
ORDER BY COUNT(DISTINCT DA.MaDuAn) DESC

--14. Tính lương trung bình của chuyên gia theo từng cấp độ kinh nghiệm (Junior: 0-2 năm, Middle: 3-5 năm, Senior: >5 năm).
SELECT 
	CASE	
		WHEN NamKinhNghiem <= 2 THEN 'Junior'
		WHEN NamKinhNghiem <= 5 THEN 'Middle'
		ELSE 'Senior'
	END AS 'CapDo',
	AVG(Luong) AS 'LuongTB'
FROM ChuyenGia
GROUP BY 
	CASE 
		WHEN NamKinhNghiem <=2 THEN 'Junior'
		WHEN NamKinhNghiem <=5 THEN 'Middle'
		ELSE 'Senior'
	END

--15. Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.
SELECT TenDuAn FROM DuAn DA JOIN ChuyenGia_DuAn CGDA ON DA.MaDuAn = CGDA.MaDuAn JOIN ChuyenGia CG
								ON CG.MaChuyenGia = CGDA.MaChuyenGia
GROUP BY DA.MaDuAn, TenDuAn
HAVING COUNT(DISTINCT ChuyenNganh) = (SELECT COUNT(DISTINCT ChuyenNganh) FROM ChuyenGia
									)
									
-- Trigger:
--16. Tạo một trigger để tự động cập nhật số lượng dự án của công ty khi thêm hoặc xóa dự án.
ALTER TABLE CongTy
ADD SoDuAn int

CREATE TRIGGER capnhatSoDuAnCongTy ON DuAn
FOR INSERT, DELETE
AS
BEGIN
UPDATE CongTy
SET SoDuAn = SoDuAn + 1
FROM CongTy CT JOIN inserted i ON CT.MaCongTy = i.MaCongTy

UPDATE CongTy
SET SoDuAn = SoDuAn -1
FROM CongTy CT JOIN deleted d on CT.MaCongTy = d.MaCongTy
END

--17. Tạo một trigger để ghi log mỗi khi có sự thay đổi trong bảng ChuyenGia.
CREATE TABLE ChuyenGiaLog 
(
LogID INT IDENTITY(1,1) primary key,
MaChuyenGia int,
HanhDong nvarchar(10),
NgayThayDoi datetime default GETDATE()
)

CREATE TRIGGER log_ChuyenGia ON ChuyenGia
FOR INSERT, UPDATE, DELETE
AS
BEGIN
DECLARE @MaChuyenGia int, @HanhDong nvarchar(10)
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
BEGIN
SET @HanhDong = 'UPDATE'
SELECT @MaChuyenGia = MaChuyenGia FROM inserted
END
ELSE IF EXISTS (SELECT * FROM inserted)
BEGIN
SET @HanhDong = 'INSERT'
SELECT @MaChuyenGia = MaChuyenGia FROM inserted
END
ELSE 
BEGIN
SET @HanhDong = 'DELETE'
SELECT @MaChuyenGia = MaChuyenGia FROM deleted
END
INSERT INTO ChuyenGiaLog (MaChuyenGia, HanhDong) VALUES
(@MaChuyenGia, @HanhDong)
END

--18. Tạo một trigger để đảm bảo rằng một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.
CREATE TRIGGER gioiHanDuAn ON ChuyenGia_DuAn
FOR INSERT
AS
BEGIN
DECLARE @MaChuyenGia int, @SoDuAn int
SELECT @MaChuyenGia = MaChuyenGia FROM inserted
SELECT @SoDuAn = (SELECT COUNT(*) FROM ChuyenGia_DuAn WHERE MaChuyenGia = @MaChuyenGia)
IF (@SoDuAn > 5)
BEGIN
RAISERROR('Mot chuyen gia khong the tham gia qua 5 du an cung luc',16,1)
ROLLBACK TRANSACTION
END
END

--19. Tạo một trigger để tự động cập nhật trạng thái của dự án thành 'Hoàn thành' khi tất cả chuyên gia đã kết thúc công việc.
ALTER TABLE ChuyenGia_DuAn
ADD NgayKetThuc DATE

CREATE TRIGGER capNhatTrangThaiDuAn ON ChuyenGia_DuAn
FOR UPDATE
AS
BEGIN
UPDATE DuAn
SET TrangThai = N'Hoàn thành'
WHERE MaDuAn IN (SELECT MaDuAn FROM ChuyenGia_DuAn
				GROUP BY MaDuAn
				HAVING COUNT(*) = SUM(CASE WHEN NgayKetThuc IS NOT NULL THEN 1 ELSE 0 END)
				)
AND TrangThai != N'Hoàn Thành'
END	

--20. Tạo một trigger để tự động tính toán và cập nhật điểm đánh giá trung bình của công ty dựa trên điểm đánh giá của các dự án.
CREATE TRIGGER TRG_capNhatDanhGiaCongTy ON DuAn
FOR UPDATE
AS
BEGIN
IF UPDATE(DiemDanhGia)
BEGIN 
UPDATE CongTy
SET DiemDanhGiaTB = (SELECT AVG(DiemDanhGia) FROM DuAn DA
					WHERE DA.MaCongTy = CT.MaCongTy AND DiemDanhGia IS NOT NULL
					)
FROM CongTy CT JOIN inserted I ON i.MaCongTy = CT.MaCongTy
END
END