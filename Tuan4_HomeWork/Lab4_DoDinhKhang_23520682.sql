-- 76. Liệt kê top 3 chuyên gia có nhiều kỹ năng nhất và số lượng kỹ năng của họ.
SELECT TOP 3 CG.MaChuyenGia, HOTEN, COUNT(MaKyNang) AS 'SLKN' FROM ChuyenGia CG
JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaChuyenGia
GROUP BY CG.MaChuyenGia, HOTEN
ORDER BY COUNT(MaKyNang) DESC

-- 77. Tìm các cặp chuyên gia có cùng chuyên ngành và số năm kinh nghiệm chênh lệch không quá 2 năm.
SELECT 
CG1.HoTen AS ChuyenGia1,
CG2.HoTen AS ChuyenGia2,
CG1.ChuyenNganh
FROM ChuyenGia CG1 JOIN ChuyenGia CG2 ON CG1.ChuyenNganh = CG2.ChuyenNganh
WHERE CG1.MaChuyenGia < CG2.MaChuyenGia AND ABS(CG1.NamKinhNghiem - CG2.NamKinhNghiem) <= 2

-- 78. Hiển thị tên công ty, số lượng dự án và tổng số năm kinh nghiệm của các chuyên gia tham gia dự án của công ty đó.
SELECT TenCongTy, COUNT(DA.MaDuAn) AS 'SoDuAn', SUM(NamKinhNghiem) AS 'TongNamKinhNghiem' 
FROM CongTy CT JOIN DuAn DA ON CT.MaCongTy = DA.MaCongTy 
JOIN ChuyenGia_DuAn CGDA ON CGDA.MaDuAn = DA.MaDuAn
JOIN ChuyenGia CG ON CG.MaChuyenGia = CGDA.MaChuyenGia
GROUP BY TenCongTy

-- 79. Tìm các chuyên gia có ít nhất một kỹ năng cấp độ 5 nhưng không có kỹ năng nào dưới cấp độ 3.
SELECT CG.MaChuyenGia, HoTen FROM ChuyenGia CG 
WHERE CG.MaChuyenGia IN 
(
SELECT MaChuyenGia FROM ChuyenGia_KyNang CGKN
WHERE CapDo = 5
INTERSECT 
SELECT MaChuyenGia FROM ChuyenGia_KyNang CGKN
WHERE CapDo >= 3
)

-- 80. Liệt kê các chuyên gia và số lượng dự án họ tham gia, bao gồm cả những chuyên gia không tham gia dự án nào.
SELECT CG.MaChuyenGia, HoTen, COUNT(MaDuAn) AS 'SoLuongDuAn' FROM ChuyenGia CG
LEFT JOIN ChuyenGia_DuAn CGDA ON CGDA.MaChuyenGia = CG.MaChuyenGia
GROUP BY CG.MaChuyenGia, HoTen

-- 81*. Tìm chuyên gia có kỹ năng ở cấp độ cao nhất trong mỗi loại kỹ năng.
WITH RANKEDSKILLS AS (
SELECT HoTen, LoaiKyNang, CapDo,
	ROW_NUMBER() OVER (PARTITION BY LoaiKyNang ORDER BY CapDo DESC) AS 'RANK'
FROM ChuyenGia CG JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaChuyenGia
	JOIN KyNang KN ON KN.MaKyNang = CGKN.MaKyNang
)
SELECT HoTen, LoaiKyNang, CapDo FROM RANKEDSKILLS
WHERE RANK = 1

-- 82. Tính tỷ lệ phần trăm của mỗi chuyên ngành trong tổng số chuyên gia.
WITH CountChuyenNganh AS
( SELECT ChuyenNganh, COUNT(*) AS SOLUONG
	FROM ChuyenGia
	GROUP BY ChuyenNganh
),
TongCount AS
(
SELECT COUNT(*) AS TongSo
FROM ChuyenGia
)

SELECT CountChuyenNganh.ChuyenNganh, CountChuyenNganh.SOLUONG,
		CAST(CountChuyenNganh.SOLUONG AS FLOAT) / TongCount.TongSo * 100 AS PhanTram
FROM CountChuyenNganh, TongCount


-- 83. Tìm các cặp kỹ năng thường xuất hiện cùng nhau nhất trong hồ sơ của các chuyên gia.
WITH SKILLPAIRS AS
(
SELECT CGKN1.MaKyNang AS KyNang1,
		CGKN2.MaKyNang AS KyNang2,
		COUNT(*) AS SoLan
		FROM ChuyenGia_KyNang CGKN1 JOIN ChuyenGia_KyNang CGKN2 ON CGKN1.MaChuyenGia = CGKN2.MaChuyenGia AND CGKN1.MaKyNang < CGKN2.MaKyNang
		GROUP BY CGKN1.MaKyNang, CGKN2.MaKyNang
		)
SELECT TOP 5
    K1.TenKyNang AS KyNang1,
    K2.TenKyNang AS KyNang2,
    SoLan
FROM SKILLPAIRS
JOIN KyNang K1 ON SKILLPAIRS.KyNang1 = K1.MaKyNang
JOIN KyNang K2 ON SKILLPAIRS.KyNang2 = K2.MaKyNang
ORDER BY SKILLPAIRS.SoLan DESC;

-- 84. Tính số ngày trung bình giữa ngày bắt đầu và ngày kết thúc của các dự án cho mỗi công ty.
SELECT TenCongTy,
		AVG(DATEDIFF(day, NgayBatDau, NgayKetThuc)) AS 'TrungBinhSoNgay'
		FROM CongTy CT JOIN DuAn DA ON CT.MaCongTy = DA.MaCongTy
GROUP BY TenCongTy

-- 85*. Tìm chuyên gia có sự kết hợp độc đáo nhất của các kỹ năng (kỹ năng mà chỉ họ có).
WITH KyNangDocDao AS (
    SELECT 
        CG.MaChuyenGia,
        CG.HoTen,
        COUNT(*) AS SoLuongKyNangDocDao
    FROM ChuyenGia CG JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaChuyenGia
    WHERE CGKN.MaKyNang NOT IN
	(
        SELECT DISTINCT MaKyNang FROM ChuyenGia_KyNang
        WHERE MaChuyenGia != CG.MaChuyenGia
    )
    GROUP BY CG.MaChuyenGia, CG.HoTen
)
SELECT TOP 1 HoTen, SoLuongKyNangDocDao FROM KyNangDocDao
ORDER BY SoLuongKyNangDocDao DESC;

-- 86*. Tạo một bảng xếp hạng các chuyên gia dựa trên số lượng dự án và tổng cấp độ kỹ năng.
WITH SoDuAn AS (
    SELECT MaChuyenGia, COUNT(*) AS SoLuongDuAn
    FROM ChuyenGia_DuAn
    GROUP BY MaChuyenGia
				),
TongCapDo AS (
    SELECT MaChuyenGia, SUM(CapDo) AS TongCapDoKyNang
    FROM ChuyenGia_KyNang
    GROUP BY MaChuyenGia
				)
SELECT 
    ChuyenGia.HoTen,
    COALESCE(SoDuAn.SoLuongDuAn, 0) AS SoLuongDuAn,
    COALESCE(TongCapDo.TongCapDoKyNang, 0) AS TongCapDoKyNang,
    RANK() OVER (ORDER BY COALESCE(SoDuAn.SoLuongDuAn, 0) + COALESCE(TongCapDo.TongCapDoKyNang, 0) DESC) AS XepHang
FROM ChuyenGia LEFT JOIN SoDuAn  ON ChuyenGia.MaChuyenGia = SoDuAn.MaChuyenGia
LEFT JOIN TongCapDo  ON ChuyenGia.MaChuyenGia = TongCapDo.MaChuyenGia;

-- 87. Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.
WITH DuAnChuyenNganh AS (
    SELECT DA.MaDuAn, DA.TenDuAn,
        COUNT(DISTINCT CG.ChuyenNganh) AS SoLuongChuyenNganh
    FROM DuAn DA JOIN ChuyenGia_DuAn CGDA ON DA.MaDuAn = CGDA.MaDuAn JOIN ChuyenGia CG ON CGDA.MaChuyenGia = CG.MaChuyenGia
    GROUP BY DA.MaDuAn, DA.TenDuAn
),
TotalChuyenNganh AS (
    SELECT COUNT(DISTINCT ChuyenNganh) AS TongSoChuyenNganh
    FROM ChuyenGia
)
SELECT DuAnChuyenNganh.TenDuAn FROM DuAnChuyenNganh, TotalChuyenNganh
WHERE DuAnChuyenNganh.SoLuongChuyenNganh = TotalChuyenNganh.TongSoChuyenNganh;

-- 88. Tính tỷ lệ thành công của mỗi công ty dựa trên số dự án hoàn thành so với tổng số dự án.
WITH DuAnStatus AS (
    SELECT CT.MaCongTy, CT.TenCongTy,
        SUM(CASE WHEN DA.TrangThai = N'Hoàn thành' THEN 1 ELSE 0 END) AS SoDuAnHoanThanh,
        COUNT(*) AS TongSoDuAn
    FROM CongTy CT LEFT JOIN DuAn  DA ON CT.MaCongTy = DA.MaCongTy
    GROUP BY CT.MaCongTy, CT.TenCongTy
)
SELECT TenCongTy, SoDuAnHoanThanh, TongSoDuAn,
    CASE 
        WHEN TongSoDuAn > 0 THEN CAST(SoDuAnHoanThanh AS FLOAT) / TongSoDuAn * 100 
        ELSE 0 
    END AS TyLeThanhCong
FROM DuAnStatus;

-- 89. Tìm các chuyên gia có kỹ năng "bù trừ" nhau (một người giỏi kỹ năng A nhưng yếu kỹ năng B, người kia ngược lại).
WITH SKILLLEVELS AS (
    SELECT CG.MaChuyenGia, CG.HoTen,  CGKN.MaKyNang,  CGKN.CapDo,
        ROW_NUMBER() OVER (PARTITION BY CG.MaChuyenGia ORDER BY CGKN.CapDo DESC) AS SKILLRANK,
        ROW_NUMBER() OVER (PARTITION BY CG.MaChuyenGia ORDER BY CGKN.CapDo ASC) AS REVERSESKILLRANK
    FROM ChuyenGia CG
    JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaChuyenGia
)
SELECT 
    A.HoTen AS ChuyenGia1,
    B.HoTen AS ChuyenGia2,
    KN1.TenKyNang AS KyNang1,
    KN2.TenKyNang AS KyNang2
FROM SKILLLEVELS A
JOIN SKILLLEVELS B ON A.MaChuyenGia <> B.MaChuyenGia 
    AND A.SKILLRANK = 1 
    AND B.REVERSESKILLRANK = 1 
JOIN KyNang KN1 ON KN1.MaKyNang = A.MaKyNang
JOIN KyNang KN2 ON KN2.MaKyNang = B.MaKyNang
WHERE A.MaKyNang <> B.MaKyNang 