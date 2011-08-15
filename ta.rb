# # Technical Analysis Library v 0.1
#
# Jaime Moran 2011
#

class TA

  # The class operates on an array of closing prices
  def initialize close
    @close = close
  end

  # ## Returns
  #
  #     close - prevClose / prevClose
  #
  def tick2ret

    # this will skip the first element
    (1..@close.length-1).each.collect { |i|
      (@close[i] - @close[i-1]) / (@close[i-1]).to_f
    }.unshift(0) # prepend a 0

  end

  # ## Change
  #
  #     close - prevClose
  #
  def change

    (1..@close.length-1).each.collect { |i|
      @close[i] - @close[i-1]
    }.unshift(0)

  end

  # ## Cumulative Sum
  #
  #    xi = xi + xi-1
  #
  def cumsum
    ret = [ @close.first ]
    (1..@close.length-1).each{ |i| ret[i] = ret[i-1] + @close[i] }
    return ret
  end

  # ## EMA
  #
  # Exponential Moving Averages
  #
  # * `n` is the period
  #
  # The formula is
  #
  #     current_EMA = (( current_close - prev_EMA ) x multiplier) + prev_EMA
  #
  def ema n

    multiplier = 2 / (1 + n).to_f

    # Items with index below `n` are filled with zeros
    result = (1..n-1).collect{nil}

    # At index `n` store the average of the previous `n` items
    result << @close.take(n).inject(:+)/n

    # iterate items in `x` exluding those with an index below `n`
    (n..@close.length-1).each do |i|
      result << ( @close[i] - result[i-1] ) * multiplier + result[i-1]
    end

    return result
  end

  # ## SMA
  #
  # Simple Moving Averages
  #
  def sma n
    result = (1..n-1).collect{0}
    (n-1..@close.length-1).each do |i|
      # compute average of the last `n` items
      result << @close[i-n+1..i].inject(:+)/n
    end
    return result
  end
end
