-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: shelfbound
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'Raji','$2a$12$M6tILXf19qK3OBOCNmDCfesEWTyoJ0RlJL2zwBENOF.HU2FXeKNUS');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `book_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `stock_quantity` int NOT NULL DEFAULT '0',
  `image_url` varchar(500) DEFAULT NULL,
  `rating` decimal(2,1) DEFAULT '0.0',
  `category_id` int DEFAULT NULL,
  `is_new_arrival` tinyint(1) DEFAULT '0',
  `is_popular` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`book_id`),
  KEY `fk_books_category` (`category_id`),
  CONSTRAINT `fk_books_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'Harry Potter and the Sorcerer\'s Stone','J.K. Rowling','Fantasy fiction novel',499.00,38,'images/books/harry-potter.jpg',4.8,1,0,1,'2026-05-27 03:50:07'),(3,'The Midnight Library','Matt Haig','Fantasy and emotional fiction',599.00,23,'images/books/midnight-library.jpg',4.5,1,0,0,'2026-05-27 03:50:07'),(4,'Atomic Habits','James Clear','Self-improvement and habit building',699.00,60,'images/books/atomic-habits.jpg',4.9,2,0,1,'2026-05-27 03:50:31'),(6,'The Psychology of Money','Morgan Housel','Financial mindset and investing',550.00,35,'images/books/psychology-money.jpg',4.7,2,0,0,'2026-05-27 03:50:31'),(7,'Diary of a Wimpy Kid','Jeff Kinney','Funny kids story book',350.00,40,'images/books/wimpy-kid.jpg',4.6,3,0,0,'2026-05-27 03:50:51'),(8,'Charlie and the Chocolate Factory','Roald Dahl','Classic children adventure',299.00,30,'images/books/chocolate-factory.jpg',4.7,3,0,0,'2026-05-27 03:50:51'),(9,'Peppa Pig Story Collection','Peppa Pig','Kids picture stories',250.00,20,'images/books/peppa-pig.jpg',4.3,3,0,0,'2026-05-27 03:50:51'),(10,'UPSC Civil Services Guide','Pearson','UPSC preparation book',899.00,25,'images/books/upsc-guide.jpg',4.4,4,0,0,'2026-05-27 03:51:08'),(11,'JEE Physics','H.C. Verma','Physics for JEE aspirants',799.00,30,'images/books/hc-verma.jpg',4.8,4,0,0,'2026-05-27 03:51:08'),(12,'NEET Biology Master','Trueman','Biology preparation for NEET',699.00,35,'images/books/neet-biology.jpg',4.5,4,0,0,'2026-05-27 03:51:08'),(13,'Onyx Storm','Rebecca Yarros','Trending fantasy bestseller',899.00,20,'images/books/onyx-storm.jpg',4.6,5,0,1,'2026-05-27 03:51:25'),(14,'The Housemaid','Freida McFadden','Popular psychological thriller',650.00,25,'images/books/the-housemaid.jpg',4.7,5,0,1,'2026-05-27 03:51:25'),(15,'Fourth Wing','Rebecca Yarros','Fantasy dragon fiction',999.00,15,'images/books/fourth-wing.jpg',4.8,5,0,1,'2026-05-27 03:51:25'),(16,'Great Big Beautiful Life','Emily Henry','Romantic contemporary fiction',799.00,18,'images/books/great-big-life.jpg',4.5,6,1,0,'2026-05-27 03:51:44'),(17,'The Impossible Fortune','Richard Osman','Mystery thriller novel',899.00,12,'images/books/impossible-fortune.jpg',4.6,6,1,0,'2026-05-27 03:51:44'),(18,'Alchemised','SenLinYu','Fantasy romance bestseller',999.00,10,'images/books/alchemised.jpg',4.7,6,1,0,'2026-05-27 03:51:44'),(19,'Deep Work','Cal Newport','Productivity and focus mastery',699.00,30,'images/books/deep-work.jpg',4.7,7,0,0,'2026-05-27 03:52:00'),(20,'Think and Grow Rich','Napoleon Hill','Success and mindset principles',499.00,35,'images/books/think-grow-rich.jpg',4.6,7,0,0,'2026-05-27 03:52:00'),(21,'Ikigai','Hector Garcia','Japanese philosophy for meaningful life',550.00,40,'images/books/ikigai.jpg',4.8,7,0,0,'2026-05-27 03:52:00'),(22,'The Great Gatsby','F. Scott Fitzgerald','Classic American tragedy of wealth and ambition',349.00,30,'images/books/great-gatsby.jpg',4.6,1,0,1,'2026-05-31 08:37:07'),(23,'To Kill a Mockingbird','Harper Lee','Timeless story of racial injustice and childhood innocence',399.00,45,'images/books/to-kill-mockingbird.jpg',4.9,1,0,1,'2026-05-31 08:37:07'),(24,'The Hobbit','J.R.R. Tolkien','Epic fantasy adventure of Bilbo Baggins',599.00,35,'images/books/the-hobbit.jpg',4.8,1,0,0,'2026-05-31 08:37:07'),(25,'The 7 Habits of Highly Effective People','Stephen Covey','Powerful lessons in personal change and effectiveness',599.00,50,'images/books/7-habits.jpg',4.8,2,0,1,'2026-05-31 08:37:43'),(26,'Sapiens','Yuval Noah Harari','Brief history of humankind and our evolution',799.00,40,'images/books/sapiens.jpg',4.7,2,0,1,'2026-05-31 08:37:43'),(27,'Educated','Tara Westover','Memoir of a girl who leaves her survivalist family',499.00,25,'images/books/educated.jpg',4.6,2,0,0,'2026-05-31 08:37:43'),(28,'The Very Hungry Caterpillar','Eric Carle','Classic picture book about transformation',199.00,60,'images/books/hungry-caterpillar.jpg',4.9,3,0,0,'2026-05-31 08:38:17'),(29,'Matilda','Roald Dahl','Magical story of a brilliant little girl',299.00,40,'images/books/matilda.jpg',4.8,3,0,0,'2026-05-31 08:38:17'),(30,'Where the Wild Things Are','Maurice Sendak','Imaginative adventure of a mischievous boy',250.00,35,'images/books/wild-things.jpg',4.7,3,0,0,'2026-05-31 08:38:17'),(31,'NCERT at Your Fingertips','MTG','Quick revision guide for NEET and JEE',450.00,55,'images/books/ncert-fingertips.jpg',4.6,4,0,0,'2026-05-31 08:38:53'),(32,'Indian Polity for UPSC','M. Laxmikanth','Comprehensive guide to Indian Constitution',750.00,40,'images/books/indian-polity.jpg',4.9,4,0,0,'2026-05-31 08:38:53'),(33,'JEE Advanced Mathematics','R.D. Sharma','Advanced problems for engineering aspirants',699.00,30,'images/books/jee-maths.jpg',4.7,4,0,0,'2026-05-31 08:38:53'),(34,'The Silent Patient','Alex Michaelides','Psychological thriller with a shocking twist',550.00,35,'images/books/silent-patient.jpg',4.7,5,0,1,'2026-05-31 08:39:19'),(35,'It Ends With Us','Colleen Hoover','Emotional romance about love and courage',499.00,50,'images/books/it-ends-with-us.jpg',4.8,5,0,1,'2026-05-31 08:39:19'),(36,'The Midnight Library','Matt Haig','Fantasy about infinite lives and second chances',599.00,20,'images/books/midnight-library-2.jpg',4.5,5,0,0,'2026-05-31 08:39:19'),(37,'The Women','Kristin Hannah','Historical fiction about Vietnam War nurses',899.00,15,'images/books/the-women.jpg',4.6,6,1,0,'2026-05-31 08:39:41'),(38,'The Wedding People','Alison Espach','Heartwarming story about unexpected connections',699.00,20,'images/books/wedding-people.jpg',4.5,6,1,0,'2026-05-31 08:39:41'),(39,'The God of the Woods','Liz Moore','Mystery thriller set in a summer camp',799.00,12,'images/books/god-of-woods.jpg',4.7,6,1,0,'2026-05-31 08:39:41'),(40,'The Power of Now','Eckhart Tolle','Spiritual guide to living in the present moment',499.00,45,'images/books/power-of-now.jpg',4.8,7,0,0,'2026-05-31 08:39:59'),(41,'Mindset','Carol Dweck','Psychology of success and growth mindset',450.00,40,'images/books/mindset.jpg',4.7,7,0,0,'2026-05-31 08:39:59'),(42,'The Art of War','Sun Tzu','Ancient military strategy for modern life',299.00,50,'images/books/art-of-war.jpg',4.6,7,0,0,'2026-05-31 08:39:59'),(47,'The Secret','Rhonda Byrne','Your thoughts, beliefs, and expectations can influence what you attract into your life.',300.00,40,'https://www.simonandschuster.com/books/The-Secret/Rhonda-Byrne/The-Secret-Library/9781582701707?utm_source=chatgpt.com',0.0,NULL,0,0,'2026-08-19 11:32:05');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `cart_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `book_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_id`),
  KEY `fk_cart_user` (`user_id`),
  KEY `fk_cart_book` (`book_id`),
  CONSTRAINT `fk_cart_book` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (7,7,4,1,'2026-05-31 14:52:01'),(8,7,3,1,'2026-05-31 14:52:47'),(32,7,1,1,'2026-09-09 10:20:46');
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (7,'Adult Learning'),(4,'Competitive Exams'),(1,'Fiction'),(3,'Kids'),(6,'New Arrivals'),(2,'Non-Fiction'),(5,'Popular Books');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_messages`
--

DROP TABLE IF EXISTS `contact_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_messages` (
  `message_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT 'Pending',
  `admin_reply` text,
  `replied_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`message_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_messages`
--

LOCK TABLES `contact_messages` WRITE;
/*!40000 ALTER TABLE `contact_messages` DISABLE KEYS */;
INSERT INTO `contact_messages` VALUES (2,'devasena','devaralarajyalakshmi265@gmail.com','hello i need more ui improvement','2026-05-29 18:53:16','Replied','ok','2026-05-30 11:26:13'),(4,'lasya','lasya@gmail.com','order delay','2026-05-31 14:24:09','Replied','we will process','2026-05-31 14:25:05'),(5,'lasya','lasya@gmail.com','good product','2026-05-31 14:44:08','Pending',NULL,NULL),(6,'lasya','lasya@gmail.com','good product','2026-05-31 14:53:26','Replied','thankyou','2026-05-31 14:55:21'),(11,'D.Rajyalakshmi','devaralarajyalakshmi265@gmail.com','i want 100 books.','2026-08-19 11:06:45','Replied','ok  we will arrange and contact you shortly thank you','2026-09-09 06:58:02');
/*!40000 ALTER TABLE `contact_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offers`
--

DROP TABLE IF EXISTS `offers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offers` (
  `offer_id` int NOT NULL AUTO_INCREMENT,
  `coupon_code` varchar(50) NOT NULL,
  `discount_percentage` double NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `min_order_amount` double DEFAULT '0',
  `status` varchar(20) DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`offer_id`),
  UNIQUE KEY `coupon_code` (`coupon_code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offers`
--

LOCK TABLES `offers` WRITE;
/*!40000 ALTER TABLE `offers` DISABLE KEYS */;
INSERT INTO `offers` VALUES (1,'WELCOME20',20,'Flat 20% OFF on all orders',0,'ACTIVE','2026-09-09 09:45:06'),(3,'LEARNNOW',25,'flat 25% off on min order of 599',599,'ACTIVE','2026-09-09 10:05:53');
/*!40000 ALTER TABLE `offers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `book_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `fk_orderitems_order` (`order_id`),
  KEY `fk_orderitems_book` (`book_id`),
  CONSTRAINT `fk_orderitems_book` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_orderitems_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,16,3,799.00),(2,2,16,2,799.00),(3,3,17,2,899.00),(7,7,17,3,899.00),(8,8,4,1,699.00),(9,9,1,1,499.00),(10,10,1,1,499.00),(11,11,1,1,499.00),(12,12,39,1,799.00),(13,13,37,2,899.00),(14,14,1,1,499.00),(15,14,37,2,899.00),(16,14,17,1,899.00),(17,14,14,1,650.00),(20,16,4,1,699.00),(21,17,1,3,499.00),(22,17,37,2,899.00),(23,17,17,1,899.00),(24,17,14,1,650.00),(25,17,6,2,550.00),(26,17,24,1,599.00),(27,17,3,1,599.00),(28,17,4,1,699.00),(29,18,37,2,899.00),(30,18,9,1,250.00),(31,19,9,1,250.00),(32,20,1,1,499.00),(33,20,37,2,899.00),(34,20,17,1,899.00),(35,20,14,1,650.00),(36,20,6,2,550.00),(37,20,24,1,599.00),(38,20,3,1,599.00),(39,20,4,1,699.00),(40,20,9,2,250.00),(41,21,1,1,499.00),(42,21,37,2,899.00),(43,21,17,1,899.00),(44,21,14,1,650.00),(45,21,6,2,550.00),(46,21,24,1,599.00),(47,21,3,1,599.00),(48,21,4,1,699.00),(49,21,9,2,250.00),(50,22,17,1,899.00),(51,23,3,1,599.00),(52,24,3,2,599.00),(53,25,1,1,499.00),(54,26,3,2,599.00),(55,27,3,1,599.00),(56,28,4,1,699.00),(57,29,24,2,599.00),(58,29,3,1,599.00),(59,30,9,2,250.00),(60,31,3,1,599.00),(61,32,4,1,699.00),(62,33,7,1,350.00),(63,34,3,1,599.00),(64,34,18,1,999.00);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `order_status` varchar(50) DEFAULT 'Pending',
  `payment_method` varchar(50) DEFAULT NULL,
  `shipping_address` text NOT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `discount_amount` decimal(10,2) DEFAULT '0.00',
  `delivery_date` datetime DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `fk_orders_user` (`user_id`),
  CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,2397.00,'Pending',NULL,'Default Address','2026-05-28 10:02:16',0.00,NULL),(2,1,1598.00,'Pending',NULL,'Default Address','2026-05-28 10:14:05',0.00,NULL),(3,1,1798.00,'Pending','COD',',  - ','2026-05-28 10:58:20',0.00,NULL),(4,1,399.00,'Pending','COD',',  - ','2026-05-28 10:59:38',0.00,NULL),(5,1,399.00,'Pending','COD',',  - ','2026-05-28 11:16:48',0.00,NULL),(6,1,399.00,'Pending','COD',',  - ','2026-05-28 12:00:31',0.00,NULL),(7,1,2697.00,'Delivered','COD',',  - ','2026-05-28 13:41:44',0.00,NULL),(8,1,699.00,'Pending','COD','buddhivari street, golla palem, kovur mandal, nellore district, Nellore - 524137','2026-05-28 17:31:36',0.00,NULL),(9,1,499.00,'Delivered','COD','buddhivari street, golla palem, kovur mandal, nellore district, Nellore - 524137','2026-05-29 11:37:19',0.00,NULL),(10,1,499.00,'Pending','COD','sarojininagar, hyd - 536758','2026-05-30 13:55:08',0.00,NULL),(11,1,499.00,'Pending','COD','sarojininagar, hyd - 536758','2026-05-31 06:56:15',0.00,NULL),(12,1,799.00,'Cancelled','UPI','Rajyalakshmi, guntur - 567483','2026-05-31 08:59:28',0.00,NULL),(13,1,1798.00,'Shipped','UPI','sri, guntur - 567854','2026-05-31 11:13:18',0.00,NULL),(14,1,3846.00,'Delivered','UPI','btm, nellore - 524321','2026-05-31 14:22:08',0.00,NULL),(16,7,699.00,'Delivered','UPI','BTM, Bengaluru - 12345','2026-05-31 14:52:15',0.00,NULL),(17,1,7841.00,'Shipped','COD','Raji\n8328175792\nDagadarthi, Nellore\nNellore, Andhra  - 524137\nIndia','2026-07-11 11:56:36',0.00,NULL),(18,1,2048.00,'Pending','COD','Raji\n8328175792\nDagadarthi, Nellore\nNellore, Andhra  - 524137\nIndia','2026-07-11 15:31:15',0.00,NULL),(19,1,250.00,'Pending','COD','Raji\n8328175792\nDagadarthi, Nellore\nNellore, Andhra  - 524137\nIndia','2026-07-11 15:31:51',0.00,NULL),(20,1,7343.00,'Pending','COD','Raji\n8328175792\nDagadarthi, Nellore\nNellore, Andhra  - 524137\nIndia','2026-07-11 15:36:16',0.00,NULL),(21,1,7343.00,'Pending','COD','Raji\n8328175792\nDagadarthi, Nellore\nNellore, Andhra  - 524137\nIndia','2026-07-11 15:46:32',0.00,NULL),(22,1,899.00,'Returned','COD','Raji\n8328175792\nDagadarthi, Nellore\nNellore, Andhra  - 524137\nIndia','2026-07-11 15:47:35',0.00,'2026-07-11 22:09:49'),(23,1,479.20,'Pending','COD','Raji\n8328175792\nDagadarthi, Nellore\nNellore, Andhra  - 524137\nIndia','2026-07-11 18:03:07',119.80,NULL),(24,1,958.40,'Pending','COD','Raji\n08328175792\nmain road 00\nkavali, Andhra  - 578989\nIndia','2026-07-11 18:14:18',239.60,NULL),(25,1,499.00,'Pending','COD','Raji\n08328175792\nmain road 00\nkavali, Andhra  - 578989\nIndia','2026-07-11 18:20:47',0.00,NULL),(26,1,1198.00,'Pending','UPI','Raji\n3247985019\nmain road 00\nSrinagar, Andhra  - 578989\nIndia','2026-07-13 14:31:57',0.00,NULL),(27,1,479.20,'Pending','CARD','Raji\n3247985019\nmain road 00\nSrinagar, Andhra  - 578989\nIndia','2026-07-14 10:48:08',119.80,NULL),(28,1,699.00,'Pending','COD','Raji\n3247985019\nmain road 00\nSrinagar, Andhra  - 578989\nIndia','2026-07-19 07:12:51',0.00,NULL),(29,1,1437.60,'Pending','UPI','Raji\n3247985019\nmain road 00\nSrinagar, Andhra  - 578989\nIndia','2026-07-22 11:40:07',359.40,NULL),(30,1,400.00,'Delivered','UPI','Raji\n3247985019\nmain road 00, mandal\nSrinagar, Andhra  - 578989\nIndia','2026-07-22 12:43:19',100.00,'2026-08-19 17:03:23'),(31,1,479.20,'Pending','COD','Raji\n3247985019\nmain road 00, mandal\nSrinagar, Andhra  - 578989\nIndia','2026-07-22 12:51:05',119.80,NULL),(32,1,559.20,'Returned','COD','Raji\n3247985019\nmain road 00, mandal\nSrinagar, Andhra - 578989\nIndia','2026-07-22 13:06:06',139.80,'2026-07-22 18:40:16'),(33,1,280.00,'Shipped','UPI','Raji\n3247985019\nmain road 00, mandal\nSrinagar, Andhra - 578989\nIndia','2026-08-19 11:16:54',70.00,NULL),(34,1,1198.50,'Pending','UPI','Raji\n3247985019\nmain road 00, mandal\nSrinagar, Andhra - 578989\nIndia','2026-09-09 10:35:07',399.50,NULL);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` text,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT 'ACTIVE',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Raji','devaralarajyalakshmi265@gmail.com','$2a$12$wiAmiDM8ekIQV9X9Liw9JuZM5.8dcaRzqkzBbsVkacs456HgB5NB.','3247985019','main road 00, mandal','Srinagar','Andhra','578989','2026-05-27 13:47:05','ACTIVE'),(7,'lasya','lasya@gmail.com','$2a$12$g6XOskNEt25Dr4OjWCEJPuv8MwDg7MQabYQsEtvrfMySPvZA4fKzq','2345241554','BTM','Bengaluru','karnataka','12345','2026-05-31 14:51:30','ACTIVE'),(8,'Radhika','radhikamudukumu1@gmail.com','radha','7981809331','Gudur, Saidapur','Nellore','Andhra Pradesh','524407','2026-09-09 06:20:07','ACTIVE'),(9,'M.Radhika','mradhika18383@gmail.com','radhasagar','7981809331','Gudur, Saidapur','Nellore','Andhra Pradesh','524407','2026-09-09 06:27:17','ACTIVE');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `wishlist_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `book_id` int NOT NULL,
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`wishlist_id`),
  KEY `fk_wishlist_user` (`user_id`),
  KEY `fk_wishlist_book` (`book_id`),
  CONSTRAINT `fk_wishlist_book` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_wishlist_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
INSERT INTO `wishlist` VALUES (14,7,3,'2026-05-31 14:52:34'),(15,7,4,'2026-05-31 14:52:36'),(37,1,9,'2026-07-11 15:07:11'),(38,1,37,'2026-07-19 11:43:24'),(40,1,10,'2026-07-22 11:39:05'),(42,1,7,'2026-07-22 12:48:12'),(44,1,4,'2026-08-19 11:14:10');
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'shelfbound'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-09 16:19:27
