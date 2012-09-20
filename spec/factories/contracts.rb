# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contract do
    client_id nil
    descrizione "MyString"
    tipo "MyString"
    costo_orario 1.5
  end
end
