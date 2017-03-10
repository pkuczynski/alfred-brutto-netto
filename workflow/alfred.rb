require 'json'

class Alfred
  def self.error title
    self.out [{title: title}]
  end

  def self.out items
    puts JSON[{items: items}]
  end
end