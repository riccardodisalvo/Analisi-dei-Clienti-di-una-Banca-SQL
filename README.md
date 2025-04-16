# Analysis of a Bank's Customers

## Project Overview

The Banking Intelligence company wants to develop a supervised machine learning model to predict future behaviors of its customers, based on transactional data and product ownership characteristics. The aim of the project is to create a denormalized table with a set of indicators (features) derived from the tables available in the database, which represent the behaviors and financial activities of customers.

## Key Objective

Goal is to create a feature table for training machine learning models by enriching customer data with various indicators calculated from their transactions and accounts held. The final table will be referenced by customer ID and will contain both quantitative and qualitative information.

## Key Indicators Explored

The indicators will be calculated for each individual customer (referred to customer_id) and include:

### 1. **Basic indicators**
 - Customer age (from customer table).
### 2. **Indicators on transactions**
 - Number of outgoing transactions on all accounts.
 - Number of incoming transactions on all accounts.
 - Total amount transacted out on all accounts.
 - Total amount transacted in on all accounts.
### 3. **Indicators on accounts**
 - Total number of accounts owned.
 - Number of accounts owned by type (one indicator for each account type).
### 4. **Indicators on transactions by account type**
 - Number of outgoing transactions by account type (one indicator for each account type).
 - Number of incoming transactions by account type (one indicator for each account type).
 - Amount transacted out by account type (one indicator for each account type).
 - Amount transacted in by account type (one indicator for each account type).

 ## Database Structure
 
The database ('db_bancario.sql') consists of the following tables:

- **Customer**: contains personal information about customers (for example, age).
- **Account**: contains information about the accounts held by customers.
- **Account_Type**: describes the different types of accounts available.
- **Transaction_Type**: contains the types of transactions that can occur on the accounts.
- **Transactions**: contains the details of transactions made by customers on the various accounts.

## Strategy used 

1. **Join Tables**
To build the final table, you will need to perform a series of joins between the tables available in the database.

2. **Calculate Indicators**
The behavioral indicators will be calculated using aggregation operations (SUM, COUNT) to obtain the required totals.
