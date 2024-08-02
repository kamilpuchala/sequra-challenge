# README

## Table of Contents
1. [Description](#description)
2. [How to run](#how-to-run)
    - [Technologies used](#technologies-used)
    - [Steps to run the project](#steps-to-run-the-project)
    - [Endpoints](#endpoints)
    - [Background jobs](#background-jobs)
3. [Calculations](#calculations)
4. [Improvements](#improvements)

## Description:

This is a backend coding challenge for a company [seQura](https://www.sequra.com/).
Details of the challenge can be found [here](https://sequra.github.io/backend-challenge/).

## How to run:

Ensure you have the following prerequisites installed:
- Ruby 3.2.2
- Rails 7.1.3
- SqlLite3 
- Redis (please make sure you have Redis installed and running - add `REDIS_URL` to your environment variables as in `.env.sample`)
- Sidekiq (for background jobs)
- Rspect (for testing - run `rspec` to run the tests)

Set up your environment variables:
1. Copy `.env.sample` to `.env`
2. Fill in the required variables, specifically `REDIS_URL`

### Steps to run the project:

1. Clone the repository: [Repository](https://github.com/kamilpuchala/sequra-challenge)
2. Install dependencies `bundle install`
3. Set up database: `rails db:create db:migrate`
4. Download `merchants.csv` and `orders.csv` files and copy to `tmp/initial_data` folder. Files can be found [here](https://drive.google.com/drive/folders/1xhfz9_3YqUmRT05mvRRLxBcaLv1kWRlR?usp=sharing)
5. Import initial merchants: `rails merchants_initial:import`
6. Import initial orders: `rails orders_initial:import` - it can take a while (10-20 minutes)
8. Calculate initial disbursements: `rails initial_disbursements_create:create` - it will calculate disbursements for an existing historical data.
9. Calcualte initial monthly fee: `rails initial_monthly_fee_create:create` - it will calculate monthly fees for an existing historical data.
10. Start the server: `rails s` 
11. Start sidekiq for background jobs: `bundle exec sidekiq` 

### Endpoints:

1. **Create a new merchant:**
```
POST /merchants

example request body:
{ "merchant": 
    {
        "external_id": "merchant_id",
        "reference": "company_name", 
        "email": "email@email.com", 
        "live_on": "2024-07-20", 
        "disbursement_frequency": "DAILY"(options: "DDAILY"/"WEEKLY"),
        "minimum_monthly_fee": "20"
    }
}
```
2. **Create a new order:**
```
POST /orders

example request body:
{ "order": 
    {
        "merchant_reference": "company_name"(it must coresponde to the merchant reference), 
        "date": "2024-07-29",
        "amount": 50555
    }
}
```
### Background jobs:
1.**Calculate disbursements for a specific merchant:**
```
CreateDisbursementWorker
```
- It will calculate disbursements for merchants that have `disbursement_frequency` set to `DAILY`(yesterday disbursments) or `WEEKLY`(disbursements from previous week) if yesterday is corresponding to the live_on day week for merchant. 
- It's run every day at 01:00 AM UTC.
2. **Calculate monthly fees for a specific merchant:**
```
CreateMonthlyFeesWorker
```
- It will calculate `charged_amount` for merchants and `fee_to_charge` if the `charged_amount` is less than `minimum_monthly_fee`.
- It's run every month at 06:00 AM on day-of-month 2.
- Calculations are based on the previous month disbursements.
- `*Note`: For merchants which have `disbursement_frequency` set to "WEEKLY" the monthly fee is calculated based on the disbursements date calculation in a month. Which can include orders from the previous month as well as exclude orders from the current month. Which depend on merchant live_on date and first/last date of the month. 

## Calculations:

Year | Number of disbursements | Total orders Amount |Amount disbursed to merchants | Amount of order fees |Number of monthly fees charged (From minimum monthly fee) |Amount of monthly fee charged (From minimum monthly fee)
--- | --- |---------------------|-------------------------------------------|-------------------| --- | ---
2022 | 1767 | 37 852 696.71       | 37 513 725.45         | 338 971.26        | 31 | 574.2
2023 | 11990 | 189 684 161.2       | 187 980 225.81      | 1 703 935.39      | 154 | 2863.51

Calculation notice:
1. Disbursements are calculated based on the orders from the previous day or the previous week.
2. For monthly/yearly calculations, weekly disbursements may included orders from previous month/year, depends on the merchant's `live_on` date.
3. Last order(imported from the file) was made in 2023-11-07, calculations are done till the end of 2023. Which may increases the number of charged minimum monthly fees. I assume that merchants stop using this payment method but still has valid contracts with the company.
4. For disbursements initial calculation, time period was set from first order date to the last order date + 6.days, to ensure that all of orders for merchant with weekly `disbursement_frequency` will be included. Initial calculation should be run with production deploy and next calculations should be run by background jobs as a life system.  

## Improvements
1. Extend API with endpoints for dashboard and automatic report send to the client.
2. Add authorization and authentication to the API.
3. Prepare production release with initial data import and switch to background jobs for disbursements and monthly fees calculations.


## Contact Information

For any questions or support, please contact:

- [Kamil Puchala](mailto:kamilpuchalaa@gmail.com)
