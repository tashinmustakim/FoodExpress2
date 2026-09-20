-- Database creation
CREATE DATABASE IF NOT EXISTS food_delivery_app;
USE food_delivery_app;

-- 1. users table
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address VARCHAR(255),
    role ENUM('customer', 'admin') DEFAULT 'customer',
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login_date DATETIME
);

-- 2. addresses table
CREATE TABLE IF NOT EXISTS addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    zip VARCHAR(20) NOT NULL,
    landmark VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 3. restaurants table
CREATE TABLE IF NOT EXISTS restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    cuisine_type VARCHAR(50),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip VARCHAR(20),
    phone VARCHAR(15),
    email VARCHAR(100),
    rating DECIMAL(3, 2) DEFAULT 0.0,
    delivery_time INT DEFAULT 30,
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. menu_items table
CREATE TABLE IF NOT EXISTS menu_items (
    menu_item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50),
    is_veg BOOLEAN DEFAULT TRUE,
    is_available BOOLEAN DEFAULT TRUE,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE
);

-- 5. carts table
CREATE TABLE IF NOT EXISTS carts (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 6. cart_items table
CREATE TABLE IF NOT EXISTS cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cart_id) REFERENCES carts(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(menu_item_id) ON DELETE CASCADE
);

-- 7. orders table
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    address_id INT,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('placed', 'accepted', 'preparing', 'out_for_delivery', 'delivered', 'cancelled') DEFAULT 'placed',
    payment_method ENUM('cash_on_delivery', 'card', 'upi') DEFAULT 'cash_on_delivery',
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    delivery_instructions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
    FOREIGN KEY (address_id) REFERENCES addresses(address_id) ON DELETE SET NULL
);

-- 8. order_items table
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_order DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(menu_item_id)
);

-- Seed Data: Sample Users
INSERT IGNORE INTO users (name, username, password, email, phone, address, role) VALUES
('Admin User', 'admin', '$2a$12$V.K5tWvI6M55.tJ8f9eNqOyEwJ2P6hRkH9Q4M3V4f/f5xXWfB.VwW', 'admin@foodxpress.com', '9876543210', 'Admin HQ, Dhaka', 'admin'),
('John Doe', 'john_doe', '$2a$12$V.K5tWvI6M55.tJ8f9eNqOyEwJ2P6hRkH9Q4M3V4f/f5xXWfB.VwW', 'john@gmail.com', '9998887776', 'Dhanmondi, Dhaka', 'customer');

-- Reset Restaurants & Menu Items for Bangladeshi Seed Data
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE menu_items;
TRUNCATE TABLE restaurants;
SET FOREIGN_KEY_CHECKS = 1;

-- Seed Data: Sample Restaurants (Bangladeshi Restaurants)
INSERT INTO restaurants (name, description, cuisine_type, address, city, state, zip, phone, email, rating, delivery_time, image_url, is_active) VALUES
('Kacchi Bhai', 'Authentic Kacchi Biryani, Mutton Borhani, and traditional Old Dhaka royal feast.', 'Kacchi Biryani', 'Dhanmondi 27', 'Dhaka', 'Dhaka Division', '1209', '01700000001', 'kacchibhai@gmail.com', 4.9, 20, 'assets/images/restaurants/rameshwaram_cafe.jpg', TRUE),
('Sultan\'s Dine', 'Famous for premium Kacchi platters, Jali Kabab, and Shahi Firni.', 'Kacchi & Traditional', 'Gulshan 2', 'Dhaka', 'Dhaka Division', '1212', '01700000002', 'sultansdine@gmail.com', 4.8, 25, 'assets/images/restaurants/lavonne_bakery.jpg', TRUE),
('Star Kabab & Restaurant', 'Iconic Bangladeshi dining famous for fresh grilled kababs, naan, and Morog Polao.', 'Kabab & Traditional', 'Banani', 'Dhaka', 'Dhaka Division', '1213', '01700000003', 'starkabab@gmail.com', 4.7, 30, 'assets/images/restaurants/karavalli.jpg', TRUE),
('Nanna Biryani', 'Historic Old Dhaka heritage restaurant famous for traditional Morog Polao and Beef Tehari.', 'Old Dhaka Special', 'Lalbagh', 'Dhaka', 'Dhaka Division', '1211', '01700000004', 'nannabiryani@gmail.com', 4.6, 25, 'assets/images/restaurants/beijing_bites.jpg', TRUE),
('Takeout Bangladesh', 'Dhaka\'s favorite gourmet burger joint serving juicy beef patties and crispy chicken.', 'Burgers & Fast Food', 'Uttara Sector 3', 'Dhaka', 'Dhaka Division', '1230', '01700000005', 'takeoutbd@gmail.com', 4.5, 20, 'assets/images/restaurants/burma_burma.jpg', TRUE);

-- Seed Data: Sample Menu Items
-- Kacchi Bhai Items (Restaurant ID: 1)
INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, is_available, image_url) VALUES
(1, 'Special Mutton Kacchi Biryani', 'Aromatic basmati rice cooked with tender mutton chunks, secret spices, and fried potatoes.', 380.00, 'Biryani', FALSE, TRUE, 'assets/images/default_image.png'),
(1, 'Beef Tehari', 'Mustard oil infused rice cooked with juicy beef cubes and green chilies.', 220.00, 'Tehari', FALSE, TRUE, 'assets/images/default_image.png'),
(1, 'Shahi Borhani', 'Traditional spicy yogurt drink infused with mint, mustard, and cumin.', 80.00, 'Beverages', TRUE, TRUE, 'assets/images/default_image.png');

-- Sultan\'s Dine Items (Restaurant ID: 2)
INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, is_available, image_url) VALUES
(2, 'Sultan\'s Kacchi Platter', 'Royal Kacchi Biryani served with Chicken Roast, Jali Kabab, Borhani, and Firni.', 450.00, 'Platter', FALSE, TRUE, 'assets/images/default_image.png'),
(2, 'Beef Jali Kabab (2 pcs)', 'Crispy egg net wrapped spiced beef patties fried to perfection.', 120.00, 'Kabab', FALSE, TRUE, 'assets/images/default_image.png'),
(2, 'Zafrani Shahi Firni', 'Rich rice pudding cooked with saffron, cardamoms, and crushed pistachios.', 90.00, 'Desserts', TRUE, TRUE, 'assets/images/default_image.png');

-- Star Kabab & Restaurant Items (Restaurant ID: 3)
INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, is_available, image_url) VALUES
(3, 'Special Chicken Chaap', 'Pan-fried marinated chicken leg slow-cooked in rich spicy gravy.', 160.00, 'Main Course', FALSE, TRUE, 'assets/images/default_image.png'),
(3, 'Butter Naan', 'Soft clay oven baked flatbread brushed with fresh butter.', 40.00, 'Bread', TRUE, TRUE, 'assets/images/default_image.png'),
(3, 'Special Morog Polao', 'Classic aromatic polao rice served with a whole juicy chicken leg roast.', 260.00, 'Polao', FALSE, TRUE, 'assets/images/default_image.png');

-- Nanna Biryani Items (Restaurant ID: 4)
INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, is_available, image_url) VALUES
(4, 'Old Dhaka Morog Polao', 'Traditional Old Dhaka style Morog Polao cooked with pure ghee and boiled egg.', 240.00, 'Polao', FALSE, TRUE, 'assets/images/default_image.png'),
(4, 'Shahi Tukda', 'Golden fried bread soaked in saffron infused rabri and dry fruits.', 100.00, 'Desserts', TRUE, TRUE, 'assets/images/default_image.png');

-- Takeout Bangladesh Items (Restaurant ID: 5)
INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, is_available, image_url) VALUES
(5, 'Beef Cheese Supreme Burger', 'Double juicy beef patty topped with melted cheddar cheese, caramelized onions, and house sauce.', 290.00, 'Burgers', FALSE, TRUE, 'assets/images/default_image.png'),
(5, 'Crispy Chicken Strips (4 pcs)', 'Golden crunchy seasoned chicken tenders served with honey mustard dip.', 190.00, 'Starters', FALSE, TRUE, 'assets/images/default_image.png');
