# frozen_string_literal: true

require_relative  '../spec_helper'
require 'webmock/rspec'
RSpec.describe Sync::SingleFlight do
  let(:singleflight) { described_class.new }

  describe "#execute" do
    it "returns the result of the block and ensures the GET request is called only once" do
      stub_request(:get, "https://example.com/data")
        .to_return(body: "data", status: 200)

      threads = 5.times.map do
        Thread.new do
          result = singleflight.execute('fetch_data') do
             sleep(2)
             Net::HTTP.get(URI("https://example.com/data"))
          end
          result
        end
      end


      threads.each(&:join)
      results = threads.map(&:value)
      expect(results.uniq.size).to eq(1)
      expect(results.uniq).to eq(['data'])
      expect(a_request(:get, "https://example.com/data")).to have_been_made.once
    end
  end

end