Pod::Spec.new do |s|
  s.name = 'PWListKit'
  s.version = '0.1'
  s.summary = 'A data-driven UICollectionView framework.'
  s.homepage = 'https://github.com/parallelWorld/PWListKit'
  s.description = 'A data-driven UICollectionView framework for building fast and flexible lists.'

  s.authors = 'parallelWorld'
  s.source_files = 'Source/**/*.{h,m,mm}'
  s.requires_arc = true

  s.ios.deployment_target = '8.0'
  s.source = { :git => 'https://github.com/parallelWorld/PWListKit.git', :tag => s.version.to_s }
  s.dependency 'UITableView+FDTemplateLayoutCell', '1.6'
  s.library = 'c++'
  s.pod_target_xcconfig = {
       'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
       'CLANG_CXX_LIBRARY' => 'libc++'
  }
end
