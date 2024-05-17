-- Database: HelloWorldShop

-- Table: Categories
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    ParentCategoryID INT,
    CategoryName VARCHAR(255) NOT NULL,
    CONSTRAINT FK_ParentCategory FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID)
);

-- Table: Suppliers
CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    CompanyName VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    PointOfContact VARCHAR(255),
    PhoneNumber VARCHAR(50),
    CompanyCategory VARCHAR(255),
    Revenue DECIMAL(15, 2)
);

-- Table: Items
CREATE TABLE Items (
    ItemID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierID INT,
    CategoryID INT,
    Description TEXT,
    ReservePrice DECIMAL(10, 2),
    Location VARCHAR(255),
    SaleType ENUM('ListedPrice', 'Auction') NOT NULL,
    ListedPrice DECIMAL(10, 2),
    AuctionEndTime DATETIME,
    CONSTRAINT FK_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    CONSTRAINT FK_Category FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Table: Users
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    UserName VARCHAR(255) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Name VARCHAR(255),
    Age INT,
    Gender ENUM('Male', 'Female', 'Other'),
    AnnualIncome DECIMAL(15, 2)
);

-- Table: UserAddresses
CREATE TABLE UserAddresses (
    AddressID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    Street VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(50),
    Zip VARCHAR(20),
    CONSTRAINT FK_UserAddress FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table: UserPhones
CREATE TABLE UserPhones (
    PhoneID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    PhoneNumber VARCHAR(50),
    CONSTRAINT FK_UserPhone FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table: UserCreditCards
CREATE TABLE UserCreditCards (
    CreditCardID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    CardType VARCHAR(50),
    CardNumber VARCHAR(255),
    ExpirationDate DATE,
    CONSTRAINT FK_UserCreditCard FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table: Ratings
CREATE TABLE Ratings (
    RatingID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    RatedUserID INT,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Comment TEXT,
    CONSTRAINT FK_RatingUser FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_RatedUser FOREIGN KEY (RatedUserID) REFERENCES Users(UserID)
);

-- Table: Bids
CREATE TABLE Bids (
    BidID INT AUTO_INCREMENT PRIMARY KEY,
    ItemID INT,
    UserID INT,
    BidAmount DECIMAL(10, 2),
    BidTime DATETIME,
    CONSTRAINT FK_BidItem FOREIGN KEY (ItemID) REFERENCES Items(ItemID),
    CONSTRAINT FK_BidUser FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table: Orders
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    ItemID INT,
    UserID INT,
    OrderTime DATETIME,
    Quantity INT,
    TotalAmount DECIMAL(10, 2),
    Status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    DeliveryStatus ENUM('Pending', 'Shipped', 'Delivered') DEFAULT 'Pending',
    TrackingNumber VARCHAR(255),
    CONSTRAINT FK_OrderItem FOREIGN KEY (ItemID) REFERENCES Items(ItemID),
    CONSTRAINT FK_OrderUser FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table: Notifications
CREATE TABLE Notifications (
    NotificationID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    Message TEXT,
    NotificationTime DATETIME,
    IsRead BOOLEAN DEFAULT FALSE,
    CONSTRAINT FK_NotificationUser FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table: SalesReports
CREATE TABLE SalesReports (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    ReportDate DATE,
    ReportData TEXT
);

-- Creating necessary indexes for efficient querying
CREATE INDEX idx_CategoryName ON Categories (CategoryName);
CREATE INDEX idx_CompanyName ON Suppliers (CompanyName);
CREATE INDEX idx_ItemDescription ON Items (Description(255)); -- Specify prefix length for TEXT column
CREATE INDEX idx_UserName ON Users (UserName);
CREATE INDEX idx_Email ON Users (Email);

-- Insert the root category
INSERT INTO Categories (CategoryName) VALUES ('All');

-- Sample Procedures and Triggers can be added as needed to handle complex business logic

-- Inserting sample data into the Categories table
INSERT INTO Categories (ParentCategoryID, CategoryName) VALUES (NULL, 'All');
INSERT INTO Categories (ParentCategoryID, CategoryName) VALUES (1, 'Sporting Goods');
INSERT INTO Categories (ParentCategoryID, CategoryName) VALUES (2, 'Outdoor Sports');
INSERT INTO Categories (ParentCategoryID, CategoryName) VALUES (2, 'Indoor Sports');
INSERT INTO Categories (ParentCategoryID, CategoryName) VALUES (3, 'Camping & Hiking');
INSERT INTO Categories (ParentCategoryID, CategoryName) VALUES (3, 'Cycling');
INSERT INTO Categories (ParentCategoryID, CategoryName) VALUES (4, 'Basketball');
INSERT INTO Categories (ParentCategoryID, CategoryName) VALUES (4, 'Badminton');

-- Inserting sample data into the Suppliers table
INSERT INTO Suppliers (CompanyName, Address, PointOfContact, PhoneNumber, CompanyCategory, Revenue) VALUES 
('OutdoorGear Inc.', '123 Outdoor St, New York, USA, 12345', 'Dayneris Targaryen', '555-1234', 'Outdoor Sports', 1000000.00),
('CyclingPros', '456 Cycle Rd, London, UK, 12345', 'Din Winchester', '555-5678', 'Cycling', 750000.00),
('Basketball World', '789 Hoops Ave, Amsterdam, Holland, 12345', 'Jody Mills', '555-9012', 'Basketball', 500000.00),
('Badminton Central', '321 Shuttle Dr, Moscow, Russia, 12345', 'Alena Shishkova', '555-3456', 'Badminton', 300000.00);

-- Inserting sample data into the Users table
INSERT INTO Users (UserName, PasswordHash, Email, Name, Age, Gender, AnnualIncome) VALUES  
('beysenova_sania1', 'hashedpassword1', 'sania@google.com', 'Beysenova Sania', 25, 'Female', 50000.00), 
('maxutova_anar2', 'hashedpassword2', 'anar@google.com', 'Maxutova Anar', 28, 'Female', 55000.00), 
('tugalev_artem3', 'hashedpassword3', 'artem@google.com', 'Tugalev Artem', 30, 'Male', 60000.00), 
('lev_tsoy4', 'hashedpassword4', 'lev@google.com', 'Lev Tsoy', 35, 'Male', 65000.00), 
('bakdaulet_ramazanov5', 'hashedpassword5', 'ramazanov@google.com', 'Bakdaulet Ramazanov', 27, 'Male', 48000.00), 
('baidaly_sagatov6', 'hashedpassword6', 'sagatov@google.com', 'Baidaly Sagatov', 32, 'Male', 62000.00), 
('arsen_mukhatayev7', 'hashedpassword7', 'mukhatayev@google.com', 'Arsen Mukhatayev', 29, 'Male', 53000.00), 
('dinnur_li8', 'hashedpassword8', 'li@google.com', 'Dinnur Li', 26, 'Male', 49000.00), 
('nurdin_nurtay9', 'hashedpassword9', 'nurtay@google.com', 'Nurdin Nurtay', 31, 'Male', 61000.00), 
('eldar_shakhzhanov10', 'hashedpassword10', 'shakhzhanov@google.com', 'Eldar Shakhzhanov', 33, 'Male', 64000.00);

-- Inserting sample data into the UserAddresses table
INSERT INTO UserAddresses (UserID, Street, City, State, Zip) VALUES 
(1, '123 Main St', 'Almaty', 'Kazakhstan', '12345'),
(2, '456 Oak St', 'Almaty', 'Kazakhstan', '12345'),
(3, '789 Pine St', 'Almaty', 'Kazakhstan', '12345'),
(4, '101 Maple St', 'Astana', 'Kazakhstan', '12345'),
(5, '202 Elm St', 'Almaty', 'Kazakhstan', '12345'),
(6, '303 Birch St', 'Astana', 'Kazakhstan', '12345'),
(7, '404 Cedar St', 'Almaty', 'Kazakhstan', '12345'),
(8, '505 Walnut St', 'Aktobe', 'Kazakhstan', '12345'),
(9, '606 Willow St', 'Almaty', 'Kazakhstan', '12345'),
(10, '707 Spruce St', 'Talgar', 'Kazakhstan', '12345');

-- Inserting sample data into the UserPhones table
INSERT INTO UserPhones (UserID, PhoneNumber) VALUES 
(1, '555-1111'),
(2, '555-2222'),
(3, '555-3333'),
(4, '555-4444'),
(5, '555-5555'),
(6, '555-6666'),
(7, '555-7777'),
(8, '555-8888'),
(9, '555-9999'),
(10, '555-0000');

-- Inserting sample data into the UserCreditCards table
INSERT INTO UserCreditCards (UserID, CardType, CardNumber, ExpirationDate) VALUES 
(1, 'Visa', '4111111111111111', '2025-12-31'),
(2, 'MasterCard', '5500000000000004', '2024-11-30'),
(3, 'Visa', '4111111111111111', '2025-10-31'),
(4, 'MasterCard', '5500000000000004', '2024-09-30'),
(5, 'Visa', '4111111111111111', '2025-08-31'),
(6, 'MasterCard', '5500000000000004', '2024-07-31'),
(7, 'Visa', '4111111111111111', '2025-06-30'),
(8, 'MasterCard', '5500000000000004', '2024-05-31'),
(9, 'Visa', '4111111111111111', '2025-04-30'),
(10, 'MasterCard', '5500000000000004', '2024-03-31');

-- Inserting sample data into the Items table
INSERT INTO Items (SupplierID, CategoryID, Description, ReservePrice, Location, SaleType, ListedPrice, AuctionEndTime) VALUES 
(1, 3, 'High-quality hiking tent', 100.00, 'Warehouse A', 'Auction', NULL, '2024-05-31 23:59:59'),
(2, 6, 'Mountain bike with 21-speed gear', 300.00, 'Warehouse B', 'Auction', NULL, '2024-06-15 23:59:59'),
(3, 7, 'Professional basketball', 50.00, 'Warehouse C', 'ListedPrice', 70.00, NULL),
(4, 8, 'Set of badminton rackets', 20.00, 'Warehouse D', 'ListedPrice', 35.00, NULL);

-- Inserting sample data into the Ratings table
INSERT INTO Ratings (UserID, RatedUserID, Rating, Comment) VALUES 
(1, 2, 5, 'Great buyer, fast payment!'),
(2, 1, 4, 'Good communication, smooth transaction.'),
(3, 4, 3, 'Item as described, but shipping was slow.'),
(4, 3, 5, 'Excellent seller, highly recommended!'),
(5, 6, 4, 'Good buyer, would sell to again.'),
(6, 5, 3, 'Average experience, could be better.'),
(7, 8, 5, 'Very satisfied with the transaction.'),
(8, 7, 4, 'Item arrived on time and in good condition.'),
(9, 10, 5, 'Fantastic buyer, prompt payment!'),
(10, 9, 4, 'Good seller, item as described.');

-- Inserting sample data into the Bids table
INSERT INTO Bids (ItemID, UserID, BidAmount, BidTime) VALUES 
(1, 3, 120.00, '2024-05-15 10:00:00'),
(2, 5, 320.00, '2024-05-16 11:00:00'),
(1, 6, 130.00, '2024-05-17 12:00:00'),
(2, 7, 340.00, '2024-05-18 13:00:00');

-- Inserting sample data into the Orders table
INSERT INTO Orders (ItemID, UserID, OrderTime, Quantity, TotalAmount, Status, DeliveryStatus, TrackingNumber) VALUES 
(3, 1, '2024-05-10 14:00:00', 1, 70.00, 'Completed', 'Shipped', 'TRK123456789'),
(4, 2, '2024-05-12 15:30:00', 2, 70.00, 'Completed', 'Delivered', 'TRK987654321');

INSERT INTO Notifications (UserID, Message, IsRead) VALUES 
(1, 'Your order has been shipped. Tracking number: TRK123456789', 0),
(2, 'Your order has been delivered. Tracking number: TRK987654321', 0);
