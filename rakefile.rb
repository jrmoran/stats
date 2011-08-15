require 'yaml'
require './ta'
#require './tastrats'
require './basicstats'

#require 'bigdecimal'
#require 'bigdecimal/util'

desc 'create documentation'
task :doc do
  sh 'docco *.rb'
end

task :default => ['test:all']

# ## Testing Tasks

namespace :test do

  # ### preparing data
  goog    = YAML.load_file 'data/goog.yml'
  close   = goog['close'].reverse
  change  = goog['change'].reverse
  cumsum = goog['cumsum'].reverse
  returns = goog['returns'].reverse
  sma10   = goog['sma10'].reverse
  ema10   = goog['ema10'].reverse
  ema12   = goog['ema12'].reverse

  show_diag = false

  # ## All Tests
  desc 'Run all tests'
  task :all => ['ta', 'stats']

  # ### TA Tests
  desc 'Run tests for Technical Analysis Library'
  task :ta do
    ta = TA.new close

    puts "\n======= TESTING TA ======="


    print "\nReturns ................."
    print returns == ta.tick2ret.collect{|x| x.round(3)} ? 'OK' : 'FAIL'
    show returns, ta.tick2ret if show_diag

    print "\nChange .................."
    print change == ta.change.collect{|x| x.round(3)} ? 'OK' : 'FAIL'
    show change, ta.change if show_diag

    print "\nCum Sum ................." 
    print cumsum == ta.cumsum.collect{|x| x.round(3)} ? 'OK' : 'FAIL'
    show cumsum, ta.cumsum if show_diag

    print "\nSMA 10 .................." 
    print sma10 == ta.sma(10).collect{|x| x.round(3)} ? 'OK' : 'FAIL'
    show sma10, ta.sma(10) if show_diag

    print "\nEMA 10 .................." 
    print ema10 == ta.ema(10).collect{|x| x.round(3) if x } ? 'OK' : 'FAIL'
    show ema10, ta.ema(10) if show_diag

    print "\nEMA 12 .................." 
    print ema12 == ta.ema(12).collect{|x| x.round(3) if x } ? 'OK' : 'FAIL'
    show ema12, ta.ema(12) if show_diag

    puts "\n========== DONE =========="
  end

  # ### STATS Tests
  desc 'Run tests for Basic Statistics Library'
  task :stats do

    print "\nSUM ....................." 
    print goog['sum'] == close.sum ? 'OK' : 'FAIL' 

    print "\nCUMSUM .................." 
    print cumsum == close.cumsum.map{ |x| x.round(3)}  ? 'OK' : 'FAIL' 
    show cumsum, close.cumsum if show_diag

    print "\nMEAN ...................." 
    print goog['mean'] == close.mean.round(3) ? 'OK' : 'FAIL' 
    print "\nMean is #{close.mean.round(3)}\n" if show_diag

    print "\nVARIANCE (P) ............" 
    print goog['varp'] == close.variance_p.round(3) ? 'OK' : 'FAIL'
    print "\nVariance is #{close.variance_p.round(3)}\n" if show_diag

    print "\nSTD DEV (P) ............." 
    print goog['stdevp'] == close.standard_deviation_p.round(3) ? 'OK' : 'FAIL'
    print "\nSTD DEV is #{close.standard_deviation_p.round(3)}\n" if show_diag

    print "\nVARIANCE (S) ............" 
    print goog['var'] == close.variance.round(3) ? 'OK' : 'FAIL'
    print "\nVariance is #{close.variance.round(3)}\n" if show_diag

    print "\nSTD DEV (S) ............." 
    print goog['stdev'] == close.standard_deviation.round(3) ? 'OK' : 'FAIL'
    print "\nSTD DEV is #{close.standard_deviation.round(3)}\n" if show_diag

    print "\nSum Squared Dev ........." 
    print goog['devsq'] == close.sum_squared_deviations.round(3) ? 'OK' : 'FAIL'
    print "\nSTD DEV is #{close.sum_squared_deviations.round(3)}\n" if show_diag

    puts "\n========== DONE =========="
  end
end

def show arr1, arr2
  puts "\nShow\n"
  arr1.zip(arr2).each{|x| puts x.map{|x| x.round(4) if x }.join "\t" }
end

def ema_report close, res
  # Display
  puts "series\tchange\tema(5)\tema(20)\tpositions\tpnl\tequity"
  close.zip(res[:change], 
            res[:lead], 
            res[:lag], 
            res[:pos], 
            res[:pnl], 
            res[:equity]).each{ |x| puts x.map{|y| y.round(4) if y }.join "\t"
  }

  puts "Sharpe Ratio is #{res[:sh].round(5)}"
end
