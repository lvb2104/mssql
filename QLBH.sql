--DROP DATABASE QLBH;
CREATE DATABASE QLBH;
USE QLBH;
SET DATEFORMAT DMY;

--------------------------------------------------------- I. Ngôn ngữ định nghĩa dữ liệu (Data Definition Language): --------------------------------------------------------
-- 1. Tạo các quan hệ và khai báo các khóa chính, khóa ngoại của quan hệ.
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

-- 11. Ngày mua hàng (NGHD) của một khách hàng thành viên sẽ lớn hơn hoặc bằng ngày khách hàng đó đăng ký thành viên (NGDK).
CREATE TRIGGER trigger_11
ON HOADON
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT COUNT(*)
		FROM KHACHHANG
		JOIN inserted ON KHACHHANG.MAKH = inserted.MAKH
		WHERE inserted.NGHD < KHACHHANG.NGDK
	)
	BEGIN
		RAISERROR('LOI: NGAY HOA DON KHONG HOP LE', 16, 1)
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		PRINT N'Thêm hóa đơn thành công'
	END
END

-- 12. Ngày bán hàng (NGHD) của một nhân viên phải lớn hơn hoặc bằng ngày nhân viên đó vào làm.
CREATE TRIGGER trigger_12
ON HOADON
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT COUNT(*)
		FROM NHANVIEN
		JOIN inserted ON NHANVIEN.MANV = inserted.MANV
		WHERE inserted.NGHD < NHANVIEN.NGVL
	)
	BEGIN
		RAISERROR('LOI: NGAY HOA DON KHONG HOP LE', 16, 1)
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		PRINT N'Thêm hóa đơn thành công'
	END
END

-- 13. Trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa đơn đó.
CREATE TRIGGER trigger_13
ON CTHD
FOR INSERT, UPDATE, DELETE 
AS
BEGIN 
	UPDATE HOADON
	SET TRIGIA = (
		SELECT SUM(CTHD.SL * SANPHAM.GIA)
		FROM CTHD
		JOIN SANPHAM ON CTHD.MASP = SANPHAM.MASP
		WHERE HOADON.SOHD = CTHD.SOHD
	)
	WHERE HOADON.SOHD IN (
		SELECT SOHD
		FROM inserted
		UNION
		SELECT SOHD
		FROM deleted
	)
END


-- 14. Doanh số của một khách hàng là tổng trị giá các hóa đơn mà khách hàng thành viên đó đã mua.
CREATE TRIGGER trigger_14
ON HOADON
FOR INSERT, UPDATE, DELETE
AS 
BEGIN 
	UPDATE KHACHHANG
	SET DOANHSO = (
		SELECT SUM(TRIGIA)
		FROM HOADON
		WHERE KHACHHANG.MAKH = HOADON.MAKH
	)
	WHERE MAKH IN (
		SELECT MAKH
		FROM inserted
		UNION
		SELECT MAKH
		FROM deleted
	)
END

------------------------------------------------------- II. Ngôn ngữ thao tác dữ liệu (Data Manipulation Language): ----------------------------------------------------------
-- 1. Nhập dữ liệu cho các quan hệ trên.
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH01','NGUYEN VAN A','731TRAN HUNG DAO,Q5,THHCM','08823451','22/10/1960','22/07/2006',13060000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH02','TRAN NGOC HAN','23/5NGUYEN TRAI,Q5,TPHCM','0908256478','03/04/1974','30/07/2006',280000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH03','TRAN NGOC LINH','45NGUYEN CANH CHAN,Q1,TPHCM','0938776266','10/06/1980','05/05/2006',3860000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH04','TRAN MINH LONG','50/34LE DAI HANH,Q10,TPHCM','0917325476','09/03/1965','02/10/2006',250000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH05','LE NHAT MINH','34TRUONG DINH,Q3,TPHCM','08246108','10/03/1950','28/10/2006',21000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH06','LE HOAI THUONG','227NGUYEN VAN CU,Q5,TPHCM','08631738','31/12/1981','24/11/2006',915000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH07','NGUYEN VAN TAM','32/3 TRAN BINH TRONG,Q5,TPHCM','0916783565','06/06/1971','01/12/2006',12500)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH08','PHAN THI THANH','45/2 AN DUONG VUONG,Q5,TPHCM','0938435756','10/01/1971','13/12/2006',365000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH09','LE HA VINH','837 LE HONG PHONG,Q5,TPHCM','08654763','03/03/1979','14/01/2007',70000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH10','HA DUY LAP','34/34B NGUYEN TRAI,Q5,TPHCM','08768904','02/05/1983','16/01/2007',67500)

INSERT INTO NHANVIEN(MANV,HOTEN,SODT,NGVL) VALUES ('NV01','NGUYEN NHU NHUT','0927345678','13/04/2006')
INSERT INTO NHANVIEN(MANV,HOTEN,SODT,NGVL) VALUES ('NV02','LE THI PHI YEN','0987567390','21/04/2006')
INSERT INTO NHANVIEN(MANV,HOTEN,SODT,NGVL) VALUES ('NV03','NGUYEN VAN B','0997047382','27/04/2006')
INSERT INTO NHANVIEN(MANV,HOTEN,SODT,NGVL) VALUES ('NV04','NGO THANH TUAN','0913758498','24/06/2006')
INSERT INTO NHANVIEN(MANV,HOTEN,SODT,NGVL) VALUES ('NV05','NGUYEN THI TRUC THANH','0918590387','20/07/2006')

INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('BC01','BUT CHI','CAY','SINGAPORE',3000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('BC02','BUT CHI','CAY','SINGAPORE',5000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('BC03','BUT CHI','CAY','VIETNAM',3500)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('BC04','BUT CHI','HOP','VIETNAM',30000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('BB01','BUT BI','CAY','VIETNAM',5000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('BB02','BUT BI','CAY','TRUNGQUOC',7000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('BB03','BUT BI','HOP','THAILAN',100000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('TV01','TAP 100 TRANG GIAY MONG','QUYEN','TRUNGQUOC',2500)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('TV02','TAP 200 TRANG GIAY MONG','QUYEN','TRUNGQUOC',4500)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('TV03','TAP 100 TRANG GIAY TOT','QUYEN','VIETNAM',3000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('TV04','TAP 200 TRANG GIAY TOT','QUYEN','VIETNAM',5500)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('TV05','TAP 100 TRANG ','CHUC','VIETNAM',23000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('TV06','TAP 200 TRANG ','CHUC','VIETNAM',53000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('TV07','TAP 100 TRANG ','CHUC','TRUNGQUOC',34000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST01','SO TAY 500 TRANG','QUYEN','TRUNGQUOC',40000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST02','SO TAY LOAI 1','QUYEN','VIETNAM',55000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST03','SO TAY LOAI 2','QUYEN','VIETNAM',51000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST04','SO TAY','QUYEN','THAILAN',55000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST05','SO TAY MONG','QUYEN','THAILAN',20000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST06','PHAN VIET BANG','HOP','VIETNAM',5000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST07','PHAN KHONG BUI','HOP','VIETNAM',7000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST08','BONG BAMG','CAI','VIETNAM',1000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST09','BUT LONG','CAY','VIETNAM',5000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST10','BUT LONG','CAY','TRUNGQUOC',7000)

INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1001,'27/07/2006','KH01','NV01',320000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1002,'10/08/2006','KH01','NV02',840000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1003,'23/08/2006','KH02','NV01',100000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1004,'01/09/2006','KH02','NV01',180000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1005,'20/10/2006','KH01','NV02',3800000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1006,'16/10/2006','KH01','NV03',2430000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1007,'28/10/2006','KH03','NV03',510000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1008,'28/10/2006','KH01','NV03',440000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1009,'28/10/2006','KH03','NV04',200000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1010,'01/11/2006','KH01','NV01',5200000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1011,'04/11/2006','KH04','NV03',250000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1012,'30/11/2006','KH05','NV03',21000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1013,'12/12/2006','KH06','NV01',5000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1014,'31/12/2006','KH03','NV02',3150000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1015,'01/01/2007','KH06','NV01',910000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1016,'01/01/2007','KH07','NV02',12500)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1017,'02/01/2007','KH08','NV03',35000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1018,'13/01/2007','KH08','NV03',330000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1019,'13/01/2007','KH01','NV03',30000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1020,'14/01/2007','KH09','NV04',70000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1021,'16/01/2007','KH10','NV03',67500)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1022,'16/01/2007',NULL,'NV03',7000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1023,'17/01/2007',NULL,'NV01',330000)

INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1001,'TV02',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1001,'ST01',5)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1001,'BC01',5)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1001,'BC02',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1001,'ST08',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1002,'BC04',20)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1002,'BB01',20)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1002,'BB02',20)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1003,'BB03',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1004,'TV01',20)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1004,'TV02',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1004,'TV03',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1004,'TV04',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1005,'TV05',50)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1005,'TV06',50)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1006,'TV07',20)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1006,'ST01',30)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1006,'ST02',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1007,'ST03',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1008,'ST04',8)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1009,'ST05',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1010,'TV07',50)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1010,'ST07',50)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1010,'ST08',100)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1010,'ST04',50)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1010,'TV03',100)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1011,'ST06',50)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1012,'ST07',3)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1013,'ST08',5)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1014,'BC02',80)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1014,'BB02',100)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1014,'BC04',60)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1014,'BB01',50)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1015,'BB02',30)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1015,'BB03',7)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1016,'TV01',5)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1017,'TV02',1)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1017,'TV03',1)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1017,'TV04',5)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1018,'ST04',6)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1019,'ST05',1)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1019,'ST06',2)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1020,'ST07',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1021,'ST08',5)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1021,'TV01',7)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1021,'TV02',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1022,'ST07',1)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1023,'ST04',6)

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

-- 19. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT COUNT(*)
FROM HOADON
WHERE NOT EXISTS (
    SELECT 1
    FROM KHACHHANG
    WHERE HOADON.MAKH = KHACHHANG.MAKH
)

-- 20. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
-- MASP DISTINCT, YEAR(2006) = NGHD
SELECT COUNT(DISTINCT CTHD.MASP)
FROM CTHD
JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
WHERE YEAR(HOADON.NGHD) = 2006

-- 21. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
SELECT MAX(TRIGIA) AS MAX_TRIGIA, MIN(TRIGIA) AS MIN_TRIGIA
FROM HOADON

-- 22. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA)
FROM HOADON
WHERE YEAR(NGHD) = 2006

-- 23. Tính doanh thu bán hàng trong năm 2006.
SELECT SUM(TRIGIA)
FROM HOADON
WHERE YEAR(NGHD) = 2006

-- 24. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT SOHD
FROM HOADON
WHERE TRIGIA = (
	SELECT MAX(TRIGIA)
	FROM HOADON
)

-- 25. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT HOTEN
FROM KHACHHANG
WHERE MAKH IN (
	SELECT MAKH
	FROM HOADON
	WHERE TRIGIA = (
		SELECT MAX(TRIGIA)
		FROM HOADON
		WHERE YEAR(NGHD) = 2006
	)
)

-- 26. In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh số cao nhất.
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

-- 28. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Thai Lan' AND GIA IN (
	SELECT DISTINCT TOP 3 GIA
	FROM SANPHAM
	ORDER BY GIA DESC
)

-- 29. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND GIA IN (
    SELECT DISTINCT TOP 3 GIA
    FROM SANPHAM
    WHERE NUOCSX = 'Trung Quoc'
    ORDER BY GIA DESC
)

-- 30.* In ra danh sách 3 khách hàng có doanh số cao nhất (sắp xếp theo kiểu xếp hạng).
SELECT TOP 3 HOTEN
FROM KHACHHANG
ORDER BY DOANHSO DESC

-- 31. Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
SELECT COUNT(*)
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'

-- 32. Tính tổng số sản phẩm của từng nước sản xuất.
SELECT NUOCSX, COUNT(*)
FROM SANPHAM
GROUP BY NUOCSX

-- 33. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT NUOCSX, MAX(GIA), MIN(GIA), AVG(GIA)
FROM SANPHAM
GROUP BY NUOCSX

--34. Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD, SUM(TRIGIA) AS DOANHTHU
FROM HOADON
GROUP BY NGHD
ORDER BY NGHD

-- 35. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT SANPHAM.TENSP, SUM(SL)
FROM CTHD
JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
JOIN SANPHAM ON SANPHAM.MASP = CTHD.MASP
WHERE MONTH(HOADON.NGHD) = 10 AND YEAR(HOADON.NGHD) = 2006
GROUP BY SANPHAM.TENSP

-- 36. Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT MONTH(NGHD) AS MONTH, SUM(TRIGIA) AS DOANHTHU
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)

-- 37. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT SOHD
FROM HOADON
WHERE 4 <= (
	SELECT COUNT(MASP)
	FROM CTHD
	WHERE HOADON.SOHD = CTHD.SOHD
)

-- 38. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT SOHD
FROM CTHD
JOIN SANPHAM ON SANPHAM.MASP = CTHD.MASP
WHERE SANPHAM.NUOCSX = 'Viet Nam'
GROUP BY SOHD
HAVING COUNT(SANPHAM.MASP) = 3

-- 39. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
SELECT TOP 1 WITH TIES KHACHHANG.MAKH, KHACHHANG.HOTEN
FROM HOADON
JOIN KHACHHANG ON KHACHHANG.MAKH = HOADON.MAKH
GROUP BY KHACHHANG.MAKH, KHACHHANG.HOTEN
ORDER BY COUNT(SOHD) DESC

-- 40. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
SELECT TOP 1 SUM(TRIGIA)
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
ORDER BY SUM(TRIGIA) DESC

-- 41. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT TOP 1 WITH TIES SANPHAM.MASP, SANPHAM.TENSP
FROM SANPHAM
JOIN CTHD ON CTHD.MASP = SANPHAM.MASP
JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
WHERE YEAR(NGHD) = 2006
GROUP BY SANPHAM.MASP, SANPHAM.TENSP
ORDER BY SUM(SL)

-- 42.* Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
SELECT NUOCSX, MASP, TENSP
FROM SANPHAM SP
WHERE GIA = (
	SELECT MAX(GIA)
	FROM SANPHAM
	WHERE SP.NUOCSX = NUOCSX
)

select MASP, TENSP, NUOCSX
from SANPHAM S1
where GIA = (select max(GIA) from SANPHAM S2 where NUOCSX = S1.NUOCSX group by S2.NUOCSX)

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
