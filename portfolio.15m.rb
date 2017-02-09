#!/usr/bin/env ruby

# <bitbar.title>Portfolio</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Roman Krasavtsev</bitbar.author>
# <bitbar.author.github>RomanKrasavtsev</bitbar.author.github>
# <bitbar.desc>Track your portfolio</bitbar.desc>
# <bitbar.image>https://raw.github.com/romankrasavtsev/portfolio-bitbar-plugin/master/portfolio-bitbar-plugin.png</bitbar.image>
# <bitbar.dependencies>ruby</bitbar.dependencies>
# <bitbar.abouturl>https://github.com/RomanKrasavtsev/portfolio-bitbar-plugin</bitbar.abouturl>

require "nokogiri"
require "open-uri"

user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"

portfolio = [
  {
    name: "Microsoft",
    url: "https://www.bloomberg.com/quote/MSFT:US",
    purchases: [
      { date: "13.01.2017", price: 127.25, amount: 2 } # 63.62 USD
    ]
  },
  {
    name: "Tinkoff",
    url: "https://www.bloomberg.com/quote/TCS:LI",
    purchases: [
      { date: "13.01.2017", price: 66.17, amount: 6 } # 11.02 USD
    ]
  },
  {
    name: "Ferrari",
    url: "https://www.bloomberg.com/quote/RACE:US",
    purchases: [
      { date: "13.01.2017", price: 61.94, amount: 1 } # 61.94 USD
    ]
  },
  {
    name: "Facebook",
    url: "https://www.bloomberg.com/quote/FB:US",
    purchases: [
      { date: "09.02.2017", price: 136.05, amount: 1 }
    ]
  },
  {
    name: "Apple",
    url: "https://www.bloomberg.com/quote/AAPL:US",
    purchases: [
      { date: "09.02.2017", price: 133.38, amount: 1 }
    ]
  }
]

interesting_stocks = [
  "Microsoft - 62.61 - 19.64%",
  "Apple - 119.25 - 22,99%",
  "Amazon - 813.64 - 34%",
  "Facebook - 126.62 - 30%",
  "Oracle - 39.20 - 13.13%",
  "Ferrari NV - 56.55 - 41.2%",
  "Tesla - 229.59 - 8.81%",
  "Google - 829.53 - 13.49%"
]

puts "💼"
puts "---"

total_purchase_price = 0
total_current_price = 0
portfolio.each do |stock|
  price = Nokogiri::HTML(open(stock[:url], 'User-Agent' => user_agent), nil, "UTF-8")
    .css(".container")
    .css(".price")
    .to_s
    .gsub(/<[^>]*>/, "")
    .to_f

  purchase_price = 0
  current_price = 0
  stock[:purchases].each do |purchase|
    purchase_price += purchase[:price]
    current_price += price * purchase[:amount]
  end
  percent = (current_price * 100 / purchase_price) - 100
  total_purchase_price += purchase_price
  total_current_price += current_price

  puts "#{stock[:name]}: $#{current_price.round(2)} [#{(percent).round(2)}%, $#{(current_price - purchase_price).round(2)}]"
end

total_percent = (total_current_price * 100 / total_purchase_price) - 100

puts "---"
puts "Total: $#{total_current_price.round(2)} [#{total_percent.round(2)}%, $#{(total_current_price - total_purchase_price).round(2)}]"
