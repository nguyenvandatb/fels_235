module WordsHelper
  def remove_answer name, f
    f.hidden_field(:_destroy) + link_to(name, "javascript:void(0);", onclick: "remove_answer(this)")
  end

  def add_answer name, f, association
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to name, "javascript:void(0);", onclick: "add_answer(this, \"#{association}\",
      \"#{escape_javascript(fields)}\")", class: "btn btn-default"
  end
end
