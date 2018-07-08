require "cake"
require "./src/augment/exception"
require "./src/augment/builder"

default :development

phony :development
target :development, desc: "Builds the binary and scripts in development mode" do |env|
  Augment::Builder.new.build(development: true)
end

phony :production
target :production, desc: "Builds the binary and scripts in production mode" do |env|
  Augment::Builder.new.build
end

Cake.run
