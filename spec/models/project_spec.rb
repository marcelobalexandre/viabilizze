require 'spec_helper'
require 'rails_helper'

describe Project do
  subject(:project) { FactoryGirl.build(:project) }

  it { expect(subject).to respond_to(:name) }
  it { expect(subject).to respond_to(:user_id) }

  it { expect(subject).to belong_to(:user) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_uniqueness_of(:name).scoped_to(:user_id) }

  describe "when name is already taken from the another user" do
    before do
      another_user = FactoryGirl.create(:user)
      project_with_same_name = subject.dup
      project_with_same_name.user_id = another_user.id
      project_with_same_name.save
      subject.save
    end

    it { expect(subject).to be_valid }
  end

  it { expect(subject).to validate_presence_of(:user_id) }
end