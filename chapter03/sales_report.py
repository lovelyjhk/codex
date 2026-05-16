sales = [
    {"month": "2026-01", "product": "Notebook", "region": "Seoul", "quantity": 12, "unit_price": 3500},
    {"month": "2026-01", "product": "Pen", "region": "Busan", "quantity": 50, "unit_price": 800},
    {"month": "2026-02", "product": "Planner", "region": "Seoul", "quantity": 8, "unit_price": 12000},
    {"month": "2026-02", "product": "Binder", "region": "Incheon", "quantity": 15, "unit_price": 4500},
    {"month": "2026-03", "product": "Notebook", "region": "Daegu", "quantity": 20, "unit_price": 3500},
    {"month": "2026-03", "product": "Planner", "region": "Busan", "quantity": 6, "unit_price": 12000},
]


def calculate_revenue(item):
    return item["quantity"] * item["unit_price"]


def calculate_monthly_revenue(sales_data):
    revenue_by_month = {}
    for item in sales_data:
        month = item["month"]
        revenue_by_month[month] = revenue_by_month.get(month, 0) + calculate_revenue(item)

    return revenue_by_month


def calculate_product_revenue(sales_data):
    revenue_by_product = {}
    for item in sales_data:
        product = item["product"]
        revenue_by_product[product] = revenue_by_product.get(product, 0) + calculate_revenue(item)

    return revenue_by_product


def build_report(sales_data):
    total_revenue = sum(calculate_revenue(item) for item in sales_data)
    average_revenue = total_revenue / len(sales_data)
    best_seller = max(sales_data, key=calculate_revenue)

    revenue_by_region = {}
    for item in sales_data:
        region = item["region"]
        revenue_by_region[region] = revenue_by_region.get(region, 0) + calculate_revenue(item)

    return {
        "total_revenue": total_revenue,
        "average_revenue": average_revenue,
        "best_seller": best_seller,
        "revenue_by_region": revenue_by_region,
        "revenue_by_month": calculate_monthly_revenue(sales_data),
        "revenue_by_product": calculate_product_revenue(sales_data),
    }


def print_report(report):
    print("Sales Report")
    print("=" * 30)
    print(f"Total revenue: {report['total_revenue']:,} KRW")
    print(f"Average revenue per item: {report['average_revenue']:,.0f} KRW")
    print(
        "Best seller: "
        f"{report['best_seller']['product']} "
        f"({calculate_revenue(report['best_seller']):,} KRW)"
    )

    print("\nRevenue by region")
    for region, revenue in sorted(report["revenue_by_region"].items()):
        print(f"- {region}: {revenue:,} KRW")

    print("\nRevenue by month")
    for month, revenue in sorted(report["revenue_by_month"].items()):
        print(f"- {month}: {revenue:,} KRW")

    print("\nRevenue by product")
    for product, revenue in sorted(
        report["revenue_by_product"].items(),
        key=lambda item: item[1],
        reverse=True,
    ):
        print(f"- {product}: {revenue:,} KRW")


if __name__ == "__main__":
    sales_report = build_report(sales)
    print_report(sales_report)
