-- 8. Hiển thị tên và cấp độ của tất cả các kỹ năng của chuyên gia có MaChuyenGia là 1.
SELECT TenKyNang, CapDo FROM ChuyenGia_KyNang CGKN JOIN KyNang KN ON CGKN.MaKyNang = KN.MaKyNang
WHERE MaChuyenGia = 1

-- 9. Liệt kê tên các chuyên gia tham gia dự án có MaDuAn là 2.
SELECT HoTen FROM ChuyenGia_DuAn CGDA JOIN ChuyenGia CG ON CGDA.MaChuyenGia = CG.MaChuyenGia
WHERE MaDuAn = 2

-- 10. Hiển thị tên công ty và tên dự án của tất cả các dự án.
SELECT TenCongTy, TenDuAn FROM CongTy CT JOIN DuAn DA ON CT.MaCongTy = DA.MaCongTy

-- 11. Đếm số lượng chuyên gia trong mỗi chuyên ngành.
SELECT ChuyenNganh, COUNT(MaChuyenGia) AS 'SoLuongChuyenGia'
FROM ChuyenGia
GROUP BY ChuyenNganh

-- 12. Tìm chuyên gia có số năm kinh nghiệm cao nhất.
SELECT TOP 1 MaChuyenGia, HoTen, NamKinhNghiem FROM ChuyenGia
ORDER BY NamKinhNghiem DESC

-- 13. Liệt kê tên các chuyên gia và số lượng dự án họ tham gia.
SELECT HoTen, COUNT(MaDuAn) AS 'SoLuongDuAn'
FROM ChuyenGia  CG JOIN ChuyenGia_DuAn CGDA ON CG.MaChuyenGia = CGDA.MaChuyenGia
GROUP BY HoTen

-- 14. Hiển thị tên công ty và số lượng dự án của mỗi công ty.
SELECT TenCongTy, COUNT(MaDuAn) AS 'SoLuongDuAn'
FROM CongTy CT JOIN DuAn DA ON CT.MaCongTy = DA.MaCongTy
GROUP BY TenCongTy

-- 15. Tìm kỹ năng được sở hữu bởi nhiều chuyên gia nhất.
SELECT TOP 1 MaKyNang,  COUNT(MaChuyenGia) AS 'SoLuongChuyenGia'
FROM ChuyenGia_KyNang
GROUP BY MaKyNang
ORDER BY COUNT(MaChuyenGia) DESC

-- 16. Liệt kê tên các chuyên gia có kỹ năng 'Python' với cấp độ từ 4 trở lên.
SELECT HoTen FROM ChuyenGia  CG JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaChuyenGia JOIN KyNang KN ON KN.MaKyNang = CGKN.MaKyNang
WHERE TenKyNang = 'Python' AND CapDo >= 4

-- 17. Tìm dự án có nhiều chuyên gia tham gia nhất.
SELECT TOP 1 MaDuAn,  COUNT(MaChuyenGia) AS 'SoLuongChuyenGia'
FROM ChuyenGia_DuAn
GROUP BY MaDuAn
ORDER BY COUNT(MaChuyenGia) DESC

-- 18. Hiển thị tên và số lượng kỹ năng của mỗi chuyên gia.
SELECT HoTen, COUNT(MaKyNang) AS 'SoLuongKyNang'
FROM ChuyenGia CG JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaKyNang
GROUP BY HoTen

-- 19. Tìm các cặp chuyên gia làm việc cùng dự án.
SELECT 
CG1.HoTen AS ChuyenGia1,
CG2.HoTen AS ChuyenGia2,
DA.TenDuAn
FROM ChuyenGia_DuAn CGDA1
JOIN ChuyenGia_DuAn CGDA2 ON CGDA1.MaDuAn = CGDA2.MaDuAn
JOIN ChuyenGia CG1 ON CGDA1.MaChuyenGia = CG1.MaChuyenGia
JOIN ChuyenGia CG2  ON CGDA2.MaChuyenGia = CG2.MaChuyenGia
JOIN DuAn DA ON CGDA1.MaDuAn = DA.MaDuAn
WHERE CGDA1.MaChuyenGia < CGDA2.MaChuyenGia
ORDER BY DA.MaDuAn

-- 20. Liệt kê tên các chuyên gia và số lượng kỹ năng cấp độ 5 của họ.
SELECT HoTen, COUNT(MaKyNang) AS 'SoKyNangCap5'
FROM ChuyenGia CG JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaKyNang
WHERE CapDo = 5
GROUP BY HoTen

-- 21. Tìm các công ty không có dự án nào.
SELECT MaCongTy, TenCongTy FROM CongTy
EXCEPT
SELECT CT.MaCongTy, TenCongTy FROM CongTy CT JOIN DuAn DA ON CT.MaCongTy = DA.MaCongTy

-- 22. Hiển thị tên chuyên gia và tên dự án họ tham gia, bao gồm cả chuyên gia không tham gia dự án nào.
SELECT HoTen, TenDuAn FROM ChuyenGia CG 
LEFT JOIN ChuyenGia_DuAn CGDA ON CG.MaChuyenGia = CGDA.MaChuyenGia 
LEFT JOIN DuAn DA ON DA.MaDuAn = CGDA.MaDuAn 

-- 23. Tìm các chuyên gia có ít nhất 3 kỹ năng.
SELECT HoTen, COUNT(MaKyNang) AS 'SoLuongKyNang'
FROM ChuyenGia CG JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaKyNang
GROUP BY HoTen
HAVING COUNT(MaKyNang) >= 3

-- 24. Hiển thị tên công ty và tổng số năm kinh nghiệm của tất cả chuyên gia trong các dự án của công ty đó.
SELECT TenCongTy, SUM(NamKinhNghiem) AS 'SoNamKinhNghiem'
FROM CongTy CT 
JOIN DuAn DA ON DA.MaCongTy = CT.MaCongTy 
JOIN ChuyenGia_DuAn CGDA ON CGDA.MaDuAn = DA.MaDuAn 
JOIN ChuyenGia CG ON CG.MaChuyenGia = CGDA.MaChuyenGia
GROUP BY TenCongTy

-- 25. Tìm các chuyên gia có kỹ năng 'Java' nhưng không có kỹ năng 'Python'.
SELECT HoTen FROM ChuyenGia CG 
JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaChuyenGia 
JOIN KyNang KN ON KN.MaKyNang = CGKN.MaKyNang
WHERE TenKyNang = 'Java'
EXCEPT
SELECT HoTen FROM ChuyenGia CG 
JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaChuyenGia 
JOIN KyNang KN ON KN.MaKyNang = CGKN.MaKyNang
WHERE TenKyNang = 'Python'

-- 76. Tìm chuyên gia có số lượng kỹ năng nhiều nhất.
SELECT TOP 1 HoTen, COUNT(MaKyNang) AS 'SoLuongKyNang'
FROM ChuyenGia CG JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia = CGKN.MaChuyenGia
GROUP BY HoTen
ORDER BY COUNT(MaKyNang) DESC

-- 77. Liệt kê các cặp chuyên gia có cùng chuyên ngành.
SELECT 
CG1.HoTen AS ChuyenGia1,
CG2.HoTen AS ChuyenGia2,
CG1.ChuyenNganh
FROM ChuyenGia CG1 JOIN ChuyenGia CG2 ON CG1.ChuyenNganh = CG2.ChuyenNganh 
WHERE CG1.MaChuyenGia < CG2.MaChuyenGia
ORDER BY ChuyenNganh

-- 78. Tìm công ty có tổng số năm kinh nghiệm của các chuyên gia trong dự án cao nhất.
SELECT TOP 1 TenCongTy, SUM(NamKinhNghiem) AS 'SoNamKinhNghiem'
FROM CongTy CT 
JOIN DuAn DA ON DA.MaCongTy = CT.MaCongTy 
JOIN ChuyenGia_DuAn CGDA ON CGDA.MaDuAn = DA.MaDuAn 
JOIN ChuyenGia CG ON CG.MaChuyenGia = CGDA.MaChuyenGia
GROUP BY TenCongTy
ORDER BY SUM(NamKinhNghiem) DESC

-- 79. Tìm kỹ năng được sở hữu bởi tất cả các chuyên gia.
SELECT TenKyNang
FROM KyNang KN JOIN ChuyenGia_KyNang CGKN ON KN.MaKyNang = CGKN.MaKyNang
GROUP BY TenKyNang
HAVING COUNT(DISTINCT CGKN.MaChuyenGia) = (SELECT COUNT(*) MaChuyenGia FROM ChuyenGia)
