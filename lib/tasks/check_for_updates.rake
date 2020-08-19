task check_for_updates: :environment do
  Product.all.each &:check
end
