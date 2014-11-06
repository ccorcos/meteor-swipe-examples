@sign = (x) ->
  if x >= 0 then return 1 else return -1

@bound = (min, max, n) ->
  Math.min(Math.max(min, n), max)

@wrap = (min, max, n) ->
  if n < min
    return max - (min - 1) - 1
  else if n > max
    return min + (n - max) - 1
  else
    return n

@delay = (ms, func) -> setTimeout func, ms
