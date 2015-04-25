require 'spec_helper'
require 'rails_helper'

describe MultipleUnits do
  subject(:multiple_units) { FactoryGirl.build(:multiple_units) }

  it { expect(subject).to respond_to(:quantity) }
  it { expect(subject).to respond_to(:name) }
  it { expect(subject).to respond_to(:names) }
  it { expect(subject).to respond_to(:private_area) }
  it { expect(subject).to respond_to(:common_area) }
  it { expect(subject).to respond_to(:box_area) }
  it { expect(subject).to respond_to(:exchanged) }
  it { expect(subject).to respond_to(:project_id) }

  it { expect(subject).to validate_numericality_of(:quantity).is_greater_than_or_equal_to(2) }
  
  it { expect(subject).to validate_presence_of(:name) }
  
  describe "#names" do
    before do
      subject.quantity = 3
      subject.name = 'Unit'      
    end

    it { expect(subject.names).to eq([ 'Unit 01', 'Unit 02', 'Unit 03' ]) }
  end

  describe "#verify_uniqueness_of_names" do
    context "when one of the names is already taken from a unit from the same project" do
      before do
        project = FactoryGirl.create(:project)
        
        unit_with_same_name = FactoryGirl.create(:unit, name: subject.names.first, project_id: project.id)
        project.units << unit_with_same_name
        
        subject.project_id = project.id      
      end

      it { expect { subject.verify_uniqueness_of_names }.to change{subject.errors[:name].count}.from(0).to(1) }      
    end

    context "when more than one of the names is already taken from a unit from the same project" do
      before do
        project = FactoryGirl.create(:project)
        
        unit_with_same_name = FactoryGirl.create(:unit, name: subject.names.first, project_id: project.id)
        another_unit_with_same_name = FactoryGirl.create(:unit, name: subject.names.last, project_id: project.id)
        project.units << unit_with_same_name
        project.units << another_unit_with_same_name
        
        subject.project_id = project.id      
      end

      it { expect { subject.verify_uniqueness_of_names }.to change{subject.errors[:name].count}.from(0).to(1) }
    end

    context "when some of the names is already taken from a unit from the another project" do
      before do
        project = FactoryGirl.create(:project)
        
        another_project = FactoryGirl.create(:project)
        unit_with_same_name = FactoryGirl.create(:unit, name: subject.names.first, project_id: another_project.id)
        another_project.units << unit_with_same_name
        
        subject.project_id = project.id      
      end

      it { expect { subject.verify_uniqueness_of_names }.not_to change{subject.errors[:name].count}.from(0) }
    end
  end

  it { expect(subject).to validate_numericality_of(:private_area).is_greater_than_or_equal_to(0) }
  it { expect(subject).to validate_numericality_of(:common_area).is_greater_than_or_equal_to(0) }
  it { expect(subject).to validate_numericality_of(:box_area).is_greater_than_or_equal_to(0) }

  it { expect(subject).to validate_presence_of(:exchanged) }
  it { expect(subject).to validate_presence_of(:project_id) }
end