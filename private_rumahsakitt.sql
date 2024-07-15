-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 15, 2024 at 10:35 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `private_rumahsakitt`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CekJenisKelaminPasien` ()   BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE p_nama VARCHAR(100);
    DECLARE p_jenis_kelamin ENUM('P', 'L');
    DECLARE cur CURSOR FOR SELECT nama, jenis_kelamin FROM Pasien;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO p_nama, p_jenis_kelamin;
        IF done THEN
            LEAVE read_loop;
        END IF;
        CASE p_jenis_kelamin
            WHEN 'L' THEN
                SELECT CONCAT('Pasien ', p_nama, ' adalah laki-laki') AS Pesan;
            WHEN 'P' THEN
                SELECT CONCAT('Pasien ', p_nama, ' adalah perempuan') AS Pesan;
            ELSE
                SELECT CONCAT('Jenis kelamin pasien ', p_nama, ' tidak diketahui') AS Pesan;
        END CASE;
    END LOOP;
    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DetailPerawatanWithCheck` (IN `in_id_pasien` INT, IN `in_id_dokter` INT)   BEGIN
    DECLARE perawatan_count INT;
    SELECT COUNT(*) INTO perawatan_count 
    FROM Perawatan 
    WHERE id_pasien = in_id_pasien AND id_dokter = in_id_dokter;
    IF perawatan_count > 0 THEN
        SELECT * 
        FROM Perawatan 
        WHERE id_pasien = in_id_pasien AND id_dokter = in_id_dokter;
    ELSE
        SELECT 'Perawatan tidak ditemukan' AS Message;
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `cari_dokter` (`nama` VARCHAR(255), `spesialisasi` VARCHAR(255)) RETURNS VARCHAR(255) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE result VARCHAR(255);
    SELECT nama INTO result
    FROM dokter
    WHERE nama = nama AND spesialisasi = spesialisasi
    LIMIT 1;
    RETURN result;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `JumlahPasien` () RETURNS INT(11)  BEGIN
    DECLARE jumlah INT;
    SELECT COUNT(*) INTO jumlah FROM Pasien;
    RETURN jumlah;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `dokter`
--

CREATE TABLE `dokter` (
  `id_dokter` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `spesialisasi` varchar(100) DEFAULT NULL,
  `jenis_kelamin` enum('P','L') DEFAULT NULL,
  `telepon` varchar(15) DEFAULT NULL,
  `alamat` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dokter`
--

INSERT INTO `dokter` (`id_dokter`, `nama`, `spesialisasi`, `jenis_kelamin`, `telepon`, `alamat`) VALUES
(1, 'Dr. Raffi', 'Umum', 'L', '08123456784', 'Jl. Setia Budi No. 1'),
(2, 'Dr. Rifa', 'Anak', 'P', '08123456785', 'Jl. Thamrin No. 2'),
(3, 'Dr. Lefi', 'Gigi', 'P', '08123456786', 'Jl. Sudirman No. 3'),
(4, 'Dr. Angga', 'Bedah', 'L', '08123456787', 'Jl. Diponegoro No. 4'),
(5, 'Dr. Ayu', 'Kulit', 'P', '08123456788', 'Jl. Sisingamangaraja No. 5');

-- --------------------------------------------------------

--
-- Table structure for table `obat`
--

CREATE TABLE `obat` (
  `id_obat` int(11) NOT NULL,
  `nama_obat` varchar(100) DEFAULT NULL,
  `jenis_obat` varchar(50) DEFAULT NULL,
  `harga` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `obat`
--

INSERT INTO `obat` (`id_obat`, `nama_obat`, `jenis_obat`, `harga`) VALUES
(1, 'Paracetamol', 'Tablet', 5000.00),
(2, 'Amoxicillin', 'Kapsul', 10000.00),
(3, 'Ibuprofen', 'Sirup', 15000.00),
(4, 'Cough Syrup', 'Sirup', 20000.00),
(5, 'Vitamin C', 'Tablet', 25000.00);

-- --------------------------------------------------------

--
-- Table structure for table `pasien`
--

CREATE TABLE `pasien` (
  `id_pasien` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `jenis_kelamin` enum('P','L') DEFAULT NULL,
  `telepon` varchar(15) DEFAULT NULL,
  `alamat` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pasien`
--

INSERT INTO `pasien` (`id_pasien`, `nama`, `tanggal_lahir`, `jenis_kelamin`, `telepon`, `alamat`) VALUES
(1, 'Ahmad', '1985-04-12', 'L', '081234567890', 'Jl. Merdeka No. 123, Jakarta'),
(2, 'Budi', '1978-09-30', 'L', '081456789012', 'Jl. Gatot Subroto No. 67, Surabaya'),
(3, 'Chandra', '1982-12-05', 'P', '081567890123', 'Jl. Diponegoro No. 89, Yogyakarta'),
(4, 'Dewi', '1993-12-03', 'L', '082456789012', 'Jl. HOS Cokroaminoto No. 45, Padang'),
(5, 'Eka', '1979-07-20', 'L', '082678901234', 'Jl. Adi Sucipto No. 89, Balikpapan');

--
-- Triggers `pasien`
--
DELIMITER $$
CREATE TRIGGER `before_insert_pasien` BEFORE INSERT ON `pasien` FOR EACH ROW BEGIN
    INSERT INTO LogPasien (id_pasien, nama, tanggal_lahir, jenis_kelamin, telepon, alamat, aksi)
    VALUES (NEW.id_pasien, NEW.nama, NEW.tanggal_lahir, NEW.jenis_kelamin, NEW.telepon, NEW.alamat, 'INSERT');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_pasien` BEFORE UPDATE ON `pasien` FOR EACH ROW BEGIN
    INSERT INTO LogPasien (id_pasien, nama, tanggal_lahir, jenis_kelamin, telepon, alamat, aksi)
    VALUES (OLD.id_pasien, OLD.nama, OLD.tanggal_lahir, OLD.jenis_kelamin, OLD.telepon, OLD.alamat, 'UPDATE');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `perawatan`
--

CREATE TABLE `perawatan` (
  `id_perawatan` int(11) NOT NULL,
  `id_pasien` int(11) DEFAULT NULL,
  `id_dokter` int(11) DEFAULT NULL,
  `tanggal_perawatan` date DEFAULT NULL,
  `deskripsi` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `perawatan`
--

INSERT INTO `perawatan` (`id_perawatan`, `id_pasien`, `id_dokter`, `tanggal_perawatan`, `deskripsi`) VALUES
(1, 1, 1, '2024-07-01', 'Check-up rutin'),
(2, 2, 2, '2024-07-02', 'Pemeriksaan demam'),
(3, 3, 3, '2024-07-03', 'Perawatan gigi'),
(4, 4, 4, '2024-07-04', 'Operasi kecil'),
(5, 5, 5, '2024-07-05', 'Pemeriksaan kulit');

-- --------------------------------------------------------

--
-- Table structure for table `perawatan_obat`
--

CREATE TABLE `perawatan_obat` (
  `id_perawatan` int(11) NOT NULL,
  `id_obat` int(11) NOT NULL,
  `jumlah` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `perawatan_obat`
--

INSERT INTO `perawatan_obat` (`id_perawatan`, `id_obat`, `jumlah`) VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 2);

-- --------------------------------------------------------

--
-- Table structure for table `rekammedis`
--

CREATE TABLE `rekammedis` (
  `id_rekam_medis` int(11) NOT NULL,
  `id_pasien` int(11) DEFAULT NULL,
  `riwayat_penyakit` text DEFAULT NULL,
  `alergi_obat` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rekammedis`
--

INSERT INTO `rekammedis` (`id_rekam_medis`, `id_pasien`, `riwayat_penyakit`, `alergi_obat`) VALUES
(1, 1, 'Hipertensi', 'Tidak ada'),
(2, 2, 'Diabetes', 'Sulfa'),
(3, 3, 'Gigi sensitif', 'Tidak ada'),
(4, 4, 'Asma', 'Aspirin'),
(5, 5, 'Eksim', 'Penisilin');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `dokter`
--
ALTER TABLE `dokter`
  ADD PRIMARY KEY (`id_dokter`);

--
-- Indexes for table `obat`
--
ALTER TABLE `obat`
  ADD PRIMARY KEY (`id_obat`);

--
-- Indexes for table `pasien`
--
ALTER TABLE `pasien`
  ADD PRIMARY KEY (`id_pasien`);

--
-- Indexes for table `perawatan`
--
ALTER TABLE `perawatan`
  ADD PRIMARY KEY (`id_perawatan`),
  ADD KEY `id_pasien` (`id_pasien`),
  ADD KEY `id_dokter` (`id_dokter`);

--
-- Indexes for table `perawatan_obat`
--
ALTER TABLE `perawatan_obat`
  ADD PRIMARY KEY (`id_perawatan`,`id_obat`),
  ADD KEY `id_obat` (`id_obat`);

--
-- Indexes for table `rekammedis`
--
ALTER TABLE `rekammedis`
  ADD PRIMARY KEY (`id_rekam_medis`),
  ADD UNIQUE KEY `id_pasien` (`id_pasien`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `dokter`
--
ALTER TABLE `dokter`
  MODIFY `id_dokter` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `obat`
--
ALTER TABLE `obat`
  MODIFY `id_obat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pasien`
--
ALTER TABLE `pasien`
  MODIFY `id_pasien` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `perawatan`
--
ALTER TABLE `perawatan`
  MODIFY `id_perawatan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `rekammedis`
--
ALTER TABLE `rekammedis`
  MODIFY `id_rekam_medis` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `perawatan`
--
ALTER TABLE `perawatan`
  ADD CONSTRAINT `perawatan_ibfk_1` FOREIGN KEY (`id_pasien`) REFERENCES `pasien` (`id_pasien`),
  ADD CONSTRAINT `perawatan_ibfk_2` FOREIGN KEY (`id_dokter`) REFERENCES `dokter` (`id_dokter`);

--
-- Constraints for table `perawatan_obat`
--
ALTER TABLE `perawatan_obat`
  ADD CONSTRAINT `perawatan_obat_ibfk_1` FOREIGN KEY (`id_perawatan`) REFERENCES `perawatan` (`id_perawatan`),
  ADD CONSTRAINT `perawatan_obat_ibfk_2` FOREIGN KEY (`id_obat`) REFERENCES `obat` (`id_obat`);

--
-- Constraints for table `rekammedis`
--
ALTER TABLE `rekammedis`
  ADD CONSTRAINT `rekammedis_ibfk_1` FOREIGN KEY (`id_pasien`) REFERENCES `pasien` (`id_pasien`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
