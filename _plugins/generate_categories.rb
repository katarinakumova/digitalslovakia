module Jekyll
  class Post
    def populate_categories
      if self.categories.empty?
        self.categories = self.data.pluralized_array('category', 'categories').map {|c| c.to_s}
      end
      self.categories.flatten!
    end
  end

  class Site
    def post_attr_hash(post_attr)
      # Build a hash map based on the specified post attribute ( post attr =>
      # array of posts ) then sort each array in reverse order.
      hash = Hash.new { |hsh, key| hsh[key] = { "posts" => [] } }
      self.posts.each { |p| p.send(post_attr.to_sym).each { |name|
        # t = name.gsub(/\s/, '_')
        t = name
        hash[t]["posts"] << p
        hash[t]["name"] = name
      } }
      hash.values.map { |sortme| sortme["posts"].sort! { |a, b| b <=> a } }
      hash.values.sort { |a, b| b['posts'].length <=> a['posts'].length }
    end
  end

  class CategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category'] = category

      self.data['title'] = category['name']
    end
  end

  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'category_index'
        dir = site.config['category_dir'] || ''
        site.site_payload['site']['categories'].each do |category|
          site.pages << CategoryPage.new(site, site.source, File.join(dir, category['name']), category)
        end
      end
    end
  end
end
