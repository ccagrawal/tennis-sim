$(document).ready(function() {
  Highcharts.setOptions({
    global: {
      useUTC: true
    }
  });

  $("#simChart").highcharts({
    chart: {
      marginRight: 10,
      borderWidth: 2,
      height: 300,
      width: 600
    },
    title: {
      text: "Simulation Results"
    },
    xAxis: {
      categories: ['Points', 'Games', 'Tiebreakers', 'Sets', 'Matches']
    },
    yAxis: {
      title: {
        text: "Win Percentage"
      },
      min: 0,
      max: 1
    },
    tooltip: {
      shared: true
    },
    legend: {
      enabled: false,
      floating: false
    },
    series: [{
      name: 'Probability',
      type: 'bar',
      data: [.5, .5, .5, .5, .5],
      tooltip: {
        pointFormat: '<b>{series.name}:</b> {point.y:.3f}<br>'
      }
    }, {
      name: '95% Confidence Interval',
      type: 'errorbar',
      color: '#0038A8',
      lineWidth: 4,
      whiskerLength: "50%",
      data: [[0, 1], [0, 1], [0, 1], [0, 1], [0, 1]],
      tooltip: {
        pointFormat: '<b>Range:</b> ({point.low: .3f}, {point.high: .3f})'
      }
    }]
  });


  // Handle messages from server - update graph
  Shiny.addCustomMessageHandler("updateHighchart",
    function(message) {
      var chart = $("#" + message.name).highcharts();
      var series = chart.series;

      series[0].data[0].update(Number(message.y0));
      series[0].data[1].update(Number(message.y1));
      series[0].data[2].update(Number(message.y2));
      series[0].data[3].update(Number(message.y3));
      series[0].data[4].update(Number(message.y4));
      
      series[1].data[0].update([Number(message.lb0), Number(message.ub0)]);
      series[1].data[1].update([Number(message.lb1), Number(message.ub1)]);
      series[1].data[2].update([Number(message.lb2), Number(message.ub2)]);
      series[1].data[3].update([Number(message.lb3), Number(message.ub3)]);
      series[1].data[4].update([Number(message.lb4), Number(message.ub4)]);
    }
  );
});