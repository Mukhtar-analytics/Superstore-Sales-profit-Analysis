# Data Model — Star Schema

This project uses a **Star Schema** design in Power BI to support efficient DAX calculations and clear, scalable analysis. The raw, cleaned dataset (`orders1`) produced by the SQL pipeline was decomposed in Power Query into one fact table and five dimension tables.

![Star Schema Model](../assets/star_schema_model.png)

## Data Sources

Three raw tables are available in `data/`: `orders1`, `people`, and `returns`.

- **`orders1`** is the primary source for the entire model — split into `Fact Sales` and all five dimension tables.
- **`people`** was partially used: a relevant column was merged directly into `Dim Customer` during Power Query preparation, rather than kept as a separate dimension.
- **`returns`** was not used in this version of the analysis. It is included as raw data for potential future work, such as a returns-rate or product-quality analysis page.

## Fact Table

### `Fact Sales`
Contains the transactional measures and foreign keys linking to each dimension.

| Column | Type | Description |
|---|---|---|
| Order ID | Key | Links to `Dim Orders` |
| Product ID | Key | Links to `Dim Product` |
| Customer ID | Key | Links to `Dim Customer` |
| Order Date | Key | Links to `Dim Order Date` |
| Discount | Measure | Discount applied to the order line |
| Profit | Measure | Profit generated |
| Quantity | Measure | Units sold |

## Dimension Tables

### `Dim Customer`
Customer attributes: `customer id`, `customer name`, `city`, `country`.

### `Dim Product`
Product attributes: `Product ID`, `Product Name`, `Category`, `Sub-Category`, `Segment`.

### `Dim Orders`
Order-level attributes: `Order ID`, `Order Priority`, `Ship Mode`.

### `Dim Order Date`
A standalone calendar table built with Power Query (M code), used to analyze orders by day, month, quarter, and year. Includes calculated columns such as `Day Name`, `Month Name`, `Quarter`, `Is Weekend`, `Start Of Month`, and `End Of Month`.

### `Dim Ship Date`
A second, independent calendar table — built by duplicating the `Dim Order Date` M query — used specifically for shipping-date analysis (e.g., delivery time trends). Kept as a separate table rather than a role-playing dimension so both date relationships can remain active simultaneously.

## Relationships

All relationships are **one-to-many (1:*)**, flowing from each dimension table into `Fact Sales`:

| From (1) | To (*) |
|---|---|
| Dim Orders | Fact Sales |
| Dim Product | Fact Sales |
| Dim Customer | Fact Sales |
| Dim Order Date | Fact Sales |
| Dim Ship Date | Fact Sales |

## Why This Design?

- **Performance:** Star schemas minimize the number of joins DAX needs to traverse, improving query and visual load speed.
- **Clarity:** Separating descriptive attributes (dimensions) from transactional facts makes the model easier to navigate and maintain.
- **Two independent date tables:** Since a single order has two distinct dates (order date and ship date), duplicating the calendar table avoids the complexity of managing active/inactive relationships and `USERELATIONSHIP()` in every time-based measure.
