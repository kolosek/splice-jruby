describe Company do
  it { should have_db_column(:name).of_type(:string) }
  # it { should validate_presence_of(:email) }
  it { should have_many(:users) }
  it { should have_many(:profiles).through(:users) }

  describe 'database actions' do
    let!(:company) { create :company }
    let!(:user1) { create :user, company_id: company.id }
    let!(:profile1) { create :profile, user_id: user1.id }
    let!(:user2) { create :user, company_id: company.id }
    let!(:profile2) { create :profile, user_id: user2.id }
    let!(:user3) { create :user, company_id: company.id }
    let!(:profile3) { create :profile, user_id: user3.id }

    it 'updates company name' do
      company_name = company.name
      expect{company.update(name: 'NewName')}.to change{company.reload.name}.from(company_name).to('NewName')
    end

    it "can get the average views for all it's profiles" do
      profile1.update_column(:views, 3)
      profile2.update_column(:views, 5)
      profile3.update_column(:views, 4)
      expect(company.average_profile_views).to eq(4)
    end

    it "can get the total views for all it's profiles" do
      profile1.update_column(:views, 37)
      profile2.update_column(:views, 53)
      profile3.update_column(:views, 17)
      expect(company.total_profile_views).to eq(107)
    end

    it "allows plucking profile ids" do
      expect(company.profiles.pluck(:id)).to eq([profile1.id, profile2.id, profile3.id])
    end

  end
end
