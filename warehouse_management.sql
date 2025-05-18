-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 17, 2025 at 01:02 PM
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
-- Database: `warehouse_management`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_register`
--

CREATE TABLE `admin_register` (
  `id` int(11) NOT NULL,
  `admin_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `outlet_location` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_register`
--

INSERT INTO `admin_register` (`id`, `admin_name`, `email`, `password`, `outlet_location`) VALUES
(22, 'Homagama1', 'adminHomagama@gmail.com', 'Homagama1', 'Homagama'),
(23, 'Kandy1', 'kandy1@gmail.com', 'Kandy1', 'Kandy'),
(25, 'Headoffice', 'headoffice@gmail.com', 'Headoffice', 'HO'),
(26, 'Jaffna1', 'jaffna1@gmail.com', 'Jaffna1', 'Jaffna'),
(27, 'Matara1', 'matara1@gmail.com', 'Matara1', 'Matara'),
(28, 'Anuradhapura1', 'anuradhapura1@gamil.com', 'Anuradhapura1', 'Anuradhapura'),
(29, 'NuwaraEliya1', 'nuwaraeliya1@gmail.com', 'NuwaraEliya1', 'Nuwara Eliya'),
(30, 'Colombo1', 'colombo1@gmail.com', 'Colombo1', 'Colombo');

-- --------------------------------------------------------

--
-- Table structure for table `distance_pricing`
--

CREATE TABLE `distance_pricing` (
  `id` int(11) NOT NULL,
  `from_location` varchar(255) NOT NULL,
  `to_location` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `distance_pricing`
--

INSERT INTO `distance_pricing` (`id`, `from_location`, `to_location`, `price`) VALUES
(17, 'Homagama', 'Kandy', 100.00),
(18, 'Homagama', 'Jaffna', 420.00),
(19, 'Homagama', 'Matara', 90.00),
(20, 'Homagama', 'Anuradhapura', 300.00),
(21, 'Homagama', 'Nuwara Eliya', 220.00),
(22, 'Homagama', 'Hambanthota', 280.00),
(23, 'Homagama', 'Colombo', 30.00),
(24, 'Kandy', 'Jaffna', 350.00),
(25, 'Kandy', 'Matara', 180.00),
(26, 'Kandy', 'Anuradhapura', 130.00),
(27, 'Kandy', 'Nuwara Eliya', 80.00),
(28, 'Kandy', 'Hambanthota', 250.00),
(29, 'Kandy', 'Colombo', 110.00),
(30, 'Jaffna', 'Matara', 550.00),
(31, 'Jaffna', 'Anuradhapura', 170.00),
(32, 'Jaffna', 'Nuwara Eliya', 370.00),
(33, 'Jaffna', 'Hambanthota', 760.00),
(34, 'Jaffna', 'Colombo', 400.00),
(35, 'Matara', 'Anuradhapura', 330.00),
(36, 'Matara', 'Nuwara Eliya', 190.00),
(37, 'Matara', 'Hambanthota', 110.00),
(38, 'Matara', 'Colombo', 100.00),
(39, 'Anuradhapura', 'Nuwara Eliya', 160.00),
(40, 'Anuradhapura', 'Hambanthota', 290.00),
(41, 'Anuradhapura', 'Colombo', 200.00),
(42, 'Nuwara Eliya', 'Hambanthota', 210.00),
(43, 'Nuwara Eliya', 'Colombo', 180.00),
(44, 'Hambanthota', 'Colombo', 260.00);

-- --------------------------------------------------------

--
-- Table structure for table `location_tracking`
--

CREATE TABLE `location_tracking` (
  `id` int(11) NOT NULL,
  `product_key` varchar(100) NOT NULL,
  `from_location` varchar(255) NOT NULL,
  `to_location` varchar(255) NOT NULL,
  `tracking_date` date NOT NULL,
  `tracking_update` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `location_tracking`
--

INSERT INTO `location_tracking` (`id`, `product_key`, `from_location`, `to_location`, `tracking_date`, `tracking_update`) VALUES
(60, 'aa0bb3798e02', 'Homagama', 'Kandy', '2024-02-17', 'Success'),
(61, '34add265f7ef', 'Homagama', 'Colombo', '2024-03-19', 'ship'),
(62, '210514c06dc5', 'Homagama', 'Colombo', '2024-03-22', 'ship'),
(64, 'caeffdce1066', 'Homagama', 'Jaffna', '2024-06-27', 'Homagama'),
(65, '66a4e82ff32c', 'Homagama', 'Anuradhapura', '2024-07-30', 'Homagama'),
(66, 'f94ad5194e49', 'Homagama', 'Nuwara Eliya', '2024-08-13', 'Homagama'),
(67, '439f6a2d3fcf', 'Homagama', 'Hambanthota', '2025-09-30', 'Homagama'),
(68, '817fb096ac45', 'Jaffna', 'Hambanthota', '2025-05-17', 'Jaffna'),
(69, 'acc1d6fb8a74', 'Jaffna', 'Hambanthota', '2025-04-10', 'Jaffna'),
(70, '62a3669f6424', 'Jaffna', 'Hambanthota', '2025-04-10', 'Jaffna'),
(71, '5a181c9c3c07', 'Jaffna', 'Matara', '2025-03-26', 'Jaffna'),
(72, '7451bfa37e9a', 'Jaffna', 'Anuradhapura', '2025-02-18', 'Jaffna'),
(73, '7e5023998959', 'Nuwara Eliya', 'Matara', '2025-01-06', 'Nuwara Eliya'),
(74, 'c86fc6c3f54d', 'Nuwara Eliya', 'Matara', '2025-01-06', 'Nuwara Eliya'),
(78, '588f0dd2a3f8', 'Homagama', 'Matara', '2025-01-06', 'Homagama'),
(79, '5901f834d92d', 'Homagama', 'Matara', '2025-01-23', 'ship'),
(80, '662b37cdcc81', 'Homagama', 'Matara', '2025-01-23', 'ship'),
(81, '1a6f6b927ab0', 'Homagama', 'Matara', '2024-12-19', 'Homagama'),
(82, '416a60f8dcd2', 'Homagama', 'Matara', '2025-03-14', 'Homagama'),
(83, '27c2b8ba2097', 'Homagama', 'Matara', '2025-02-19', 'Homagama'),
(84, 'fed420d741cf', 'Homagama', 'Matara', '2025-04-21', 'Homagama'),
(85, 'ee7288af4838', 'Homagama', 'Nuwara Eliya', '2025-04-21', 'Homagama'),
(86, 'fd5b6c635942', 'Homagama', 'Hambanthota', '2025-05-17', 'Homagama'),
(87, 'e62f9ac7c782', 'Homagama', 'Jaffna', '2025-02-17', 'Homagama');

-- --------------------------------------------------------

--
-- Table structure for table `outlet_details`
--

CREATE TABLE `outlet_details` (
  `id` int(11) NOT NULL,
  `outlet_name` varchar(255) NOT NULL,
  `total_registered_items` int(11) DEFAULT 0,
  `total_returned_items` int(11) DEFAULT 0,
  `remaining_returned_items` int(11) DEFAULT 0,
  `available_new_items` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `outlet_details`
--

INSERT INTO `outlet_details` (`id`, `outlet_name`, `total_registered_items`, `total_returned_items`, `remaining_returned_items`, `available_new_items`) VALUES
(22, 'Homagama', 17, 0, 0, 12),
(23, 'Kandy', 0, 0, 0, 0),
(24, 'Jaffna', 5, 0, 0, 5),
(25, 'Matara', 0, 0, 0, 0),
(26, 'Anuradhapura', 0, 0, 0, 0),
(27, 'Nuwara Eliya', 2, 0, 0, 2),
(28, 'Hambantota', 0, 0, 0, 0),
(29, 'Colombo', 0, 0, 0, 0),
(30, 'HO', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_details`
--

CREATE TABLE `product_details` (
  `id` int(11) NOT NULL,
  `sender_name` varchar(255) NOT NULL,
  `receiver_name` varchar(255) NOT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `receiver_location` varchar(255) NOT NULL,
  `product_key` varchar(100) NOT NULL,
  `product_weight` decimal(10,2) NOT NULL,
  `from_location` varchar(255) NOT NULL,
  `to_location` varchar(255) NOT NULL,
  `added_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_details`
--

INSERT INTO `product_details` (`id`, `sender_name`, `receiver_name`, `postal_code`, `receiver_location`, `product_key`, `product_weight`, `from_location`, `to_location`, `added_date`) VALUES
(64, 'saduni', 'Kavindu', '20000', '1/A,Yatinuwara', 'aa0bb3798e02', 1.00, 'Homagama', 'Kandy', '2024-02-17'),
(65, 'Pasindu ', 'Sakuni', '00100', '26/Thunmulla', '34add265f7ef', 0.40, 'Homagama', 'Colombo', '2024-03-19'),
(66, 'Pasindu ', 'Sakuni', '00100', '26/Thunmulla', '210514c06dc5', 0.40, 'Homagama', 'Colombo', '2024-03-22'),
(68, 'Kasun', 'Wathsala', '80000', '26/yalpanam', 'caeffdce1066', 0.50, 'Homagama', 'Jaffna', '2024-06-27'),
(69, 'Santha', 'Wathsala', '50000', '89', '66a4e82ff32c', 0.50, 'Homagama', 'Anuradhapura', '2024-07-30'),
(70, 'soratha', 'Wathsala', '22300', '89', 'f94ad5194e49', 0.90, 'Homagama', 'Nuwara Eliya', '2024-08-13'),
(71, 'Banda', 'Senda', '82100', '1/A,', '439f6a2d3fcf', 2.00, 'Homagama', 'Hambanthota', '2024-09-30'),
(72, 'Banda', 'Senda', '82100', '1/A,', '817fb096ac45', 1.00, 'Jaffna', 'Hambanthota', '2025-05-17'),
(73, 'Janith', 'Gihan', '82100', '1/A,', 'acc1d6fb8a74', 1.00, 'Jaffna', 'Hambanthota', '2025-04-10'),
(74, 'Janith', 'Gihan', '82100', '1/A,', '62a3669f6424', 1.00, 'Jaffna', 'Hambanthota', '2025-04-10'),
(75, 'Kasun', 'Sakuni', '81050', '1/A,', '5a181c9c3c07', 1.00, 'Jaffna', 'Matara', '2025-03-26'),
(76, 'Kasun', 'Sakuni', '50050', '1/A,', '7451bfa37e9a', 1.00, 'Jaffna', 'Anuradhapura', '2025-02-18'),
(77, 'Janith', 'Sakuni', '81100', '1/A,', '7e5023998959', 0.78, 'Nuwara Eliya', 'Matara', '2025-01-06'),
(78, 'Janith', 'Senura', '81100', '1/A,', 'c86fc6c3f54d', 0.20, 'Nuwara Eliya', 'Matara', '2025-01-06'),
(82, 'Janith', 'Senura', '81100', '1/A,', '588f0dd2a3f8', 0.20, 'Homagama', 'Matara', '2025-01-06'),
(83, 'Janith', 'Senura', '81100', '1/A,', '5901f834d92d', 0.20, 'Homagama', 'Matara', '2025-01-23'),
(84, 'saduni', 'Senura', '81100', '1/A,', '662b37cdcc81', 3.00, 'Homagama', 'Matara', '2025-01-23'),
(85, 'saduni', 'Senura', '81100', '1/A,', '1a6f6b927ab0', 3.00, 'Homagama', 'Matara', '2024-12-19'),
(86, 'saduni', 'Senura', '81100', '1/A,', '416a60f8dcd2', 3.00, 'Homagama', 'Matara', '2025-03-14'),
(87, 'saduni', 'Senura', '81100', '1/A,', '27c2b8ba2097', 3.00, 'Homagama', 'Matara', '2025-02-19'),
(88, 'Janith', 'Wathsala', '81100', '1/A,', 'fed420d741cf', 5.00, 'Homagama', 'Matara', '2025-04-21'),
(89, 'Janith', 'Wathsala', '22250', '1/A,', 'ee7288af4838', 5.00, 'Homagama', 'Nuwara Eliya', '2025-04-21'),
(90, 'Janith', 'Wathsala', '82050', '1/A,', 'fd5b6c635942', 2.00, 'Homagama', 'Hambanthota', '2025-05-17'),
(91, 'Janith', 'Wathsala', '80000', '1/A,', 'e62f9ac7c782', 2.00, 'Homagama', 'Jaffna', '2025-02-17');

-- --------------------------------------------------------

--
-- Table structure for table `product_pricing`
--

CREATE TABLE `product_pricing` (
  `id` int(11) NOT NULL,
  `product_key` varchar(100) NOT NULL,
  `item_price` decimal(10,2) NOT NULL,
  `price_date` date NOT NULL,
  `admin_location` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_pricing`
--

INSERT INTO `product_pricing` (`id`, `product_key`, `item_price`, `price_date`, `admin_location`) VALUES
(46, 'aa0bb3798e02', 115.00, '2024-02-17', 'Homagama'),
(47, '34add265f7ef', 45.00, '2024-03-19', 'Homagama'),
(48, '210514c06dc5', 45.00, '2024-03-22', 'Homagama'),
(49, 'caeffdce1066', 435.00, '2024-06-27', 'Homagama'),
(50, '66a4e82ff32c', 315.00, '2024-07-30', 'Homagama'),
(51, 'f94ad5194e49', 235.00, '2024-08-13', 'Homagama'),
(52, '439f6a2d3fcf', 295.00, '2024-09-30', 'Homagama'),
(53, '817fb096ac45', 775.00, '2025-05-17', 'Jaffna'),
(54, 'acc1d6fb8a74', 775.00, '2025-04-10', 'Jaffna'),
(55, '62a3669f6424', 775.00, '2025-04-10', 'Jaffna'),
(56, '5a181c9c3c07', 565.00, '2025-03-26', 'Jaffna'),
(57, '7451bfa37e9a', 185.00, '2025-02-18', 'Jaffna'),
(58, '7e5023998959', 205.00, '2025-01-06', 'Nuwara Eliya'),
(59, 'c86fc6c3f54d', 205.00, '2025-01-06', 'Nuwara Eliya'),
(60, '588f0dd2a3f8', 105.00, '2025-01-06', 'Homagama'),
(61, '5901f834d92d', 105.00, '2025-01-23', 'Homagama'),
(62, '662b37cdcc81', 105.00, '2025-01-23', 'Homagama'),
(63, '1a6f6b927ab0', 105.00, '2024-12-19', 'Homagama'),
(64, '416a60f8dcd2', 105.00, '2025-03-14', 'Homagama'),
(65, '27c2b8ba2097', 105.00, '2025-02-19', 'Homagama'),
(66, 'fed420d741cf', 105.00, '2025-04-21', 'Homagama'),
(67, 'ee7288af4838', 235.00, '2025-04-21', 'Homagama'),
(68, 'fd5b6c635942', 295.00, '2025-05-17', 'Homagama'),
(69, 'e62f9ac7c782', 435.00, '2025-02-17', 'Homagama');

-- --------------------------------------------------------

--
-- Table structure for table `staff_management`
--

CREATE TABLE `staff_management` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `role` varchar(100) NOT NULL,
  `location` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff_management`
--

INSERT INTO `staff_management` (`id`, `name`, `role`, `location`) VALUES
(17, 'Janith Wathsala', 'Manager', 'Homagama'),
(18, 'Achintha', 'Driver', 'Homagama'),
(19, 'Pasindu', 'Security', 'Homagama'),
(20, 'Santha', 'Driver', 'Kandy'),
(21, 'Janith ', 'Security', 'Kandy'),
(22, 'Achintha', 'Manager', 'Kandy');

-- --------------------------------------------------------

--
-- Table structure for table `warehouse_postal_codes`
--

CREATE TABLE `warehouse_postal_codes` (
  `id` int(11) NOT NULL,
  `location` varchar(255) NOT NULL,
  `postal_code` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `warehouse_postal_codes`
--

INSERT INTO `warehouse_postal_codes` (`id`, `location`, `postal_code`) VALUES
(26, 'Colombo', '00100'),
(27, 'Colombo', '00110'),
(28, 'Colombo', '00120'),
(29, 'Kandy', '20000'),
(30, 'Kandy', '20050'),
(31, 'Kandy', '20100'),
(32, 'Jaffna', '80000'),
(33, 'Jaffna', '80050'),
(34, 'Jaffna', '80100'),
(35, 'Jaffna', '40000'),
(36, 'Jaffna', '40050'),
(37, 'Jaffna', '40100'),
(38, 'Matara', '81000'),
(39, 'Matara', '81050'),
(40, 'Matara', '81100'),
(41, 'Anuradhapura', '50000'),
(42, 'Anuradhapura', '50050'),
(43, 'Anuradhapura', '50100'),
(44, 'Nuwara Eliya', '22200'),
(45, 'Nuwara Eliya', '22250'),
(46, 'Nuwara Eliya', '22300'),
(47, 'Hambanthota', '82000'),
(48, 'Hambanthota', '82050'),
(49, 'Hambanthota', '82100');

-- --------------------------------------------------------

--
-- Table structure for table `weight_pricing`
--

CREATE TABLE `weight_pricing` (
  `id` int(11) NOT NULL,
  `weight_range` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `weight_pricing`
--

INSERT INTO `weight_pricing` (`id`, `weight_range`, `price`) VALUES
(7, '0g - 200g', 15.00),
(8, '201g - 500g', 18.00),
(9, '501g - 1000g', 22.00),
(10, '1001g - 1500g', 25.00),
(11, '1501g - 2000g', 28.00),
(12, '2001g - 3000g', 32.00),
(13, '3001g - 4000g', 35.00),
(14, '4001g - 5000g', 40.00),
(15, '5001g - 6000g', 45.00),
(16, '6001g - 7000g', 50.00);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_register`
--
ALTER TABLE `admin_register`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `outlet_location` (`outlet_location`);

--
-- Indexes for table `distance_pricing`
--
ALTER TABLE `distance_pricing`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `location_tracking`
--
ALTER TABLE `location_tracking`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_key` (`product_key`);

--
-- Indexes for table `outlet_details`
--
ALTER TABLE `outlet_details`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `outlet_name` (`outlet_name`);

--
-- Indexes for table `product_details`
--
ALTER TABLE `product_details`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_key` (`product_key`),
  ADD KEY `postal_code` (`postal_code`);

--
-- Indexes for table `product_pricing`
--
ALTER TABLE `product_pricing`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_key` (`product_key`),
  ADD KEY `admin_location` (`admin_location`);

--
-- Indexes for table `staff_management`
--
ALTER TABLE `staff_management`
  ADD PRIMARY KEY (`id`),
  ADD KEY `location` (`location`);

--
-- Indexes for table `warehouse_postal_codes`
--
ALTER TABLE `warehouse_postal_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `postal_code` (`postal_code`);

--
-- Indexes for table `weight_pricing`
--
ALTER TABLE `weight_pricing`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_register`
--
ALTER TABLE `admin_register`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `distance_pricing`
--
ALTER TABLE `distance_pricing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `location_tracking`
--
ALTER TABLE `location_tracking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `outlet_details`
--
ALTER TABLE `outlet_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `product_details`
--
ALTER TABLE `product_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT for table `product_pricing`
--
ALTER TABLE `product_pricing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT for table `staff_management`
--
ALTER TABLE `staff_management`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `warehouse_postal_codes`
--
ALTER TABLE `warehouse_postal_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `weight_pricing`
--
ALTER TABLE `weight_pricing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_register`
--
ALTER TABLE `admin_register`
  ADD CONSTRAINT `admin_register_ibfk_1` FOREIGN KEY (`outlet_location`) REFERENCES `outlet_details` (`outlet_name`);

--
-- Constraints for table `location_tracking`
--
ALTER TABLE `location_tracking`
  ADD CONSTRAINT `location_tracking_ibfk_1` FOREIGN KEY (`product_key`) REFERENCES `product_details` (`product_key`);

--
-- Constraints for table `product_details`
--
ALTER TABLE `product_details`
  ADD CONSTRAINT `product_details_ibfk_1` FOREIGN KEY (`postal_code`) REFERENCES `warehouse_postal_codes` (`postal_code`);

--
-- Constraints for table `product_pricing`
--
ALTER TABLE `product_pricing`
  ADD CONSTRAINT `product_pricing_ibfk_1` FOREIGN KEY (`product_key`) REFERENCES `product_details` (`product_key`),
  ADD CONSTRAINT `product_pricing_ibfk_2` FOREIGN KEY (`admin_location`) REFERENCES `outlet_details` (`outlet_name`);

--
-- Constraints for table `staff_management`
--
ALTER TABLE `staff_management`
  ADD CONSTRAINT `staff_management_ibfk_1` FOREIGN KEY (`location`) REFERENCES `outlet_details` (`outlet_name`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
