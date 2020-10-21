module ActiveRecord
  module Fsm
    class Graph
      attr_accessor :transitions, :states, :final_states

      def initialize(transitions)
        @transitions = transitions
        @states = transitions.flatten.uniq
        @final_states = transitions.map(&:last) - transitions.map(&:first)
      end

      def valid_transition?(cur_state, tar_state)
        transitions.include?([cur_state, tar_state])
      end

      def final_state?(state)
        final_states.include?(state)
      end

      class << self
        attr_writer :defined_klasses

        def defined_klasses
          @defined_klasses ||= []
        end
      end
    end
  end
end
