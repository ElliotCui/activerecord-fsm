require "activerecord/fsm/graph"

module ActiveRecord
  module Fsm
    extend ActiveSupport::Concern

    module ClassMethods
      attr_accessor :fsm_graph

      def fsm_define(transitions)
        self.class_eval do
          private

          def fsm_graph_check_permit_transitions
            unless self.class.fsm_graph.valid_transition?(*self.status_change)
              self.errors.add(:status, "no permit status change. #{self.status_change}")
              throw :abort
            end
          end
        end

        ActiveRecord::Fsm::Graph.defined_klasses << self
        self.fsm_graph = ActiveRecord::Fsm::Graph.new(transitions)

        validates :status, presence: true, inclusion: { in: self.fsm_graph.states }
        validate :fsm_graph_check_permit_transitions, on: :update, if: :will_save_change_to_status?

        self.fsm_graph
      end
    end

    class Error < StandardError; end
  end
end
