class BenchmarksController < ApplicationController

  def method_create
    Company.create!(name: "Company")
    head :ok, content_type: "text/html"
  end

  def method_update
    company = Company.first
    company.update!(name: "New Company Name")

    head :ok, content_type: "text/html"
  end

  def method_where
    companies = Company.where(id: 551)
    ids = companies.ids
    head :ok, content_type: "text/html"
  end

  def method_limit
    companies = Company.limit(1)
    ids = companies.ids
    head :ok, content_type: "text/html"
  end

end
