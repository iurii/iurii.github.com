module Jekyll
  

  class CategoryIndex < Page
    
    def initialize(site, base, category_dir, category)
      @site = site
      @base = base
      @dir  = category_dir
      @name = 'index.html'
      self.process(@name)
      # Read the YAML data from the layout page.
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category']    = category
      # Set the title for this page.
      title_prefix             = site.config['category_title_prefix'] || 'Category: '
      self.data['title']       = "#{title_prefix}#{category}"
      # Set the meta-description for this page.
      meta_description_prefix  = site.config['category_meta_description_prefix'] || 'Category: '
      self.data['description'] = "#{meta_description_prefix}#{category}"
    end
    
  end
  
    def write_category_index(category_dir, category)
      index = CategoryIndex.new(self, self.source, category_dir, category)
      index.render(self.layouts, site_payload)
      index.write(self.dest)
      # Record the fact that this page has been added, otherwise Site::cleanup will remove it.
      self.pages << index
    end
    
    # Loops through the list of category pages and processes each one.
    def write_category_indexes
      if self.layouts.key? 'category_index'
        dir = self.config['category_dir'] || 'categories'
        self.categories.keys.each do |category|
          self.write_category_index(File.join(dir, category), category)
        end
        
      # Throw an exception if the layout couldn't be found.
      else
        throw "No 'category_index' layout found."
      end
    end
    
  end
  
  
  # Jekyll hook - the generate method is called by jekyll, and generates all of the category pages.
  class GenerateCategories < Generator
    safe true
    priority :low

    def generate(site)
      site.write_category_indexes
    end

  end
  

    def category_links(categories)
      categories = categories.sort!.map do |item|
        '<a href="/blog/category/'+item+'/">'+item+'</a>'
      end
      
      connector = "and"
      case categories.length
      when 0
        ""
      when 1
        categories[0].to_s
      when 2
        "#{categories[0]} #{connector} #{categories[1]}"
      else
        "#{categories[0...-1].join(', ')}, #{connector} #{categories[-1]}"
      end
    end
    
 
    def date_to_html_string(date)
      result = '<span class="month">' + date.strftime('%b').upcase + '</span> '
      result += date.strftime('<span class="day">%d</span> ')
      result += date.strftime('<span class="year">%Y</span> ')
      result
    end
    
  end
  
end