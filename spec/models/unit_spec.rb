require 'spec_helper'
require 'rails_helper'

describe Unit do
  subject(:unit) { FactoryGirl.build(:unit) }

  it { expect(subject).to respond_to(:name) }
  it { expect(subject).to respond_to(:private_area) }
  it { expect(subject).to respond_to(:common_area) }
  it { expect(subject).to respond_to(:box_area) }
  it { expect(subject).to respond_to(:total_area) }
  it { expect(subject).to respond_to(:exchanged) }
  it { expect(subject).to respond_to(:project_id) }

  it { expect(subject).to belong_to(:project) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_uniqueness_of(:name).scoped_to(:project_id) }

  describe "when name is already taken from the project user" do
    before do
      another_project = FactoryGirl.create(:project)
      unit_with_same_name = subject.dup
      unit_with_same_name.project_id = another_project.id
      unit_with_same_name.save
      subject.save
    end

    it { expect(subject).to be_valid }
  end

  it { expect(subject).to validate_numericality_of(:private_area).is_greater_than_or_equal_to(0) }
  it { expect(subject).to validate_numericality_of(:common_area).is_greater_than_or_equal_to(0) }
  it { expect(subject).to validate_numericality_of(:box_area).is_greater_than_or_equal_to(0) }

  it { expect(subject).to validate_presence_of(:exchanged) }
  it { expect(subject).to validate_presence_of(:project_id) }

  describe "#total_area" do
    before do
      subject.private_area = 10
      subject.common_area  = 10
      subject.box_area     = 10
    end

    it { expect(subject.total_area).to eq(30) }
  end
end