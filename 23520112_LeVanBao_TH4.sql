DROP DATABASE QLBH;
CREATE DATABASE QLBH;
USE QLBH;
SET DATEFORMAT dmy

CREATE TABLE KHACHHANG
(
    MAKH CHAR(4) PRIMARY KEY,
    HOTEN VARCHAR(40),
    DCHI VARCHAR(50),
    SODT VARCHAR(20),
    NGSINH SMALLDATETIME,
    NGDK SMALLDATETIME,
    DOANHSO MONEY,
);

CREATE TABLE NHANVIEN
(
    MANV CHAR(4) PRIMARY KEY,
    HOTEN VARCHAR(40),
    SODT VARCHAR(20),
    NGVL SMALLDATETIME
);

CREATE TABLE SANPHAM
(
    MASP CHAR(4) PRIMARY KEY,
    TENSP VARCHAR(40),
    DVT VARCHAR(20),
    NUOCSX VARCHAR(20),
    GIA MONEY
);

CREATE TABlE HOADON
(
    SOHD INT PRIMARY KEY,
    NGHD SMALLDATETIME,
    MAKH CHAR(4),
    MANV CHAR(4),
    TRIGIA MONEY,
    FOREIGN KEY (MAKH) REFERENCES KHACHHANG (MAKH),
    FOREIGN KEY (MANV) REFERENCES NHANVIEN (MANV),
);

CREATE TABLE CTHD
(
    SOHD INT,
    MASP CHAR(4),
    SL INT,
    PRIMARY KEY (SOHD, MASP),
    FOREIGN KEY (SOHD) REFERENCES HOADON (SOHD),
    FOREIGN KEY (MASP) REFERENCES SANPHAM (MASP),
);

--------------------------------------------------------- I. Ngôn ngữ định nghĩa dữ liệu (Data Definition Language): --------------------------------------------------------
-- 1. Tạo các quan hệ và khai báo các khóa chính, khóa ngoại của quan hệ.
-- 2. Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM.
ALTER TABLE SANPHAM 
ADD GHICHU VARCHAR(20)

-- 3. Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.
ALTER TABLE KHACHHANG 
ADD LOAIKH TINYINT

-- 4. Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).
ALTER TABLE SANPHAM
ALTER COLUMN GHICHU VARCHAR(100)

-- 5. Xóa thuộc tính GHICHU trong quan hệ SANPHAM.
ALTER TABLE SANPHAM
DROP COLUMN GHICHU

-- 6. Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang lai”, “Thuong xuyen”, “Vip”…
ALTER TABLE KHACHHANG
ALTER COLUMN loAIKH VARCHAR(100)

-- 7. Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”)
ALTER TABLE SANPHAM
ADD CONSTRAINT DVI_CHECK CHECK (DVT IN ('cay', 'hop', 'cai', 'quyen', 'chuc'))

-- 8. Giá bán của sản phẩm từ 500 đồng trở lên.
ALTER TABLE HOADON
ADD CONSTRAINT TRIGIA_CHECK CHECK (TRIGIA > 500)

-- 9. Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.
ALTER TABLE HOADON
ADD CONSTRAINT SOHD_CHECK CHECK (SOHD >= 1)

-- 10. Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó.
ALTER TABLE KHACHHANG
ADD CONSTRAINT NGSINH_CHECK CHECK (NGSINH < NGDK)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO KHACHHANG
    (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK)
VALUES
    ('KH01', 'Nguyen Van A', '731 Tran Hung Dao,  Q5,  TpHCM', '08823451', '1960-10-22', 13060000, '2006-07-22'),
    ('KH02', 'Tran Ngoc Han', '23/5 Nguyen Trai,  Q5, TpHCM', '0908256478', '1974-04-03', 280000, '2006-07-30'),
    ('KH03', 'Tran Ngoc Linh', '45 Nguyen Canh Chan,  Q1,  TpHCM', '0938776266', '1980-06-12', 3860000, '2006-08-05'),
    ('KH04', 'Tran Minh Long', '50/34 Le Dai Hanh,  Q10,  TpHCM', '0917325476', '1965-03-09', 250000, '2006-10-02'),
    ('KH05', 'Le Nhat Minh', '34 Truong Dinh,  Q3,  TpHCM', '08246108', '1950-03-10', 21000, '2006-10-28'),
    ('KH06', 'Le Hoai Thuong', '227 Nguyen Van Cu,  Q5,  TpHCM', '08631738', '1981-12-31', 915000, '2006-11-24'),
    ('KH07', 'Nguyen Van Tam', '32/3 Tran Binh Trong,  Q5,  TpHCM', '0916783565', '1971-04-06', 12500, '2006-12-01'),
    ('KH08', 'Phan Thi Thanh', '45/2 An Duong Vuong,  Q5,  TpHCM', '0938435756', '1971-01-10', 365000, '2006-12-13'),
    ('KH09', 'Le Ha Vinh', '873 Le Hong Phong,  Q5,  TpHCM', '08654763', '1979-09-03', 70000, '2007-01-14'),
    ('KH10', 'Ha Duy Lap', '34/34B Nguyen Trai,  Q1,  TpHCM', '08768904', '1983-05-02', 675000, '2007-01-16');

INSERT INTO NHANVIEN
    (MANV, HOTEN, SODT, NGVL)
VALUES
    ('NV01', 'Nguyen Nhu Nhut', '0927345678', '2006-04-13'),
    ('NV02', 'Le Thi Phi Yen', '0987567390', '2006-04-21'),
    ('NV03', 'Nguyen Van B', '0997047382', '2006-04-27'),
    ('NV04', 'Ngo Thanh Tuan', '0913758498', '2006-06-24'),
    ('NV05', 'Nguyen Thi Truc Thanh', '0918590387', '2006-07-20');

INSERT INTO SANPHAM
    (MASP, TENSP, DVT, NUOCSX, GIA)
VALUES
    ('BC01', 'But chi', 'cay', 'Singapore', 3000),
    ('BC02', 'But chi', 'cay', 'Singapore', 5000),
    ('BC03', 'But chi', 'cay', 'Viet Nam', 3500),
    ('BC04', 'But chi', 'hop', 'Viet Nam', 30000),
    ('BB01', 'But bi', 'cay', 'Viet Nam', 5000),
    ('BB02', 'But bi', 'cay', 'Trung Quoc', 5000),
    ('BB03', 'But bi', 'hop', 'Thai Lan', 100000),
    ('TV01', 'Tap 100 giay mong', 'quyen', 'Trung Quoc', 2500),
    ('TV02', 'Tap 200 giay mong', 'quyen', 'Trung Quoc', 4500),
    ('TV03', 'Tap 100 giay tot', 'quyen', 'Viet Nam', 3000),
    ('TV04', 'Tap 200 giay tot', 'quyen', 'Viet Nam', 5500),
    ('TV05', 'Tap 100 trang', 'chuc', 'Viet Nam', 23000),
    ('TV06', 'Tap 200 trang', 'chuc', 'Viet Nam', 53000),
    ('TV07', 'Tap 100 trang', 'chuc', 'Trung Quoc', 34000),
    ('ST01', 'So tay 500 trang', 'quyen', 'Trung Quoc', 40000),
    ('ST02', 'So tay loai 1', 'quyen', 'Viet Nam', 55000),
    ('ST03', 'So tay loai 2', 'quyen', 'Viet Nam', 51000),
    ('ST04', 'So tay', 'quyen', 'Thai Lan', 55000),
    ('ST05', 'So tay mong', 'quyen', 'Thai Lan', 20000),
    ('ST06', 'Phan viet bang', 'hop', 'Viet Nam', 5000),
    ('ST07', 'Phan khong bui', 'hop', 'Viet Nam', 7000),
    ('ST08', 'Bong bang', 'cai', 'Viet Nam', 5000),
    ('ST09', 'But long', 'cay', 'Viet Nam', 5000),
    ('ST10', 'But long', 'cay', 'Trung Quoc', 7000);

INSERT INTO HOADON
    (SOHD, NGHD, MAKH, MANV, TRIGIA)
VALUES
    ('1001', '2006-07-23', 'KH01', 'NV01', 320000),
    ('1002', '2006-08-12', 'KH01', 'NV02', 840000),
    ('1003', '2006-08-23', 'KH02', 'NV01', 100000),
    ('1004', '2006-09-01', 'KH02', 'NV01', 180000),
    ('1005', '2006-10-20', 'KH01', 'NV02', 3800000),
    ('1006', '2006-10-16', 'KH01', 'NV03', 2430000),
    ('1007', '2006-10-28', 'KH03', 'NV03', 510000),
    ('1008', '2006-10-28', 'KH01', 'NV03', 440000),
    ('1009', '2006-10-28', 'KH03', 'NV04', 200000),
    ('1010', '2006-11-01', 'KH01', 'NV01', 5200000),
    ('1011', '2006-11-04', 'KH04', 'NV03', 250000),
    ('1012', '2006-11-30', 'KH05', 'NV03', 21000),
    ('1013', '2006-12-12', 'KH06', 'NV01', 5000),
    ('1014', '2006-12-31', 'KH03', 'NV02', 3150000),
    ('1015', '2007-01-01', 'KH06', 'NV02', 910000),
    ('1016', '2007-01-01', 'KH07', 'NV02', 12500),
    ('1017', '2007-01-02', 'KH08', 'NV03', 35000),
    ('1018', '2007-01-13', 'KH01', 'NV03', 330000),
    ('1019', '2007-01-13', 'KH01', 'NV03', 30000),
    ('1020', '2007-01-14', 'KH09', 'NV04', 70000),
    ('1021', '2007-01-16', 'KH10', 'NV03', 67500),
    ('1022', '2007-01-16', NULL, 'NV03', 7000),
    ('1023', '2007-01-17', NULL, 'NV01', 330000);

INSERT INTO CTHD
    (SOHD, MASP, SL)
VALUES
    ('1001', 'TV02', 10),
    ('1001', 'ST01', 5),
    ('1001', 'BC01', 5),
    ('1001', 'BC02', 10),
    ('1001', 'ST08', 10),
    ('1001', 'BC04', 20),
    ('1002', 'BB01', 20),
    ('1002', 'BB02', 20),
    ('1003', 'BB03', 10),
    ('1004', 'TV01', 20),
    ('1004', 'TV02', 10),
    ('1004', 'TV03', 10),
    ('1004', 'TV04', 10),
    ('1005', 'TV05', 50),
    ('1005', 'TV06', 50),
    ('1006', 'TV07', 20),
    ('1006', 'ST01', 30),
    ('1006', 'ST02', 10),
    ('1007', 'ST03', 10),
    ('1008', 'ST04', 8),
    ('1009', 'ST05', 10),
    ('1010', 'TV07', 50),
    ('1010', 'ST07', 50),
    ('1010', 'ST08', 100),
    ('1010', 'ST04', 50),
    ('1010', 'TV03', 100),
    ('1011', 'ST06', 50),
    ('1012', 'ST07', 3),
    ('1013', 'ST08', 5),
    ('1014', 'BC02', 80),
    ('1014', 'BB02', 100),
    ('1014', 'BC04', 60),
    ('1014', 'BB01', 50),
    ('1015', 'BB02', 30),
    ('1015', 'BB03', 7),
    ('1016', 'TV01', 5),
    ('1017', 'TV02', 1),
    ('1017', 'TV03', 1),
    ('1017', 'TV04', 5),
    ('1018', 'ST04', 6),
    ('1019', 'ST05', 1),
    ('1019', 'ST06', 2),
    ('1020', 'ST07', 10),
    ('1021', 'ST08', 5),
    ('1021', 'TV01', 7),
    ('1021', 'TV02', 10),
    ('1022', 'ST07', 1),
    ('1023', 'ST04', 6);

------------------------------------------------------- II. Ngôn ngữ thao tác dữ liệu (Data Manipulation Language): ----------------------------------------------------------

-- 2. Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. Tạo quan hệ KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG.
SELECT *
INTO SANPHAM1
FROM SANPHAM;

SELECT *
INTO KHACHHANG1
FROM KHACHHANG;

-- 3. Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)
UPDATE SANPHAM1
SET GIA = GIA * 1.05
WHERE NUOCSX = 'Thai Lan'

-- 4. Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống (cho quan hệ SANPHAM1).
UPDATE SANPHAM1
SET GIA = GIA * 0.95
WHERE NUOCSX = 'Trung Quoc' AND GIA <= 10000

-- 5. Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước ngày 1/1/2007 có doanh số từ 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ 1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1).
UPDATE KHACHHANG1
SET LOAIKH = 'Vip'
WHERE (NGDK < '1/1/2007' AND DOANHSO >= 10000000) OR (NGDK >= '1/1/2007' AND DOANHSO >= 2000000)

-------------------------------------------------------- III. Ngôn ngữ truy vấn dữ liệu có cấu trúc: -------------------------------------------------------------------------
-- 1. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'

-- 2. In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”.
SELECT MASP, TENSP
FROM SANPHAM
WHERE DVT = 'cay' OR DVT = 'quyen'

-- 3. In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”.
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP LIKE 'B%' AND MASP LIKE '%01'

-- 4. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND GIA BETWEEN 30000 AND 40000

-- 5. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX IN ('Thai Lan', 'Trung Quoc') AND GIA BETWEEN 30000 AND 40000

-- 6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
SELECT SOHD, TRIGIA
FROM HOADON
WHERE NGHD BETWEEN '1/1/2007' AND '2/1/2007'

-- 7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
SELECT SOHD, TRIGIA
FROM HOADON
WHERE MONTH(NGHD) = 1 AND YEAR(NGHD) = 2007
ORDER BY DAY(NGHD) ASC, TRIGIA DESC

-- 8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
SELECT KHACHHANG.MAKH, KHACHHANG.HOTEN
FROM KHACHHANG
JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
WHERE HOADON.NGHD = '1/1/2007'

-- 9. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006.
SELECT HOADON.SOHD, HOADON.TRIGIA
FROM HOADON
JOIN NHANVIEN ON HOADON.MANV = NHANVIEN.MANV
WHERE NHANVIEN.HOTEN = 'Nguyen Van B' AND HOADON.NGHD = '28/10/2006'

-- 10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
SELECT SANPHAM.MASP, SANPHAM.TENSP
FROM SANPHAM
JOIN CTHD ON SANPHAM.MASP = CTHD.MASP
JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
JOIN KHACHHANG ON HOADON.MAKH = KHACHHANG.MAKH
WHERE KHACHHANG.HOTEN = 'Nguyen Van A' AND MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006

-- 11. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.
SELECT HOADON.SOHD
FROM HOADON
JOIN CTHD ON HOADON.SOHD = CTHD.SOHD
WHERE CTHD.MASP IN ('BB01', 'BB02')

-- 12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT HOADON.SOHD
FROM HOADON
JOIN CTHD ON HOADON.SOHD = CTHD.SOHD
WHERE CTHD.MASP IN ('BB01', 'BB02') AND CTHD.SL BETWEEN 10 AND 20

-- 13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT SOHD
FROM CTHD
WHERE MASP = 'BB01' AND SL BETWEEN 10 AND 20
INTERSECT
SELECT SOHD
FROM CTHD
WHERE MASP = 'BB02' AND SL BETWEEN 10 AND 20

-- Cach 2:
-- SELECT SOHD
-- FROM CTHD
-- WHERE MASP IN ('BB01', 'BB02') AND SL BETWEEN 10 AND 20
-- GROUP BY SOHD
-- HAVING COUNT(DISTINCT MASP) = 2

-- 14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được bán ra trong ngày 1/1/2007.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'
UNION
SELECT SANPHAM.MASP, SANPHAM.TENSP
FROM SANPHAM
JOIN CTHD ON SANPHAM.MASP = CTHD.MASP
JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
WHERE HOADON.NGHD = '1/1/2007'

-- Cach 2:
-- SELECT MASP, TENSP
-- FROM SANPHAM
-- WHERE NUOCSX = 'Trung Quoc' OR MASP IN (
--     SELECT MASP
--     FROM CTHD
--     WHERE SOHD IN (
--         SELECT SOHD
--         FROM HOADON
--         WHERE NGHD = '1/1/2007'
--     )
-- )

-- Cach 3:
-- SELECT MASP, TENSP
-- FROM SANPHAM
-- WHERE NUOCSX = 'Trung Quoc' OR MASP IN (
--     SELECT SANPHAM.MASP
--     FROM SANPHAM
--     JOIN CTHD ON SANPHAM.MASP = CTHD.MASP
--     JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
--     WHERE HOADON.NGHD = '1/1/2007'
-- )

-- 15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
SELECT MASP, TENSP
FROM SANPHAM
EXCEPT
SELECT SANPHAM.MASP, SANPHAM.TENSP
FROM SANPHAM
JOIN CTHD ON SANPHAM.MASP = CTHD.MASP

-- Cach 2:
-- SELECT MASP, TENSP
-- FROM SANPHAM
-- WHERE MASP NOT IN (
--     SELECT MASP
--     FROM CTHD
-- )

-- 16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP NOT IN (
    SELECT CTHD.MASP
    FROM CTHD
    JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
    WHERE YEAR(HOADON.NGHD) = 2006
)

-- 17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND MASP NOT IN (
    SELECT CTHD.MASP
    FROM CTHD
    JOIN HOADON
    ON CTHD.SOHD = HOADON.SOHD
    WHERE YEAR(HOADON.NGHD) = 2006
)

-- 18. Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất.
SELECT CTHD.SOHD
FROM CTHD
JOIN SANPHAM ON SANPHAM.MASP = CTHD.MASP
JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
WHERE YEAR(HOADON.NGHD) = 2006 AND SANPHAM.NUOCSX = 'Singapore'
GROUP BY CTHD.SOHD
HAVING COUNT(DISTINCT SANPHAM.MASP) = (
    SELECT COUNT(DISTINCT MASP)
    FROM SANPHAM
    WHERE NUOCSX = 'Singapore'
)

--26. In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh số cao nhất.
SELECT TOP 3 MAKH, HOTEN
FROM KHACHHANG
ORDER BY DOANHSO DESC

--27. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN (
    SELECT DISTINCT TOP 3 GIA
    FROM SANPHAM
    ORDER BY GIA DESC
)

--29. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND GIA IN (
    SELECT DISTINCT TOP 3 GIA
    FROM SANPHAM
    WHERE NUOCSX = 'Trung Quoc'
    ORDER BY GIA DESC
)

--34. Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD, SUM(TRIGIA) AS DOANHTHU
FROM HOADON
GROUP BY NGHD
ORDER BY NGHD

--36. Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT MONTH(NGHD) AS MONTH, SUM(TRIGIA) AS DOANHTHU
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)

--38. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT SOHD
FROM CTHD
JOIN SANPHAM ON SANPHAM.MASP = CTHD.MASP
WHERE SANPHAM.NUOCSX = 'Viet Nam'
GROUP BY SOHD
HAVING COUNT(DISTINCT SANPHAM.MASP) = 3

--43. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
SELECT NUOCSX
FROM SANPHAM
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3

--44. *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
SELECT *
FROM (
    SELECT TOP 10 MAKH
    FROM KHACHHANG
    ORDER BY DOANHSO DESC
) AS TOP10
WHERE MAKH IN (
    SELECT TOP 1 MAKH
    FROM HOADON
    GROUP BY MAKH
    ORDER BY COUNT(SOHD) DESC
)





DROP DATABASE QLGV;
CREATE DATABASE QLGV;
USE QLGV;
SET DATEFORMAT DMY;

CREATE TABLE HOCVIEN
(
    MAHV char(5) PRIMARY KEY,
    HO varchar(40),
    TEN varchar(10),
    NGSINH smalldatetime,
    GIOITINH varchar(3),
    NOISINH varchar(40),
    MALOP char(3),
);

CREATE TABLE LOP
(
    MALOP char(3) PRIMARY KEY,
    TENLOP varchar(40),
    TRGLOP char(5),
    SISO tinyint,
    MAGVCN char(4),
);

CREATE TABLE KHOA
(
    MAKHOA varchar(4) PRIMARY KEY,
    TENKHOA varchar(40),
    NGTLAP smalldatetime,
    TRGKHOA char(4)
);

CREATE TABLE MONHOC
(
    MAMH varchar(10) PRIMARY KEY,
    TENMH varchar(40),
    TCLT tinyint,
    TCTH tinyint,
    MAKHOA varchar(4),
);

CREATE TABLE DIEUKIEN
(
    MAMH varchar(10),
    MAMH_TRUOC varchar(10),
    PRIMARY KEY (MAMH, MAMH_TRUOC),
);

CREATE TABLE GIAOVIEN
(
    MAGV char(4) PRIMARY KEY,
    HOTEN varchar(40),
    HOCVI varchar(10),
    HOCHAM varchar(10),
    GIOITINH varchar(3),
    NGSINH smalldatetime,
    NGVL smalldatetime,
    HESO numeric(4,2),
    MUCLUONG money,
    MAKHOA varchar(4),
);

CREATE TABLE GIANGDAY
(
    MALOP char(3),
    MAMH varchar(10),
    MAGV char(4),
    HOCKY tinyint,
    NAM smallint,
    TUNGAY smalldatetime,
    DENNGAY smalldatetime,
    PRIMARY KEY (MALOP, MAMH),
);

CREATE TABLE KETQUATHI
(
    MAHV char(5),
    MAMH varchar(10),
    LANTHI tinyint,
    NGTHI smalldatetime,
    DIEM numeric(4,2),
    KQUA varchar(10),
    PRIMARY KEY (MAHV, MAMH, LANTHI),
);

-- Foreign key
ALTER TABLE HOCVIEN
ADD FOREIGN KEY (MALOP) REFERENCES LOP(MALOP);

ALTER TABLE LOP
ADD FOREIGN KEY (MAGVCN) REFERENCES GIAOVIEN(MAGV);
-- FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN(MAHV); --

-- ALTER TABLE KHOA
-- ADD FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN(MAGV); --

ALTER TABLE MONHOC
ADD FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA);

ALTER TABLE DIEUKIEN
ADD FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH);
    -- FOREIGN KEY (MAMH_TRUOC) REFERENCES MONHOC(MAMH); --

-- ALTER TABLE GIAOVIEN
-- ADD FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA); --

ALTER TABLE GIANGDAY
ADD FOREIGN KEY (MALOP) REFERENCES LOP(MALOP),
    FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
    FOREIGN KEY (MAGV) REFERENCES GIAOVIEN(MAGV);

ALTER TABLE KETQUATHI
ADD FOREIGN KEY (MAHV) REFERENCES HOCVIEN(MAHV),
    FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH);

------------------------------------------------ I. Ngôn ngữ định nghĩa dữ liệu (Data Definition Language): -----------------------------------------------------------------------
-- 1. Tạo quan hệ và khai báo tất cả các ràng buộc khóa chính, khóa ngoại. Thêm vào 3 thuộc tính GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN.
ALTER TABLE HOCVIEN
ADD GHICHU varchar(100),
    DIEMTB numeric(4, 2),
    XEPLOAI varchar(10);

-- 3. Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.
ALTER TABLE GIAOVIEN
ADD CONSTRAINT GIOITINH_GIAOVIEN_CHECK CHECK (GIOITINH IN ('Nam', 'Nu'));

ALTER TABLE HOCVIEN
ADD CONSTRAINT GIOITINH_HOCVIEN_CHECK CHECK (GIOITINH IN ('Nam', 'Nu'));

-- 4. Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).
ALTER TABLE KETQUATHI
ALTER COLUMN DIEM DECIMAL(4, 2)

ALTER TABLE KETQUATHI
ADD CONSTRAINT DIEM_CHECK CHECK (DIEM >= 0 AND DIEM <= 10);

-- 5. Kết quả thi là “Dat” nếu điểm từ 5 đến 10  và “Khong dat” nếu điểm nhỏ hơn 5.
ALTER TABLE KETQUATHI ADD CONSTRAINT CK_KQUA CHECK(KQUA = IIF(DIEM BETWEEN 5 AND 10, 'Dat', 'Khong dat'))

-- UPDATE KETQUATHI
-- SET KQUA = 
-- CASE 
--     WHEN DIEM >= 5 THEN 'Dat'
--     ELSE 'Khong dat'
-- END

-- 6. Học viên thi một môn tối đa 3 lần.
ALTER TABLE KETQUATHI
ADD CONSTRAINT LANTHI CHECK (LANTHI <= 3)

-- 7. Học kỳ chỉ có giá trị từ 1 đến 3.
ALTER TABLE GIANGDAY
ADD CONSTRAINT HOCKY_CHECK CHECK (HOCKY >= 1 AND HOCKY <= 3);

-- 8. Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.
ALTER TABLE GIAOVIEN
ADD CONSTRAINT HOCVI_CHECK CHECK (HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS'));

-- 11.	Học viên ít nhất là 18 tuổi.
ALTER TABLE HOCVIEN ADD CONSTRAINT CK_TUOI CHECK(GETDATE() - NGSINH >= 18)

-- 12.	Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
ALTER TABLE GIANGDAY ADD CONSTRAINT CK_NGAY CHECK(TUNGAY < DENNGAY)

-- 13.	Giáo viên khi vào làm ít nhất là 22 tuổi.
ALTER TABLE GIAOVIEN ADD CONSTRAINT CK_NGVL CHECK(GETDATE() - NGVL >= 22)

-- 14.	Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
ALTER TABLE MONHOC ADD CONSTRAINT CK_TC CHECK(ABS(TCLT - TCTH) <= 3)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO KHOA VALUES('KHMT','Khoa hoc may tinh','7/6/2005','GV01')
INSERT INTO KHOA VALUES('HTTT','He thong thong tin','7/6/2005','GV02')
INSERT INTO KHOA VALUES('CNPM','Cong nghe phan mem','7/6/2005','GV04')
INSERT INTO KHOA VALUES('MTT','Mang va truyen thong','20/10/2005','GV03')
INSERT INTO KHOA VALUES('KTMT','Ky thuat may tinh','20/12/2005','Null')

INSERT INTO MONHOC VALUES('THDC','Tin hoc dai cuong','4','1','KHMT')
INSERT INTO MONHOC VALUES('CTRR','Cau truc roi rac','5','2','KHMT')
INSERT INTO MONHOC VALUES('CSDL','Co so du lieu','3','1','HTTT')
INSERT INTO MONHOC VALUES('CTDLGT','Cau truc du lieu va giai thuat','3','1','KHMT')
INSERT INTO MONHOC VALUES('PTTKTT','Phan tich thiet ke thuat toan','3','0','KHMT')
INSERT INTO MONHOC VALUES('DHMT','Do hoa may tinh','3','1','KHMT')
INSERT INTO MONHOC VALUES('KTMT','Kien truc may tinh','3','0','KTMT')
INSERT INTO MONHOC VALUES('TKCSDL','Thiet ke co so du lieu','3','1','HTTT')
INSERT INTO MONHOC VALUES('PTTKHTTT','Phan tich thiet ke he thong thong tin','4','1','HTTT')
INSERT INTO MONHOC VALUES('HDH','He dieu hanh','4','1','KTMT')
INSERT INTO MONHOC VALUES('NMCNPM','Nhap mon cong nghe phan mem','3','0','CNPM')
INSERT INTO MONHOC VALUES('LTCFW','Lap trinh C for win','3','1','CNPM')
INSERT INTO MONHOC VALUES('LTHDT','Lap trinh huong doi tuong','3','1','CNPM')

INSERT INTO DIEUKIEN VALUES('CSDL','CTRR')
INSERT INTO DIEUKIEN VALUES('CSDL','CTDLGT')
INSERT INTO DIEUKIEN VALUES('CTDLGT','THDC')
INSERT INTO DIEUKIEN VALUES('PTTKTT','THDC')
INSERT INTO DIEUKIEN VALUES('PTTKTT','CTDLGT')
INSERT INTO DIEUKIEN VALUES('DHMT','THDC')
INSERT INTO DIEUKIEN VALUES('LTHDT','THDC')
INSERT INTO DIEUKIEN VALUES('PTTKHTTT','CSDL')

INSERT INTO GIAOVIEN VALUES('GV01','Ho Thanh Son','PTS','GS','Nam','2/5/1950','11/1/2004','5.00','2,250,000','KHMT')
INSERT INTO GIAOVIEN VALUES('GV02','Tran Tam Thanh','TS','PGS','Nam','17/12/1965','20/4/2004','4.50','2,025,000','HTTT')
INSERT INTO GIAOVIEN VALUES('GV03','Do Nghiem Phung','TS','GS','Nu','1/8/1950','23/9/2004','4.00','1,800,000','CNPM')
INSERT INTO GIAOVIEN VALUES('GV04','Tran Nam Son','TS','PGS','Nam','22/2/1961','12/1/2005','4.50','2,025,000','KTMT')
INSERT INTO GIAOVIEN VALUES('GV05','Mai Thanh Danh','ThS','GV','Nam','12/3/1958','12/1/2005','3.00','1,350,000','HTTT')
INSERT INTO GIAOVIEN VALUES('GV06','Tran Doan Hung','TS','GV','Nam','11/3/1953','12/1/2005','4.50','2,025,000','KHMT')
INSERT INTO GIAOVIEN VALUES('GV07','Nguyen Minh Tien','ThS','GV','Nam','23/11/1971','1/3/2005','4.00','1,800,000','KHMT')
INSERT INTO GIAOVIEN VALUES('GV08','Le Thi Tran','KS','Null','Nu','26/3/1974','1/3/2005','1.69','760,500','KHMT')
INSERT INTO GIAOVIEN VALUES('GV09','Nguyen To Lan','ThS','GV','Nu','31/12/1966','1/3/2005','4.00','1,800,000','HTTT')
INSERT INTO GIAOVIEN VALUES('GV10','Le Tran Anh Loan','KS','Null','Nu','17/7/1972','1/3/2005','1.86','837,000','CNPM')
INSERT INTO GIAOVIEN VALUES('GV11','Ho Thanh Tung','CN','GV','Nam','12/1/1980','15/5/2005','2.67','1,201,500','MTT')
INSERT INTO GIAOVIEN VALUES('GV12','Tran Van Anh','CN','Null','Nu','29/3/1981','15/5/2005','1.69','760,500','CNPM')
INSERT INTO GIAOVIEN VALUES('GV13','Nguyen Linh Dan','CN','Null','Nu','23/5/1980','15/5/2005','1.69','760,500','KTMT')
INSERT INTO GIAOVIEN VALUES('GV14','Truong Minh Chau','ThS','GV','Nu','30/11/1976','15/5/2005','3.00','1,350,000','MTT')
INSERT INTO GIAOVIEN VALUES('GV15','Le Ha Thanh','ThS','GV','Nam','4/5/1978','15/5/2005','3.00','1,350,000','KHMT')

INSERT INTO LOP VALUES('K11','Lop 1 khoa 1','K1108','11','GV07')
INSERT INTO LOP VALUES('K12','Lop 2 khoa 1','K1205','12','GV09')
INSERT INTO LOP VALUES('K13','Lop 3 khoa 1','K1305','12','GV14')

INSERT INTO HOCVIEN VALUES('K1101','Nguyen Van','A','27/1/1986','Nam','TpHCM','K11')
INSERT INTO HOCVIEN VALUES('K1102','Tran Ngoc','Han','14/3/1986','Nu','Kien Giang','K11')
INSERT INTO HOCVIEN VALUES('K1103','Ha Duy','Lap','18/4/1986','Nam','Nghe An','K11')
INSERT INTO HOCVIEN VALUES('K1104','Tran Ngoc','Linh','30/3/1986','Nu','Tay Ninh','K11')
INSERT INTO HOCVIEN VALUES('K1105','Tran Minh','Long','27/2/1986','Nam','TpHCM','K11')
INSERT INTO HOCVIEN VALUES('K1106','Le Nhat','Minh','24/1/1986','Nam','TpHCM','K11')
INSERT INTO HOCVIEN VALUES('K1107','Nguyen Nhu','Nhut','27/1/1986','Nam','Ha Noi','K11')
INSERT INTO HOCVIEN VALUES('K1108','Nguyen Manh','Tam','27/2/1986','Nam','Kien Giang','K11')
INSERT INTO HOCVIEN VALUES('K1109','Phan Thi Thanh','Tam','27/1/1986','Nu','Vinh Long','K11')
INSERT INTO HOCVIEN VALUES('K1110','Le Hoai','Thuong','5/2/1986','Nu','Can Tho','K11')
INSERT INTO HOCVIEN VALUES('K1111','Le Ha','Vinh','25/12/1986','Nam','Vinh Long','K11')
INSERT INTO HOCVIEN VALUES('K1201','Nguyen Van','B','11/2/1986','Nam','TpHCM','K12')
INSERT INTO HOCVIEN VALUES('K1202','Nguyen Thi Kim','Duyen','18/1/1986','Nu','TpHCM','K12')
INSERT INTO HOCVIEN VALUES('K1203','Tran Thi Kim','Duyen','17/9/1986','Nu','TpHCM','K12')
INSERT INTO HOCVIEN VALUES('K1204','Truong My','Hanh','19/5/1986','Nu','Dong Nai','K12')
INSERT INTO HOCVIEN VALUES('K1205','Nguyen Thanh','Nam','17/4/1986','Nam','TpHCM','K12')
INSERT INTO HOCVIEN VALUES('K1206','Nguyen Thi Truc','Thanh','4/3/1986','Nu','Kien Giang','K12')
INSERT INTO HOCVIEN VALUES('K1207','Tran Thi Bich','Thuy','8/2/1986','Nu','Nghe An','K12')
INSERT INTO HOCVIEN VALUES('K1208','Huynh Thi Kim','Trieu','8/4/1986','Nu','Tay Ninh','K12')
INSERT INTO HOCVIEN VALUES('K1209','Pham Thanh','Trieu','23/2/1986','Nam','TpHCM','K12')
INSERT INTO HOCVIEN VALUES('K1210','Ngo Thanh','Tuan','14/2/1986','Nam','TpHCM','K12')
INSERT INTO HOCVIEN VALUES('K1211','Do Thi','Xuan','9/3/1986','Nu','Ha Noi','K12')
INSERT INTO HOCVIEN VALUES('K1212','Le Thi Phi','Yen','12/3/1986','Nu','TpHCM','K12')
INSERT INTO HOCVIEN VALUES('K1301','Nguyen Thi Kim','Cuc','9/6/1986','Nu','Kien Giang','K13')
INSERT INTO HOCVIEN VALUES('K1302','Truong Thi My','Hien','18/3/1986','Nu','Nghe An','K13')
INSERT INTO HOCVIEN VALUES('K1303','Le Duc','Hien','21/3/1986','Nam','Tay Ninh','K13')
INSERT INTO HOCVIEN VALUES('K1304','Le Quang','Hien','18/4/1986','Nam','TpHCM','K13')
INSERT INTO HOCVIEN VALUES('K1305','Le Thi','Huong','27/3/1986','Nu','TpHCM','K13')
INSERT INTO HOCVIEN VALUES('K1306','Nguyen Thai','Huu','30/3/1986','Nam','Ha Noi','K13')
INSERT INTO HOCVIEN VALUES('K1307','Tran Minh','Man','28/5/1986','Nam','TpHCM','K13')
INSERT INTO HOCVIEN VALUES('K1308','Nguyen Hieu','Nghia','8/4/1986','Nam','Kien Giang','K13')
INSERT INTO HOCVIEN VALUES('K1309','Nguyen Trung','Nghia','18/1/1987','Nam','Nghe An','K13')
INSERT INTO HOCVIEN VALUES('K1310','Tran Thi Hong','Tham','22/4/1986','Nu','Tay Ninh','K13')
INSERT INTO HOCVIEN VALUES('K1311','Tran Minh','Thuc','4/4/1986','Nam','TpHCM','K13')
INSERT INTO HOCVIEN VALUES('K1312','Nguyen Thi Kim','Yen','7/9/1986','Nu','TpHCM','K13')

INSERT INTO GIANGDAY VALUES('K11','THDC','GV07','1','2006','2/1/2006','12/5/2006')
INSERT INTO GIANGDAY VALUES('K12','THDC','GV06','1','2006','2/1/2006','12/5/2006')
INSERT INTO GIANGDAY VALUES('K13','THDC','GV15','1','2006','2/1/2006','12/5/2006')
INSERT INTO GIANGDAY VALUES('K11','CTRR','GV02','1','2006','9/1/2006','17/5/2006')
INSERT INTO GIANGDAY VALUES('K12','CTRR','GV02','1','2006','9/1/2006','17/5/2006')
INSERT INTO GIANGDAY VALUES('K13','CTRR','GV08','1','2006','9/1/2006','17/5/2006')
INSERT INTO GIANGDAY VALUES('K11','CSDL','GV05','2','2006','1/6/2006','15/7/2006')
INSERT INTO GIANGDAY VALUES('K12','CSDL','GV09','2','2006','1/6/2006','15/7/2006')
INSERT INTO GIANGDAY VALUES('K13','CTDLGT','GV15','2','2006','1/6/2006','15/7/2006')
INSERT INTO GIANGDAY VALUES('K13','CSDL','GV05','3','2006','1/8/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES('K13','DHMT','GV07','3','2006','1/8/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES('K11','CTDLGT','GV15','3','2006','1/8/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES('K12','CTDLGT','GV15','3','2006','1/8/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES('K11','HDH','GV04','1','2007','2/1/2007','18/2/2007')
INSERT INTO GIANGDAY VALUES('K12','HDH','GV04','1','2007','2/1/2007','20/3/2007')
INSERT INTO GIANGDAY VALUES('K11','DHMT','GV07','1','2007','18/2/2007','20/3/2007')

INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1101','CSDL','1','20/7/2006','10.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1101','CTDLGT','1','28/12/2006','9.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1101','THDC','1','20/5/2006','9.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1101','CTRR','1','13/5/2006','9.50','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1102','CSDL','1','20/7/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1102','CSDL','2','27/7/2006','4.25','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1102','CSDL','3','10/8/2006','4.50','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1102','CTDLGT','1','28/12/2006','4.50','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1102','CTDLGT','2','5/1/2007','4.00','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1102','CTDLGT','3','15/1/2007','6.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1102','THDC','1','20/5/2006','5.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1102','CTRR','1','13/5/2006','7.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1103','CSDL','1','20/7/2006','3.50','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1103','CSDL','2','27/7/2006','8.25','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1103','CTDLGT','1','28/12/2006','7.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1103','THDC','1','20/5/2006','8.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1103','CTRR','1','13/5/2006','6.50','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1104','CSDL','1','20/7/2006','3.75','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1104','CTDLGT','1','28/12/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1104','THDC','1','20/5/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1104','CTRR','1','13/5/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1104','CTRR','2','20/5/2006','3.50','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1104','CTRR','3','30/6/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1201','CSDL','1','20/7/2006','6.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1201','CTDLGT','1','28/12/2006','5.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1201','THDC','1','20/5/2006','8.50','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1201','CTRR','1','13/5/2006','9.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1202','CSDL','1','20/7/2006','8.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1202','CTDLGT','1','28/12/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1202','CTDLGT','2','5/1/2007','5.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1202','THDC','1','20/5/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1202','THDC','2','27/5/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1202','CTRR','1','13/5/2006','3.00','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1202','CTRR','2','20/5/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1202','CTRR','3','30/6/2006','6.25','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1203','CSDL','1','20/7/2006','9.25','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1203','CTDLGT','1','28/12/2006','9.50','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1203','THDC','1','20/5/2006','10.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1203','CTRR','1','13/5/2006','10.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1204','CSDL','1','20/7/2006','8.50','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1204','CTDLGT','1','28/12/2006','6.75','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1204','THDC','1','20/5/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1204','CTRR','1','13/5/2006','6.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1301','CSDL','1','20/12/2006','4.25','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1301','CTDLGT','1','25/7/2006','8.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1301','THDC','1','20/5/2006','7.75','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1301','CTRR','1','13/5/2006','8.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1302','CSDL','1','20/12/2006','6.75','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1302','CTDLGT','1','25/7/2006','5.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1302','THDC','1','20/5/2006','8.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1302','CTRR','1','13/5/2006','8.50','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1303','CSDL','1','20/12/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1303','CTDLGT','1','25/7/2006','4.50','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1303','CTDLGT','2','7/8/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1303','CTDLGT','3','15/8/2006','4.25','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1303','THDC','1','20/5/2006','4.50','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1303','CTRR','1','13/5/2006','3.25','Khong Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1303','CTRR','2','20/5/2006','5.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1304','CSDL','1','20/12/2006','7.75','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1304','CTDLGT','1','25/7/2006','9.75','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1304','THDC','1','20/5/2006','5.50','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1304','CTRR','1','13/5/2006','5.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1305','CSDL','1','20/12/2006','9.25','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1305','CTDLGT','1','25/7/2006','10.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1305','THDC','1','20/5/2006','8.00','Dat')
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES('K1305','CTRR','1','13/5/2006','10.00','Dat')

---------------------------------------------- II. Ngôn ngữ thao tác dữ liệu (Data Manipulation Language): -----------------------------------------------------------------
-- 1. Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.
UPDATE GIAOVIEN
SET HESO = HESO + 0.2
WHERE MAGV IN (
    SELECT TRGKHOA
    FROM KHOA
)

-- 2. Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên (tất cả các môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau cùng).
-- Cach 1:
UPDATE HOCVIEN
SET DIEMTB = (
	SELECT AVG(DIEM)
	FROM (
		-- CHỌN MÔN HỌC CÓ SỐ LẦN THI LẠI LỚN NHẤT
		SELECT *
		FROM KETQUATHI AS KQ
		WHERE LANTHI = (
			-- CHỌN SỐ LẦN THI LẠI LỚN NHẤT
			SELECT MAX(LANTHI)
			FROM KETQUATHI
			WHERE KQ.MAHV = KETQUATHI.MAHV 
			AND KQ.MAMH = KETQUATHI.MAMH
		) 
	) AS LASTATTEMPT
	WHERE HOCVIEN.MAHV = LASTATTEMPT.MAHV
)
SELECT * FROM HOCVIEN

-- Cach 2:
UPDATE HOCVIEN
SET DIEMTB = (
    SELECT AVG(DIEM)
    FROM KETQUATHI AS KQ
    WHERE KQ.MAHV = HOCVIEN.MAHV
    AND KQ.LANTHI = (
        SELECT MAX(LANTHI)
        FROM KETQUATHI AS KQ2
        WHERE KQ2.MAHV = KQ.MAHV AND KQ2.MAMH = KQ.MAMH
    )
);

-- 3. Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất kỳ thi lần thứ 3 dưới 5 điểm.
UPDATE HOCVIEN
SET GHICHU = 'Cam thi'
WHERE MAHV IN (
    SELECT MAHV
    FROM KETQUATHI
    WHERE LANTHI = 3 AND DIEM < 5
);

-- 4. Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau:
-- Nếu DIEMTB ≥ 9 thì XEPLOAI =”XS”
-- Nếu  8 ≤ DIEMTB < 9 thì XEPLOAI = “G”
-- Nếu  6.5 ≤ DIEMTB < 8 thì XEPLOAI = “K”
-- Nếu  5  ≤  DIEMTB < 6.5 thì XEPLOAI = “TB”
-- Nếu  DIEMTB < 5 thì XEPLOAI = ”Y”
UPDATE HOCVIEN
SET XEPLOAI = CASE
    WHEN DIEMTB >= 9 THEN 'XS'
    WHEN DIEMTB >= 8 THEN 'G'
    WHEN DIEMTB >= 6.5 THEN 'K'
    WHEN DIEMTB >= 5 THEN 'TB'
    ELSE 'Y'
END;

---------------------------------------------------------- III. Ngôn ngữ truy vấn dữ liệu có cấu trúc: --------------------------------------------------------------
--1.	In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT HV.MAHV, HV.HO+' '+HV.TEN AS HOTEN, HV.NGSINH, HV.MALOP 
FROM HOCVIEN HV
INNER JOIN LOP L ON L.TRGLOP = HV.MAHV

--2.	In ra bảng điểm khi thi (mã học viên, họ tên, lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo tên, họ học viên.
SELECT HOCVIEN.MAHV, HOCVIEN.HO+' '+HOCVIEN.TEN AS HOTEN, KETQUATHI.LANTHI, KETQUATHI.DIEM
FROM KETQUATHI
INNER JOIN  HOCVIEN ON KETQUATHI.MAHV = HOCVIEN.MAHV
INNER JOIN MONHOC ON KETQUATHI.MAMH = MONHOC.MAMH
WHERE KETQUATHI.MAMH = 'CTRR' AND MALOP = 'K12'
ORDER BY TEN, HO

--3.	In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt.
SELECT KETQUATHI.MAHV, HOCVIEN.HO+' '+HOCVIEN.TEN AS HOTEN, TENMH 
FROM KETQUATHI
INNER  JOIN MONHOC ON MONHOC.MAMH = KETQUATHI.MAMH
INNER JOIN HOCVIEN ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE LANTHI = 1 AND KQUA = 'Dat'

--4.	In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
SELECT HOCVIEN.MAHV, HOCVIEN.HO+' '+HOCVIEN.TEN AS HOTEN
FROM HOCVIEN
INNER JOIN KETQUATHI ON KETQUATHI.MAHV = HOCVIEN.MAHV
INNER JOIN MONHOC ON KETQUATHI.MAMH = MONHOC.MAMH
WHERE HOCVIEN.MALOP = 'K11' AND TENMH = 'cau truc roi rac' AND LANTHI = 1 AND KQUA = 'Khong Dat'

--5.* Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).


--6. Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006.
SELECT DISTINCT MONHOC.TENMH
FROM GIANGDAY
JOIN GIAOVIEN ON GIAOVIEN.MAGV = GIANGDAY.MAGV
JOIN MONHOC ON MONHOC.MAMH = GIANGDAY.MAMH
WHERE GIAOVIEN.HOTEN = 'Tran Tam Thanh' AND HOCKY = 1 AND NAM = 2006

--7. Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN (
    SELECT MAMH
    FROM GIANGDAY
    JOIN GIAOVIEN ON GIAOVIEN.MAGV = GIANGDAY.MAGV
    JOIN LOP ON LOP.MAGVCN = GIAOVIEN.MAGV
    WHERE LOP.MALOP = 'K11' AND HOCKY = 1 AND NAM = 2006
)

--8. Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.
SELECT HV.HO + ' ' + HV.TEN AS HOTEN
FROM HOCVIEN HV
WHERE MAHV IN (
    SELECT LOP.TRGLOP
    FROM LOP
    JOIN GIANGDAY ON GIANGDAY.MALOP = LOP.MALOP
    JOIN GIAOVIEN ON GIAOVIEN.MAGV = GIANGDAY.MAGV
    JOIN MONHOC ON MONHOC.MAMH = GIANGDAY.MAMH
    WHERE GIAOVIEN.HOTEN = 'Nguyen To Lan' AND MONHOC.TENMH = 'Co So Du Lieu'
)

--9. In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”.
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN (
	SELECT MAMH_TRUOC
	FROM DIEUKIEN
	WHERE MAMH = (
		SELECT MAMH 
		FROM MONHOC
		WHERE TENMH = 'Co so du lieu'
	)
)

--10. Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, tên môn học) nào.
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN (
	SELECT MAMH
	FROM DIEUKIEN
	WHERE MAMH_TRUOC IN (
		SELECT MAMH
		FROM MONHOC
		WHERE TENMH = 'Cau truc roi rac'
	)
)

--11. Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006.
SELECT HOTEN
FROM GIAOVIEN
WHERE MAGV IN (
	SELECT MAGV
	FROM GIANGDAY
	WHERE MALOP = 'K11' AND HOCKY = 1 AND NAM = 2006 AND MAGV IN (
		SELECT MAGV
		FROM GIANGDAY
		WHERE MALOP = 'K12'
	)
)

-- 12. Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này.
SELECT HOCVIEN.MAHV, HO + ' ' + TEN AS HOTEN
FROM HOCVIEN
JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE KETQUATHI.MAMH = 'CSDL'
AND KETQUATHI.LANTHI = 1
AND KETQUATHI.DIEM < 5
AND NOT EXISTS 
(
    SELECT 1
    FROM KETQUATHI AS KQ2
    WHERE KQ2.MAHV = KETQUATHI.MAHV
    AND KQ2.MAMH = 'CSDL'
    AND KQ2.LANTHI > 1
)

--13. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV NOT IN (
    SELECT MAGV
    FROM GIANGDAY
)

-- 14. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách.
SELECT GV1.MAGV, GV1.HOTEN
FROM GIAOVIEN GV1
WHERE NOT EXISTS(
	SELECT *
	FROM GIANGDAY GD
	INNER JOIN MONHOC ON GD.MAMH = MONHOC.MAMH 
	WHERE GD.MAGV = GV1.MAGV
	AND MONHOC.MAKHOA = GV1.MAKHOA
)

--15. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat” hoặc thi lần thứ 2 môn CTRR được 5 điểm.
SELECT HO + ' ' + TEN AS HOTEN
FROM HOCVIEN
WHERE MALOP = 'K11' AND MAHV IN (
    SELECT MAHV
    FROM KETQUATHI
    WHERE (LANTHI >= 3 AND KQUA = 'Khong dat') OR (LANTHI = 2 AND DIEM = 5 AND MAMH = 'CTRR')
)

--16. Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.
SELECT HOTEN
FROM GIAOVIEN
WHERE MAGV IN (
    SELECT MAGV
    FROM GIANGDAY
    WHERE MAMH = 'CTRR'
    GROUP BY MAGV, HOCKY, NAMHOC
    HAVING COUNT(MALOP) >=2
)

-- 17. Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
SELECT HOCVIEN.MAHV, HO + ' ' + TEN AS HOTEN, KQ.DIEM
FROM HOCVIEN
INNER JOIN KETQUATHI KQ ON KQ.MAHV = HOCVIEN.MAHV 
WHERE KQ.MAMH = 'CSDL'
  AND KQ.LANTHI = (
      SELECT MAX(LANTHI)
      FROM KETQUATHI
      WHERE MAHV = KQ.MAHV
        AND MAMH = 'CSDL'
)

-- 18. Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).
SELECT HOCVIEN.MAHV, HO+' '+TEN AS HOTEN, MAX(KQ.DIEM) AS DIEMCAONHAT
FROM HOCVIEN
INNER JOIN KETQUATHI KQ ON KQ.MAHV = HOCVIEN.MAHV
WHERE KQ.MAMH = 'CSDL'
GROUP BY HOCVIEN.MAHV, HOCVIEN.MAHV, HO+' '+TEN

--23. Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV IN (
    SELECT MAGV
    FROM GIANGDAY
    JOIN LOP ON GIANGDAY.MAGV = LOP.MAGVCN
)

--25. * Tìm họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần thi).
SELECT HO + ' ' + TEN
FROM HOCVIEN
WHERE MAHV IN (
    SELECT TRGLOP
    FROM LOP
    WHERE TRGLOP IN (
        SELECT MAHV
        FROM KETQUATHI
        WHERE KETQUATHI.MAHV = LOP.TRGLOP AND KQUA = 'Khong Dat'
        GROUP BY MAHV
        HAVING COUNT(MAMH) >= 3
    )
)

--27. Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất.
SELECT MALOP, MAHV, HOTEN
FROM (
    SELECT HOCVIEN.MALOP, HOCVIEN.MAHV, HOCVIEN.HO + ' ' + HOCVIEN.TEN AS HOTEN, 
           ROW_NUMBER() OVER (PARTITION BY HOCVIEN.MALOP ORDER BY COUNT(*) DESC) AS RN
    FROM HOCVIEN
    JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
    WHERE KETQUATHI.DIEM IN (9, 10)
    GROUP BY HOCVIEN.MALOP, HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN
) AS SubQuery
WHERE RN = 1;

-- 27.	Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
SELECT LEFT(A.MAHV, 3) MALOP, A.MAHV, HO + ' ' + TEN HOTEN FROM (
	SELECT MAHV, RANK () OVER (ORDER BY COUNT(MAMH) DESC) RANK_MH FROM KETQUATHI KQ 
	WHERE DIEM BETWEEN 9 AND 10
	GROUP BY KQ.MAHV
) A INNER JOIN HOCVIEN HV
ON A.MAHV = HV.MAHV
WHERE RANK_MH = 1
GROUP BY LEFT(A.MAHV, 3), A.MAHV, HO, TEN

--29. Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
SELECT HOCKY, NAM, A.MAGV, HOTEN FROM (
	SELECT HOCKY, NAM, MAGV, RANK() OVER (PARTITION BY HOCKY, NAM ORDER BY COUNT(MAMH) DESC) RANK_SOMH FROM GIANGDAY
	GROUP BY HOCKY, NAM, MAGV
) A INNER JOIN GIAOVIEN GV 
ON A.MAGV = GV.MAGV
WHERE RANK_SOMH = 1

--32. * Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng).
SELECT C.MAHV, HO + ' ' + TEN HOTEN FROM (
	SELECT MAHV, COUNT(KQUA) SODAT FROM KETQUATHI A
	WHERE NOT EXISTS (
		SELECT 1 
		FROM KETQUATHI B 
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
	) AND KQUA = 'Dat'
	GROUP BY MAHV
	INTERSECT
	SELECT MAHV, COUNT(MAMH) SOMH FROM KETQUATHI 
	WHERE LANTHI = 1
	GROUP BY MAHV
) C INNER JOIN HOCVIEN HV
ON C.MAHV = HV.MAHV

--34. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn và đều đạt (chỉ xét lần thi sau cùng).
SELECT C.MAHV, HO + ' ' + TEN HOTEN FROM (
	SELECT MAHV, COUNT(KQUA) SODAT FROM KETQUATHI A
	WHERE NOT EXISTS (
		SELECT 1 FROM KETQUATHI B 
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
	) AND KQUA = 'Dat'
	GROUP BY MAHV
	INTERSECT
	SELECT MAHV, COUNT(MAMH) SOMH FROM KETQUATHI 
	WHERE LANTHI = 1
	GROUP BY MAHV
) C INNER JOIN HOCVIEN HV
ON C.MAHV = HV.MAHV

--35. ** Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần thi sau cùng).
SELECT A.MAHV, HO + ' ' + TEN HOTEN FROM (
	SELECT B.MAMH, MAHV, DIEM, DIEMMAX
	FROM KETQUATHI B INNER JOIN (
		SELECT MAMH, MAX(DIEM) DIEMMAX FROM KETQUATHI
		GROUP BY MAMH
	) C 
	ON B.MAMH = C.MAMH
	WHERE NOT EXISTS (
		SELECT 1 FROM KETQUATHI D 
		WHERE B.MAHV = D.MAHV AND B.MAMH = D.MAMH AND B.LANTHI < D.LANTHI
	) AND DIEM = DIEMMAX
) A INNER JOIN HOCVIEN HV
ON A.MAHV = HV.MAHV