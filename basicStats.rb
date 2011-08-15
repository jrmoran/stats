# # Basic Statistics
#
# Jaime Moran 2011.
#
# ## Sumary
#
# Let `a = [1, 2, 3, 4, 5]`
#
#     require './basicstats.rb'
#
#     a.sum                     => 15
#     a.cumsum                  => [1 3 6 10 15]
#     a.mean                    => 3
#     a.variance_p              => 2
#     a.standard_deviation_p    => 1.414
#     a.variance                => 2.5
#     a.standard_deviation      => 1.581
#     a.sum_squared_deviations  => 10
#

module Enumerable

  # ## Sum
  #
  #     ∑ (xi....xn)

  def sum
    self.inject(:+)
  end

  # ## Cumulative Sum
  #
  #    xi = xi + xi-1
  #
  def cumsum
    cumsum = [ self.first ]
    self.each_with_index{ |x, i|
      cumsum[i] = self[i] + cumsum[ i - 1 ] unless i == 0
    }
    return cumsum
  end

  # ## Mean
  #
  #     ∑ (xi....xn)
  #     ____________
  #           n

  def mean
    self.sum / self.size.to_f
  end

  # ## Variance ( population )
  # It's the mean of the total sum of squares
  #
  #     ∑ (xi - xBar)^2
  #     --------------
  #           n

  def variance_p
    self.sum_squared_deviations / self.size.to_f
  end

  # ## Standard Deviation ( population )
  def standard_deviation_p
    Math.sqrt(self.variance_p)
  end

  # ## Variance ( sample )
  # Similar to the population variance, with the exception that the sum
  # of squares is divided by `n-1` where `n` is the sample size.
  #
  #     ∑ (xi - xBar)^2
  #     --------------
  #         n - 1

  def variance
    self.sum_squared_deviations / (self.size - 1).to_f
  end

  # ## Standard Deviation ( sample )
  def standard_deviation
    Math.sqrt(self.variance)
  end

  # ## Sum of Squared Deviations
  # Is the sum of the squares of the difference between the 
  # dependent variable and its mean
  #
  #     ∑ (xi - xBar)^2
  #
  def sum_squared_deviations
    mean = self.mean
    self.map{|x| (x - mean) ** 2}.sum
  end
end
