# Warehouse Management System

## Overview

The Warehouse Management System (WMS) is a robust, enterprise-grade web application designed to streamline warehouse operations, including inventory tracking, outlet management, staff administration, and reporting. Built primarily using Java (Servlets, JSP), it provides a scalable solution for businesses to manage multiple warehouses/outlets, staff, and products efficiently.

---

## Features

- **User Authentication & Role Management**
  - Secure login for Head Office Admins and Outlet Admins
  - Role-based access to dashboards and functionalities

- **Outlet Management**
  - Add, view, update, and delete outlet details
  - Track performance metrics for each outlet

- **Staff Management**
  - Register, update, and remove staff members
  - Assign staff to specific outlets

- **Inventory & Product Tracking**
  - Register new products and manage existing inventory
  - View and report on product movement (inbound/outbound)

- **Order & Delivery Management**
  - Track product deliveries and returns
  - Generate monthly delivery and revenue reports

- **Rich Dashboards**
  - Visualize key metrics (registered items, returns, available stock, etc.)
  - Separate dashboards for Head Office and Outlet Admins

- **Data Analytics & Reporting**
  - Monthly sales and delivery analysis
  - Exportable reports for auditing and business insights

---

## System Architecture

- **Three-Tier/MVC Architecture**
  - **Presentation Layer**: JSP, HTML, CSS for user interfaces and dashboards
  - **Business Logic Layer**: Java Servlets handle requests and business rules
  - **Data Access Layer**: DAOs manage database operations (CRUD) with MySQL

- **Database**
  - MySQL with tables: `admin_register`, `staff_management`, `outlet_details`, `product_pricing`, etc.

---

## Technologies Used

- **Java** (Servlets, DAOs, Model Beans)
- **JSP** (JavaServer Pages)
- **JSTL** (JavaServer Pages Standard Tag Library)
- **CSS** (Custom styles for dashboards and forms)
- **MySQL** (Relational Database)
- **JDBC** (Database Connectivity)

---

## Getting Started

### Prerequisites

- JDK 8 or higher
- Apache Tomcat (or any compatible Java EE server)
- MySQL database
- Maven (for building the project)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/wathsaladmpgj/warehouse_management_system.git
   ```

2. **Configure the Database:**
   - Create a MySQL database named `warehouse_management`.
   - Import the provided SQL schema (`/db/warehouse_management.sql` if available).
   - Update database credentials in the DAO classes (e.g., `DBConnection.java`).

3. **Build & Deploy:**
   - Build the project using Maven:
     ```bash
     mvn clean package
     ```
   - Deploy the generated WAR file to your Tomcat server’s `webapps` directory.


## Usage

- **Head Office Admin:** Manage all outlets, view global reports, add new admins/staff, and access advanced analytics.
- **Outlet Admin:** Manage outlet-specific inventory, staff, and orders.
- **Staff:** (if applicable) Carry out operational tasks as assigned.

---

## Acknowledgements

- Java EE and MySQL communities for tools and libraries
- All contributors and testers



