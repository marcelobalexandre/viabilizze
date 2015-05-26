$(document).on('page:change', updateSellingPrice);

$(document).on('change', '[data-update-selling-price]', updateSellingPrice);

function updateSellingPrice() {
    var url = $("span[data-selling-price-url]").data("selling-price-url");

    $("input[data-unit]").each(function() {
        var input = $(this);
        var unit_id = input.data("unit");
        var net_profit_margin = $("input[data-net-profit-margin]").val();
        var sales_commissions_rate = $("input[data-sales-commissions-rate]").val();
        var sales_taxes_rate = $("input[data-sales-taxes-rate]").val();
        var sales_charges_rate = $("input[data-sales-charges-rate]").val();
        var individualization_costs = $("input[data-individualization-costs]").val() ? $("input[data-individualization-costs]").val() : '0';
        var cost_per_square_meter = $("input[data-cost-per-square-meter]").val() ? $("input[data-cost-per-square-meter]").val() : '0';
        var land_acquisition_cost = $("input[data-land-acquisition-cost]").val();
        var exchanged_units_expenses = $("input[data-exchanged-units-expenses]").val();

        selling_price = {
            net_profit_margin: net_profit_margin,
            sales_commissions_rate: sales_commissions_rate,
            sales_taxes_rate: sales_taxes_rate,
            sales_charges_rate: sales_charges_rate,
            individualization_costs: individualization_costs,
            cost_per_square_meter: cost_per_square_meter,
            land_acquisition_cost: land_acquisition_cost,
            exchanged_units_expenses: exchanged_units_expenses
        };

        $.ajax({
            type: 'GET',
            url: url,
            data: {
                unit_id: unit_id,
                selling_price: selling_price
            },
            success: function(data, status, xhr) {
                input.val(data.selling_price);
            },
            error: function(xhr, status, error) {
                console.log(xhr);
                alert(error);
            }
        });
    });
}