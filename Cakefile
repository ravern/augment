require "cake"

BIN = "augment"

default :run

phony :run
target :run, deps: [:build], desc: "Build and run augment" do |env|
  run "bin/#{BIN}", env.args
  File.delete("bin/#{BIN}.dwarf")
end

phony :build
target :build, desc: "Build augment" do |env|
  run "shards", ["build"]
end

Cake.run
