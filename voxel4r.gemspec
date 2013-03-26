lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'voxel4r/version'

Gem::Specification.new do |gem|
  gem.name          = "voxel4r"
  gem.version       = Voxel4r::VERSION
  gem.authors       = ["Israel Buitron"]
  gem.email         = ["israel.buitron@gmail.com"]
  gem.description   = %q{Voxels generator library}
  gem.summary       = %q{Simply library to generate voxels.}
  gem.homepage      = "http://computacion.cs.cinvestav.mx/~ibuitron"

  gem.add_dependency "rasem"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
