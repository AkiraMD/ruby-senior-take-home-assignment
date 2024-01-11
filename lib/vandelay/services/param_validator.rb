module Vandelay
  module Services
    class ParamValidator
      def self.valid?(value, type)
        Kernel.send(type.to_s, value) rescue false
      end
    end
  end
end
