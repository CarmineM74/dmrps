# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rp, :class => 'Rps' do
    location ""
    user ""
  end
end
