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

  describe ".by_name" do
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

  describe "#total_units_not_exchanged" do
    [ # unit_one_exchanged | unit_two_exchanged | unit_three_exchanged | total_units_not_exchanged
      [              false,               false,                 false,                          3],
      [               true,               false,                 false,                          2],
      [               true,                true,                 false,                          1]
    ].each do |unit_one_exchanged, unit_two_exchanged, unit_three_exchanged, total_units_not_exchanged|
      it "calculates the total of units not exchanged" do
        unit_one = FactoryGirl.build(:unit, exchanged: unit_one_exchanged)
        unit_two = FactoryGirl.build(:unit, exchanged: unit_two_exchanged)
        unit_three = FactoryGirl.build(:unit, exchanged: unit_three_exchanged)

        project = FactoryGirl.build(:project)
        project.units << unit_one
        project.units << unit_two
        project.units << unit_three

        expect(project.total_units_not_exchanged).to eq(total_units_not_exchanged)
      end
    end
  end

  describe "#total_area_not_exchanged" do
    [ # unit_one_total_area | unit_two_total_area | exchanged_unit_total_area | total_area_not_exchanged
      [              581.64,               126.57,                     200.21,                    708.21],
      [              127.34,               116.00,                     123.12,                    243.34],
      [              234.76,               228.23,                     309.17,                    462.99]
    ].each do |unit_one_total_area, unit_two_total_area, exchanged_unit_total_area, total_area_not_exchanged|
      # Formula: sum the total area of all not exchanged units
      it "calculates the total area not exchanged" do
        unit_one = FactoryGirl.build(:unit, private_area: unit_one_total_area, common_area: 0.00, box_area: 0.00, exchanged: false)
        unit_two = FactoryGirl.build(:unit, private_area: unit_two_total_area, common_area: 0.00, box_area: 0.00, exchanged: false)
        exchanged_unit = FactoryGirl.build(:unit, private_area: exchanged_unit_total_area, common_area: 0.00, box_area: 0.00, exchanged: true)

        project = FactoryGirl.build(:project)
        project.units << unit_one
        project.units << unit_two
        project.units << exchanged_unit

        expect(project.total_area_not_exchanged).to eq(total_area_not_exchanged)
      end
    end
  end
end