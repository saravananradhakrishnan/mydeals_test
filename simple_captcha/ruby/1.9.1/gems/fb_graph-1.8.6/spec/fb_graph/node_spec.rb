require 'spec_helper'

describe FbGraph::Node do

  describe '.new' do
    it 'should setup endpoint' do
      FbGraph::Node.new('matake').endpoint.should == File.join(FbGraph::ROOT_URL, 'matake')
    end

    it 'should support access_token option' do
      FbGraph::Node.new('matake', :access_token => 'access_token').access_token.should == 'access_token'
    end
  end

  describe '#build_params' do
    it 'should make all values to JSON or String' do
      client = Rack::OAuth2::Client.new(:identifier => 'client_id', :secret => 'client_secret')
      node = FbGraph::Node.new('identifier')
      params = node.send :build_params, {:hash => {:a => :b}, :array => [:a, :b], :integer => 123}
      params[:hash].should == '{"a":"b"}'
      params[:array].should == '["a","b"]'
      params[:integer].should == '123'
    end

    it 'should support Rack::OAuth2::AccessToken as self.access_token' do
      client = Rack::OAuth2::Client.new(:identifier => 'client_id', :secret => 'client_secret')
      node = FbGraph::Node.new('identifier', :access_token => Rack::OAuth2::AccessToken::Legacy.new(:access_token => 'token'))
      params = node.send :build_params, {}
      params[:oauth_token].should == 'token'
    end

    it 'should support OAuth2::AccessToken as options[:access_token]' do
      client = Rack::OAuth2::Client.new(:identifier => 'client_id', :secret => 'client_secret')
      node = FbGraph::Node.new('identifier')
      params = node.send :build_params, {:access_token => Rack::OAuth2::AccessToken::Legacy.new(:access_token => 'token')}
      params[:oauth_token].should == 'token'
    end
  end

end

describe FbGraph::Node, '#handle_response' do
  it 'should handle null/false response' do
    node = FbGraph::Node.new('identifier')
    null_response = node.send :handle_response do
      HTTP::Message.new_response 'null'
    end
    null_response.should be_nil
    lambda do
      node.send :handle_response do
        HTTP::Message.new_response 'false'
      end
    end.should raise_error(
      FbGraph::NotFound,
      'Graph API returned false, so probably it means your requested object is not found.'
    )
  end
end