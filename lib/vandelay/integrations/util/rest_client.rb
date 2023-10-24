# frozen_string_literal: true

module Vandelay
  module Integrations
    module Util
      # Wrapper around Net::HTTP to simplify error handling
      # TODO: Replace Net::HTTP with faraday
      class RestClient
        ALL_NET_HTTP_ERRORS = [
          Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
          Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError
        ]

        def initialize(base_uri)
          super()

          @base_uri = base_uri
        end

        def get(path, headers = {})
          http_response = Net::HTTP.get_response(
            URI::HTTP.build(host: @base_uri, path: path),
            headers
          )

          RestResponse.new http_response, nil

        rescue *ALL_NET_HTTP_ERRORS => e
          return RestResponse.new nil, e
        end
      end

      class RestResponse
        attr_reader :base_response
        attr_reader :exception

        # @param [Net::HTTPResponse, nil] response
        # @param [Exception, nil] exception
        def initialize(response, exception)
          super()

          @base_response = response
          @exception = exception
        end

        def response_code
          @base_response&.code.to_s
        end

        def success?
          exception.nil? && response_code.start_with?('2') && json_ok?
        end

        def not_found?
          exception.nil? && response_code == '404'
        end

        def json_ok?
          @json ||= JSON.parse @base_response.body, { symbolize_names: true }
          true
        rescue JSON::ParserError
          false
        end

        # @return [Object, nil]
        def json
          return nil unless json_ok?

          @json
        end
      end
    end
  end
end

