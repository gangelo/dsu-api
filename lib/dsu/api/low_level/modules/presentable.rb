# frozen_string_literal: true

module Dsu
  module Api
    module LowLevel
      module Modules
        module Presentable
          def presenter
            "Dsu::Presenters::#{self.class.name.demodulize}Presenter".constantize.new(self, options: options)
          end
        end
      end
    end
  end
end
