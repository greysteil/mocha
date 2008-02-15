module Mocha

  class Cardinality
    
    INFINITY = 1 / 0.0
    
    class << self
      
      def exactly(count)
        new(count, count)
      end
      
      def at_least(count)
        new(count, INFINITY)
      end
      
      def at_most(count)
        new(0, count)
      end
      
      def times(range_or_count)
        case range_or_count
        when Range
          new(range_or_count.first, range_or_count.last)
        else
          new(range_or_count, range_or_count)
        end
      end
      
    end
    
    def initialize(required, maximum)
      @required, @maximum = required, maximum
    end
    
    def invocations_allowed?(invocation_count)
      invocation_count < maximum
    end
    
    def satisfied?(invocations_so_far)
      invocations_so_far >= required
    end
    
    def needs_verifying?
      self != self.class.at_least(0)
    end
    
    def verified?(invocation_count)
      (invocation_count >= required) && (invocation_count <= maximum)
    end
    
    def mocha_inspect
      if required == 0 && infinite?(maximum)
        "allowed any number of times"
      else
        if required == 0 && maximum == 0
          "expected never"
        elsif required == maximum
          "expected exactly #{times(required)}"
        elsif infinite?(maximum)
          "expected at least #{times(required)}"
        elsif required == 0
          "expected at most #{times(maximum)}"
        else
          "expected between #{required} and #{times(maximum)}"
        end
      end
    end
    
    def ==(object)
      object.is_a?(Mocha::Cardinality) && (object.required == required) && (object.maximum == maximum)
    end
    
    protected
    
    attr_reader :required, :maximum
    
    private
    
    def times(number)
      number == 1 ? "once" : "#{number} times"
    end
    
    def infinite?(number)
      number.respond_to?(:infinite?) && number.infinite?
    end
    
  end
  
end
