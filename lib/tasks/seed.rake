require_relative '../assets/seeds'

task seed: :environment do
  all_products = Page.all
  SEEDS.each do |seed|
    seed[:urls].each do |url|
      next if all_products.find{|p|p.url === url}
      product = Page.create(keyword: seed[:keyword], url: url ) rescue binding.pry
      puts "CREATED: #{url}"
    end
  end
end
