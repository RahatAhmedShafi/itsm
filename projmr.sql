-- Active: 1731659303838@@127.0.0.1@3306@projmr
Create ER Diagram for this mysql code
-- Step 0: Create Database
CREATE DATABASE IF NOT EXISTS it_service_management;
USE it_service_management;

-- Step 1: Create departments table (without manager_id foreign key for circular reference)
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL,
    manager_id INT -- Will reference employees later
);

-- Step 2: Create employees table
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
);

-- Step 3: Add foreign key for manager_id in departments table
ALTER TABLE departments
ADD CONSTRAINT fk_manager FOREIGN KEY (manager_id) REFERENCES employees(employee_id) ON DELETE SET NULL;

-- Step 4: Create services table
CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(255) NOT NULL,
    description TEXT,
    cost DECIMAL(10, 2)
);
-- Step 5: Create projects table (used in tasks and collaborations)
CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(255) NOT NULL,
    description TEXT
);
-- Step 6: Create tasks table
CREATE TABLE tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    task_name VARCHAR(255) NOT NULL,
    project_id INT,
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE
);
-- Step 7: Create testers table
CREATE TABLE testers (
    tester_id INT AUTO_INCREMENT PRIMARY KEY,
    tester_name VARCHAR(255) NOT NULL,
    assigned_task_id INT,
    FOREIGN KEY (assigned_task_id) REFERENCES tasks(task_id) ON DELETE SET NULL
);
-- Step 8: Create task history table
CREATE TABLE task_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    change_description TEXT NOT NULL,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE
);
-- Step 9: Create user skills table
CREATE TABLE user_skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    skill_name VARCHAR(255) NOT NULL,
    skill_level ENUM('Beginner', 'Intermediate', 'Expert'),
    FOREIGN KEY (user_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);
-- Step 10: Create project risks table
CREATE TABLE project_risks (
    risk_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    risk_description TEXT NOT NULL,
    risk_level ENUM('Low', 'Medium', 'High'),
    mitigation_plan TEXT,
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE
);
-- Step 11: Create task timer table
CREATE TABLE task_timer (
    timer_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    employee_id INT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NULL,
    total_time_spent TIME GENERATED ALWAYS AS (TIMEDIFF(end_time, start_time)),
    FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);
-- Step 12: Create feedback table
CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    feedback_text TEXT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    feedback_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);
-- Step 13: Create user rewards table
CREATE TABLE user_rewards (
    reward_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    reward_name VARCHAR(255) NOT NULL,
    reward_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);
-- Step 14: Create calendar events table
CREATE TABLE calendar_events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    event_title VARCHAR(255) NOT NULL,
    event_date DATE NOT NULL,
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);
-- Step 15: Create collaborations table
CREATE TABLE collaborations (
    collaboration_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    collaborator_id INT NOT NULL,
    collaboration_details TEXT,
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (collaborator_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);
-- Step 16: Create admin table
CREATE TABLE admin_users (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('Super Admin', 'Moderator', 'Support') DEFAULT 'Moderator',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Active', 'Inactive') DEFAULT 'Active'
);
-- Step 17: Create customers table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    contact_info TEXT
);
-- Step 18: Create transactions table
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT NOT NULL,
    customer_id INT NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (admin_id) REFERENCES admin_users(admin_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);
