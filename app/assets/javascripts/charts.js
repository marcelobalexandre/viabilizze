$(document).on('page:change', function() {
    if ($("#doughnut-chart").get(0))
    {
        var url = $("span[data-charts-url]").data("charts-url");
        $.ajax({
            type: 'GET',
            dataType: "json",
            url: url,
            success: function(data, status, xhr) {
                createChart(data);
            },
            error: function(xhr, status, error) {
                console.log(xhr);
                alert(error);
            }
        });


    }
});

function createChart(data) {
    var context = $("#doughnut-chart").get(0).getContext("2d");

    var data = [
        {
            value: parseFloat(data.construction_costs).toFixed(2),
            color:"#F7464A",
            highlight: "#FF5A5E",
            label: "Custo de Construção das Unidades"
        },
        {
            value: parseFloat(data.individualization_costs).toFixed(2),
            color: "#46BFBD",
            highlight: "#5AD3D1",
            label: "Individualização"
        },
        {
            value: parseFloat(data.land_acquisition_cost).toFixed(2),
            color: "#FDB45C",
            highlight: "#FFC870",
            label: "Terreno"
        },
        {
            value: parseFloat(data.sales_commissions).toFixed(2),
            color: "#365BB0",
            highlight: "#5777C0",
            label: "Comissões"
        },
        {
            value: parseFloat(data.sales_taxes).toFixed(2),
            color: "#2ECF2E",
            highlight: "#54D954",
            label: "Impostos sobre Vendas"
        },
        {
            value: parseFloat(data.sales_charges).toFixed(2),
            color: "#BB2A9F",
            highlight: "#C94EB2",
            label: "Outras Taxas sobre Vendas"
        },
        {
            value: parseFloat(data.exchanged_units_expenses).toFixed(2),
            color: "#FFFF39",
            highlight: "#FFFF63",
            label: "Outras Despesas de Permuta"
        }
    ]

    var options = {
        tooltipTemplate: "<%= numberToCurrency(value) %>",
        legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<segments.length; i++){%><li><span style=\"background-color:<%=segments[i].fillColor%> !important\"></span><%if(segments[i].label){%><%=segments[i].label%> <div class=\"right\"><%=numberToCurrency(segments[i].value)%></div><%}%></li><%}%></ul>"
    }

    var doughnutChart = new Chart(context).Doughnut(data, options);
    document.getElementById('doughnut-chart-legend').innerHTML = doughnutChart.generateLegend();
}

function numberToCurrency(num) {
    var number = numeral(num);

    numeral.defaultFormat('$ 0,0.00');
    numeral.language('pt-br');

    return number.format();
}