require 'spec_helper'
require 'rails_helper'

describe MultipleUnitsCreator do
  subject(:multiple_units_creator) { MultipleUnitsCreator }

  describe "#call" do
    let(:project) { FactoryGirl.create(:project) }
    let(:multiple_units) { FactoryGirl.build(:multiple_units, quantity: 5, project_id: project.id) }

    it "should save multiple units" do
      expect { subject.call(project, multiple_units) }.to change{Unit.all.count}.from(0).to(5)
    end
  end
end