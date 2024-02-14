# frozen_string_literal: true

require 'webmock/rspec'

# Disable outbound web connections
WebMock.disable_net_connect! allow_localhost: true
