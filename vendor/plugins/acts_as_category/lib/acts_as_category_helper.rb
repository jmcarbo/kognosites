module ActsAsCategoryHelper
  
  extend ActiveSupport::Memoizable
  
  def aac_tree(roots)
    result = '<ul class="tree_root">'
    roots.each { |root| result += aac_tree_category(root) }
    result += '</ul>'
  end
  memoize :aac_tree
  
  def aac_sortable_tree(model, ajaxurl = {:controller => :funkengallery, :action => :update_positions}, column = 'name')
    raise "Model '#{model.to_s}' does not acts_as_category" unless model.respond_to?(:acts_as_category)
    result = '<div id="aac_sortable_tree_response"></div>'
    model.roots.each { |root| result += aac_sortable_tree_list(root, ajaxurl, column) }
    result
  end
  
  private 
  
  def aac_tree_category(category)
    anchor = "aac_tree_#{category.id.to_s}"
    if category.ancestors_count == 0
      # CSS for root categories
      html_headline = ' class="tree_headline" ' 
      html_count = ''
    else
      # CSS for any deeper level of categories
      html_headline = '' 
      html_count = ' <span class="tree_count"> ' + h(category.pictures_count.to_s)+ '</span>'
    end

    result = tag('a', {:name => anchor})
    result += "<li#{html_headline}>"
    result += '<b>' if @category == category.id
    if category.pictures_count == 0 or category.ancestors_count == 0 or category.children_count > 0 then
      result += content_tag('a', h(category.name), :onclick => "new Element.toggle('#{anchor}')", :href => "\##{anchor}")
    else
      result += link_to_unless_current h(category.name), {:controller => 'category', :id => category.id } unless category.ancestors_count == 0
    end
    result += '</b>' if @category == category.id
    result += html_count if category.pictures_count > 0
    result += '</li>'

    if category.children_count > 0
      addon = (category.ancestors_count == 0 or category.descendants_ids.include?(@category) or (category.self_and_siblings_ids.include?(@category) and category.children_count == 0)) ? '' : ' style="display: none;"'
      result += "<ul id='#{anchor}' #{addon}>"
      category.children.each { |child| result += aac_tree_category(child) }
      result += '</ul>'
    end
    result
  end
  
  def aac_sortable_tree_list(category, ajaxurl, column = 'name')
    parent_id = category.parent ? category.parent.id.to_s : '0'
    firstitem = category.read_attribute(category.position_column) == 1
    lastitem  = category.position == category.self_and_siblings.size
    result = ''
    result += "<ul id=\"aac_sortable_tree_#{parent_id}\">\n" if firstitem
    result += "<li id=\"category_#{category.id}\">#{category.read_attribute(column)}"
    result += category.children.empty? ? "</li>\n" : "\n"
    category.children.each {|child| result += aac_sortable_tree_list(child, ajaxurl, column) } unless category.children.empty?
    result += "</ul></li>\n" + sortable_element("aac_sortable_tree_#{parent_id}", :update => 'aac_sortable_tree_response', :url => ajaxurl) if lastitem
    result
  end

end
