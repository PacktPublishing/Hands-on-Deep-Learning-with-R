library(quantmod)
library(tseries) 
library(ggplot2)
library(timeSeries)
library(forecast)
library(xts)
library(keras)
library(tensorflow)

FB <- getSymbols('FB', from='2014-01-01', to='2018-12-31', source = 'google', auto.assign=FALSE)

FB[1:5,]

closing_prices <- FB$FB.Close

plot.xts(closing_prices,main="Facebook Closing Stock Prices")

arima_mod <- auto.arima(closing_prices)

forecasted_prices <- forecast(arima_mod,h=365)

autoplot(forecasted_prices)

fb_future <- getSymbols('FB', from='2019-01-01', to='2019-12-31', source = 'google', auto.assign=FALSE)

future_values <- ts(data = fb_future$FB.Close, start = 1258, end = 1509)

autoplot(forecasted_prices) + autolayer(future_values, series="Actual Closing Prices")