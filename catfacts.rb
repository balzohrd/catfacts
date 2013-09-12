require 'rubygems'
require 'google_text'
require 'highline/import'
require 'timeout'

class CatFacts

  def initialize
    username = ARGV[0]
    password = ask("What is your Google Password?\n") { |q| q.echo = false }
    GoogleText.configure {|config| config.email, config.password = username, password}
  end

  def send_sms
    number = ARGV[1]
    name = ARGV[2]
    greeting = GoogleText::Message.new(:text => "Hello #{name}, thanks for signing up to CatFacts! You will receive a free cat fact every 10  minutes! Text 'Cat' to stop receiving CatFacts!", :to => number)
    greeting.send

    1.upto(Float::INFINITY) do |i|
      file = File.read('catfacts').split(/\n/)
      fact = file[Random.rand(file.size)][0..-2]
      message = GoogleText::Message.new(:text => fact, :to => number)
      message.send
      puts "Sent This Cat Fact: #{fact}"
      sleep(600)
    end
  end

end

cf = CatFacts.new
cf.send_sms
