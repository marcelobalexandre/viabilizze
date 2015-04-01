require 'spec_helper'
require 'rails_helper'

describe User do
  let(:attributes) { FactoryGirl.attributes_for(:user) }

  subject(:user) { User.new(attributes) }

  it { expect(subject).to respond_to(:name) }
  it { expect(subject).to respond_to(:email) }
  it { expect(subject).to respond_to(:password) }
  it { expect(subject).to respond_to(:password_confirmation) }
  
  #devise properties
  it { expect(subject).to respond_to(:encrypted_password) }

  #devise recoverable properties
  it { expect(subject).to respond_to(:reset_password_token) }
  it { expect(subject).to respond_to(:reset_password_sent_at) }

  #devise rememberable properties
  it { expect(subject).to respond_to(:remember_created_at) }

  #devise trackable properties
  it { expect(subject).to respond_to(:sign_in_count) }
  it { expect(subject).to respond_to(:current_sign_in_at) }
  it { expect(subject).to respond_to(:last_sign_in_at) }
  it { expect(subject).to respond_to(:current_sign_in_ip) }
  it { expect(subject).to respond_to(:last_sign_in_ip) }

  describe "when data is valid" do
    it { expect(subject).to be_valid }
  end

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_length_of(:name).is_at_least(3).is_at_most(35) }
  
  it { expect(subject).to validate_presence_of(:email) }
  it { expect(subject).not_to allow_value('user@foo,com',
                                          'user_at_foo.org',
                                          'example.user@foo.',
                                          'foo@bar_baz.com',
                                          'foo@bar+baz.com',
                                          'foo@bar..com').for(:email) }
  it { expect(subject).to allow_value('user@foo.COM',
                                      'A_US-ER@f.b.org',
                                      'frst.lst@foo.jp','a+b@baz.cn').for(:email) }
  it { expect(subject).to validate_length_of(:email).is_at_most(100) }
  it { expect(subject).to validate_uniqueness_of(:email) }

  it { expect(subject).to validate_presence_of(:password) }
  it { expect(subject).to validate_confirmation_of(:password) }
  it { expect(subject).to validate_length_of(:password).is_at_least(8).is_at_most(128) }

  describe "when saved" do
    it "set the encrypted password attribute" do
      subject.save!

      expect(subject.encrypted_password).not_to be_blank
    end
  end
end