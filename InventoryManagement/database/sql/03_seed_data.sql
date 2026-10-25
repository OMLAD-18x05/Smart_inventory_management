-- ==============================================================================
-- Script 03: Seed Sample Data
-- Project: Smart Inventory Management Mobile Application
-- Target Database: inventory_management
-- Safe Execution: Uses INSERT IGNORE / ON DUPLICATE KEY UPDATE for idempotent reruns.
-- ==============================================================================

USE `inventory_management`;

-- ------------------------------------------------------------------------------
-- 1. Seed Demo Users
-- Passwords:
--   admin@inventory.local / admin -> Admin@123
--   staff@inventory.local / staff -> Staff@123
-- Both hashed with Spring Security BCrypt (work factor 12).
-- ------------------------------------------------------------------------------
INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `full_name`, `role`, `is_active`)
VALUES
    (1, 'admin', 'admin@inventory.local', '$2a$12$EKLtZWDybiy1qlD7/2j1bObB8/0/3mznFu6N0OW9IGn7Ia6uRgimC', 'System Administrator', 'ROLE_ADMIN', TRUE),
    (2, 'staff', 'staff@inventory.local', '$2a$12$XloqiZPQESnSCHiwCjdEmOffqxogDQV.XifI4wek00qPDaUfekvfS', 'Warehouse Staff', 'ROLE_STAFF', TRUE)
ON DUPLICATE KEY UPDATE
    `password_hash` = VALUES(`password_hash`),
    `full_name`     = VALUES(`full_name`),
    `role`          = VALUES(`role`),
    `is_active`     = VALUES(`is_active`);

-- ------------------------------------------------------------------------------
-- 2. Seed Categories (6 Categories)
-- ------------------------------------------------------------------------------
INSERT INTO `categories` (`id`, `name`, `description`, `is_active`)
VALUES
    (1, 'Electronics', 'Consumer electronics, audio devices, and power accessories', TRUE),
    (2, 'Computer Peripherals', 'Keyboards, mice, monitors, webcams, and docking stations', TRUE),
    (3, 'Office Supplies', 'Desk organization, paper goods, printing supplies, and stationery', TRUE),
    (4, 'Network Hardware', 'Routers, managed switches, patch cables, and access points', TRUE),
    (5, 'Storage Devices', 'Solid state drives, high-capacity hard drives, and flash storage', TRUE),
    (6, 'Mobile Accessories', 'Protective cases, high-speed charging cables, and adapters', TRUE)
ON DUPLICATE KEY UPDATE
    `description` = VALUES(`description`),
    `is_active`   = VALUES(`is_active`);

-- ------------------------------------------------------------------------------
-- 3. Seed Suppliers (4 Suppliers)
-- ------------------------------------------------------------------------------
INSERT INTO `suppliers` (`id`, `company_name`, `contact_person`, `email`, `phone`, `address`, `is_active`)
VALUES
    (1, 'Apex Electronics Ltd.', 'Alice Smith', 'alice@apexelectronics.com', '+1-555-0199', '456 Industrial Parkway, Austin, TX 78701', TRUE),
    (2, 'LogiTech Supply Co.', 'Robert Vance', 'robert@logitechsupply.com', '+1-555-0245', '789 Logistics Way, Chicago, IL 60607', TRUE),
    (3, 'Global Office Solutions', 'Karen Filippelli', 'karen@globaloffice.com', '+1-555-0371', '101 Corporate Blvd, Scranton, PA 18503', TRUE),
    (4, 'NextGen Storage Corp.', 'David Wallace', 'david@nextgenstorage.com', '+1-555-0482', '22 Silicon Valley Blvd, San Jose, CA 95110', TRUE)
ON DUPLICATE KEY UPDATE
    `company_name`   = VALUES(`company_name`),
    `contact_person` = VALUES(`contact_person`),
    `email`          = VALUES(`email`),
    `phone`          = VALUES(`phone`),
    `address`        = VALUES(`address`),
    `is_active`      = VALUES(`is_active`);

-- ------------------------------------------------------------------------------
-- 4. Seed Products (12 Sample Products across various stock levels)
-- Includes:
-- - Normal stock items
-- - Low stock items (quantity_on_hand <= min_reorder_level)
-- - Out of stock items (quantity_on_hand = 0)
-- ------------------------------------------------------------------------------
INSERT INTO `products` 
    (`id`, `sku`, `barcode`, `name`, `description`, `category_id`, `supplier_id`, `cost_price`, `selling_price`, `quantity_on_hand`, `min_reorder_level`, `location_shelf`, `is_active`, `version`)
VALUES
    -- 1. Normal stock
    (1, 'SKU-ELEC-001', '8901234567890', 'Ergonomic Wireless Mouse', '2.4GHz rechargeable wireless optical mouse with USB-C charging', 2, 2, 12.50, 24.99, 45, 10, 'Aisle 2, Bin 101', TRUE, 0),
    (2, 'SKU-KEYB-002', '8901234567891', 'RGB Mechanical Keyboard', 'Tenkeyless tactile mechanical keyboard with hot-swappable switches', 2, 2, 45.00, 89.99, 30, 8, 'Aisle 2, Bin 102', TRUE, 0),
    (3, 'SKU-DISP-003', '8901234567892', '27-inch 4K IPS Monitor', 'Ultra-HD HDR400 designer monitor with USB-C 65W power delivery', 2, 1, 195.00, 329.99, 18, 5, 'Aisle 4, Bay A', TRUE, 0),
    (4, 'SKU-STOR-004', '8901234567893', '1TB NVMe PCIe 4.0 SSD', 'High performance M.2 internal solid-state drive up to 7000MB/s', 5, 4, 48.00, 84.99, 60, 15, 'Aisle 1, Bin 201', TRUE, 0),
    (5, 'SKU-STOR-005', '8901234567894', '2TB Portable External SSD', 'Ruggedized drop-resistant USB 3.2 Gen 2 portable drive', 5, 4, 82.00, 149.99, 25, 10, 'Aisle 1, Bin 202', TRUE, 0),
    (6, 'SKU-NETW-006', '8901234567895', 'Wi-Fi 6 Mesh Dual-Band Router', 'Gigabit AX3000 whole-home mesh coverage system (Pack of 2)', 4, 1, 65.00, 119.99, 22, 6, 'Aisle 3, Bin 301', TRUE, 0),
    (7, 'SKU-NETW-007', '8901234567896', 'Cat6 Snagless Ethernet Cable 10ft', 'High bandwidth 550MHz UTP network patch cable, Blue', 4, 1, 2.20, 7.99, 150, 25, 'Aisle 3, Bin 305', TRUE, 0),
    (8, 'SKU-OFFC-008', '8901234567897', 'A4 Multipurpose Copy Paper 500 Sheets', '92 Bright 20lb acid-free laser and inkjet white copy paper ream', 3, 3, 3.80, 7.49, 120, 20, 'Pallet Rack 1', TRUE, 0),
    
    -- 9. Low Stock Alert Item (quantity: 4 <= min_reorder_level: 10)
    (9, 'SKU-HEAD-009', '8901234567898', 'Active Noise Cancelling Headphones', 'Over-ear wireless headphones with 40h battery life and transparency mode', 1, 1, 55.00, 109.99, 4, 10, 'Aisle 2, Bin 105', TRUE, 0),
    
    -- 10. Low Stock Alert Item (quantity: 3 <= min_reorder_level: 8)
    (10, 'SKU-CAM-010', '8901234567899', '1080p Full HD Webcam', 'Wide-angle conference webcam with dual stereo noise-cancelling mics', 2, 2, 22.00, 44.99, 3, 8, 'Aisle 2, Bin 108', TRUE, 0),
    
    -- 11. Low Stock Alert Item (quantity: 2 <= min_reorder_level: 5)
    (11, 'SKU-USBC-011', '8901234567800', '100W GaN Fast Charger 3-Port', 'Compact Gallium Nitride multi-port rapid travel power adapter', 1, 1, 18.50, 39.99, 2, 5, 'Aisle 1, Bin 110', TRUE, 0),
    
    -- 12. Out of Stock Item (quantity: 0 <= min_reorder_level: 12)
    (12, 'SKU-DOCK-012', '8901234567801', '12-in-1 Triple Display USB-C Dock', 'Aluminum multiport docking station with dual HDMI, DisplayPort, and 100W PD', 2, 2, 70.00, 139.99, 0, 12, 'Aisle 2, Bin 115', TRUE, 0)
ON DUPLICATE KEY UPDATE
    `name`              = VALUES(`name`),
    `description`       = VALUES(`description`),
    `category_id`       = VALUES(`category_id`),
    `supplier_id`       = VALUES(`supplier_id`),
    `cost_price`        = VALUES(`cost_price`),
    `selling_price`     = VALUES(`selling_price`),
    `quantity_on_hand`  = VALUES(`quantity_on_hand`),
    `min_reorder_level` = VALUES(`min_reorder_level`),
    `location_shelf`    = VALUES(`location_shelf`),
    `is_active`         = VALUES(`is_active`);

-- ------------------------------------------------------------------------------
-- 5. Seed Historical Stock Transactions (Immutable Audit Trail)
-- Demonstrates Stock-In receiving and Stock-Out dispatching
-- ------------------------------------------------------------------------------
INSERT INTO `stock_transactions`
    (`id`, `product_id`, `transaction_type`, `quantity`, `previous_quantity`, `new_quantity`, `unit_cost`, `reference_invoice`, `notes`, `performed_by_user_id`, `transaction_timestamp`)
VALUES
    -- Initial inventory intake for Mouse (Product 1)
    (1, 1, 'STOCK_IN', 50, 0, 50, 12.50, 'PO-2026-001', 'Initial stock received from LogiTech Supply Co.', 1, '2026-10-18 09:00:00'),
    -- Customer dispatch for Mouse (Product 1)
    (2, 1, 'STOCK_OUT', 5, 50, 45, NULL, 'DISP-2026-101', 'Dispatched to North Warehouse Retail Floor', 2, '2026-10-19 14:30:00'),
    
    -- Intake for Keyboard (Product 2)
    (3, 2, 'STOCK_IN', 35, 0, 35, 45.00, 'PO-2026-002', 'Received shipment container via freight', 1, '2026-10-18 10:15:00'),
    -- Sales order dispatch for Keyboard (Product 2)
    (4, 2, 'STOCK_OUT', 5, 35, 30, NULL, 'DISP-2026-102', 'Order fulfillment for corporate client', 2, '2026-10-20 11:00:00'),
    
    -- Intake for Headphone (Product 9)
    (5, 9, 'STOCK_IN', 10, 0, 10, 55.00, 'PO-2026-003', 'Seasonal intake shipment', 1, '2026-10-17 08:30:00'),
    -- Heavy dispatch leading to Low Stock condition (10 -> 4)
    (6, 9, 'STOCK_OUT', 6, 10, 4, NULL, 'DISP-2026-103', 'Bulk order dispatch for college bookstore', 2, '2026-10-21 13:45:00')
ON DUPLICATE KEY UPDATE
    `quantity`          = VALUES(`quantity`),
    `previous_quantity` = VALUES(`previous_quantity`),
    `new_quantity`      = VALUES(`new_quantity`),
    `notes`             = VALUES(`notes`);
