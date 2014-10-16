require 'rails_helper'

RSpec.describe Run, :type => :model do
  it { should belong_to :fleet }

  it { should have_many(:results).dependent(:destroy) }

  it { should validate_presence_of(:fleet).on(:create) }

  it { should validate_presence_of(:target) }

  it do
    should validate_numericality_of(:duration).
      is_greater_than(0).
      is_less_than_or_equal_to(1800).
      with_message("must be between 1 and 1800")
  end

  it do
    should validate_numericality_of(:rate).
      is_greater_than(0).
      is_less_than_or_equal_to(20000).
      with_message("must be between 1 and 20000")
  end

  context 'workflow' do
    it { should respond_to(:initiated?) }
    it { should respond_to(:start!) }

    it { should respond_to(:started?) }
    it { should respond_to(:finish!) }
    it { should respond_to(:fail!) }

    it { should respond_to(:finished?) }

    it { should respond_to(:failed?) }

    it "should begin with state :initiated" do
      expect(build_stubbed(:run).initiated?).to eq(true)
    end
  end
end
