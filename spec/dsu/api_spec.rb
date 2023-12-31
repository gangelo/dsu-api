# frozen_string_literal: true

RSpec.describe Dsu::Api do
  it 'has a version number' do
    expect(Dsu::Api::VERSION).not_to be_nil
  end
end
