require "activerecord/fsm/graph"

module ActiveRecord
  module Fsm
    extend ActiveSupport::Concern

    module ClassMethods
      attr_accessor :fsm_graph, :fsm_column

      def fsm_define(transitions, fsm_column = 'status')
        self.class_eval do
          private

          def fsm_graph_check_permit_transitions
            unless self.class.fsm_graph.valid_transition?(*self.send("#{self.class.fsm_column.to_s}_change"))
              self.errors.add(self.class.fsm_column.to_sym, "no permit status change. #{self.send("#{self.class.fsm_column.to_s}_change")}")
              throw :abort
            end
          end
        end

        ActiveRecord::Fsm::Graph.defined_klasses << self
        self.fsm_column = fsm_column.to_s
        self.fsm_graph = ActiveRecord::Fsm::Graph.new(transitions)

        validates :status, presence: true, inclusion: { in: self.fsm_graph.states }
        validate :fsm_graph_check_permit_transitions, on: :update, if: "will_save_change_to_#{fsm_column}?".to_sym

        self.fsm_graph
      end
    end

    class Error < StandardError; end
  end
end
