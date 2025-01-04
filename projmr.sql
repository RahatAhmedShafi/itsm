-- Active: 1731659303838@@127.0.0.1@3306@projmr


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
    cost DECIMAL(10, 2),
    department_id INT, -- Foreign key column
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
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
-- Step 19: Create application usage table
CREATE TABLE application_usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    application_name VARCHAR(100) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    duration TIME GENERATED ALWAYS AS (TIMEDIFF(end_time, start_time)) STORED,
    task_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (task_id) REFERENCES tasks(task_id)
);

-- Insert data into departments
INSERT INTO departments (department_name, manager_id) VALUES
('IT', NULL), ('HR', NULL), ('Finance', NULL);

-- Insert data into employees
INSERT INTO employees (full_name, email, phone_number, department_id) VALUES
('John Doe', 'john.doe@example.com', '1234567890', 1),
('Jane Smith', 'jane.smith@example.com', '0987654321', 2),
('Alice Brown', 'alice.brown@example.com', '1122334455', 3);

-- Update departments with manager IDs
UPDATE departments SET manager_id = 1 WHERE department_name = 'IT';
UPDATE departments SET manager_id = 2 WHERE department_name = 'HR';

-- Insert data into services
INSERT INTO services (service_name, description, cost) VALUES
('Web Hosting', 'Basic hosting service', 19.99),
('Cloud Storage', 'Secure cloud storage', 49.99);

-- Insert data into projects
INSERT INTO projects (project_name, description) VALUES
('Project Alpha', 'Development of a new product'),
('Project Beta', 'Enhancement of an existing system');

-- Insert data into tasks
INSERT INTO tasks (task_name, project_id) VALUES
('Design UI', 1), ('Develop Backend', 1), ('Testing', 2);

-- Insert data into testers
INSERT INTO testers (tester_name, assigned_task_id) VALUES
('Tester A', 3), ('Tester B', 3);

-- Insert data into task history
INSERT INTO task_history (task_id, change_description) VALUES
(1, 'Initial Design Completed'), (2, 'Backend API Integration Started');

-- Insert data into user skills
INSERT INTO user_skills (user_id, skill_name, skill_level) VALUES
(1, 'Python', 'Expert'), (2, 'JavaScript', 'Intermediate');

-- Insert data into project risks
INSERT INTO project_risks (project_id, risk_description, risk_level, mitigation_plan) VALUES
(1, 'Scope Creep', 'High', 'Define clear project boundaries'),
(2, 'Resource Availability', 'Medium', 'Ensure proper resource allocation');

-- Insert data into task timer
INSERT INTO task_timer (task_id, employee_id, start_time, end_time) VALUES
(1, 1, '2024-01-01 10:00:00', '2024-01-01 12:00:00'),
(2, 2, '2024-01-02 11:00:00', '2024-01-02 13:00:00');

-- Insert data into feedback
INSERT INTO feedback (user_id, feedback_text, rating) VALUES
(1, 'Great performance!', 5), (2, 'Needs improvement in time management', 3);

-- Insert data into user rewards
INSERT INTO user_rewards (user_id, reward_name) VALUES
(1, 'Employee of the Month'), (3, 'Top Performer Award');

-- Insert data into calendar events
INSERT INTO calendar_events (event_title, event_date, employee_id) VALUES
('Team Meeting', '2024-01-10', 1), ('Project Deadline', '2024-01-15', 2);

-- Insert data into collaborations
INSERT INTO collaborations (project_id, collaborator_id, collaboration_details) VALUES
(1, 1, 'Leading the design phase'), (2, 2, 'Assisting with testing');

-- Insert data into admin_users
INSERT INTO admin_users (username, password, role, status) VALUES
('admin1', 'password1', 'Super Admin', 'Active'),
('admin2', 'password2', 'Moderator', 'Active');

-- Insert data into customers
INSERT INTO customers (customer_name, contact_info) VALUES
('Customer A', 'contact@example.com'), ('Customer B', 'phone:1234567890');

-- Insert data into transactions
INSERT INTO transactions (admin_id, customer_id, transaction_amount) VALUES
(1, 1, 199.99), (2, 2, 299.99);


