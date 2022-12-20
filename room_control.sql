CREATE DATABASE IF NOT EXISTS `room_control`;
USE `room_control`;

CREATE TABLE IF NOT EXISTS `readings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `humidity` float DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;