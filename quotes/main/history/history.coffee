if Meteor.isClient

  # http://www.highcharts.com/docs/working-with-data/data-module
  Template.history.helpers
    id: -> Session.get 'id'
    quot: ->
      results = Session.get 'history'
      if results?
        row = results.rows[0]
        return "行情：Date #{row.DATE} Code #{row.CODE} Close #{row.TCLOSE}"
        #return "#{results.symbol}#{results.name}: #{results.price}"

  renderChart = ->

    ($ "#container-remote").highcharts "StockChart",
      rangeSelector:
        selected: 1

      title:
        text: Session.get 'id'
      subtitle:
        text: 'realtime'
      series: [{
        name: Session.get 'id'
        type: 'candlestick'
        data: Session.get 'history'
        tooltip:
          valueDecimals: 3
        }
      ]

  Template.history.rendered = ->
    # http://www.highcharts.com/docs/getting-started/how-to-set-options
    Highcharts.setOptions
      chart:
        backgroundColor:
          linearGradient: [0, 500, 0, 500]
          stops: [
              [0, 'rgb(255, 255, 255)']
              [1, 'rgb(240, 240, 255)']
          ]
        borderWidth: 2
    renderChart()

    $.get 'test.csv', (csv)->
      ($ '#container').highcharts
          chart:
              type: 'column'

          data:
              csv: csv

          title:
              text: 'Fruit Consumption'

          yAxis:
              title:
                  text: 'Units'


  Template.cardHeading.events
    'change .stocks': (e,t) ->
      stock = (t.find '.stocks').value
      source = '163.com' # history

      Session.set 'id', stock
      date = new Date()
      end = date.year * 1000 + date.hour * 100 + date.day
      GetData.quotes {source: source, ids: stock, start:20080801, end:end}, (data)->

        # dealing with the data here, for this case it's for a single stock
        Session.set 'history', GetData.rows
        renderChart()

        #Session.set 'data', GetData.rows
