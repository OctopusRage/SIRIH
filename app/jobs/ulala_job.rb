class UlalaJob
  @queue = :default
  def self.perform
    # Do anything here
    User.create(name:"deaf",username:"deaf", password:"ajitirta")
    puts "Guembul"
  end
end