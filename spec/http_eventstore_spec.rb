require 'spec_helper'

describe HttpEventstore do
  describe 'http_adapter' do
    context 'default' do
      it { expect(described_class.http_adapter).to be_nil }
    end

    context 'specified' do
      before { described_class.http_adapter = :typhoeus }

      it { expect(described_class.http_adapter).to eql :typhoeus }

      after { described_class.http_adapter = nil }
    end
  end
end
