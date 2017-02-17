module ApplicationHelper
  def full_title page_title= ""
    base_title = t "website_title"
   if page_title.empty?
    base_title
   else
    page_title + "|" + base_title
   end
  end

  def increase_index items, index
    items.offset + index + 1
  end

  def render_404
   respond_to do |format|
    format.html{render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found}
    format.xml{head :not_found}
    format.any{head :not_found}
   end
  end
end
