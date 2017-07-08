class TestJob < ApplicationJob
  queue_as :default

  def perform
    User.create(name:"aji",username:"ajitirta", password:"ajitirta")
  end
end
