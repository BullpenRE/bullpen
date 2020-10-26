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

if Sector.none?
  Sector.create([
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

if Skill.none?
  Skill.create([
                 { description: 'Underwriting' },
                 { description: 'Investment Memo' },
                 { description: 'Brokerage Memo' },
                 { description: 'Acquisition Underwriting' },
                 { description: 'Development Underwriting' },
                 { description: 'Construction Management' },
                 { description: 'Distribution Waterfall' },
                 { description: 'Financial Modeling' },
                 { description: 'Capital Markets' },
                 { description: 'Acquisition Diligence' },
                 { description: 'Development Diligence' },
                 { description: 'Due Diligence' },
                 { description: 'Market Research' },
                 { description: 'Zoning Requirements' },
                 { description: 'Debt Sizing' },
                 { description: 'Asset Management' },
                 { description: 'Property Review' },
                 { description: 'Equity Memo' },
                 { description: 'Debt Memo' },
                 { description: 'Lease Audit' },
                 { description: 'Legal Review' },
                 { description: 'Copywriting' },
                 { description: 'Marketing' },
                 { description: 'Content Creation' },
                 { description: 'Graphic Design' }
               ])
end

if Software.none?
  Software.create([
                    { description: 'Argus' },
                    { description: 'Costar' },
                    { description: 'Compstak' },
                    { description: 'Juniper Square' },
                    { description: 'Backstop' },
                    { description: 'RealPage' },
                    { description: 'MRI' },
                    { description: 'AppFolio' },
                    { description: 'VTS' },
                    { description: 'Real Capital Analytics' },
                    { description: 'Reonomy' },
                    { description: 'Buildout' },
                    { description: 'RedIQ' },
                    { description: 'VAL' },
                    { description: 'PropertyMetrics' },
                    { description: 'REIS' },
                    { description: 'Yardi' },
                    { description: 'Microsoft Excel' },
                    { description: 'Microsoft Powerpoint' },
                    { description: 'Microsoft Suite' }
                  ])
end

if Rails.env.development? && AdminUser.none?
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
end
