Factory.sequence :email do |n|
  "user_##{n}@example.com"
end

Factory.define :product do |product|
  product.name 'Inhouse volleyball'
  product.description 'Some text that describes this product. '
  product.price 100
  product.enabled true
end

Factory.define :user do |user|
  user.password 'password'
  user.password_confirmation 'password'
  user.email { Factory.next(:email) }
end

Factory.define :registration do |registration|
  p = Factory(:product)
  
  registration.first_name 'player'
  registration.last_name 'name'
  registration.parent_first_name 'parent' 
  registration.parent_last_name 'name'
  registration.grade 3
  registration.school 'LME'
  registration.email { Factory.next(:email) }
  registration.phone '9524316344'
  registration.address '21266 Inspiration path'
  registration.city 'Lake City'
  registration.state 'MN'
  registration.zip '55044'
  registration.parent_helper true
  registration.tshirt_size 'YL'
  registration.parent_tshirt_size 'XL'
  registration.note "Some text that I'm sending along with this message as a note. Some text that I'm sending along with this message as a note. Some text that I'm sending along with this message as a note. "
  registration.has_release true
  registration.product_id p.id
end
