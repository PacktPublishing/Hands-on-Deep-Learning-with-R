future_prices <- fb_future$FB.Close

closing_deltas <- diff(log(rbind(closing_prices,future_prices)),lag=1)
closing_deltas <- closing_deltas[!is.na(closing_deltas)]

plot(closing_deltas,type='l', main='Facebook Daily Log Returns')

adf.test(closing_deltas)