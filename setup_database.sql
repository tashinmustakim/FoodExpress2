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
-- Password is 'password123' BCrypt hashed
INSERT INTO users (name, username, password, email, phone, address, role) VALUES
('Admin User', 'admin', '$2a$12$V.K5tWvI6M55.tJ8f9eNqOyEwJ2P6hRkH9Q4M3V4f/f5xXWfB.VwW', 'admin@foodxpress.com', '9876543210', 'Admin HQ, Bangalore', 'admin'),
('John Doe', 'john_doe', '$2a$12$V.K5tWvI6M55.tJ8f9eNqOyEwJ2P6hRkH9Q4M3V4f/f5xXWfB.VwW', 'john@gmail.com', '9998887776', '123 Main St, Bangalore', 'customer');

-- Seed Data: Sample Restaurants
INSERT INTO restaurants (name, description, cuisine_type, address, city, state, zip, phone, email, rating, delivery_time, image_url, is_active) VALUES
('Rameshwaram Cafe', 'Authentic South Indian quick service restaurant famous for its ghee idlis and filter coffee.', 'South Indian', 'Indiranagar', 'Bangalore', 'Karnataka', '560038', '9000000001', 'rameshwaram@gmail.com', 4.8, 15, 'assets/images/restaurants/rameshwaram_cafe.jpg', TRUE),
('Lavonne Bakery', 'Exquisite French pastry shop, cafe, and baking academy offering premium desserts.', 'Bakery & Desserts', 'Domlur', 'Bangalore', 'Karnataka', '560071', '9000000002', 'lavonne@gmail.com', 4.7, 25, 'assets/images/restaurants/lavonne_bakery.jpg', TRUE),
('Karavalli', 'Premium coastal Indian fine dining showcasing cuisines from Goa, Mangalore, and Kerala.', 'Coastal Indian', 'Residency Road', 'Bangalore', 'Karnataka', '560025', '9000000003', 'karavalli@gmail.com', 4.6, 35, 'assets/images/restaurants/karavalli.jpg', TRUE),
('Beijing Bites', 'Popular Chinese restaurant serving local favorites and classic Hakka noodles.', 'Chinese', 'Koramangala', 'Bangalore', 'Karnataka', '560095', '9000000004', 'beijingbites@gmail.com', 4.2, 20, 'assets/images/restaurants/beijing_bites.jpg', TRUE),
('Burma Burma', 'Splendid vegetarian Burmese dining experience with premium teas and authentic dishes.', 'Burmese', 'Indiranagar', 'Bangalore', 'Karnataka', '560038', '9000000005', 'burmaburma@gmail.com', 4.5, 30, 'assets/images/restaurants/burma_burma.jpg', TRUE);

-- Seed Data: Sample Menu Items
-- Rameshwaram Cafe Items (Restaurant ID: 1)
INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, is_available, image_url) VALUES
(1, 'Ghee Podi Idli', 'Soft fluffy idlis tossed in flavorful spice powder (podi) and lots of pure ghee.', 90.00, 'Breakfast', TRUE, TRUE, 'assets/images/default_image.png'),
(1, 'Crispy Ghee Roast Dosa', 'Golden crispy rice crepe cooked in pure ghee, served with sambar and coconut chutney.', 110.00, 'Breakfast', TRUE, TRUE, 'assets/images/default_image.png'),
(1, 'Filter Coffee', 'Traditional South Indian filter coffee brewed with hot frothy milk.', 40.00, 'Beverages', TRUE, TRUE, 'assets/images/default_image.png');

-- Lavonne Bakery Items (Restaurant ID: 2)
INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, is_available, image_url) VALUES
(2, 'Chocolate Croissant', 'Flaky butter croissant filled with premium dark chocolate.', 180.00, 'Bakery', TRUE, TRUE, 'assets/images/default_image.png'),
(2, 'Blueberry Cheesecake', 'Rich creamy cheesecake topped with sweet blueberry compote.', 240.00, 'Desserts', TRUE, TRUE, 'assets/images/default_image.png'),
(2, 'Hot Chocolate', 'Rich, thick, and velvety chocolate drink made with real chocolate.', 150.00, 'Beverages', TRUE, TRUE, 'assets/images/default_image.png');

-- Karavalli Items (Restaurant ID: 3)
INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, is_available, image_url) VALUES
(3, 'Kori Gassi', 'Mangalorean style chicken curry cooked with freshly ground spices and coconut milk.', 450.00, 'Main Course', FALSE, TRUE, 'assets/images/default_image.png'),
(3, 'Neer Dosa', 'Paper-thin, light, and lacy rice crepes, perfect accompaniment for curries.', 90.00, 'Bread', TRUE, TRUE, 'assets/images/default_image.png'),
(3, 'Elaneer Payasam', 'Traditional dessert made with tender coconut pulp and milk.', 180.00, 'Desserts', TRUE, TRUE, 'assets/images/default_image.png');

-- Beijing Bites Items (Restaurant ID: 4)
INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, is_available, image_url) VALUES
(4, 'Veg Schezwan Noodles', 'Spicy stir-fried noodles tossed with fresh vegetables and hot Schezwan sauce.', 190.00, 'Main Course', TRUE, TRUE, 'assets/images/default_image.png'),
(4, 'Chicken Dim Sums', 'Steamed dumplings stuffed with minced seasoned chicken, served with chili dip.', 210.00, 'Starters', FALSE, TRUE, 'assets/images/default_image.png');

-- Burma Burma Items (Restaurant ID: 5)
INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, is_available, image_url) VALUES
(5, 'Burmese Tea Leaf Salad', 'Fermented tea leaves tossed with crunchy nuts, cabbage, tomato, and garlic.', 320.00, 'Salads', TRUE, TRUE, 'assets/images/default_image.png'),
(5, 'Samosa Soup', 'Tangy and flavorful broth served with smashed samosas and vegetables.', 280.00, 'Soups', TRUE, TRUE, 'assets/images/default_image.png');
