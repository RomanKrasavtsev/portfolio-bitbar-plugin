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
      { date: "13.01.2017", price: 61.94, amount: 1 }, # 61.94 USD
      { date: "02.05.2017", price: 229.83, amount: 3 } # 76.61 USD
    ]
  },
  {
    name: "Facebook",
    url: "https://www.bloomberg.com/quote/FB:US",
    purchases: [
      { date: "09.02.2017", price: 136.05, amount: 1 } # 136.05 USD
    ]
  },
  {
    name: "Apple",
    url: "https://www.bloomberg.com/quote/AAPL:US",
    purchases: [
      { date: "09.02.2017", price: 133.38, amount: 1 } # 133.38 USD
    ]
  },
  {
    name: "Netflix",
    url: "https://www.bloomberg.com/quote/NFLX:US",
    purchases: [
      { date: "06.03.2017", price: 283.95, amount: 2 } # 141.97 USD
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
    .xpath("//span[starts-with(@class, 'priceText__')]")
    .children
    .to_s
    .to_f

  puts "#{stock[:name]} [$#{price}] | color=black"

  purchase_price = 0
  current_price = 0
  stock[:purchases].each do |purchase|
    purchase_price += purchase[:price]
    current_price += price * purchase[:amount]
    puts "#{purchase[:date]}: $#{purchase[:price]} [#{(price * purchase[:amount] * 100 / purchase[:price] - 100).round(2)}%, $#{(price * purchase[:amount] - purchase[:price]).round(2)}]"
  end
  percent = (current_price * 100 / purchase_price) - 100
  total_purchase_price += purchase_price
  total_current_price += current_price

  puts "= $#{current_price.round(2)} [#{(percent).round(2)}%, $#{(current_price - purchase_price).round(2)}]" if stock[:purchases].size > 1
end

total_percent = (total_current_price * 100 / total_purchase_price) - 100

puts "---"
puts "= $#{total_current_price.round(2)} [#{total_percent.round(2)}%, $#{(total_current_price - total_purchase_price).round(2)}] | color=black length=28"
