
task check_for_updates: :environment do
  Product.due_for_check.each &:check
end
