describe Company do
  it { should have_db_column(:name).of_type(:string) }
  # it { should validate_presence_of(:email) }

  describe 'database actions' do
    let!(:company) { create :company }

    it 'updates company name' do
      company_name = company.name
      expect{company.update(name: 'NewName')}.to change{company.reload.name}.from(company_name).to('NewName')
    end
  end
end