This is _proof-of-concept_ (released as a gem just for the sake of experimentation) for a discussion of how the reasonable amount of _new_ pattern-matching features in Ruby language core could look.

The detailed description and discussion of problem scope could be found in a corresponding [blog post](https://zverok.github.io/blog/2018-06-26-pattern-matching.html).

Here, just to show the idea, the small example of "imaginary" syntax of enhanced `case` matching:

```ruby
def parse_coord(lat, *lngs)
  print "parsing (%p, *%p) => " % [lat, lngs]

  case (lat, *lngs)                       # several variables can be matched at once
  when (String)
    puts "one string"
  when (Integer, Integer => lng)          # matched sub-pattern could be bound to local variable
    puts "two integers %p, %p" %
      [lat, lng]
  when (Integer, Integer => lng, Hash => opts)
    puts "two integers & opts: %p, %p, %p" %
      [lat, lng, opts]
  when (Integer, *Integer)                # array of objects of same type matched with "splat" syntax
    puts "integer + array of integers"
  when (_, _, Hash => opts)               # _ is skip/match any value
    puts "something + Hash %p" % opts
  else
    puts "no matches"
  end
end

parse_coord(10, 20)                     # (Integer, Integer => lng) pattern works
parse_coord('10,20')                    # (String)
parse_coord(10, 20, rectangular: true)  # (Integer, Integer => lng, Hash => opts)
parse_coord(10, 20, 30)                 # (Integer, *Integer)
parse_coord('foo', 'bar', rectangular: true) # (_, _, Hash => opts)
parse_coord('10,20', 30)                # Note that (String) pattern should NOT match this
parse_coord(10, 20, '30')               # Note that (Integer, *Integer) pattern should NOT match this
```

And here is how the library imitates it:

* `M()` instead of just `()` (and array of case arguments instead of `()` again);
* `binding_of_caller` with predefined local variables hack to bind variables;
* `Class#to_a` defined (instead of `*` being special syntax in this context).

```ruby
def parse_coord(lat, *lngs)
  lng, opts = nil # binding will need that

  print "parsing (%p, *%p) => " % [lat, lngs]

  case [lat, *lngs]
  when M(String)
    puts "one string"
  when M(Integer, Integer => :lng)
    puts "two integers %p, %p" % [lat, lng]
  when M(Integer, Integer => :lng, Hash => :opts)
    puts "two integers & opts: %p, %p, %p" %
      [lat, lng, opts]
  when M(Integer, *Integer)
    puts "integer + array of integers"
  when M(_, _, Hash => :opts)
    puts "something + Hash %p" % opts
  else
    puts "no matches"
  end
end
```

Run `ruby demo.rb` to see code above work (including binding to local variables).