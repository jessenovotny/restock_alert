task check_for_updates: :environment do
  Page.check_for_updates
end

task check_mvps: :environment do
  Page.all(filter: "NOT({MVP} = '')").map do |page|
    Thread.new do
      while true
        page.check
        sleep 30
      end
    end
  end.each &:join
end

task :test do
  puts 'TEST COMPLETE'
end
