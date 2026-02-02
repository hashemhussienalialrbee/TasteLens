
USE tastelens_db;
-- ======= TasteLens Database Schema (MySQL) =======

-- Users
CREATE TABLE users (
  user_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  name VARCHAR(150),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  phone VARCHAR(50),
  city VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Preferences / Mood entries
CREATE TABLE preferences (
  preference_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  user_id CHAR(36) NOT NULL,
  mood VARCHAR(50),
  category VARCHAR(100),
  notes TEXT,
  lat DOUBLE,
  lng DOUBLE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Restaurants
CREATE TABLE restaurants (
  restaurant_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  name VARCHAR(255) NOT NULL,
  type VARCHAR(100),
  address TEXT,
  city VARCHAR(100),
  lat DOUBLE,
  lng DOUBLE,
  rating DECIMAL(2,1) DEFAULT 0.0,
  meta JSON
);

-- Activities
CREATE TABLE activities (
  activity_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  name VARCHAR(255) NOT NULL,
  type VARCHAR(100),
  address TEXT,
  city VARCHAR(100),
  lat DOUBLE,
  lng DOUBLE,
  rating DECIMAL(2,1) DEFAULT 0.0,
  meta JSON
);

-- Recommendations
CREATE TABLE recommendations (
  rec_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  user_id CHAR(36) NOT NULL,
  restaurant_id CHAR(36),
  activity_id CHAR(36),
  source VARCHAR(50) DEFAULT 'engine',
  score DECIMAL(5,3),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
  FOREIGN KEY (activity_id) REFERENCES activities(activity_id)
);

-- Feedback
CREATE TABLE feedback (
  feedback_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  rec_id CHAR(36),
  user_id CHAR(36) NOT NULL,
  rating TINYINT CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (rec_id) REFERENCES recommendations(rec_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Tags
CREATE TABLE tags (
  tag_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  name VARCHAR(100) UNIQUE NOT NULL
);

-- Many-to-many links
CREATE TABLE restaurant_tags (
  restaurant_id CHAR(36),
  tag_id CHAR(36),
  PRIMARY KEY (restaurant_id, tag_id),
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE CASCADE
);

CREATE TABLE activity_tags (
  activity_id CHAR(36),
  tag_id CHAR(36),
  PRIMARY KEY (activity_id, tag_id),
  FOREIGN KEY (activity_id) REFERENCES activities(activity_id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE CASCADE
);
