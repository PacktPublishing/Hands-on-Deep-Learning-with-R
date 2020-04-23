train_gen <- timeseries_generator(
  closing_deltas,
  closing_deltas,
  length = 3,
  sampling_rate = 1,
  stride = 1,
  start_index = 1,
  end_index = 1258,
  shuffle = FALSE,
  reverse = FALSE,
  batch_size = 1
)

test_gen <- timeseries_generator(
  closing_deltas,
  closing_deltas,
  length = 3,
  sampling_rate = 1,
  stride = 1,
  start_index = 1259,
  end_index = 1507,
  shuffle = FALSE,
  reverse = FALSE,
  batch_size = 1
)