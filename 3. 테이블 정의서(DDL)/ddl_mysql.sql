CREATE TABLE `Products` (
  `ProductID` VARCHAR(20) PRIMARY KEY NOT NULL,
  `ProductName` VARCHAR(50) NOT NULL,
  `ProductDescription` VARCHAR(100),
  `CategoryID` VARCHAR(20) NOT NULL,
  `ProductPrice` INT NOT NULL,
  `ProductCount` INT NOT NULL,
  `AvgDeliver` FLOAT,
  `CumulativeSale` INT NOT NULL
);

CREATE TABLE `Customers` (
  `CustomerID` VARCHAR(20) PRIMARY KEY NOT NULL,
  `CustomerEmail` VARCHAR(100) UNIQUE NOT NULL,
  `CustomerPassword` VARCHAR(100) NOT NULL,
  `CustomerTel` VARCHAR(30) NOT NULL,
  `CustomerGender` VARCHAR(10),
  `CustomerName` VARCHAR(50) NOT NULL,
  `CustomerAddress` VARCHAR(100) NOT NULL,
  `CustomerBirth` DATE,
  `CustomerDateofjoin` DATE,
  `CustomerGrade` VARCHAR(10) NOT NULL
);

CREATE TABLE `Categories` (
  `CategoryID` VARCHAR(20) PRIMARY KEY NOT NULL,
  `CategoryName` VARCHAR(30) NOT NULL
);

CREATE TABLE `Orders` (
  `OrderID` VARCHAR(20) PRIMARY KEY NOT NULL,
  `OrderRegion` VARCHAR(100) NOT NULL,
  `OrderRegionDetail` VARCHAR(100) NOT NULL,
  `OrderDate` DATE NOT NULL,
  `PaymentMethod` VARCHAR(10),
  `TotalPrice` INT NOT NULL,
  `ShippingCost` INT,
  `ItemCNT` INT,
  `OrderName` VARCHAR(50) NOT NULL,
  `OrderTel` VARCHAR(15) NOT NULL,
  `Refundable` VARCHAR(2),
  `CustomerID` VARCHAR(20) NOT NULL
);

CREATE TABLE `OrderedDetails` (
  `OrderID` VARCHAR(20) NOT NULL,
  `ProductID` VARCHAR(20) NOT NULL,
  `OrderItemCnt` INT,
  PRIMARY KEY (`OrderID`, `ProductID`)
);

CREATE TABLE `DiscountDetails` (
  `DiscountRate` FLOAT,
  `DiscountDetail` VARCHAR(20),
  `CustomerGrade` VARCHAR(10) PRIMARY KEY NOT NULL
);

CREATE TABLE `ShoppingCart` (
  `CartID` VARCHAR(20) PRIMARY KEY NOT NULL,
  `CustomerID` VARCHAR(20) NOT NULL,
  `ProductID` VARCHAR(20) NOT NULL,
  `CartCount` INT,
  `CartDate` DATE
);

CREATE TABLE `QnA` (
  `QnAID` VARCHAR(20) PRIMARY KEY NOT NULL,
  `CustomerID` VARCHAR(20),
  `QnACategory` VARCHAR(30) NOT NULL,
  `ProductID` VARCHAR(20),
  `OrderID` VARCHAR(20),
  `QnADate` DATE NOT NULL,
  `QnAPassword` VARCHAR(50),
  `Status` VARCHAR(30)
);

CREATE TABLE `LogData` (
  `event_time` TIMESTAMP NOT NULL,
  `event_type` VARCHAR(50) NOT NULL,
  `event_date` VARCHAR(50) NOT NULL,
  `user_session` VARCHAR(100) NOT NULL,
  `price` FLOAT,
  `cust_id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`event_time`, `event_type`, `event_date`)
);

ALTER TABLE `Products` ADD CONSTRAINT `fk_Products_ItemCategory` FOREIGN KEY (`CategoryID`) REFERENCES `Categories` (`CategoryID`);

ALTER TABLE `OrderedDetails` ADD FOREIGN KEY (`OrderID`) REFERENCES `Orders` (`OrderID`);

ALTER TABLE `OrderedDetails` ADD FOREIGN KEY (`ProductID`) REFERENCES `Products` (`ProductID`);

ALTER TABLE `Customers` ADD CONSTRAINT `fk_Customers_CustomerGrade` FOREIGN KEY (`CustomerGrade`) REFERENCES `DiscountDetails` (`CustomerGrade`);

ALTER TABLE `ShoppingCart` ADD FOREIGN KEY (`CustomerID`) REFERENCES `Customers` (`CustomerID`);

ALTER TABLE `ShoppingCart` ADD FOREIGN KEY (`ProductID`) REFERENCES `Products` (`ProductID`);

ALTER TABLE `QnA` ADD FOREIGN KEY (`CustomerID`) REFERENCES `Customers` (`CustomerID`);

ALTER TABLE `QnA` ADD FOREIGN KEY (`ProductID`) REFERENCES `Products` (`ProductID`);

ALTER TABLE `QnA` ADD FOREIGN KEY (`OrderID`) REFERENCES `Orders` (`OrderID`);

ALTER TABLE `QnA` ADD CONSTRAINT `fk_QnA_OrderID` FOREIGN KEY (`OrderID`) REFERENCES `OrderedDetails` (`OrderID`);

ALTER TABLE `Orders` ADD CONSTRAINT `fk_Orders_CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `Customers` (`CustomerID`);

ALTER TABLE `LogData` ADD FOREIGN KEY (`price`) REFERENCES `Products` (`ProductPrice`);

ALTER TABLE `LogData` ADD FOREIGN KEY (`cust_id`) REFERENCES `Customers` (`CustomerID`);
