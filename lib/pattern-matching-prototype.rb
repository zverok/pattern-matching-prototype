require 'binding_of_caller'

module PatternMatchingPrototype
  def M(*arg)
    M.new(*arg)
  end

  def _
    Object # Object#===(almost anything) → true
  end

  def self.included(*)
    # patches core objects everywhere... but only when included. Kinda trying to be good
    ::Class.include(M::ToSplat)
  end

  class M
    class SplatPattern
      def initialize(pattern)
        @pattern = pattern
      end

      def ===(array)
        array.is_a?(Array) or fail "SplatPattern only matches arrays, #{array.class} given"
        array.all? { |el| @pattern === el }
      end
    end

    class BoundPattern
      def initialize(pattern, name, binding)
        name.is_a?(Symbol) or fail ArgumentError, "Expected to pass symbol names to bind, #{name} given"
        binding.local_variables.include?(name) or
          fail ArgumentError, "binding_of_caller hack requires variable to be defined before"\
                              " pattern definition, like #{name} = nil"
        @pattern = pattern
        @name = name
        @binding = binding
      end

      def ===(value)
        # FIXME: local variables here are rewritten on each, even partial match.
        # But final value would be from final match.
        # But if nothing matched fully, instance var still would be set.
        # :shrug:
        (@pattern === value).tap { |matched| @binding.local_variable_set(@name, value) if matched }
      end
    end

    module ToSplat
      def to_a
        [SplatPattern.new(self)]
      end
    end

    def initialize(*patterns)
      if patterns.last.is_a?(Hash)
        @patterns = patterns[0..-2] + hash_to_patterns(patterns.pop, binding.of_caller(2))
      else
        @patterns = patterns
      end
    end

    def ===(array)
      array.is_a?(Array) or fail "Prototype only matches arrays, #{array.class} given"
      array = array.dup

      if @patterns.last.is_a?(SplatPattern)
        return false unless @patterns.count -1 >= array.count
        rest = array.shift(@patterns.count - 1)
        @patterns[0..-2].zip(rest).all? { |p, e| p === e } && @patterns.last === array
      else
        return false unless @patterns.count == array.count

        @patterns.zip(array).all? { |p, e| p === e }
      end
    end

    private

    def hash_to_patterns(hash, binding)
      hash.map { |pattern, name| BoundPattern.new(pattern, name, binding) }
    end
  end
end