FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do
    name 'Test'
    redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
    uid '234234234'
    secret '62374682347'
  end
end
