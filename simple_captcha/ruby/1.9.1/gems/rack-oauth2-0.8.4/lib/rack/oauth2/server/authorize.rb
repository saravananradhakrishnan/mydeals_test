module Rack
  module OAuth2
    module Server
      class Authorize < Abstract::Handler
        def call(env)
          request = Request.new(env)
          request.profile.new(&@authenticator).call(env).finish
        rescue Rack::OAuth2::Server::Abstract::Error => e
          e.finish
        end

        class Request < Abstract::Request
          attr_required :response_type
          attr_optional :redirect_uri, :state
          attr_reader :verified_redirect_uri

          def initialize(env)
            super
            # NOTE: Raise before redirect_uri is saved not to redirect back to unverified redirect_uri.
            bad_request! if client_id.blank?
            @redirect_uri = Util.parse_uri(params['redirect_uri']) if params['redirect_uri']
            @state = params['state']
          end

          def profile
            case params['response_type'].to_s
            when 'code'
              Code
            when 'token'
              Token
            when ''
              attr_missing!
            else
              # TODO: support extensions
              unsupported_response_type!
            end
          end

          def verify_redirect_uri!(pre_registered)
            @verified_redirect_uri = if redirect_uri.present?
              if Util.uri_match?(pre_registered, redirect_uri)
                redirect_uri
              else
                bad_request!
              end
            else
              pre_registered
            end
            self.verified_redirect_uri.to_s
          end
        end

        class Response < Abstract::Response
          attr_required :redirect_uri
          attr_optional :state, :approval

          def initialize(request)
            @state = request.state
            super
          end

          def approved?
            @approval
          end

          def approve!
            @approval = true
          end

          def protocol_params
            {:state => state}
          end

          def finish
            if approved?
              attr_missing!
              redirect Util.redirect_uri(redirect_uri, protocol_params_location, protocol_params)
            end
            super
          end
        end
      end
    end
  end
end

require 'rack/oauth2/server/authorize/code'
require 'rack/oauth2/server/authorize/token'
require 'rack/oauth2/server/authorize/error'