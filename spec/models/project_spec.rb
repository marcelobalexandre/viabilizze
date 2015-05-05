require 'spec_helper'
require 'rails_helper'

describe Project do
  subject(:project) { FactoryGirl.build(:project) }

  it { expect(subject).to respond_to(:name) }
  it { expect(subject).to respond_to(:user_id) }
  it { expect(subject).to respond_to(:units) }
  it { expect(subject).to respond_to(:sensitivity_analyses) }

  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to have_many(:units) }
  it { expect(subject).to have_many(:sensitivity_analyses) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_uniqueness_of(:name).scoped_to(:user_id) }

  describe "when name is already taken from project from another user" do
    before do
      another_user = FactoryGirl.create(:user)
      project_with_same_name = subject.dup
      project_with_same_name.user_id = another_user.id
      project_with_same_name.save
      subject.save
    end

    it { expect(subject).to be_valid }
  end

  it { expect(subject).to validate_presence_of(:user) }

  describe "#by_name" do
    let(:project_three) { FactoryGirl.create(:project, name: "Project Without Example 3") }
    let(:project_two) { FactoryGirl.create(:project, name: "Project With Example 2") }
    let(:project_one) { FactoryGirl.create(:project, name: "Project With Example 1") }

    it "orders by ascending name" do
      expect(Project.all.by_name(nil)).to eq([project_one, project_two, project_three])
    end

    it "search by name and orders by ascending name" do
      expect(Project.all.by_name('Project With')).to eq([project_one, project_two])
    end
  end
end