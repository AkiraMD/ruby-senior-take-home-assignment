RSpec.describe Vandelay::Services::CacheService do

  let(:cache_key) { 'test_redis_key' }

  context 'with a cached value cache' do
    before do
      described_class.new(cache_key).fetch_and_store { 5 }
    end

    it 'gets cached value' do
      value = described_class.new(cache_key).fetch_and_store { 15 }
      expect(value).to eq(5)
    end
  end
end
