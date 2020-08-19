task check_for_updates: :environment do
  binding.pry
  Product.due_for_check.each &:check
end
