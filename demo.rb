require_relative 'lib/pattern-matching-prototype'

include PatternMatchingPrototype

def parse_coord(lat, *lngs)
  lng, opts = nil # binding will need that

  print "parsing (%p, *%p) => " % [lat, lngs]

  # library syntax                                  # imaginary proposed Ruby core syntax
  # --------------                                  # -----------------------------------
  case [lat, *lngs]                                 # case (lat, *lngs)
  when M(String)                                    # when (String)
    puts "one string"
  when M(Integer, Integer => :lng)                  # when (Integer, Integer => lng)
    puts "two integers %p, %p" % [lat, lng]
  when M(Integer, Integer => :lng, Hash => :opts)   # when (Integer, Integer => lng, Hash => opts)
    puts "two integers & opts: %p, %p, %p" %
      [lat, lng, opts]
  when M(Integer, *Integer)                         # when (Integer, *Integer)
    puts "integer + array of integers"
  when M(_, _, Hash => :opts)                       # when (_, _, Hash => opts)
    puts "something + Hash %p" % opts
  else
    puts "no matches"
  end
end

parse_coord(10, 20)
parse_coord('10,20')
parse_coord(10, 20, rectangular: true)
parse_coord(10, 20, 30)
parse_coord('foo', 'bar', rectangular: true)
parse_coord('10,20', 30)    # Note that (String) pattern should NOT match this
parse_coord(10, 20, '30')   # Note that (Integer, *Integer) pattern should NOT match this
