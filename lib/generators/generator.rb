require 'erb'

# from http://www.stuartellis.name/articles/erb/

def get_items()
  ['bread', 'milk', 'eggs', 'spam']
end

def get_template()
  %{
        Shopping List for <%= @date.strftime('%A, %d %B %Y') %>

        You need to buy:

          <% for @item in @items %>
            <%= h(@item) %>
          <% end %>
  }
end

class ShoppingList
  include ERB::Util
  attr_accessor :items, :template, :date

  def initialize(items, template, date=Time.now)
    @date = date
    @items = items
    @template = template
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def save(file)
    File.open(file, "w+") do |f|
      f.write(render)
    end
  end

end