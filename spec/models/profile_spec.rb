describe Profile do
  describe 'database actions' do
    let!(:profile1) { create :profile }
    let!(:profile2) { create :profile }
    let!(:profile3) { create :profile }
    let!(:profile4) { create :profile }

    it "should be able to create new tags for profiles" do
      tag = profile1.tags.where(name: 'BrandNewName').first_or_create
      expect(tag.name).to eq('BrandNewName')
    end

    it "should be able to find all tags on a profile" do
      profile1.tags.where(name: 'BrandNewName').first_or_create
      profile1.tags.where(name: 'BrandNewName2').first_or_create
      profile1.tags.where(name: 'BrandNewName3').first_or_create
      profile1.reload
      expect(profile1.tags[0].name).to eq('BrandNewName')
      expect(profile1.tags[1].name).to eq('BrandNewName2')
      expect(profile1.tags[2].name).to eq('BrandNewName3')
    end
  end
end
