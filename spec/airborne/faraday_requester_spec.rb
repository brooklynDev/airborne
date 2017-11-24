require 'spec_helper'

RSpec.describe Airborne::FaradayRequester do
  before do
    stub_request(:any, /www.example.com/)
    allow(Airborne).to receive_message_chain(:configuration, :base_url).and_return 'http://www.example.com'
  end

  subject { described_class.new }

  shared_examples 'faraday_get_delete_requests' do |kind_of_request|
    describe "##{kind_of_request}" do
      context 'when have only path' do
        it "makes a simple #{kind_of_request} call" do
          subject.make_request kind_of_request, '/asdasd'
          expect(a_request(kind_of_request, "www.example.com/asdasd").with(body: {})).to have_been_made.once
        end
      end

      context 'when request has body' do
        it 'makes calls with body specified in the body params' do
          subject.make_request kind_of_request, '/asdasd', { jane: 'doe' }
          expect(a_request(kind_of_request, "www.example.com/asdasd?jane=doe")).to have_been_made.once
        end
      end

      context 'when request also has headers' do
        it 'makes calls with headers specified' do
          subject.make_request kind_of_request, '/asdasd', { }, { a: '1' }
          expect(a_request(kind_of_request, "www.example.com/asdasd").with({headers: {'A' => '1'}})).to have_been_made.once
        end
      end

      context 'when request has body and headers' do
        it 'makes calls with body specified in the body params' do
          subject.make_request kind_of_request, '/asdasd', { jane: 'doe' }, { a: '1' }
          expect(a_request(kind_of_request, "www.example.com/asdasd?jane=doe").with({headers: {'A' => '1'}})).to have_been_made.once
        end
      end

      context 'when request has a different URL than the URL specified' do
        before { stub_request(:any, /www.example.de/) }

        it 'makes calls with body specified in the body params' do
          subject.make_request kind_of_request, '/asdasd', { jane: 'doe' } do |k, c|
            c.url_prefix = 'http://www.example.de'
            k.headers.merge!({ a: '1' })
          end
          expect(a_request(kind_of_request, "www.example.de/asdasd?jane=doe").with({headers: {'A' => '1'}})).to have_been_made.once
        end
      end
    end
  end

  shared_examples 'faraday_put_post_requests' do |kind_of_request|
    describe "##{kind_of_request}" do
      context 'when have only path' do
        it "makes a simple #{kind_of_request} call" do
          subject.make_request kind_of_request, '/asdasd'
          expect(a_request(kind_of_request, "www.example.com/asdasd").with(body: {})).to have_been_made.once
        end
      end

      context 'when request has body' do
        it 'makes calls with body specified in the body params' do
          subject.make_request kind_of_request, '/asdasd', { jane: 'doe' }
          expect(a_request(kind_of_request, "www.example.com/asdasd").with(body: 'jane=doe')).to have_been_made.once
        end
      end

      context 'when request also has headers' do
        it 'makes calls with headers specified' do
          subject.make_request kind_of_request, '/asdasd', { }, { a: '1' }
          expect(a_request(kind_of_request, "www.example.com/asdasd").with({headers: {'A' => '1'}})).to have_been_made.once
        end
      end

      context 'when request has body and headers' do
        it 'makes calls with body specified in the body params' do
          subject.make_request kind_of_request, '/asdasd', { jane: 'doe' }, { a: '1' }
          expect(a_request(kind_of_request, "www.example.com/asdasd").with({headers: {'A' => '1'}, body: 'jane=doe'})).to have_been_made.once
        end
      end

      context 'when request has a different URL than the URL specified' do
        before { stub_request(:any, /www.example.de/) }

        it 'makes calls with body specified in the body params' do
          subject.make_request kind_of_request, '/asdasd', { jane: 'doe' } do |k, c|
            c.url_prefix = 'http://www.example.de'
            k.headers.merge!({ a: '1' })
          end
          expect(a_request(kind_of_request, "www.example.de/asdasd").with({headers: {'A' => '1'}, body: 'jane=doe'})).to have_been_made.once
        end
      end
    end
  end

  it_behaves_like 'faraday_get_delete_requests', :get
  it_behaves_like 'faraday_get_delete_requests', :delete
  it_behaves_like 'faraday_put_post_requests', :put
  it_behaves_like 'faraday_put_post_requests', :post
end
