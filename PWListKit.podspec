Pod::Spec.new do |s|
  s.name         = "PWListKit"
  s.version      = "0.0.1"
  s.summary      = "tableView和collectionView的封装"
  s.description  = <<-DESC
    tableView和collectionView的封装，主要对dataSource和delegate的常用方法进行了封装。
                   DESC
  s.homepage     = "https://github.com/parallelWorld/PWListKit"
  s.author       = { "Parallel World" => "654269765@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/parallelWorld/PWListKit.git", :tag => "#{s.version}" }
  s.source_files = "PWListKit/**/*.{h,m}"
  s.requires_arc = true
  s.dependency "UITableView+FDTemplateLayoutCell", "~> 1.4"
end
