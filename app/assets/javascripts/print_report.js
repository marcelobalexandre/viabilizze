$(document).on('page:change', function() {
    $("#print-report-button").click(function() {
        if ($("#doughnut-chart").get(0)) {
            var doughnutChartURL = $("#doughnut-chart").get(0).toDataURL();
        }

        print();
    });
});