describe User do
  it { should have_db_column(:email).of_type(:string) }
  # it { should validate_presence_of(:email) }

  it { should belong_to(:company) }
  it { should have_one(:profile) }
end
