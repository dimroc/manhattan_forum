namespace :rncryptor do
  desc "Encrypt values with ruby rncryptor"
  task :encrypt do
    require 'ruby_rncryptor'
    require "base64"

    pw = ENV["PW"]
    val = ENV["VALUE"]
    raise ArgumentError unless val && pw
    encrypted = RubyRNCryptor.encrypt(val, pw)

    puts "Encrypting"
    puts Base64.strict_encode64(encrypted)

    puts "Decrypting..."
    decrypted = RubyRNCryptor.decrypt(encrypted, pw)
    puts decrypted
  end
end
