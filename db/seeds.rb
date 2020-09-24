# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

load(Rails.root.join( 'db', 'seeds', "#{Rails.env.downcase}.rb"))

if RealEstateSkill.none?
  RealEstateSkill.create([
                           { description: 'Underwriting' },
                           { description: 'Investment Memo' },
                           { description: 'Brokerage Memo' },
                           { description: 'Acquisition Underwriting' },
                           { description: 'Construction Management' },
                           { description: 'Distribution Waterfall' },
                           { description: 'Development Underwriting' },
                           { description: 'Financial Modeling' },
                           { description: 'Capital Markets' },
                           { description: 'Acquisition Diligence' },
                           { description: 'Due Diligence' },
                           { description: 'Content Creation' },
                           { description: 'Graphic Design' },
                           { description: 'Development Diligence' },
                           { description: 'Market Research' },
                           { description: 'Zoning Requirements' },
                           { description: 'Asset Management' },
                           { description: 'Debt Sizing' },
                           { description: 'Property Review' },
                           { description: 'Equity Memo' },
                           { description: 'Lease Audit' },
                           { description: 'Debt Memo' },
                           { description: 'Legal Review' },
                           { description: 'Copywriting' },
                           { description: 'Marketing' }
                         ])
end

if AssetClass.none?
  AssetClass.create([
                      { description: 'HTC' },
                      { description: 'Affordable Housing' },
                      { description: 'Condo' },
                      { description: 'Hospitality' },
                      { description: 'Industrial' },
                      { description: 'Land Development' },
                      { description: 'LIHTC' },
                      { description: 'Medical' },
                      { description: 'Mixed Use' },
                      { description: 'Mobile Home' },
                      { description: 'Multifamily' },
                      { description: 'Office' },
                      { description: 'Retail' },
                      { description: 'Senior Housing' },
                      { description: 'Student Housing' },
                      { description: 'Single Family' },
                      { description: 'Self Storage' },
                      { description: 'Marina' }
                    ])
end

