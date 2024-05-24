RSpec.describe Vandelay::Util::Cache do
  let(:cache) { described_class.new }

  describe '#fetch' do
    subject { cache.fetch(key, expires_in: 1) { value } }

    let(:key) { 'key' }
    let(:value) { 'value' }

    after { cache.delete(key) }

    context 'when the key is not in the cache' do
      it 'returns the value' do
        puts "subject is #{subject}"
        expect(subject).to eq(value)
      end
    end

    context 'when the key is in the cache' do
      before { cache.write(key, 'cached value') }

      it 'returns the cached value' do
        expect(subject).to eq('cached value')
      end
    end

    context 'when key is set to expire' do
      it 'expires the key' do
        expect(subject).to eq(value)

        # Ideally we would use a timecop-like gem to freeze time, but we are talking to Redis
        sleep(2)
        expect(cache.fetch(key, expires_in: 1) { 'default' }).to eq('default')
      end
    end

    context 'when no block is given' do
      subject { cache.fetch(key) }

      it 'raises an ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'block must be given!')
      end
    end
  end

  describe '#write' do
    subject { cache.write(key, value, expires_in: 1) }

    let(:key) { 'key' }
    let(:value) { 'value' }

    it 'writes value to cache' do
      subject
      expect(cache.fetch(key) { 'default' }).to eq(value)
    end
  end

  describe '#delete' do
    subject { cache.delete(key) }

    let(:key) { 'key' }

    it 'deletes key from cache' do
      cache.write(key, 'value')
      subject
      expect(cache.fetch(key) { 'default' }).to eq('default')
    end
  end
end
