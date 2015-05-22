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
  it { expect(subject).to respond_to(:unit_sensitivity_analyses) }

  it { expect(subject).to belong_to(:project) }
  it { expect(subject).to have_many(:unit_sensitivity_analyses) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_uniqueness_of(:name).scoped_to(:project_id) }

  describe "when name is already taken from unit from another project" do
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
  it { expect(subject).to validate_presence_of(:project) }

  describe "#total_area" do
    [ # private_area | common_area | box_area | total_area
      [        10.00,        10.00,     10.00,       30.00 ],
      [       381.43,       200.21,      0.00,      581.64 ],
      [        74.05,        41.71,     10.81,      126.57 ]
    ].each do |private_area, common_area, box_area, total_area|
      # Formula: private_area * common_area * box_area
      it "calculates the total area" do
        unit = FactoryGirl.build(:unit, private_area: private_area,
                                        common_area: common_area,
                                        box_area: box_area)

        expect(unit.total_area).to eq(total_area)
      end
    end
  end

  describe "#by_name" do
    let(:unit_three) { FactoryGirl.create(:unit, name: "Unit Without Example 3") }
    let(:unit_two) { FactoryGirl.create(:unit, name: "Unit With Example 2") }
    let(:unit_one) { FactoryGirl.create(:unit, name: "Unit With Example 1") }

    it "orders by ascending name" do
      expect(Unit.all.by_name(nil)).to eq([unit_one, unit_two, unit_three])
    end

    it "search by name and orders by ascending name" do
      expect(Unit.all.by_name('Unit With')).to eq([unit_one, unit_two])
    end
  end
end