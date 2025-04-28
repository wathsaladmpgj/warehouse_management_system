-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 28, 2025 at 10:58 AM
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

-- --------------------------------------------------------

--
-- Table structure for table `warehouse_postal_codes`
--

CREATE TABLE `warehouse_postal_codes` (
  `id` int(11) NOT NULL,
  `location` varchar(255) NOT NULL,
  `postal_code` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `distance_pricing`
--
ALTER TABLE `distance_pricing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `location_tracking`
--
ALTER TABLE `location_tracking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `outlet_details`
--
ALTER TABLE `outlet_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_details`
--
ALTER TABLE `product_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_pricing`
--
ALTER TABLE `product_pricing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `staff_management`
--
ALTER TABLE `staff_management`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `warehouse_postal_codes`
--
ALTER TABLE `warehouse_postal_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `weight_pricing`
--
ALTER TABLE `weight_pricing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
