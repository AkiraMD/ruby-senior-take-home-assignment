require 'spec_helper'

RSpec.describe 'Vandelay::Util::Cache', type: :service do
  let(:app) { RESTServer }
  let(:cache) { Vandelay::Util::Cache.new }

  it "should be able to set key with value" do      
    cache.set("hello", "world")
    resp = cache.get("hello")
    expect(resp).to eq("world")
  end

  it "should be able to set key with expiry" do      
    cache.set("three", "second", expiry: 2)
    expect(cache.get("three")).to eq("second")
    sleep(3)
    expect(cache.get("three")).to be_nil
  end

  it "should respond true if a key exists" do      
    cache.set("existing", "key")
    expect(cache.exists?("existing")).to eq(true)
  end

  it "should respond false if a key exists" do      
    cache.set("non-existent", "key", expiry: 1)
    sleep(2)
    expect(cache.exists?("non-existent")).to eq(false)
  end
end
